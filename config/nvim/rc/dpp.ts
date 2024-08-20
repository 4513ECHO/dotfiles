import {
  BaseConfig,
  type ConfigArguments,
  type ConfigReturn,
} from "jsr:@shougo/dpp-vim@^2.3.0/config";
import type {
  Action,
  BaseExtParams,
  Plugin,
} from "jsr:@shougo/dpp-vim@^2.3.0/types";
import { mergeFtplugins } from "jsr:@shougo/dpp-vim@^2.3.0/utils";
import type { Params as InstallerExtParams } from "jsr:@shougo/dpp-ext-installer@^1.1.0";
import type { ExtActions as LazyExtActions } from "jsr:@shougo/dpp-ext-lazy@^1.4.0";
import type {
  ExtActions as TomlExtActions,
  Toml,
} from "jsr:@shougo/dpp-ext-toml@^1.2.0";
import type { Denops } from "jsr:@denops/std@^7.0.3";
import * as vars from "jsr:@denops/std@^7.0.3/variable";
import { exists } from "jsr:@std/fs@^1.0.1/exists";
import { join } from "jsr:@std/path@^1.0.2/join";
import { parse } from "jsr:@std/toml@^1.0.0/parse";
import { ensure, is } from "jsr:@core/unknownutil@^4.2.0";
import { pipe } from "jsr:@core/pipe@^0.2.0";
import { filter } from "jsr:@core/iterutil@^0.8.0/pipe/async/filter";
import { flatMap } from "jsr:@core/iterutil@^0.8.0/pipe/async/flat-map";

type Exts = {
  lazy: LazyExtActions<BaseExtParams>;
  toml: TomlExtActions<BaseExtParams>;
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
    if (URL.canParse(plugin.repo ?? "")) {
      const { hostname, pathname } = new URL(plugin.repo ?? "");
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
    if (!(await exists(path))) {
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

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<ConfigReturn> {
    const hasNvim = args.denops.meta.host === "nvim";
    const configHome = await vars.g.get<string>(args.denops, "config_home");
    const deinDir = Deno.env.get("DEIN_DIR")!;

    const inlineVimrcs = ["autocmd", "keymap", "option", "var"]
      .map((x) => join(configHome, "rc", x + ".rc.vim"));

    args.contextBuilder.patchGlobal({
      inlineVimrcs,
      extParams: {
        installer: {
          checkDiff: true,
          maxProcesses: 8,
        } satisfies Partial<InstallerExtParams>,
      },
      protocols: ["git"],
      protocolParams: {
        git: {
          enablePartialClone: true,
        },
      },
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const extAction = async <
      E extends keyof Exts,
      A extends keyof Exts[E] & string,
      R = Exts[E][A] extends Action<BaseExtParams, infer R> ? R : unknown,
    >(ext: E, action: A, params?: unknown): Promise<R> =>
      await args.dpp.extAction(
        args.denops,
        context,
        options,
        ext,
        action,
        params,
      ) as R;

    const { plugins, ftplugins } = mergeToml(
      await Promise.all(
        [
          "init",
          "colorscheme",
          "textobj",
          "ftplugin",
          "plugin",
          "ddc",
          "ddu",
          "dpp",
          hasNvim ? "neovim" : "vim",
        ]
          .map((path) => join(deinDir, path + ".toml"))
          .map((path) => extAction("toml", "load", { path })),
      ),
    );

    const lazyResult = await extAction("lazy", "makeState", {
      plugins: plugins.map(normalizeOnMap),
    });

    const sandwichPlugin = plugins
      .find((plugin) => plugin.name === "vim-sandwich");
    const sandwichStateLines = await (async () => {
      if (!sandwichPlugin) return [];
      const sandwichPath = join(
        getPath(sandwichPlugin, args.basePath),
        "macros",
        "sandwich",
        "keymap",
        "surround.vim",
      );
      if (!(await exists(sandwichPath))) return [];
      return await Deno.readTextFile(sandwichPath).then((x) =>
        x.split("\n").reduce((acc, x) =>
          // Remove line-continuation backslashes
          acc + (x.match(/^\s*\\\s*/) ? x.replace(/^\s*\\\s*/, "") : "\n" + x)
        ).split("\n")
      );
    })();

    const colorschemes = pipe(
      plugins,
      filter(isColorSchemePlugin),
      filter((x) => evalIf(x, args.denops)),
      flatMap((x) => x.colorschemes.map((x) => [x.name, x] as const)),
    );
    const colorschemeStateLines = pipe(
      await Array.fromAsync(colorschemes),
      Object.fromEntries,
      JSON.stringify,
      (v) => ["let g:user#colorscheme#_colorschemes = " + v],
    );

    return {
      ftplugins,
      plugins: lazyResult.plugins,
      stateLines: [
        lazyResult.stateLines,
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
