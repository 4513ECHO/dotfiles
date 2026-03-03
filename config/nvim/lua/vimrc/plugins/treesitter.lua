local autocmd = require("vimrc.autocmd").autocmd

autocmd "User" {
  pattern = "TSUpdate",
  callback = function()
    ---@diagnostic disable: missing-fields
    local parser_config = require "nvim-treesitter.parsers"
    parser_config.unifieddiff = {
      install_info = {
        url = "https://github.com/monaqa/tree-sitter-unifieddiff",
        branch = "master",
        queries = "queries",
      },
    }
    parser_config.uri = {
      install_info = {
        url = "https://github.com/atusy/tree-sitter-uri",
      },
    }
    ---@diagnostic enable: missing-fields
  end,
}

vim.treesitter.language.register("unifieddiff", { "diff", "gin-diff" })

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
    elseif vim.list_contains({ "bash", "json", "yaml" }, lang) then
      return -- I want to disable treesitter for these languages
    elseif
      lang == "vim" and vim.fn.getbufoneline(bufnr, 1):match "^vim9script"
    then
      return notify "vim9script is not supported"
    end
    wrapped(bufnr, lang)
  end
end)(vim.treesitter.start)

---@type string[]
local ensure_installed = {
  "bash",
  "css",
  "go",
  "html",
  "json",
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
}

autocmd "FileType" {
  pattern = vim
    .iter(ensure_installed)
    :map(vim.treesitter.language.get_filetypes)
    :flatten()
    :totable(),
  callback = function() vim.treesitter.start() end,
}

autocmd "User" {
  pattern = "TSUpdate",
  once = true,
  callback = function() require("nvim-treesitter").install(ensure_installed) end,
}

local function link_diff_highlights()
  if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "diffAdded" })) then
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
