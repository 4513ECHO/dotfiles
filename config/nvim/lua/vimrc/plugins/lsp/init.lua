local autocmd = require("vimrc.autocmd").autocmd
local lspconfig = require "lspconfig"
local root_pattern = lspconfig.util.root_pattern
local deno_as_npm = require("vimrc.plugins.lsp.util").deno_as_npm

local function with(func, ...)
  local args = { ... }
  return function() return func(unpack(args)) end
end
local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { buffer = true })
end

autocmd "LspAttach" {
  callback = function(ctx)
    if vim.lsp.get_client_by_id(ctx.data.client_id).name == "copilot" then
      return
    end
    local filetype = vim.bo[ctx.buf].filetype

    local filter = function(client) return client.name ~= "taplo" end
    map({ "n", "x" }, "gq", with(vim.lsp.buf.format, { filter = filter }))

    local K
    if not vim.iter({ "lua", "markdown", "toml", "vim" }):find(filetype) then
      K = vim.lsp.buf.hover
    elseif filetype == "lua" then
      K = require "vimrc.plugins.lsp.lua_help"
    else
      K = "K"
    end
    map("n", "K", K)

    map("n", "gK", with(vim.lsp.buf.hover, { border = "single" }))
    map("n", "gd", vim.lsp.buf.definition)
    pcall(function()
      vim.keymap.del("n", "grn", { buffer = ctx.buf })
      vim.keymap.del("n", "gra", { buffer = ctx.buf })
      vim.keymap.del("n", "grr", { buffer = ctx.buf })
    end)
    map("n", "gr", vim.lsp.buf.rename)
    map({ "n", "x" }, "ma", "<Cmd>Ddu -name=codeAction<CR>")
    map("n", "mf", vim.lsp.buf.references)
    map("n", "md", vim.diagnostic.setloclist)
    local function jump(direction)
      return function() vim.diagnostic.jump { count = direction * vim.v.count1 } end
    end
    map("n", "]d", jump(1))
    map("n", "[d", jump(-1))
  end,
}

autocmd "LspAttach" {
  pattern = ".env",
  nested = true,
  callback = function(ctx)
    vim.lsp.buf_detach_client(ctx.buf, ctx.data.client_id)
  end,
  desc = "Disable shellcheck for .env",
}

-- https://github.com/neovim/neovim/issues/30985
for _, method in ipairs { "textDocument/diagnostic", "workspace/diagnostic" } do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context)
    if err and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context)
  end
end

vim.lsp.util.open_floating_preview = (function(wrapped)
  return function(contents, syntax, opts)
    local bufnr, winid = wrapped(contents, syntax, opts)
    if syntax == "markdown" then
      -- Reapply treesitter highlighting
      vim.treesitter.stop(bufnr)
      vim.treesitter.start(bufnr, "markdown")
      vim.wo[winid].conceallevel = 0
      -- Remove zero-width space
      vim.api.nvim_buf_call(bufnr, function()
        vim.bo[bufnr].modifiable = true
        vim.cmd "silent keeppatterns %substitute/&#8203;//eg"
        vim.bo[bufnr].modifiable = false
      end)
    end
    return bufnr, winid
  end
end)(vim.lsp.util.open_floating_preview)

require("ddc_source_lsp_setup").setup {
  override_capabilities = false,
  respect_trigger = true,
}
lspconfig.util.on_setup = lspconfig.util.add_hook_before(
  lspconfig.util.on_setup,
  ---@param config lspconfig.Config
  function(config)
    ---@type lsp.ClientCapabilities
    local capabilities = require("ddc_source_lsp").make_client_capabilities()
    if config.name == "vimls" then
      capabilities.textDocument.completion.completionItem.snippetSupport = false
    elseif config.name == "rust_analyzer" then
      capabilities.general.positionEncodings = { "utf-16" }
    end
    config.capabilities = capabilities
  end
)

vim.diagnostic.config {
  signs = {
    priority = 20,
    text = {
      [vim.diagnostic.severity.ERROR] = "✗",
      [vim.diagnostic.severity.WARN] = "‼",
      [vim.diagnostic.severity.INFO] = "i",
      [vim.diagnostic.severity.HINT] = "?",
    },
  },
  severity_sort = true,
}

lspconfig.efm.setup {
  filetypes = { "json", "lua", "markdown", "sh", "yaml" },
  init_options = {
    documentFormatting = true,
    rangeFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = false,
    completion = false,
  },
  ---@param _client vim.lsp.Client
  ---@param bufnr integer
  on_attach = function(_client, bufnr)
    if vim.bo[bufnr].filetype == "json" then
      autocmd "BufWritePre" {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { async = false, name = "efm" }
        end,
      }
    end
  end,
}

lspconfig.denols.setup {
  settings = {
    deno = {
      enable = true,
      lint = true,
      suggest = {
        autoImports = false,
      },
      unstable = true,
    },
  },
  root_dir = root_pattern("deno.json", "deno.jsonc", "denops"),
}

lspconfig.vtsls.setup {
  cmd = deno_as_npm { "npm:@vtsls/language-server@0.2.5", "--stdio" },
  cmd_env = deno_as_npm.cmd_env,
  settings = { vtsls = { typescript = {} } },
  single_file_support = false,
  root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
  on_new_config = function(new_config)
    if not new_config.settings.vtsls.typescript.globalTsdk then
      new_config.settings.vtsls.typescript.globalTsdk =
        vim.fn["denops#request"]("vimrc", "getGlobalTsdk", {})
    end
  end,
}

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

lspconfig.lua_ls.setup {
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

lspconfig.gopls.setup {}

lspconfig.jsonls.setup {
  cmd = deno_as_npm {
    "npm:vscode-langservers-extracted@4.10.0/vscode-json-language-server",
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
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
      completion = {
        callable = { snippets = "add_parentheses" },
        hideDeprecated = true,
      },
      hover = {
        documentation = {
          keywords = { enable = false },
        },
      },
    },
  },
}

lspconfig.taplo.setup {
  settings = {
    evenBetterToml = {
      schema = {
        associations = {
          ["/dein/[^/]+\\.toml$"] = (
            "file://"
            .. vim.env.MYVIMDIR
            .. "/settings/dein.toml.json"
          ),
        },
      },
    },
  },
}

lspconfig.tinymist.setup {
  settings = {
    exportPdf = "onSave",
    formatterMode = "typstyle",
  },
  ---@param client vim.lsp.Client
  ---@param bufnr integer
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(
      bufnr,
      "TinymistSetInput",
      function(ctx)
        local extra_args = vim
          .iter(ctx.fargs)
          :map(function(value) return { "--input", value } end)
          :flatten()
          :totable()
        client.notify("workspace/didChangeConfiguration", {
          settings = { typstExtraArgs = extra_args },
        })
      end,
      { bar = true, nargs = "+" }
    )
  end,
}

lspconfig.vimls.setup {
  cmd = deno_as_npm { "npm:vim-language-server@2.3.1", "--stdio" },
  cmd_env = deno_as_npm.cmd_env,
}

lspconfig.yamlls.setup {
  cmd = deno_as_npm { "npm:yaml-language-server@1.15.0", "--stdio" },
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
