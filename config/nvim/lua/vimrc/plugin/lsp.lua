---@type string[]
local ret = {}

-- NOTE: code from folke/lua-dev.nvim
---@param lib string
local function add(lib)
  for _, dir in pairs { "/lua", "/types" } do
    for _, p in pairs(vim.fn.expand(lib .. dir, false, true)) do
      p = vim.loop.fs_realpath(p)
      if p then
        table.insert(ret, p)
      end
    end
  end
end

add "$VIMRUNTIME"
for _, site in pairs(vim.split(vim.o.runtimepath, ",")) do
  add(site)
end

return ret
