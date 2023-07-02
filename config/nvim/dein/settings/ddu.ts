import {
  BaseConfig,
  type ConfigArguments,
} from "https://deno.land/x/ddu_vim@v3.3.2/base/config.ts";
import type { Params as DduUiFFParams } from "https://deno.land/x/ddu_ui_ff@v1.0.2/ff.ts";
import { collect } from "https://deno.land/x/denops_std@v5.0.1/batch/collect.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const hasNvim = args.denops.meta.host === "nvim";

    args.setAlias("source", "color", "custom-list");
    args.setAlias("source", "file_git", "file_external");
    args.setAlias("source", "mrr", "mr");
    args.setAlias("source", "mrw", "mr");

    // NOTE: for ddu-source-custom-list (as color source)
    const [callbackId, texts] = await collect(args.denops, (denops) => [
      denops.eval("denops#callback#register({_->user#colorscheme#command(_)})"),
      denops.eval("keys(user#colorscheme#get())"),
    ]);

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
        "custom-list": { defaultAction: "callback" },
        "ui-select": { defaultAction: "execute" },
        action: { defaultAction: "do" },
        colorscheme: { defaultAction: "set" },
        command_history: { defaultAction: "edit" },
        dein_update: { defaultAction: "viewDiff" },
        file: { defaultAction: "open" },
        help: { defaultAction: "open" },
        highlight: { defaultAction: "edit" },
        readme_viewer: { defaultAction: "open" },
        source: { defaultAction: "execute" },
        url: { defaultAction: "open" },
        word: { defaultAction: "append" },
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
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
      },
      sourceParams: {
        color: { callbackId, texts },
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
          floatingBorder: "rounded",
          floatingTitle: "ddu-ff",
          highlights: {
            floating: "Normal,EndOfBuffer:DduEndOfBuffer,SignColumn:Normal",
            floatingBorder: "Identifier",
          },
          previewFloating: true,
          previewFloatingBorder: "rounded",
          prompt: ">",
          split: hasNvim ? "floating" : "horizontal",
          statusline: false,
        } satisfies Partial<DduUiFFParams>,
      },
    });

    args.contextBuilder.patchLocal("rg_live", {
      sources: [{
        name: "rg",
        // @ts-expect-error: This can accept partial options but not defined in type.
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
      sources: [{ name: "color" }],
      actionOptions: {
        callback: { quit: false },
      },
      uiParams: {
        ff: {
          autoAction: { name: "itemAction" },
        } satisfies Partial<DduUiFFParams>,
      },
    });
  }
}
