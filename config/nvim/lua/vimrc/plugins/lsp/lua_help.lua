-- based on https://scrapbox.io/vim-jp/better_K_for_neovim_lua

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias callback fun(str: string, str2: string|nil): string

---@type callback
local function convert_cmd(str) return ":" .. str end
---@type callback
local function convert_opt(str) return "'" .. str .. "'" end
---@type callback
local function convert_var(scope, name) return scope .. ":" .. name end

local function lua_help()
  local current_word = vim.fn.expand "<cWORD>"
  if type(current_word) ~= "string" then
    return false
  end
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1
  for _, pattern in ipairs {
    { "fn%.([%w_]+)" }, -- vim.fn.foo
    { "fn%[['\"]([%w_#]+)['\"]%]" }, -- vim.fn["foo#bar"]
    { "api%.([%w_]+)" }, -- vim.api.foo
    { "(uv%.[%w_]+)" }, -- vim.uv
    { "vim%.cmd%.([%w_]+)", convert_cmd }, -- vim.cmd.foo
    { "vim%.opt%.(%w+)", convert_opt }, -- vim.opt.foo
    { "vim%.opt_local%.(%w+)", convert_opt }, -- vim.opt_local.foo
    { "vim%.opt_global%.(%w+)", convert_opt }, -- vim.opt_global.foo
    { "vim%.[gbw]?o%.(%w+)", convert_opt }, -- vim.wo.foo
    { "vim%.([gwbtv])%.([%w_]+)", convert_var }, -- vim.g.foo, vim.v.bar
    { "vim%.([gwbtv])%[['\"]([%w_#]+)['\"]%]", convert_var }, -- vim.g["foo#bar"]
    { "(vim%.[%w_%.]+)" }, -- other vim.foo (e.g. vim.tbl_map, vim.lsp.foo, ...)
  } do
    ---@cast pattern { [1]: string, [2]: callback|nil }
    local s, e, m1, m2 = current_word:find(pattern[1])
    if s and s <= cursor_col and cursor_col <= e then
      vim.cmd.help { pattern[2] and pattern[2](m1, m2) or m1 }
      return true
    end
  end
  return false
end

return function()
  if not lua_help() then
    vim.lsp.buf.hover()
  end
end
