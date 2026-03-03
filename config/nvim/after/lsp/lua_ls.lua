---@param plugins string[]
---@return string[]
local function library(plugins)
  local plugin_paths = vim
    .iter(vim.fn["dpp#get"]())
    :filter(function(name) return vim.list_contains(plugins, name) end)
    :map(function(_, plugin) return vim.fs.joinpath(plugin.path, "lua") end)
    :totable()
  return vim.list_extend(plugin_paths, {
    vim.fs.joinpath(vim.fn.stdpath "config" --[[@as string]], "lua"),
    vim.fs.joinpath(vim.env.VIMRUNTIME, "lua"),
    "${3rd}/luv/library",
    "${3rd}/busted/library",
    "${3rd}/luassert/library",
  })
end

return {
  settings = {
    Lua = {
      completion = { showWord = "Disable" },
      diagnostics = {
        disable = { "lowercase-global" },
        enable = true,
        globals = { "vim" },
      },
      -- NOTE: Use stylua via efm-langserver instead.
      format = { enable = false },
      runtime = {
        path = { "?.lua", "?/init.lua" },
        pathStrict = true,
        version = "LuaJIT",
      },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
        library = library {
          "ddc-source-lsp-setup",
          "fidget.nvim",
          "nvim-lspconfig",
          "nvim-treesitter",
        },
        maxPreload = 1000,
      },
    },
  },
}
