local mark_type_map = {
  E = "Error",
  W = "Warn",
  I = "Info",
  H = "Hint",
}

require("scrollbar.handlers.diagnostic").setup()
require("scrollbar.handlers.search").setup()

-- based on https://github.com/petertriho/nvim-scrollbar/issues/24
require("scrollbar.handlers").register("quickfix", function(bufnr)
  local marks = {}
  for _, entry in pairs(vim.fn.getqflist()) do
    if entry.bufnr == bufnr then
      table.insert(
        marks,
        { line = entry.lnum, type = mark_type_map[entry.type] or "Misc" }
      )
    end
  end
  return marks
end)

-- require("scrollbar.handlers").register("vim-lsp", function(bufnr)
--   if not vim.g.lsp_diagnostics_enabled == 1 then
--     return {}
--   end
--   local uri = vim.fn["lsp#utils#get_buffer_uri"](bufnr)
--   local result = {}
--   if vim.fn.getbufvar(
--     vim.fn.bufnr(vim.fn["lsp#utils#uri_to_path"](uri)),
--     "lsp_diagnostics_enabled",
--     1
--   ) == 1
--   then
--     for _, diagnostics in pairs(
--       vim.fn["lsp#internal#diagnostics#state#_get_all_diagnostics_grouped_by_server_for_uri"](
--         uri
--       )
--     ) do
--       local entry = vim.fn["lsp#ui#vim#utils#diagnostics_to_loc_list"] {
--         response = diagnostics,
--       }
--       table.insert(
--         result,
--         { line = entry.lnum, type = mark_type_map[entry.type] or "Misc" }
--       )
--     end
--   end
--   return result
-- end)
