local wezterm = require "wezterm"
local is_mac = wezterm.target_triple:find "apple%-darwin" ~= nil

wezterm.on(
  "format-window-title",
  function(tab, pane)
    return ("[%d] %s | WezTerm"):format(tab.tab_index, pane.title)
  end
)

return {
  adjust_window_size_when_changing_font_size = false,
  colors = {
    cursor_bg = "rgba(88%, 88%, 88%, 0.5)",
    cursor_border = "rgba(88%, 88%, 88%, 0.5)",
  },
  cursor_thickness = "1pt",
  enable_scroll_bar = true,
  font_size = 12,
  font = wezterm.font_with_fallback {
    "CommitMono",
    "HackGen35 Console NF",
    table.unpack(
      is_mac and { "Apple Color Emoji" }
        or { "Noto Sans Mono CJK JP", "Noto Color Emoji" }
    ),
  },
  front_end = "WebGpu",
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {
      key = "¥",
      mods = "CTRL",
      action = wezterm.action.SendKey { key = "\\", mods = "CTRL" },
    },
  },
  use_ime = false,
  window_frame = {
    font = wezterm.font {
      family = "CommitMono",
      scale = 0.8,
    },
  },
}
