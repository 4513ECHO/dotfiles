require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash",
    "go",
    "html",
    "lua",
    "markdown",
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
