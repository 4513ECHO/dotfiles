if not vim.g.neovide then
  return
end

vim.opt.guifont = "HackGen35 Console NF:h12"

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_vfx_particle_density = 15

vim.keymap.set({ "i", "c" }, "<D-v>", "<C-r>+")
