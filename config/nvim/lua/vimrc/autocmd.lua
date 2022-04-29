local group = vim.api.nvim_create_augroup("nvim_vimrc", {})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    -- NOTE: check lazily to handle opening in background
    vim.fn.timer_start(0, function()
      if vim.bo.buftype == "terminal" then
        vim.cmd "startinsert"
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
        vim.wo.cursorline = false
      end
    end)
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank { timeout = 100, on_macro = true }
  end,
})
