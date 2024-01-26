local providers = {
  pbcopy = { { "pbcopy" }, { "pbpaste" } },
  tmux = {
    { "tmux", "load-buffer", "-w", "-" },
    { "tmux", "save-buffer", "-" },
  },
  xsel = {
    { "xsel", "--nodetach", "-i", "-b" },
    { "xsel", "-o", "-b" },
  },
  osc52 = {
    require("vim.ui.clipboard.osc52").copy "+",
    require("vim.ui.clipboard.osc52").paste "+",
  },
}

local function set_provider(name)
  vim.g.clipboard = {
    name = name,
    copy = {
      ["+"] = providers[name][1],
      ["*"] = providers[name][1],
    },
    paste = {
      ["+"] = providers[name][2],
      ["*"] = providers[name][2],
    },
  }
end

if vim.fn.has "mac" == 1 then
  set_provider "pbcopy"
elseif vim.env.TMUX and vim.env.TMUX ~= "" then
  set_provider "tmux"
elseif vim.env.DISPLAY and vim.env.DISPLAY ~= "" then
  set_provider "xsel"
else
  set_provider "osc52"
end
