if not vim.g.neovide then
  return
end

vim.opt.guifont = "HackGen35 Console NF:h12"

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_vfx_particle_density = 15

local pastekey
if vim.fn.has "mac" == 1 then
  pastekey = "<D-v>"
else
  pastekey = "<C-S-v>"
end
vim.keymap.set({ "i", "c" }, pastekey, "<C-r>+")
vim.keymap.set("t", pastekey, '<C-\\><C-n>"+pi')
