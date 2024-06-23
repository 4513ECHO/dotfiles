if not vim.g.neovide then
  return
end

local font_base, font_size = "CommitMono,HackGen35 Console NF:h%d", 12
vim.opt.guifont = font_base:format(font_size)
vim.opt.linespace = 2

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_trail_size = 0.5
vim.g.neovide_cursor_vfx_particle_density = 15
vim.g.neovide_transparency = 0.8
vim.g.neovide_input_macos_option_key_is_meta = "both"
vim.g.neovide_input_ime = false

local modifier_base = vim.fn.has "mac" == 1 and "<D-%s>" or "<C-S-%s>"
---@param key string
---@return string
local function modifier(key) return modifier_base:format(key) end

-- paste
vim.keymap.set("", modifier "v", "<Nop>")
vim.keymap.set(
  { "!", "s", "t" },
  modifier "v",
  function() vim.api.nvim_paste(vim.fn.getreg "+", false, -1) end,
  { desc = "Paste from clipboard" }
)

-- disable mouse selecting
for _, mod in pairs { "S", "C", "A", "D", "2", "3", "4" } do
  vim.keymap.set("", ("<%s-LeftMouse>"):format(mod), "<Nop>")
  vim.keymap.set("", ("<%s-LeftDrag>"):format(mod), "<LeftMouse>")
  vim.keymap.set("", ("<%s-LeftRelease>"):format(mod), "<Nop>")
end
vim.keymap.set("", "<LeftDrag>", "<LeftMouse>")
vim.keymap.set("", "<LeftRelease>", "<Nop>")

vim.cmd.aunmenu { "PopUp" }

-- adjust font size
---@param ctx { fargs: string[] }
vim.api.nvim_create_user_command("FontSize", function(ctx)
  local args = ctx.fargs[1] or "12"
  font_size = (vim.startswith(args, "+") or vim.startswith(args, "-"))
      and font_size + (tonumber(args) or font_size)
    or (tonumber(args) or font_size)
  vim.opt.guifont = font_base:format(font_size)
end, { nargs = "?" })
