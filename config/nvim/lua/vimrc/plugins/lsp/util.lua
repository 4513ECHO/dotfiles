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
  return vim
    .iter(vim.lsp.get_clients { buffer = 0 })
    :filter(function(client) return client.name == "yamlls" end)
    :next()
    .request_sync("yaml/get/jsonSchema", vim.uri_from_bufnr(0)).result
end

return M
