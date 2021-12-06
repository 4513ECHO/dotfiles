let g:lsp_settings = json_decode(join(readfile(g:config_home
      \ .. '/dein/settings/vim-lsp-settings.json'
     \ )))

let g:lsp_diagnostics_echo_cursor = v:true
let g:lsp_fold_enabled = v:false
let g:lsp_document_code_action_signs_enabled = v:false
let g:lsp_diagnostics_highlights_insert_mode_enabled = v:false
let g:lsp_diagnostics_signs_insert_mode_enabled = v:false

let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_diagnostics_signs_hint = {'text': 'i'}

let g:lsp_log_file = g:data_home .. '/vim-lsp.log'

let g:lsp_settings_servers_dir = g:data_home .. '/vim-lsp-settings/servers'
let g:lsp_settings_filetype_python = 'pyls-all'
let g:lsp_settings_filetype_typescript = 'deno'
let g:lsp_settings_filetype_typescriptreact = 'deno'

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal tagfunc=lsp#tagfunc
  setlocal signcolumn=number
  nmap <buffer> K <Plug>(lsp-hover)
  nmap <buffer> gr <Plug>(lsp-rename)
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> gq <Plug>(lsp-document-format)
  xmap <buffer> gq <Plug>(lsp-document-range-format)
  nmap <buffer> gn <Plug>(lsp-next-diagnostic)
  nmap <buffer> gp <Plug>(lsp-previous-diagnostic)
endfunction

function! s:install_deno_lsp() abort
  let deno_dir = g:lsp_settings_servers_dir .. '/deno'
  if &filetype !~# 'typescript' || filereadable(deno_dir .. '/loaded_deno')
    return
  endif
  let deno =  exepath('deno')
  if deno !=# ''
    call system(printf('ln -snf %s %s/deno', deno, deno_dir))
    " call mkdir(deno_dir, 'p')
    silent! call writefile([''], deno_dir .. '/loaded_deno')
  endif
endfunction

function! s:install_pyls_ext() abort
  let pyls_dir = g:lsp_settings_servers_dir .. '/pyls-all'
  if &filetype !=# 'python' || filereadable(pyls_dir .. '/loaded_pyls_ext')
    return
  endif
  let pip = pyls_dir .. '/venv/bin/pip'
  let pyls_ext = ['pyls-mypy', 'pyls-isort', 'pyls-black']
  if executable(pip)
    call term_start(extend([pip, 'install'], pyls_ext), {
          \ 'cwd': fnamemodify(pip, ':h:h:h'),
          \ 'term_name': 'install_pyls_ext'})
    " call mkdir(pyls_dir)
    silent! call writefile([''], pyls_dir .. '/loaded_pyls_ext')
  endif
endfunction

autocmd user User lsp_buffer_enabled
      \ call <SID>on_lsp_buffer_enabled()
autocmd user User lsp_setup
      \ call <SID>install_pyls_ext() |
      \ call <SID>install_deno_lsp()
