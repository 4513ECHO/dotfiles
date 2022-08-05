local M = {}
local autocmd = require('vimrc.autocmd')

function M.hook_add()
  autocmd "User" {
    pattern = { "VimrcSearched" },
    callback = function()
      local hlslens = require "hlslens"
      hlslens.enable()
      hlslens.start()
    end,
  }
  autocmd "User" {
    pattern = { "SearchxEnter" },
    callback = function()
      require("hlslens").start(true)
    end,
  }
  autocmd "User" {
    pattern = { "SearchxCancel" },
    callback = function()
      require("hlslens").disable()
    end,
  }
  autocmd "User" {
    pattern = { "SearchxInputChanged" },
    callback = function()
      local hlslens = require "hlslens"
      hlslens.disable()
      hlslens.enable()
      hlslens.start()
    end,
  }
end

return M
