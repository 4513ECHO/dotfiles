if not vim.g.neovide then
  return
end

vim.opt.guifont = "HackGen35 Console NF:h12"
vim.opt.linespace = 2

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_vfx_particle_density = 15

-- paste
vim.keymap.set(
  { "i", "c", "t" },
  vim.fn.has "mac" == 1 and "<D-v>" or "<C-S-v>",
  function()
    vim.api.nvim_paste(vim.fn.getreg "+" --[[@as string]], false, -1)
  end
)

-- disable mouse selecting
for _, mod in pairs { "S", "A", "2", "3", "4" } do
  vim.keymap.set("", ("<%s-LeftMouse>"):format(mod), "<Nop>")
  vim.keymap.set("", ("<%s-LeftDrag>"):format(mod), "<LeftMouse>")
  vim.keymap.set("", ("<%s-LeftRelease>"):format(mod), "<Nop>")
end
vim.keymap.set("", "<LeftDrag>", "<LeftMouse>")
vim.keymap.set("", "<LeftRelease>", "<Nop>")
