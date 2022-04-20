---@type table<string, boolean>
local ret = {}

-- NOTE: code from folke/lua-dev.nvim
---@param lib string
---@param filter table|nil
local function add(lib, filter)
  for _, dir in pairs { "/lua", "/types" } do
    for _, p in pairs(vim.fn.expand(lib .. dir, false, true)) do
      p = vim.loop.fs_realpath(p)
      if p and (not filter or filter[vim.fn.fnamemodify(p, ":h:t")]) then
        ret[p] = true
      end
    end
  end
end

add "$VIMRUNTIME"
for _, site in pairs(vim.split(vim.o.runtimepath, ",")) do
  add(site)
end

return ret
