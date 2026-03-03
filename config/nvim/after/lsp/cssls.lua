local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm

return {
  cmd = deno_as_npm {
    "npm:vscode-langservers-extracted@4.10.0/vscode-css-language-server",
    "--stdio",
  },
  cmd_env = deno_as_npm.cmd_env,
}
