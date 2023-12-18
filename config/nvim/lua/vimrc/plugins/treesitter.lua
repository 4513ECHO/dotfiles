---@type table<string, ParserInfo>
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.unifieddiff = {
  install_info = {
    url = "https://github.com/monaqa/tree-sitter-unifieddiff",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "diff",
  maintainers = { "@monaqa" },
}
parser_config.uri = {
  install_info = {
    url = "https://github.com/atusy/tree-sitter-uri",
    branch = "main",
    files = { "src/parser.c" },
  },
  filetype = "uri",
  maintainers = { "@atusy" },
}
-- parser_config.vim = {
--   install_info = {
--     url = "~/Develops/github.com/4513ECHO/tree-sitter-vim",
--     branch = "interpolated-string",
--     files = { "src/parser.c", "src/scanner.c" },
--   },
--   filetype = "vim",
-- }

vim.treesitter.start = (function(wrapped)
  ---@param bufnr integer|nil
  ---@param lang string|nil
  return function(bufnr, lang)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    lang = vim.treesitter.language.get_lang(lang or vim.bo.filetype)
    if
      vim.iter({ "bash", "yaml", "vimdoc" }):find(lang)
      or (
        lang == "vim"
        and vim.api
          .nvim_buf_get_lines(bufnr, 0, 1, false)[1]
          :match "^vim9script"
      )
    then
      return
    end
    wrapped(bufnr, lang)
  end
end)(vim.treesitter.start)

local parser_install_dir = vim.fn.stdpath "data" --[[@as string]] .. "/parsers"
vim.opt.runtimepath:append(parser_install_dir)

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup {
  parser_install_dir = parser_install_dir,
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
    "uri",
    "vim",
    "yaml",
  },
  highlight = {
    enable = true,
  },
}
