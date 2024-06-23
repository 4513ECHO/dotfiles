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
    ---@type string|string[]|nil
    local pattern = opts.pattern or "*"
    if opts.buffer then
      pattern = nil
    end
    return vim.api.nvim_create_autocmd(
      event,
      vim.tbl_extend("force", { group = M.group, pattern = pattern }, opts)
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

M.autocmd "BufLeave" {
  pattern = "term://*",
  command = "checktime",
  desc = "Check files changes in terminal buffers",
}

M.autocmd "TextYankPost" {
  callback = function()
    vim.highlight.on_yank { timeout = 100, on_macro = true }
  end,
  desc = "Highlight yanked text",
}

M.autocmd "ColorScheme" {
  callback = function()
    if vim.opt.laststatus:get() == 3 then
      vim.api.nvim_set_hl(0, "VertSplit", {})
    end
  end,
  desc = "Clear VertSplit highlight",
}

return setmetatable(M, {
  __call = function(_, event) return M.autocmd(event) end,
})
