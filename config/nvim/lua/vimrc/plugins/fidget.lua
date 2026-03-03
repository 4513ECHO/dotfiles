local M = {}
---@type table<string, ProgressHandle|nil>
local handles = {}
local progress = require "fidget.progress"

---@param name string
---@param message { percentage: integer|nil, title: string|nil }
function M.report(name, message)
  if handles[name] then
    handles[name]:report(message)
  else
    handles[name] = progress.handle.create {
      title = "Download SKK-JISYO.L",
      lsp_client = { name = name },
      percentage = message.percentage,
    }
  end
end

---@param name string
function M.done(name)
  if not handles[name] then
    return
  end
  handles[name]:finish()
  handles[name] = nil
end

return M
