local autocmd = require("vimrc.autocmd").autocmd
local lspconfig = require "lspconfig"
local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
local root_pattern = lspconfig.util.root_pattern
local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm
local denops_notify = require("vimrc.plugins.lsp.util").denops_notify

autocmd "LspAttach" {
  callback = function(ctx)
    local filetype =
      vim.api.nvim_get_option_value("filetype", { buf = ctx.buf })
    local opts = { buffer = true }
    vim.keymap.set({ "n", "x" }, "gq", function()
      vim.lsp.buf.format {
        filter = function(client) return client.name ~= "taplo" end,
      }
    end, opts)
    local K
    if not vim.tbl_contains({ "lua", "markdown", "toml", "vim" }, filetype) then
      K = vim.lsp.buf.hover
    elseif filetype == "lua" then
      K = require "vimrc.plugins.lsp.lua_help"
    else
      K = "K"
    end
    vim.keymap.set("n", "K", K, opts)
    vim.keymap.set("n", "gK", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
    -- vim.keymap.set("n", "ma", vim.lsp.buf.code_action, opts)
    vim.keymap.set({ "n", "x" }, "ma", "<Cmd>Ddu -name=codeAction<CR>", opts)
    vim.keymap.set("n", "mf", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "md", vim.diagnostic.setloclist, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  end,
}

autocmd "BufWritePre" {
  pattern = "*.json",
  callback = function() vim.lsp.buf.format { async = false, name = "efm" } end,
}

autocmd { "BufRead", "BufNewFile" } {
  pattern = ".env",
  callback = function(ctx) vim.diagnostic.disable(ctx.buf) end,
}

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
require("lspconfig.ui.windows").default_options.border = "single"

vim.diagnostic.config { signs = { priority = 20 } }
vim.fn.sign_define {
  { name = "DiagnosticSignError", text = "✗", texthl = "DiagnosticError" },
  { name = "DiagnosticSignWarn", text = "‼", texthl = "DiagnosticWarn" },
  { name = "DiagnosticSignInfo", text = "i", texthl = "DiagnosticInfo" },
  { name = "DiagnosticSignHint", text = "?", texthl = "DiagnosticHint" },
}

denops_notify "vimrc" "cacheLanguageServers" { vim.fn.stdpath "cache" }

lspconfig.efm.setup {
  filetypes = { "json", "lua", "markdown", "sh", "yaml" },
}

lspconfig.denols.setup {
  capabilities = capabilities,
  init_options = {
    enable = true,
    lint = true,
    suggest = {
      autoImports = false,
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://crux.land"] = true,
          ["https://x.nest.land"] = true,
        },
      },
    },
    unstable = true,
  },
  root_dir = root_pattern("deno.json", "deno.jsonc", "denops"),
}

lspconfig.vtsls.setup {
  capabilities = capabilities,
  -- cmd = deno_as_npm { "npm:@vtsls/language-server", "--stdio" },
  -- cmd_env = deno_as_npm.cmd_env,
  cmd = {
    vim.fn.stdpath "cache"
      .. "/ls/node_modules/@vtsls/language-server/bin/vtsls.js",
    "--stdio",
  },
  single_file_support = false,
  root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
}

lspconfig.lua_ls.setup {
  capabilities = capabilities,
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
        path = { "?.lua", "?/init.lua", "?/?.lua" },
        version = "LuaJIT",
      },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("lua", true),
        maxPreload = 1000,
      },
    },
  },
}

lspconfig.gopls.setup {
  capabilities = capabilities,
}

lspconfig.jsonls.setup {
  capabilities = capabilities,
  cmd = deno_as_npm {
    "npm:vscode-langservers-extracted@4.7.0/vscode-json-language-server",
    "--stdio",
  },
  cmd_env = deno_as_npm.cmd_env,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas {},
      validate = { enable = true },
    },
  },
}

lspconfig.pylsp.setup {
  capabilities = capabilities,
  settings = {
    pylsp = {
      configurationSources = { "flake8" },
      plugins = {
        black = { enabled = true },
        flake8 = { enabled = true },
        meccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        pyls_isort = { enabled = true },
        pylsp_mypy = {
          enabled = true,
          overrides = { "--no-pretty", true },
          report_progress = true,
        },
      },
    },
  },
}

lspconfig.taplo.setup {
  capabilities = capabilities,
  settings = {
    evenBetterToml = {
      schema = {
        associations = {
          ["/dein/[^/]+\\.toml$"] = (
            "file://"
            .. vim.env.DEIN_DIR
            .. "/settings/dein.toml.json"
          ),
        },
      },
    },
  },
}

lspconfig.yamlls.setup {
  -- cmd = deno_as_npm { "npm:yaml-language-server", "--stdio" },
  -- cmd_env = deno_as_npm.cmd_env,
  cmd = {
    vim.fn.stdpath "cache"
      .. "/ls/node_modules/yaml-language-server/bin/yaml-language-server",
    "--stdio",
  },
  settings = {
    yaml = {
      completion = true,
      hover = true,
      validate = true,
      schemaStore = { enable = false, url = "" },
      schemas = require("schemastore").yaml.schemas {
        extra = {
          {
            description = "efm-langserver config",
            fileMatch = "/efm-langserver/config.yaml",
            name = "efm-langserver",
            url = "https://mattn.github.io/efm-langserver/schema.json",
          },
          {
            description = "aqua.yaml",
            fileMatch = "/aqua/aqua.yaml",
            name = "aqua.yaml",
            url = "https://pax.deno.dev/aquaproj/aqua@v2.11.0-4/json-schema/aqua-yaml.json",
          },
          {
            description = "aqua-registry",
            fileMatch = {
              "/aqua-registry/pkgs/**/registry.yaml",
              "/aqua-registry/registry.yaml",
              "/aqua/experimental.yaml",
              "/aqua/registry.yaml",
            },
            name = "aqua-registry",
            url = "https://pax.deno.dev/aquaproj/aqua@v2.11.0-4/json-schema/registry.json",
          },
        },
      },
    },
  },
}
