import {
  BaseConfig,
  type ConfigArguments,
} from "https://deno.land/x/ddu_vim@v3.4.3/base/config.ts";
import { ActionFlags } from "https://deno.land/x/ddu_vim@v3.4.3/types.ts";
import {
  type Params as UiFFParams_,
  Ui as UiFF,
} from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import type { Denops } from "https://deno.land/x/denops_std@v5.0.1/mod.ts";
import * as autocmd from "https://deno.land/x/denops_std@v5.0.1/autocmd/mod.ts";
import * as lambda from "https://deno.land/x/denops_std@v5.0.1/lambda/mod.ts";

type UiFFParams<T extends keyof UiFFParams_ = "autoResize"> = {
  [P in keyof UiFFParams_]: P extends T ? UiFFParams_[P] | string
    : UiFFParams_[P];
};

let timer = -1;
function updateLightline(args: { denops: Denops }): Promise<ActionFlags> {
  clearTimeout(timer);
  timer = setTimeout(async () => {
    await args.denops.call("lightline#update");
    await args.denops.cmd("redrawstatus");
  }, 200);
  return Promise.resolve(ActionFlags.Persist);
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
        readme_viewer: { defaultAction: "open" },
        source: { defaultAction: "execute" },
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
      uiOptions: { ff: { actions: { updateLightline } } },
      uiParams: {
        ff: {
          autoAction: {
            name: "preview",
          },
          autoResize: "sources[0] ==# 'action'",
          exprParams: defaultUiFFParams.exprParams
            .concat(["autoResize", "floatingTitle"]),
          floatingBorder: "rounded",
          floatingTitle: "sources->join(', ')",
          highlights: {
            floating: "Normal,EndOfBuffer:DduEndOfBuffer,SignColumn:Normal",
            floatingBorder: "Identifier",
          },
          previewFloating: true,
          previewFloatingBorder: "rounded",
          previewSplit: "vertical",
          prompt: ">",
          split: hasNvim ? "floating" : "horizontal",
          statusline: false,
          winCol: "&columns / 6",
          winRow: "&lines / 6",
          winWidth: "sources[0] !=# 'action' ? &columns / 3 * 2 : &columns / 3",
          winHeight: "&lines / 3 * 2",
          previewWidth: "&columns / 3",
          previewHeight: "&lines / 3 * 2",
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
          ignoreEmpty: true,
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

    const notify = (fn: () => unknown) =>
      `call denops#notify('ddu', '${lambda.register(args.denops, fn)}', [])`;

    await autocmd.group(args.denops, "vimrc-ddu", (helper) => {
      helper.remove("*");
      helper.define(
        ["CursorMoved", "TextChangedI"],
        "ddu-ff-*",
        notify(() => updateLightline(args)),
      );
    });
  }
}
