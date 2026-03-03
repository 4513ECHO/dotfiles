return {
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
        client.settings.typstExtraArgs = extra_args
        client:notify("workspace/didChangeConfiguration", {
          settings = { typstExtraArgs = extra_args },
        })
      end,
      { bar = true, nargs = "+" }
    )
  end,
}
