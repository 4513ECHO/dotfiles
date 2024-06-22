local autocmd = require("vimrc.autocmd").autocmd
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

vim.treesitter.language.register("unifieddiff", "gin-diff")

vim.treesitter.start = (function(wrapped)
  ---@param msg string
  local function notify(msg)
    vim.notify(msg, vim.log.levels.WARN, { title = "vim.treesitter.start" })
  end
  ---@param bufnr integer|nil
  ---@param lang string|nil
  return function(bufnr, lang)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    lang = vim.treesitter.language.get_lang(lang or vim.bo.filetype)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
      return notify "The file is too large"
    elseif vim.fn.line "$" > 20000 then
      return notify "The buffer has too many lines"
    elseif vim.list_contains({ "bash", "yaml", "vimdoc" }, lang) then
      return -- Not supported language
    elseif
      lang == "vim"
      and vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]:match "^vim9script"
    then
      return notify "vim9script is not supported"
    end
    wrapped(bufnr, lang)
  end
end)(vim.treesitter.start)

local parser_install_dir = vim.fn.stdpath "data" .. "/parsers"
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
    "tsx",
    "typescript",
    "typst",
    "unifieddiff",
    "uri",
    "vim",
    "yaml",
  },
  highlight = {
    enable = true,
  },
}

local function link_diff_highlights()
  if vim.fn.empty(vim.api.nvim_get_hl(0, { name = "diffAdded" })) == 1 then
    vim.api.nvim_set_hl(0, "@diff.plus", { link = "DiffAdd" })
    vim.api.nvim_set_hl(0, "@diff.minus", { link = "DiffDelete" })
  else
    vim.api.nvim_set_hl(0, "@diff.plus", { link = "diffAdded" })
    vim.api.nvim_set_hl(0, "@diff.minus", { link = "diffRemoved" })
  end
end

autocmd "ColorScheme" {
  callback = require("treesitter-compat-highlights").apply,
  desc = "Apply compatible highlights for nvim-treesitter",
}
autocmd "ColorScheme" {
  callback = link_diff_highlights,
  desc = "Link diff highlights of nvim-treesitter",
}
require("treesitter-compat-highlights").apply()
link_diff_highlights()
