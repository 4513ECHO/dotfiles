import {
  BaseConfig,
  type ConfigArguments,
  type ConfigReturn,
} from "jsr:@shougo/dpp-vim@^1.0.0/config";
import type { MultipleHook, Plugin } from "jsr:@shougo/dpp-vim@^1.0.0/types";
import * as vars from "jsr:@denops/std@^7.0.3/variable";
import { exists } from "jsr:@std/fs@^1.0.1/exists";
import { basename } from "jsr:@std/path@^1.0.2/basename";
import { join } from "jsr:@std/path@^1.0.2/join";
import { parse } from "jsr:@std/toml@^1.0.0/parse";
import { ensure, is } from "jsr:@core/unknownutil@^4.0.0";

type Toml = {
  ftplugins?: Record<string, string>;
  hooks_file?: string;
  multiple_hooks?: MultipleHook[];
  plugins?: Plugin[];
};

type LazyMakeStateResult = {
  plugins: Plugin[];
  stateLines: string[];
};

type ColorSchemePlugin = Plugin & {
  colorschemes: { name: string }[];
};

function mergeToml(results: Toml[]): ConfigReturn {
  return {
    ftplugins: results.map((x) => x.ftplugins)
      .reduce((acc, x) => {
        if (!x) return acc;
        if (!acc) return x;
        for (const [key, value] of Object.entries(x)) {
          acc[key] = acc[key] ? acc[key] + "\n" + value : value;
        }
        return acc;
      }),
    hooksFiles: results.map((x) => x.hooks_file).filter(is.String),
    multipleHooks: results.flatMap((x) => x.multiple_hooks ?? []),
    plugins: results.flatMap((x) => x.plugins ?? []),
  };
}

function getName(plugin: Plugin): string {
  return plugin.name ?? basename(plugin.repo ?? "");
}

function getPath(plugin: Plugin, basePath: string): string {
  if (plugin.path) return plugin.path;
  const rev = plugin.rev ? "_" + plugin.rev.replaceAll(/[^\w.-]/g, "_") : "";
  const name = (() => {
    if (URL.canParse(plugin.repo ?? "")) {
      const { hostname, pathname } = new URL(plugin.repo ?? "");
      return join(hostname, pathname);
    } else {
      return getName(plugin);
    }
  })();
  return join(basePath, "repos", name + rev, plugin.script_type ?? "");
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
        args: ["clone", "--filter=blob:none", plugin.repo, path],
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
        },
      },
      protocols: ["git"],
      protocolParams: {
        git: {
          enablePartialClone: true,
        },
      },
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const extAction = async (ext: string, action: string, params?: unknown) =>
      await args.dpp.extAction(
        args.denops,
        context,
        options,
        ext,
        action,
        params,
      );

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
          .map((path) => extAction("toml", "load", { path }) as Promise<Toml>),
      ),
    );

    const lazyResult = await extAction(
      "lazy",
      "makeState",
      { plugins },
    ) as LazyMakeStateResult;

    const sandwichPlugin = plugins
      .find((plugin) => getName(plugin) === "vim-sandwich");
    let sandwichStateLines: string[] = [];
    if (sandwichPlugin) {
      const sandwichPath = join(
        getPath(sandwichPlugin, args.basePath),
        "macros",
        "sandwich",
        "keymap",
        "surround.vim",
      );
      if (await exists(sandwichPath)) {
        sandwichStateLines = await Deno.readTextFile(sandwichPath).then((x) =>
          x.split("\n").reduce((acc, x) =>
            // Remove line-continuation backslashes
            acc + (x.match(/^\s*\\\s*/) ? x.replace(/^\s*\\\s*/, "") : "\n" + x)
          ).split("\n")
        );
      }
    }

    const colorschemes = Object.fromEntries(
      plugins
        .filter((x): x is ColorSchemePlugin => Object.hasOwn(x, "colorschemes"))
        .flatMap((plugin) =>
          plugin.colorschemes.map((x) => [x.name, x] as const)
        ),
    );
    const colorschemeStateLines = [
      "let g:user#colorscheme#_colorschemes = " + JSON.stringify(colorschemes),
    ];

    // if (await extAction("installer", "getNotInstalled")) {
    //   extAction("installer", "install");
    // }

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
