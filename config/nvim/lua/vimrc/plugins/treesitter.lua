local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.unifieddiff = {
  install_info = {
    url = "https://github.com/monaqa/tree-sitter-unifieddiff",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "diff",
  maintainers = { "@monaqa" },
}
-- parser_config.vim = {
--   install_info = {
--     url = "~/Develops/github.com/4513ECHO/tree-sitter-vim",
--     branch = "interpolated-string",
--     files = { "src/parser.c", "src/scanner.c" },
--   },
--   filetype = "vim",
-- }

---@param lang string
---@param bufnr integer
---@return boolean
local function disable_highlight(lang, bufnr)
  return vim.iter({ "bash", "yaml", "vimdoc" }):find(lang)
    or (
      lang == "vim"
      and vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]:match "^vim9script"
    )
end

vim.opt.runtimepath:append(vim.fn.stdpath "data" .. "/parsers")

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  parser_install_dir = vim.fn.stdpath "data" .. "/parsers",
  ensure_installed = {
    "bash",
    "go",
    "html",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "rust",
    "toml",
    "typescript",
    "unifieddiff",
    "vim",
    "yaml",
  },
  highlight = {
    enable = true,
    disable = disable_highlight,
  },
}
