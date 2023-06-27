import {
  BaseConfig,
  type ConfigArguments,
} from "https://deno.land/x/ddc_vim@v3.7.1/base/config.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    const sources = ["file", "around", "vsnip", "tmux", "buffer"];

    args.contextBuilder.patchGlobal({
      sources,
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          converters: [
            "converter_remove_overlap",
            "converter_truncate",
            "converter_fuzzy",
          ],
          maxItems: 10,
        },
        around: {
          mark: "[ard]",
          isVolatile: true,
          maxItems: 8,
        },
        buffer: {
          mark: "[buf]",
        },
        file: {
          mark: "[file]",
          minAutoCompleteLength: 30,
          isVolatile: true,
          forceCompletionPattern: "[\\w@:~._-]/[\\w@:~._-]*",
          sorters: ["sorter_file"],
        },
        github_issue: {
          mark: "[issue]",
          forceCompletionPattern: "#\\d*",
        },
        github_pull_request: {
          mark: "[PR]",
          forceCompletionPattern: "#\\d*",
        },
        line: {
          mark: "[line]",
        },
        mocword: {
          mark: "[word]",
          minAutoCompleteLength: 3,
          isVolatile: true,
          enabledIf: "exists('$MOCWORD_DATA')",
        },
        necovim: {
          mark: "[vim]",
          isVolatile: true,
          maxItems: 8,
        },
        omni: {
          mark: "[omni]",
        },
        skkeleton: {
          mark: "[skk]",
          matchers: ["skkeleton"],
          sorters: [],
          converters: [],
          minAutoCompleteLength: 1,
          isVolatile: true,
        },
        tmux: {
          mark: "[tmux]",
          enabledIf: "exists('$TMUX')",
        },
        "vim-lsp": {
          mark: "[lsp]",
          isVolatile: true,
          forceCompletionPattern: "\\.|:\\s*|->\\s*",
        },
        vsnip: {
          mark: "[snip]",
          dup: "keep",
        },
        zsh: {
          mark: "[zsh]",
          isVolatile: true,
          forceCompletionPattern: "[\\w@:~._-]/[\\w@:~._-]*",
          maxItems: 8,
        },
      },
      sourceParams: {
        around: {
          maxSize: 500,
        },
        buffer: {
          requireSameFiletype: false,
          fromAltBuf: true,
          bufNameStyle: "basename",
        },
        file: {
          trailingSlash: true,
          followSymlinks: true,
        },
        tmux: {
          currentWinOnly: true,
          excludeCurrentPane: true,
          kindFormat: "#{pane_index}.#{pane_current_command}",
        },
      },
      filterParams: {
        converter_truncate: {
          maxAbbrWidth: 40,
          maxInfoWidth: 400,
          maxKindWidth: 20,
          maxMenuWidth: 20,
          ellipsis: "…",
        },
      },
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineEnter",
        "CmdlineChanged",
      ],
      backspaceCompletion: true,
      ui: "pum",
    });

    args.contextBuilder.patchFiletype("vim", {
      sources: ["necovim", ...sources],
    });
    args.contextBuilder.patchFiletype("toml", {
      sourceOptions: {
        "vim-lsp": {
          forceCompletionPattern: '\\.|[=#{[,"]\\s*',
        },
      },
    });
    for (
      const ft of [
        "go",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "sh",
        "toml",
        "typescript",
        "typescriptreact",
        "yaml",
      ]
    ) {
      args.contextBuilder.patchFiletype(ft, {
        sources: ["vim-lsp", ...sources],
      });
    }
    for (const ft of ["markdown", "gitcommit", "help"]) {
      args.contextBuilder.patchFiletype(ft, {
        sources: ["mocword", "github_issue", "github_pull_request", ...sources],
      });
    }
    for (const ft of ["sh", "zsh"]) {
      args.contextBuilder.patchFiletype(ft, {
        sources: ["zsh", ...sources],
      });
    }

    return Promise.resolve();
  }
}
