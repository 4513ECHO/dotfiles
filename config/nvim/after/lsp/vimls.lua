local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm

return {
  capabilities = {
    textDocument = {
      completion = { completionItem = { snippetSupport = false } },
    },
  },
  cmd = deno_as_npm { "npm:vim-language-server@2.3.1", "--stdio" },
  cmd_env = deno_as_npm.cmd_env,
}
