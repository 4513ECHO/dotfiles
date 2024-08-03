import {
  BaseConfig,
  type ConfigArguments,
} from "jsr:@shougo/ddu-vim@^5.0.0/config";
import {
  ActionFlags,
  type DduItem,
  type DduOptions,
} from "jsr:@shougo/ddu-vim@^5.0.0/types";
import {
  type Params as UiFFParams,
  Ui as UiFF,
} from "jsr:@shougo/ddu-ui-ff@^1.2.0";
import type { ActionData as GitStatusActionData } from "https://pax.deno.dev/kuuote/ddu-source-git_status@v1.0.0/denops/@ddu-kinds/git_status.ts";
import type { Data as GitDiffItemData } from "https://pax.deno.dev/kuuote/ddu-source-git_diff@6a7b725b/denops/@ddu-sources/git_diff.ts";
import type { Denops } from "jsr:@denops/std@^7.0.1";
import * as autocmd from "jsr:@denops/std@^7.0.1/autocmd";
import * as batch from "jsr:@denops/std@^7.0.1/batch";
import * as lambda from "jsr:@denops/std@^7.0.1/lambda";
import * as vars from "jsr:@denops/std@^7.0.1/variable";
import { is } from "jsr:@core/unknownutil@^3.18.1";
import * as u from "jsr:@core/unknownutil@^3.18.1";
import { sprintf } from "jsr:@std/fmt@^1.0.0-rc.1/printf";
import { join } from "jsr:@std/path@^1.0.2/join";
import { equal } from "jsr:@std/assert@^1.0.0/equal";

type GitDiffItem = DduItem & { data: GitDiffItemData };

async function onColorScheme(denops: Denops): Promise<void> {
  // NOTE: eob of 'fillchars' is annoying
  const bgcolorObj = u.ensure(
    await denops.call("nvim_get_hl", 0, { name: "Normal" }),
    is.ObjectOf({ bg: is.OptionalOf(is.Number) }),
  );
  const bgcolor = sprintf("#%06x", bgcolorObj.bg ?? 0x000000);
  await denops.call("nvim_set_hl", 0, "DduEndOfBuffer", {
    foreground: bgcolor,
    background: bgcolor,
  });
}

async function applySyntax(denops: Denops): Promise<void> {
  const { sources } = u.ensure(
    await denops.call("ddu#custom#get_current"),
    is.ObjectOf({ sources: is.ArrayOf(is.ObjectOf({ name: is.String })) }),
  );
  for (const source of sources) {
    switch (source.name) {
      case "quickfix":
        await denops.cmd("setlocal syntax=qf");
        return;
      case "command_history":
        await batch.batch(denops, async (denops) => {
          if (denops.meta.host === "nvim") {
            await denops.cmd("lua vim.treesitter.start(nil, 'vim')");
            await autocmd.define(
              denops,
              "WinClosed",
              "<buffer>",
              "lua vim.treesitter.stop()",
              { group: "vimrc-ddu", once: true },
            );
          } else {
            await denops.cmd("setlocal syntax=vim");
          }
        });
        return;
    }
  }
}

const names = ["rg_live", "gin_action", "startmenu"];
async function startFilterAuto(denops: Denops): Promise<void> {
  const [filetype, name] = await batch.collect(denops, (denops) => [
    denops.eval("&filetype"),
    denops.call("getbufvar", "", "ddu_ui_name", ""),
  ]) as [string, string];
  if (filetype === "ddu-ff" && names.includes(name)) {
    await denops.call("ddu#ui#async_action", "openFilterWindow");
  }
}

