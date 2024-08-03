---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
local M = {}

---Helper function to replace language servers using npm with Deno.
---
---@example
---```lua
---require("lspconfig").vtsls.setup {
---  cmd = deno_as_npm { "npm:@vtsls/language-server", "--stdio" },
---  cmd_env = deno_as_npm.cmd_env,
---}
---```
---@class deno_as_npm
---@diagnostic disable-next-line: duplicate-doc-field
---@field cmd_env table<string, unknown> The `cmd_env` option for lspconfig-setup
---@overload fun(cmd: string[]): string[]
M.deno_as_npm = setmetatable({}, {
  __call = function(_, cmd)
    return vim.list_extend({
      "deno",
      "run",
      "--allow-all",
      "--no-config",
      "--no-lock",
      "--node-modules-dir=false",
    }, cmd)
  end,
})
M.deno_as_npm.cmd_env = { NO_COLOR = true }

---@return { uri: string }[]
function M.get_yaml_json_schema()
  local client = vim.lsp.get_clients({ bufnr = 0, name = "yamlls" })[1]
  if not client then
    return {}
  end
  ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
  return client.request_sync("yaml/get/jsonSchema", vim.uri_from_bufnr(0)).result
end

---@param client string
---@param command string
---@param arguments unknown[]
function M.executeCommand(client, command, arguments)
  local c = vim.lsp.get_clients({ name = client })[1]
  if not c then
    return
  end
  c.request(
    "workspace/executeCommand",
    { command = command, arguments = arguments },
    function(err, result)
      vim.cmd.redraw { bang = true }
      vim.api.nvim_echo({
        {
          err and vim.inspect(err) or vim.inspect(result),
          err and "ErrorMsg",
        },
      }, true, {})
    end
  )
end

return M
