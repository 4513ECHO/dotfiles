local M = {}
M.group = vim.api.nvim_create_augroup("nvim_vimrc", { clear = true })

---@param event string|string[]
---@return function
function M.autocmd(event)
  ---@param opts table
  return function(opts)
    vim.api.nvim_create_autocmd(
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
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
        vim.wo.cursorline = false
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
