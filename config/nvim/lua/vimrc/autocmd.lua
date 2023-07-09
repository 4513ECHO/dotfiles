---@diagnostic disable: duplicate-doc-field
local M = {}

---@type integer
M.group = vim.api.nvim_create_augroup("nvim_vimrc", { clear = true })

---Options for vim.api.nvim_create_autocmd()
---@class AutocmdOptions
---@field group? string|integer
---@field pattern? string|string[]
---@field buffer? integer
---@field desc? string
---@field callback? fun(ctx: AutocmdContext)|string
---@field command? string
---@field once? boolean
---@field nested? boolean

---@class AutocmdContext
---@field id integer autocommand id
---@field event string name of the triggered event |autocmd-event|
---@field group integer|nil autocommand group id, if any
---@field match string expanded value of <amatch>
---@field buf integer expanded value of <abuf>
---@field file string expanded value of <afile>
---@field data any arbitary data passed from |nvim_exec_autocmds()|

---@param event string|string[]
---@return fun(opts: AutocmdOptions): integer
function M.autocmd(event)
  ---@param opts AutocmdOptions
  ---@return integer
  return function(opts)
    return vim.api.nvim_create_autocmd(
      event,
      vim.tbl_deep_extend("force", { group = M.group, pattern = "*" }, opts)
    )
  end
end

M.autocmd "TermOpen" {
  callback = function()
    -- NOTE: check lazily to handle opening in background
    vim.fn.timer_start(0, function()
      if vim.bo.buftype == "terminal" then
        vim.cmd.startinsert {}
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.cursorline = false
      end
    end)
  end,
}

M.autocmd "TextYankPost" {
  callback = function()
    vim.highlight.on_yank { timeout = 100, on_macro = true }
  end,
}

M.autocmd "InsertLeave" {
  command = "mode",
}

return setmetatable(M, {
  __call = function(_, event) return M.autocmd(event) end,
})
