local M = {}
---@type ProgressHandle|nil
local handle
local progress = require "fidget.progress"

function M.report(message)
  if handle then
    handle:report { message = message }
  else
    handle = progress.handle.create {
      title = "Cache vtsls",
      message = message,
      lsp_client = { name = "cache_vtsls" },
    }
  end
end

function M.done()
  if not handle then
    return
  end
  handle:finish()
  handle = nil
end

return M
