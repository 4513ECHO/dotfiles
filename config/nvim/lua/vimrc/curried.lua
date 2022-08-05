---@class Curried
---@field __f function
---@field __regex string
---@field __args table
local Curried = {}
Curried.__index = Curried

---@param func function
---@param regex string?
---@return Curried
function Curried.new(func, regex, ...)
  local args = { ... }
  local curried = setmetatable({}, {
    f = func,
    regex = regex or '{}() missing \\d+ required',
    args = args or {}
  })
  return curried
end

---@return Curried|unknown
function Curried:__call(...)
  -- local cls = type(self)
  local new_args = table.insert(self.__args, ...)
  local ok, result = pcall(self.__f, new_args)
  if ok then
    return result
  else
    return { __f = self.__f }
  end
  return self.__f()
end

return Curried
