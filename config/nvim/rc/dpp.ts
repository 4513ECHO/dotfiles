import {
  BaseConfig,
  type ConfigArguments,
  type ConfigReturn,
} from "jsr:@shougo/dpp-vim@^3.0.0/config";
import { Action } from "jsr:@shougo/dpp-vim@^3.0.0/ext";
import type { BaseParams, Plugin } from "jsr:@shougo/dpp-vim@^3.0.0/types";
import { mergeFtplugins } from "jsr:@shougo/dpp-vim@^3.0.0/utils";
import type { Params as InstallerExtParams } from "jsr:@shougo/dpp-ext-installer@^1.2.0";
import type { ExtActions as LazyExtActions } from "jsr:@shougo/dpp-ext-lazy@^1.5.0";
import type {
  ExtActions as TomlExtActions,
  Toml,
} from "jsr:@shougo/dpp-ext-toml@^1.3.0";
import type { Denops } from "jsr:@denops/std@^7.2.0";
import * as vars from "jsr:@denops/std@^7.2.0/variable";
import { tee } from "jsr:@std/async@^1.0.5/tee";
import { exists } from "jsr:@std/fs@^1.0.3/exists";
import { expandGlob } from "jsr:@std/fs@^1.0.3/expand-glob";
import { basename } from "jsr:@std/path@^1.0.8/basename";
import { join } from "jsr:@std/path@^1.0.4/join";
import { parse } from "jsr:@std/toml@^1.0.1/parse";
import { ensure, is } from "jsr:@core/unknownutil@^4.3.0";
import { pipe } from "jsr:@core/pipe@^0.3.0/async";
import { filter } from "jsr:@core/iterutil@^0.8.0/pipe/async/filter";
import { flatMap } from "jsr:@core/iterutil@^0.8.0/pipe/async/flat-map";
import { map } from "jsr:@core/iterutil@^0.8.0/pipe/async/map";

type Exts = {
  lazy: LazyExtActions<BaseParams>;
  toml: TomlExtActions<BaseParams>;
};
const isColorSchemePlugin = is.ObjectOf({
  name: is.String,
  colorschemes: is.ArrayOf(is.ObjectOf({ name: is.String })),
});

function mergeToml(tomls: Toml[]): ConfigReturn {
  return {
    ftplugins: tomls.map((x) => x.ftplugins).reduce((acc, x) => {
      if (!x) return acc;
      if (!acc) return x;
      mergeFtplugins(acc, x);
      return acc;
    }),
    hooksFiles: tomls.map((x) => x.hooks_file).filter(is.String),
    multipleHooks: tomls.flatMap((x) => x.multiple_hooks ?? []),
    plugins: tomls.flatMap((x) => x.plugins ?? []),
  };
}

function getPath(plugin: Plugin, basePath: string): string {
  if (plugin.path) return plugin.path;
  const rev = plugin.rev ? "_" + plugin.rev.replaceAll(/[^\w.-]/g, "_") : "";
  const name = (() => {
    if (plugin.repo && URL.canParse(plugin.repo)) {
      const { hostname, pathname } = new URL(plugin.repo);
      return join(hostname, pathname);
    } else {
      return plugin.name;
    }
  })();
  return join(basePath, "repos", name + rev, plugin.script_type ?? "");
}

async function evalIf(plugin: Plugin, denops: Denops): Promise<boolean> {
  if (plugin.if === undefined) return true;
  if (is.String(plugin.if)) {
    return Boolean(await denops.eval(plugin.if));
  }
  return plugin.if;
}

function normalizeOnMap(plugin: Plugin): Plugin {
  if (!plugin.on_map) return plugin;
  // Remove conversion of "-" to "_" in on_map
  const normalize = (lhs: string) =>
    lhs === "<Plug>"
      ? "<Plug>(" + plugin.name
        .replaceAll(/^(?:n?vim|denops)[_-]|[._-]n?vim$/gi, "")
      : lhs;
  const on_map = is.String(plugin.on_map)
    ? normalize(plugin.on_map)
    : is.ArrayOf(is.String)(plugin.on_map)
    ? plugin.on_map.map(normalize)
    : Object.fromEntries(
      Object.entries(plugin.on_map).map(([mode, lhs]) => [
        mode,
        is.String(lhs) ? normalize(lhs) : lhs.map(normalize),
      ]),
    );
  return { ...plugin, on_map };
}

async function withPluginPath<T>(
  plugin: Plugin | undefined,
  fn1: (plugin: Plugin) => string,
  fn2: (plugin: Plugin, path: string) => Promise<T>,
): Promise<T | undefined> {
  if (!plugin) return;
  const path = fn1(plugin);
  if (await exists(path)) {
    return await fn2(plugin, path);
  }
}

async function clonePrerequisites(
  basePath: string,
  tomlPath: string,
): Promise<void> {
  const { plugins } = parse(
    await Deno.readTextFile(tomlPath),
  ) as { plugins: (Plugin & { repo: string })[] };
  const cloned: Promise<Deno.CommandStatus>[] = [];
  for (const plugin of plugins) {
    const path = getPath(plugin, basePath);
    if (!await exists(path)) {
      const { status } = new Deno.Command("git", {
        args: [
          "clone",
          "--recursive",
          "--filter=blob:none",
          ...(plugin.rev ? ["--branch", plugin.rev] : []),
          plugin.repo,
          path,
        ],
        stderr: "inherit",
        stdout: "inherit",
      }).spawn();
      cloned.push(status);
    } else {
      console.error(`Already cloned: ${plugin.repo}`);
    }
  }
  await Promise.all(cloned);
}

