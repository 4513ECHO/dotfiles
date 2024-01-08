local autocmd = require("vimrc.autocmd").autocmd
local lspconfig = require "lspconfig"
local capabilities = require("ddc_source_lsp").make_client_capabilities()
local root_pattern = lspconfig.util.root_pattern
local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm

autocmd "LspAttach" {
  callback = function(ctx)
    if vim.lsp.get_client_by_id(ctx.data.client_id).name == "copilot" then
      return
    end
    local filetype =
      vim.api.nvim_get_option_value("filetype", { buf = ctx.buf })
    local opts = { buffer = true }
    vim.keymap.set({ "n", "x" }, "gq", function()
      vim.lsp.buf.format {
        filter = function(client) return client.name ~= "taplo" end,
      }
    end, opts)
    local K
    if not vim.iter({ "lua", "markdown", "toml", "vim" }):find(filetype) then
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

-- from https://github.com/neovim/neovim/pull/15981
local util = require "vim.lsp.util"
local orig = util.make_floating_popup_options
---@diagnostic disable-next-line: duplicate-set-field
util.make_floating_popup_options = function(width, height, opts)
  local orig_opts = orig(width, height, opts)
  orig_opts.noautocmd = true
  return orig_opts
end

vim.diagnostic.config { signs = { priority = 20 } }
vim.fn.sign_define {
  { name = "DiagnosticSignError", text = "✗", texthl = "DiagnosticError" },
  { name = "DiagnosticSignWarn", text = "‼", texthl = "DiagnosticWarn" },
  { name = "DiagnosticSignInfo", text = "i", texthl = "DiagnosticInfo" },
  { name = "DiagnosticSignHint", text = "?", texthl = "DiagnosticHint" },
}

lspconfig.efm.setup {
  filetypes = { "json", "lua", "markdown", "sh", "yaml" },
  init_options = {
    documentFormatting = true,
    rangeFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = true,
    completion = true,
  },
}

lspconfig.denols.setup {
  capabilities = capabilities,
  settings = {
    deno = {
      enable = true,
      lint = true,
      suggest = {
        autoImports = false,
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://mod.4513echo.dev"] = true,
          },
        },
      },
      unstable = true,
    },
  },
  root_dir = root_pattern("deno.json", "deno.jsonc", "denops"),
  single_file_support = true,
}

lspconfig.vtsls.setup {
  -- cmd = deno_as_npm { "npm:@vtsls/language-server@0.1.23", "--stdio" },
  -- cmd_env = deno_as_npm.cmd_env,
  single_file_support = false,
  root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  on_new_config = function(new_config)
    local vtsls = vim.fn["denops#request"]("vimrc", "cacheVtsls", {
      vim.fn.stdpath "cache" --[[@as string]],
    })
    new_config.cmd = { vtsls, "--stdio" }
  end,
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
    "npm:vscode-langservers-extracted@4.8.0/vscode-json-language-server",
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

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
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
  cmd = deno_as_npm { "npm:yaml-language-server@1.14.0", "--stdio" },
  cmd_env = deno_as_npm.cmd_env,
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
            url = "https://pax.deno.dev/aquaproj/aqua@v2.21.0/json-schema/aqua-yaml.json",
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
            url = "https://pax.deno.dev/aquaproj/aqua@v2.21.0/json-schema/registry.json",
          },
        },
      },
    },
  },
}
