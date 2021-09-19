let g:lsp_settings = {
      \ 'pyls-all': {
      \   'worksoace_config': {
      \   'pylsp': {
      \     'configurationSources': ['flake8'],
      \     'plugins': {
      \       'pyls_mypy': {'enabled': v:true},
      \       'pyls_black': {'enabled': v:true},
      \       'pyls_isort': {'enabled': v:true},
      \ }}}}}

let g:lsp_diagnostics_echo_cursor = v:true

nnoremap <buffer> K :LspHover<CR>

autocmd vimrc BufWritePre <buffer> LspDocumentFormatSync
