if not vim.g.neovide then
  return
end

local font_base, font_size = "HackGen35 Console NF:h%d", 12
vim.opt.guifont = font_base:format(font_size)
vim.opt.linespace = 2

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_vfx_particle_density = 15

local modifier_base = vim.fn.has "mac" == 1 and "<D-%s>" or "<C-S-%s>"
---@param key string
---@return string
local function modifier(key) return modifier_base:format(key) end

-- paste
vim.keymap.set({ "i", "c", "t" }, modifier "v", function()
  vim.api.nvim_paste(vim.fn.getreg "+" --[[@as string]], false, -1)
end)

-- disable mouse selecting
for _, mod in pairs { "S", "C", "A", "D", "2", "3", "4" } do
  vim.keymap.set("", ("<%s-LeftMouse>"):format(mod), "<Nop>")
  vim.keymap.set("", ("<%s-LeftDrag>"):format(mod), "<LeftMouse>")
  vim.keymap.set("", ("<%s-LeftRelease>"):format(mod), "<Nop>")
end
vim.keymap.set("", "<LeftDrag>", "<LeftMouse>")
vim.keymap.set("", "<LeftRelease>", "<Nop>")

-- adjust font size
---@param ctx { fargs: string[] }
vim.api.nvim_create_user_command("FontSize", function(ctx)
  font_size = tonumber(ctx.fargs[1] or 12) or font_size
  vim.opt.guifont = font_base:format(font_size)
end, { nargs = "?" })
