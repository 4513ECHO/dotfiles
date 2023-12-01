import {
  BaseConfig,
  type ConfigArguments,
} from "https://deno.land/x/ddu_vim@v3.7.0/base/config.ts";
import {
  type Params as UiFFParams_,
  Ui as UiFF,
} from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import type { Denops } from "https://deno.land/x/denops_std@v5.1.0/mod.ts";
import * as autocmd from "https://deno.land/x/denops_std@v5.1.0/autocmd/mod.ts";
import * as lambda from "https://deno.land/x/denops_std@v5.1.0/lambda/mod.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.11.0/mod.ts";
import { sprintf } from "https://deno.land/std@0.208.0/fmt/printf.ts";

type UiFFParams<T extends keyof UiFFParams_ = never> = {
  [P in keyof UiFFParams_]: P extends T ? UiFFParams_[P] | string
    : UiFFParams_[P];
};

async function onColorScheme(denops: Denops): Promise<void> {
  // NOTE: eob of 'fillchars' is annoying
  const bgcolorObj = ensure(
    await denops.call("nvim_get_hl", 0, { name: "Normal" }),
    is.ObjectOf({ bg: is.OptionalOf(is.Number) }),
  );
  const bgcolor = sprintf("#%06x", bgcolorObj.bg ?? 0x000000);
  await denops.call("nvim_set_hl", 0, "DduEndOfBuffer", {
    foreground: bgcolor,
    background: bgcolor,
    default: true,
  });
}

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const defaultUiFFParams = new UiFF().params();
    const hasNvim = args.denops.meta.host === "nvim";

    args.setAlias("source", "file_git", "file_external");
    args.setAlias("source", "mrr", "mr");
    args.setAlias("source", "mrw", "mr");

    args.contextBuilder.patchGlobal({
      actionOptions: {
        do: { quit: false },
      },
      filterParams: {
        matcher_fzf: {
          highlightMatched: "Search",
        },
      },
      kindOptions: {
        action: { defaultAction: "do" },
        colorscheme: { defaultAction: "set" },
        command_history: { defaultAction: "edit" },
        "custom-list": { defaultAction: "callback" },
        dein_update: { defaultAction: "viewDiff" },
        file: { defaultAction: "open" },
        help: { defaultAction: "open" },
        highlight: { defaultAction: "edit" },
        lsp: { defaultAction: "open" },
        lsp_codeAction: { defaultAction: "apply" },
        "nvim-notify": { defaultAction: "open" },
        readme_viewer: { defaultAction: "open" },
        source: { defaultAction: "execute" },
        tag: { defaultAction: "jump" },
        "ui-select": { defaultAction: "execute" },
        url: { defaultAction: "open" },
        word: { defaultAction: "append" },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
        },
        action: {
          matchers: ["matcher_action", "matcher_fzf"],
        },
        dein_update: {
          matchers: ["matcher_dein_update"],
        },
        file: {
          defaultAction: "narrow",
        },
        ghq: {
          defaultAction: "cd",
        },
        source: {
          matchers: ["matcher_source", "matcher_fzf"],
        },
        colorscheme: {
          matchers: ["matcher_colorscheme", "matcher_fzf"],
        },
      },
      sourceParams: {
        ghq: { display: "relative" },
        file_git: {
          cmd: ["git", "ls-files", "-co", "--exclude-standard"],
        },
        mrr: { kind: "mrr" },
        mrw: { kind: "mrw" },
        rg: {
          args: ["--json"],
          highlights: {
            path: "Directory",
            lineNr: "LineNr",
            word: "Search",
          },
        },
      },
      ui: "ff",
      uiParams: {
        ff: {
          autoAction: {
            name: "preview",
          },
          exprParams: defaultUiFFParams.exprParams.concat("floatingTitle"),
          floatingBorder: "rounded",
          floatingTitle: "sources->join(', ')",
          highlights: {
            floating: "Normal,EndOfBuffer:DduEndOfBuffer,SignColumn:Normal",
            floatingBorder: "Identifier",
          },
          previewFloating: hasNvim,
          previewFloatingBorder: "rounded",
          previewSplit: "vertical",
          previewHeight: hasNvim ? "&lines / 3 * 2" : "&lines / 2",
          previewWidth: hasNvim ? "&columns / 3" : "&columns / 2",
          prompt: ">",
          split: hasNvim ? "floating" : "horizontal",
          statusline: false,
          winCol: "&columns / 6",
          winRow: "&lines / 6",
          winHeight: hasNvim ? "&lines / 3 * 2" : "&lines / 2",
          winWidth: "&columns / 3 * 2",
        } satisfies Partial<UiFFParams>,
      },
    });

    args.contextBuilder.patchLocal("rg_live", {
      sources: [{
        name: "rg",
        options: {
          matchers: [],
          volatile: true,
        },
      }],
      uiParams: {
        ff: {
          ignoreEmpty: false,
          autoResize: false,
          startFilter: true,
        } satisfies Partial<UiFFParams>,
      },
    });

    args.contextBuilder.patchLocal("UBA", {
      sources: [{ name: "colorscheme" }],
      actionOptions: {
        set: { quit: false },
      },
      uiParams: {
        ff: {
          autoAction: { name: "itemAction" },
          startAutoAction: true,
        } satisfies Partial<UiFFParams>,
      },
    });

    args.contextBuilder.patchLocal("codeAction", {
      sources: [{ name: "lsp_codeAction" }],
      uiParams: {
        ff: {
          autoAction: { name: "preview" },
          startAutoAction: true,
        } satisfies Partial<UiFFParams>,
      },
    });

    hasNvim && await onColorScheme(args.denops);

    const notify = (fn: () => unknown) =>
      `call denops#notify('ddu', '${lambda.register(args.denops, fn)}', [])`;

    await autocmd.group(args.denops, "vimrc-ddu", (helper) => {
      helper.remove("*");
      hasNvim &&
        helper.define(
          "ColorScheme",
          "*",
          notify(() => onColorScheme(args.denops)),
        );
    });
  }
}
