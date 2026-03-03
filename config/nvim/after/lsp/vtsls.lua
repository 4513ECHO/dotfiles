local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm

return {
  cmd = deno_as_npm { "npm:@vtsls/language-server@0.2.8", "--stdio" },
  cmd_env = deno_as_npm.cmd_env,
  settings = { vtsls = { typescript = {} } },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
  on_new_config = function(new_config)
    if not new_config.settings.vtsls.typescript.globalTsdk then
      new_config.settings.vtsls.typescript.globalTsdk =
        vim.fn["denops#request"]("vimrc", "getGlobalTsdk", {})
    end
  end,
  workspace_required = true,
}
