local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm

return {
  cmd = deno_as_npm { "npm:@tailwindcss/language-server@0.14.16", "--stdio" },
  cmd_env = deno_as_npm.cmd_env,
  settings = {
    tailwindCSS = {
      experimental = {
        configFile = "app/style.css",
      },
    },
  },
  ---@param bufnr integer
  ---@param callback fun(root_dir?: string)
  root_dir = function(bufnr, callback)
    local found_config_files = vim.fs.find({
      "package.json",
      "deno.json",
      "deno.jsonc",
    }, {
      upward = true,
      path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
    })
    if #found_config_files == 0 then
      return
    end
    for line in io.lines(found_config_files[1]) do
      if
        line --[[@as string]]:find "tailwindcss"
      then
        callback(vim.fs.dirname(found_config_files[1]))
        return
      end
    end
  end,
}
