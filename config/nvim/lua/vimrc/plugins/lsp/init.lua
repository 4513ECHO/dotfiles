local autocmd = require("vimrc.autocmd").autocmd

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

    vim.opt.winborder = "single"
    map("n", "gK", vim.lsp.buf.hover)
    map("n", "gd", vim.lsp.buf.definition)
    pcall(function()
      vim.keymap.del("n", "grn", { buffer = ctx.buf })
      vim.keymap.del("n", "gra", { buffer = ctx.buf })
      vim.keymap.del("n", "grr", { buffer = ctx.buf })
      vim.keymap.del("n", "gri", { buffer = ctx.buf })
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

vim.lsp.util.open_floating_preview = (function(wrapped)
  return function(contents, syntax, opts)
    local bufnr, winid = wrapped(contents, syntax, opts)
    if syntax == "markdown" then
      -- Reapply treesitter highlighting
      vim.treesitter.stop(bufnr)
      vim.treesitter.start(bufnr, "markdown")
      vim.wo[winid].conceallevel = 3
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

-- TODO: support vim-lsp
-- :echo lsp#get_server_names()->copy()->filter({ -> lsp#get_server_capabilities(v:val)->has_key('completionProvider') })
require("ddc_source_lsp_setup").setup {
  override_capabilities = false,
  respect_trigger = true,
}

vim.diagnostic.config {
  virtual_text = true,
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

vim.keymap.set("n", "[Toggle]d", function()
  local old_config = vim.diagnostic.config() or {}
  vim.diagnostic.config {
    virtual_text = not old_config.virtual_text,
    virtual_lines = not old_config.virtual_lines,
  }
  local mode = old_config.virtual_lines and "virtual_text" or "virtual_lines"
  vim.api.nvim_echo(
    { { "Diagnostic Mode: " }, { mode, "Constant" } },
    false,
    {}
  )
end)

vim.lsp.config("*", {
  capabilities = require("ddc_source_lsp").make_client_capabilities(),
})

vim.lsp.enable {
  "cssls",
  "denols",
  "efm",
  "gopls",
  "jsonls",
  "lua_ls",
  "pylsp",
  "rust_analyzer",
  "tailwindcss",
  "taplo",
  "tinymist",
  "vimls",
  "vtsls",
  "yamlls",
}
