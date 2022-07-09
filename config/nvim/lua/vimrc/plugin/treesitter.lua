require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash",
    "go",
    "html",
    "jsdoc",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "rust",
    "toml",
    "typescript",
    "vim",
    "yaml",
  },
  highlight = {
    enable = true,
    disable = { "bash", "yaml" },
  },
  playground = {
    enable = true,
    keybindings = {
      update = "<C-r>",
    },
  },
  query_linter = {
    enable = true,
  },
}
