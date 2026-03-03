local autocmd = require("vimrc.autocmd").autocmd

return {
  cmd = { "efm-langserver" },
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