const decoder = new TextDecoder();
async function getGitRoot(): Promise<string> {
  const { stdout } = await new Deno.Command("git", {
    args: ["rev-parse", "--show-toplevel"],
    cwd: import.meta.dirname,
    stdout: "piped",
  }).output();
  return decoder.decode(stdout).trim();
}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const hasNvim = args.denops.meta.host === "nvim";
    const configHome = await vars.g.get<string>(args.denops, "config_home");
    const githubAPIToken = Deno.env.get("GITHUB_TOKEN");

    const inlineVimrcs = ["autocmd", "keymap", "option", "var"]
      .map((x) => join(configHome, "rc", x + ".rc.vim"));

    args.contextBuilder.patchGlobal({
      inlineVimrcs,
      extParams: {
        installer: {
          checkDiff: true,
          githubAPIToken,
          maxProcesses: 8,
          logFilePath: join(
            await vars.g.get<string>(args.denops, "data_home"),
            `dpp-installer-${new Date().toISOString().substring(0, 19)}.log`,
          ),
        } satisfies Partial<InstallerExtParams>,
      },
      protocols: ["git"],
      protocolParams: {
        git: {
          enablePartialClone: true,
        },
      },
      skipMergeFilenamePattern:
        "^tags(?:-\\w\\w)?$|^package(?:-lock)?.json$|\\.png$|^README",
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const extAction = async <
      E extends keyof Exts,
      A extends keyof Exts[E] & string,
      R = Exts[E][A] extends Action<BaseParams, infer R> ? R : unknown,
    >(ext: E, action: A, params: BaseParams): Promise<R> =>
      await args.dpp.extAction(
        args.denops,
        context,
        options,
        ext,
        action,
        params,
      ) as R;

    // Load plugins from toml files
    const [iter1, iter2] = await pipe(
      expandGlob(join(Deno.env.get("MYVIMDIR")!, "dein", "*.toml")),
      map(async ({ path }) =>
        [path, await extAction("toml", "load", { path })] as const
      ),
      tee,
    );

    // Write tags file
    await pipe(
      iter1,
      flatMap(([path, { plugins }]) =>
        plugins?.map(({ name, repo }) =>
          `${name}\t${path}\t?^repo = '${repo}'`
        ) ?? []
      ),
      flatMap((x) => [x, "\n"]),
      ReadableStream.from,
      async (v) => Deno.writeTextFile(join(await getGitRoot(), "tags"), v),
    );

    const { plugins: tomlPlugins, ftplugins } = await pipe(
      iter2,
      map(([path, toml]) => [basename(path, ".toml"), toml] as const),
      filter(([path]) =>
        (hasNvim && path !== "vim") || (!hasNvim && path !== "neovim")
      ),
      map(([_, toml]) => toml),
      (v) => Array.fromAsync(v),
      mergeToml,
    );

    const { plugins, stateLines: lazyStateLines } = await pipe(
      tomlPlugins,
      (plugins) => extAction("gh_pull_request", "replace", { plugins }),
      map(normalizeOnMap),
      (v) => Array.fromAsync(v),
      (plugins) => extAction("lazy", "makeState", { plugins }),
    );

    const sandwichStateLines = await withPluginPath(
      plugins.find(({ name }) => name === "vim-sandwich"),
      (plugin) =>
        join(
          getPath(plugin, args.basePath),
          "macros",
          "sandwich",
          "keymap",
          "surround.vim",
        ),
      async (_, path) => {
        const content = await Deno.readTextFile(path);
        return content.split("\n").reduce((acc, x) =>
          // Remove line-continuation backslashes
          acc + (x.match(/^\s*\\\s*/) ? x.replace(/^\s*\\\s*/, "") : "\n" + x)
        ).split("\n");
      },
    ) ?? [];

    for (const val of ["ddc", "ddu"]) {
      await withPluginPath(
        plugins.find(({ name }) => name === `${val}.vim`),
        (plugin) => getPath(plugin, args.basePath),
        async (_, cwd) => {
          await new Deno.Command("git", {
            args: ["update-index", "--skip-worktree", `denops/${val}/_mods.js`],
            cwd,
          }).output();
        },
      );
    }

    const colorschemeStateLines = await pipe(
      plugins,
      filter(isColorSchemePlugin),
      filter((x) => evalIf(x, args.denops)),
      flatMap((x) => x.colorschemes.map((x) => [x.name, x] as const)),
      (v) => Array.fromAsync(v),
      Object.fromEntries,
      JSON.stringify,
      (v) => ["let g:user#colorscheme#_colorschemes = " + v],
    );

    console.log(
      `makeState ${args.name} successed with ${plugins.length} plugins`,
    );

    return {
      ftplugins,
      plugins,
      stateLines: [
        lazyStateLines,
        sandwichStateLines,
        colorschemeStateLines,
      ].flat(),
    };
  }
}

if (import.meta.main) {
  await clonePrerequisites(...ensure(
    Deno.args,
    is.TupleOf([is.String, is.String]),
  ));
}