async function markSelectedItems(denops: Denops): Promise<void> {
  const [buffer, items, selectedItems] = await batch.collect(
    denops,
    (denops) => [
      denops.call("bufnr"),
      denops.call("ddu#ui#get_items"),
      // NOTE: Use raw value to avoid including the current item
      denops.call("getbufvar", "", "ddu_ui_selected_items", []),
    ],
  ) as [number, DduItem[], DduItem[]];
  if (!items) {
    return;
  }
  const lnumsToPlace = selectedItems.map((selected) =>
    items.findIndex((item) => equal(item, selected)) + 1
  );
  await batch.batch(denops, async (denops) => {
    await denops.call("sign_unplace", "*", { buffer });
    if (lnumsToPlace.length < 1 || lnumsToPlace[0] === 0) {
      return;
    }
    await denops.call(
      "sign_placelist",
      lnumsToPlace.map((lnum) => ({
        buffer,
        lnum,
        name: "ddu-ff-selected",
      })),
    );
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
        dein_update: { defaultAction: "viewDiff" },
        file: { defaultAction: "open" },
        git_status: {
          defaultAction: "open",
          actions: {
            chaperon: async (args) => {
              await batch.batch(args.denops, async (denops) => {
                for (const item of args.items) {
                  const action = item.action as GitStatusActionData;
                  await denops.cmd("GinChaperon " + action.path);
                }
              });
              return ActionFlags.None;
            },
            diff: (args) => {
              const action = args.items[0].action as GitStatusActionData;
              const path = join(action.worktree, action.path);
              args.denops.dispatcher.start(
                {
                  name: "git_diff_current",
                  sourceOptions: { _: { path } },
                  sourceParams: {
                    _: u.maybe(args.actionParams, is.Record) ?? {},
                  },
                } satisfies Partial<DduOptions>,
              );
              return ActionFlags.None;
            },
            patch: async (args) => {
              await batch.batch(args.denops, async (denops) => {
                for (const item of args.items) {
                  const action = item.action as GitStatusActionData;
                  await denops.cmd(
                    "GinPatch ++opener=tabedit ++no-head " + action.path,
                  );
                }
              });
              return ActionFlags.None;
            },
          },
        },
        help: { defaultAction: "open" },
        lsp: { defaultAction: "open" },
        lsp_codeAction: { defaultAction: "apply" },
        "nvim-notify": { defaultAction: "open" },
        readme_viewer: { defaultAction: "open" },
        source: { defaultAction: "execute" },
        tag: { defaultAction: "jump" },
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
        file: { defaultAction: "narrow" },
        ghq: { defaultAction: "cd" },
        gin_action: { defaultAction: "execute" },
        git_status: {
          converters: ["converter_git_status"],
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
      uiOptions: {
        ff: {
          actions: {
            updateLightline: async (args) => {
              await args.denops.call("lightline#update");
              return ActionFlags.Persist;
            },
          },
        },
      },
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
            selected: "Visual",
          },
          maxHighlightItems: 200,
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

    args.contextBuilder.patchLocal("gin_action", {
      sources: [{ name: "gin_action" }],
    });

    args.contextBuilder.patchLocal("git_diff_current", {
      sources: [{
        name: "git_diff",
        params: {
          unifiedContext: 0,
          onlyFile: true,
        },
        options: {
          actions: {
            currentHunk: async (args) => {
              const [lnum, currentItem, items] = await batch.collect(
                args.denops,
                (denops) => [
                  denops.call("line", "."),
                  denops.call("ddu#ui#get_item"),
                  denops.call("ddu#ui#get_items"),
                ],
              ) as [number, GitDiffItem, GitDiffItem[]];
              if (lnum < 3) {
                return ActionFlags.None;
              }
              const [{ nlinum }] = currentItem.data.git_diff.lines;
              const searchItem = items.slice(2).find((item) =>
                item.word.startsWith("@@") &&
                item.data.git_diff.lines.some((line) => line.nlinum === nlinum)
              );
              if (searchItem) {
                await args.denops.dispatcher.redraw(
                  "git_diff_current",
                  { searchItem },
                );
              }
              return ActionFlags.None;
            },
            currentLine: async (args) => {
              const [lnum, items] = await batch.collect(
                args.denops,
                (denops) => [
                  denops.call("line", ".", args.context.winId),
                  denops.call("ddu#ui#get_items"),
                ],
              ) as [number, GitDiffItem[]];
              const searchItem = items.slice(2).find((item) =>
                !item.word.startsWith("@@") &&
                item.data.git_diff.lines.some(({ nlinum }) => nlinum === lnum)
              );
              if (searchItem) {
                await args.denops.dispatcher.redraw(
                  "git_diff_current",
                  { searchItem },
                );
              } else {
                await args.denops.call(
                  "ddu#util#print_error",
                  "Current line has not changed",
                );
              }
              return ActionFlags.None;
            },
          },
        },
      }],
      actionOptions: {
        currentHunk: { quit: false },
        currentLine: { quit: false },
      },
      uiParams: {
        ff: {
          maxHighlightItems: 300,
        } satisfies Partial<UiFFParams>,
      },
    });

    args.contextBuilder.patchLocal("file_tree", {
      sources: [{ name: "file" }],
      uiParams: {
        ff: {
          displayTree: true,
        } satisfies Partial<UiFFParams>,
      },
    });

    args.contextBuilder.patchLocal("startmenu", {
      sources: [{ name: "source" }],
    });

    await vars.g.set(
      args.denops,
      "ddu_source_lsp_clientName",
      hasNvim ? "nvim-lsp" : "vim-lsp",
    );

    await args.denops.call("sign_define", [
      { name: "ddu-ff-selected", text: "*", texthl: "Visual" },
    ]);

    hasNvim && await onColorScheme(args.denops);

    const notify = (callback: (denops: Denops) => Promise<void>) =>
      "call " + lambda.add(args.denops, () => callback(args.denops)).notify();

    await autocmd.group(args.denops, "vimrc-ddu", (helper) => {
      helper.remove("*");
      hasNvim &&
        helper.define("ColorScheme", "*", notify(onColorScheme));
      helper.define("FileType", "ddu-ff", notify(applySyntax));
      helper.define("User", "Ddu:uiDone", notify(startFilterAuto));
      helper.define("User", "Ddu:redraw", notify(markSelectedItems));
    });
  }
}
