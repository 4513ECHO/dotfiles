let g:lsp_settings = {
      \ 'pyls-all': {
      \   'workspace_config': {
      \   'pyls': {
      \     'configurationSources': ['flake8'],
      \     'plugins': {
      \       'jedi_definition': {
      \         'follow_imports': v:true,
      \         'follow_builtin_imports': v:true,
      \       },
      \       'pyls_mypy': {'enabled': v:true},
      \       'pyls_black': {'enabled': v:true},
      \       'pyls_isort': {'enabled': v:true},
      \ }}}},
      \ 'vim-language-server': {'disabled': v:true},
      \ 'taplo-lsp': {'disabled': v:true},
      \ 'yaml-language-server': {'disabled': v:true},
      \}

" let g:lsp_settings = json_decode(g:config_home .. '/vim-lsp-settings.json')

let g:lsp_diagnostics_echo_cursor = v:true
let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_log_file = g:data_home .. '/vim-lsp.log'

let g:lsp_settings_servers_dir = g:data_home .. '/vim-lsp-settings/servers'
let g:lsp_settings_filetype_python = 'pyls-all'
let g:lsp_settings_filetype_typescript = 'deno'

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> K <Plug>(lsp-hover)
  nmap <buffer> gr <Plug>(lsp-rename)
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> gq <Plug>(lsp-document-format)
  vmap <buffer> gq <Plug>(lsp-document-range-format)
  nmap <buffer> <C-]> <Plug>(lsp-definition)
endfunction

function! s:install_deno_lsp() abort
  let deno =  exepath('deno')
  if deno !=# ''
    call system(printf('cp %s %s', deno, g:lsp_settings_servers_dir .. '/deno/deno'))
  endif
endfunction

function! s:install_pyls_ext() abort
  let cmd = g:lsp_settings_servers_dir .. '/pyls-all/venv/bin/pip'
  if executable(cmd)
    call system(cmd .. 'install pyls-mypy pyls-isort pyls-black')
  endif
endfunction

autocmd user User lsp_buffer_enabled
      \ call s:on_lsp_buffer_enabled()
autocmd user VimEnter *
      \ call s:install_pyls_ext() |
      \ call s:install_deno_lsp()
