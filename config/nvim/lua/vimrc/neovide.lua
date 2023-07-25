if not vim.g.neovide then
  return
end

vim.opt.guifont = "HackGen35 Console NF:h12"

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_vfx_particle_density = 15

vim.keymap.set(
  { "i", "c", "t" },
  vim.fn.has "mac" == 1 and "<D-v>" or "<C-S-v>",
  function() vim.api.nvim_paste(vim.fn.getreg "+", false, -1) end
)
