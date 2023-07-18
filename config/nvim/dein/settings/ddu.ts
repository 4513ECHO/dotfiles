import {
  BaseConfig,
  type ConfigArguments,
} from "https://deno.land/x/ddu_vim@v3.4.1/base/config.ts";
import { ActionFlags } from "https://deno.land/x/ddu_vim@v3.4.1/types.ts";
import type { Params as DduUiFFParams } from "https://deno.land/x/ddu_ui_ff@v1.0.3/ff.ts";
import type { Denops } from "https://deno.land/x/denops_std@v5.0.1/mod.ts";
import { collect } from "https://deno.land/x/denops_std@v5.0.1/batch/collect.ts";
import * as autocmd from "https://deno.land/x/denops_std@v5.0.1/autocmd/mod.ts";
import * as lambda from "https://deno.land/x/denops_std@v5.0.1/lambda/mod.ts";
import * as opt from "https://deno.land/x/denops_std@v5.0.1/option/mod.ts";

// based on https://github.com/kuuote/dotvim/blob/4ed6461/conf/plug/ddu.ts#L13
type Size = [x: number, y: number, width: number, height: number];
async function calculateUiSize(denops: Denops): Promise<Size> {
  const [columns, lines] = await collect(denops, (denops) => [
    opt.columns.get(denops),
    opt.lines.get(denops),
  ]);
  return [
    Math.floor(columns / 6),
    Math.floor(lines / 6),
    Math.floor(columns / 3) * 2,
    Math.floor(lines / 3) * 2,
  ];
}

async function setUiSize(args: ConfigArguments): Promise<void> {
  const [winCol, winRow, winWidth, winHeight] = await calculateUiSize(
    args.denops,
  );
  const options = {
    uiParams: {
      ff: {
        winCol,
        winRow,
        winWidth,
        winHeight,
        previewWidth: winWidth / 2,
        previewCol: 0,
        previewRow: 0,
        previewHeight: winHeight,
      } satisfies Partial<DduUiFFParams>,
    },
  };
  args.contextBuilder.patchGlobal(options);
  await args.denops.call("ddu#ui#do_action", "updateOptions", options);
}

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
          floatingBorder: "rounded",
          floatingTitle: "ddu-ff",
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
        } satisfies Partial<DduUiFFParams>,
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
        } satisfies Partial<DduUiFFParams>,
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
        } satisfies Partial<DduUiFFParams>,
      },
    });

    const notify = (fn: () => unknown) =>
      `call denops#notify('ddu', '${lambda.register(args.denops, fn)}', [])`;

    await autocmd.group(args.denops, "vimrc-ddu", (helper) => {
      helper.remove("*");
      helper.define("VimResized", "*", notify(() => setUiSize(args)));
      helper.define(
        ["CursorMoved", "TextChangedI"],
        "ddu-ff-*",
        notify(() => updateLightline(args)),
      );
    });
    await setUiSize(args);
  }
}
