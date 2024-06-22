import {
  BaseConfig,
  type ConfigArguments,
} from "https://deno.land/x/ddc_vim@v4.3.1/base/config.ts";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    const hasNvim = args.denops.meta.host === "nvim";
    const sources = ["file", "around", "vsnip", "buffer"]
      .concat(Deno.env.has("TMUX") ? ["tmux"] : []);

    args.contextBuilder.patchGlobal({
      cmdlineSources: {
        ":": ["cmdline", "around", "buffer"],
        "@": [
          "input",
          { name: "around", options: { minAutoCompleteLength: 1 } },
          { name: "buffer", options: { minAutoCompleteLength: 1 } },
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
        input: {
          mark: "[input]",
          isVolatile: true,
        },
        line: {
          mark: "[line]",
        },
        lsp: {
          mark: "[lsp]",
          forceCompletionPattern: "\\.|:\\s*|->\\s*",
        },
        mocword: {
          mark: "[word]",
          minAutoCompleteLength: 3,
          isVolatile: true,
          enabledIf: "exists('$MOCWORD_DATA')",
        },
        omni: {
          mark: "[omni]",
        },
        skkeleton: {
          mark: "[skk]",
          matchers: [],
          sorters: [],
          converters: [],
          minAutoCompleteLength: 1,
          isVolatile: true,
        },
        tmux: {
          mark: "[tmux]",
          enabledIf: "exists('$TMUX')",
        },
        vim: {
          mark: "[vim]",
          isVolatile: true,
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
          bufNameStyle: "basename",
          getBufnrs: async () => await args.denops.call("tabpagebuflist"),
        },
        file: {
          trailingSlash: true,
          followSymlinks: true,
        },
        lsp: {
          enableAdditionalTextEdit: true,
          enableResolveItem: true,
          lspEngine: hasNvim ? "nvim-lsp" : "vim-lsp",
          snippetEngine: async (body: string) =>
            await args.denops.call("vsnip#anonymous", body),
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

    const commentContextCallback = async () =>
      await args.denops.call("ddc#syntax#in", ["comment", "Comment"])
        ? { sources: ["around", "buffer", "mocword"] }
        : {};

    const setSourcesByFiletypes = (filetypes: string[], sources: string[]) =>
      filetypes.forEach((filetype) => {
        args.contextBuilder.patchFiletype(filetype, { sources });
        args.contextBuilder.setContextFiletype(
          commentContextCallback,
          filetype,
        );
      });

    // NOTE: mocword source should be placed after around source.
    const sourcesWithMocword = sources.toSpliced(2, 0, "mocword");

    args.contextBuilder.setContextGlobal(commentContextCallback);

    setSourcesByFiletypes(["vim"], ["vim", ...sources]);
    setSourcesByFiletypes([
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
      "typst",
      "vim",
      "yaml",
    ], ["lsp", ...sources]);
    setSourcesByFiletypes(
      ["markdown", "gitcommit"],
      ["github_issue", "github_pull_request", ...sourcesWithMocword],
    );
    setSourcesByFiletypes(["help"], sourcesWithMocword);
    setSourcesByFiletypes(["sh", "zsh"], ["shell-native", ...sources]);

    return Promise.resolve();
  }
}
