vim.loader.enable()
require "vimrc.autocmd"
require "vimrc.clipboard"
require "vimrc.neovide"

require("vimrc.autocmd").autocmd "UIEnter" {
  callback = function()
    _G.package.loaded["vimrc.neovide"] = nil
    require "vimrc.neovide"
  end,
  desc = "Reload neovide configuration",
}
