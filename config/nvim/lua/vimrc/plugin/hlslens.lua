local M = {}

function M.hook_add()
  vim.api.nvim_create_autocmd({ "User" }, {
    group = "nvim_vimrc",
    pattern = { "VimrcSearched" },
    callback = function()
      local hlslens = require "hlslens"
      hlslens.enable()
      hlslens.start()
    end,
  })
  vim.api.nvim_create_autocmd({ "User" }, {
    group = "nvim_vimrc",
    pattern = { "SearchxEnter" },
    callback = function()
      require("hlslens").start(true)
    end,
  })
  vim.api.nvim_create_autocmd({ "User" }, {
    group = "nvim_vimrc",
    pattern = { "SearchxCancel" },
    callback = function()
      require("hlslens").disable()
    end,
  })
  vim.api.nvim_create_autocmd({ "User" }, {
    group = "nvim_vimrc",
    pattern = { "SearchxInputChanged" },
    callback = function()
      local hlslens = require "hlslens"
      hlslens.disable()
      hlslens.enable()
      hlslens.start()
    end,
  })
end

return M
