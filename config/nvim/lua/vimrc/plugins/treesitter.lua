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
    "tsx",
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

-- https://github.com/nvim-treesitter/nvim-treesitter/commit/1ae9b0e4558fe7868f8cda2db65239cfb14836d0
local function apply_compatible_highlights()
  for _, hl in ipairs {
    { old = "@parameter", new = "@variable.parameter" },
    { old = "@field", new = "@variable.member" },
    { old = "@namespace", new = "@module" },
    { old = "@float", new = "@number.float" },
    { old = "@symbol", new = "@string.special.symbol" },
    { old = "@string.regex", new = "@string.regexp" },
    { old = "@text.strong", new = "@markup.strong" },
    { old = "@text.italic", new = "@markup.italic" },
    { old = "@text.link", new = "@markup.link" },
    { old = "@text.strikethrough", new = "@markup.strikethrough" },
    { old = "@text.title", new = "@markup.heading" },
    { old = "@text.literal", new = "@markup.raw" },
    { old = "@text.reference", new = "@markup.link" },
    { old = "@text.uri", new = "@markup.link.url" },
    { old = "@string.special", new = "@markup.link.label" },
    { old = "@punctuation.special", new = "@markup.list" },
    { old = "@method", new = "@function.method" },
    { old = "@method.call", new = "@function.method.call" },
    { old = "@text.todo", new = "@comment.todo" },
    { old = "@text.warning", new = "@comment.warning" },
    { old = "@text.note", new = "@comment.hint" },
    { old = "@text.danger", new = "@comment.info" },
    { old = "@text.diff.add", new = "@diff.plus" },
    { old = "@text.diff.delete", new = "@diff.minus" },
    { old = "@text.diff.change", new = "@diff.delta" },
    { old = "@text.uri", new = "@string.special.url" },
    { old = "@preproc", new = "@keyword.directive" },
    { old = "@define", new = "@keyword.directive" },
    { old = "@storageclass", new = "@keyword.storage" },
    { old = "@conditional", new = "@keyword.conditional" },
    { old = "@debug", new = "@keyword.debug" },
    { old = "@exception", new = "@keyword.exception" },
    { old = "@include", new = "@keyword.import" },
    { old = "@repeat", new = "@keyword.repeat" },
  } do
    vim.api.nvim_set_hl(0, hl.new, { default = true, link = hl.old })
  end
end
apply_compatible_highlights()
require("vimrc.autocmd").autocmd "ColorScheme" {
  callback = apply_compatible_highlights,
  desc = "Apply compatible highlights for nvim-treesitter",
}
