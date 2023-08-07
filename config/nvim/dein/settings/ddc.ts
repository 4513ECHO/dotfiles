import {
  BaseConfig,
  type ConfigArguments,
} from "https://deno.land/x/ddc_vim@v3.9.1/base/config.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    const hasNvim = args.denops.meta.host === "nvim";
    const sources = ["file", "around", "vsnip", "buffer"]
      .concat(Deno.env.has("TMUX") ? ["tmux"] : []);

    args.contextBuilder.patchGlobal({
      cmdlineSources: {
        ":": ["cmdline", "around"],
        "@": [
          { name: "around", options: { minAutoCompleteLength: 1 } },
          "buffer",
        ],
      },
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
        },
        buffer: {
          mark: "[buf]",
        },
        cmdline: {
          mark: "[cmd]",
          isVolatile: true,
          forceCompletionPattern: "[\\w@:~._-]/[\\w@:~._-]*",
          keywordPattern: "[\\w#:~_-]*",
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
        },
        "nvim-lsp": {
          mark: "[lsp]",
          forceCompletionPattern: "\\.|:\\s*|->\\s*",
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
        "shell-native": {
          mark: "[sh]",
          isVolatile: true,
          forceCompletionPattern: "[\\w@:~._-]/[\\w@:~._-]*",
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
        "nvim-lsp": {
          snippetEngine: async (body: string) =>
            await args.denops.call("vsnip#anonymous", body),
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
        },
        tmux: {
          currentWinOnly: true,
          excludeCurrentPane: true,
          kindFormat: "#{pane_index}.#{pane_current_command}",
        },
        "shell-native": {
          envs: { COLUMNS: "127" },
          shell: "zsh",
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

    args.contextBuilder.patchFiletype("toml", {
      sourceOptions: {
        "nvim-lsp": {
          forceCompletionPattern: '\\.|[=#{[,"]\\s*',
        },
        "vim-lsp": {
          forceCompletionPattern: '\\.|[=#{[,"]\\s*',
        },
      },
    });

    const addSourcesByFiletypes = (filetypes: string[], added: string[]) =>
      filetypes.forEach((ft) =>
        args.contextBuilder.patchFiletype(ft, {
          sources: added.concat(sources),
        })
      );

    addSourcesByFiletypes(["vim"], ["necovim"]);
    addSourcesByFiletypes([
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
    ], [hasNvim ? "nvim-lsp" : "vim-lsp"]);
    addSourcesByFiletypes(
      ["markdown", "gitcommit"],
      ["mocword", "github_issue", "github_pull_request"],
    );
    addSourcesByFiletypes(["help"], ["mocword"]);
    addSourcesByFiletypes(["sh", "zsh"], ["shell-native"]);

    return Promise.resolve();
  }
}
