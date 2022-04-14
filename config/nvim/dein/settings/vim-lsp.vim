function! s:eval(expr) abort
  if type(a:expr) == v:t_list
    return map(a:expr, { _, v -> s:eval(v) })
  elseif type(a:expr) == v:t_dict
    return map(a:expr, { _, v -> s:eval(v) })
  elseif type(a:expr) == v:t_string
    let expr = get(matchlist(a:expr, '^`\(.*\)`$'), 1, '')
    if !empty(expr)
      return eval(expr)
    endif
  endif
  return a:expr
endfunction

let g:lsp_settings = s:eval(json_decode(join(readfile(
      \ g:config_home .. '/dein/settings/vim-lsp-settings.json'
      \ ))))

let g:lsp_async_completion = v:true
let g:lsp_completion_documentation_delay = 50
let g:lsp_diagnostics_echo_cursor = v:true
let g:lsp_diagnostics_echo_delay = 200
let g:lsp_diagnostics_highlights_delay = 100
let g:lsp_diagnostics_highlights_insert_mode_enabled = v:false
let g:lsp_diagnostics_signs_delay = 200
let g:lsp_diagnostics_signs_insert_mode_enabled = v:false
let g:lsp_diagnostics_virtual_text_delay = 200
let g:lsp_document_code_action_signs_delay = 200
let g:lsp_document_highlight_enabled = v:false
let g:lsp_fold_enabled = v:false
let g:lsp_work_done_progress_enabled = v:true

let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_hint = {'text': '?'}
let g:lsp_diagnostics_signs_information = {'text': 'i'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_document_code_action_signs_hint = {'text': 'A'}
let g:lsp_diagnostics_virtual_text_prefix = " ‣ "

let g:lsp_log_file = g:data_home .. '/vim-lsp.log'

let g:lsp_settings_servers_dir = g:data_home .. '/vim-lsp-settings/servers'
let g:lsp_settings_filetype_python = 'pyls-all'
let g:lsp_settings_filetype_typescript = 'deno'
let g:lsp_settings_filetype_typescriptreact = 'deno'
let g:lsp_settings_filetype_markdown = 'efm-langserver'
let g:lsp_settings_filetype_json = ['json-languageserver', 'efm-langserver']
let g:lsp_settings_filetype_sh = 'efm-langserver'
let g:lsp_settings_filetype_yaml = 'yaml-language-server'
let g:lsp_settings_filetype_toml = 'taplo-lsp'
let g:lsp_settings_filetype_lua = ['sumneko-lua-language-server', 'efm-langserver']

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal tagfunc=lsp#tagfunc
  setlocal signcolumn=number
  if index(['vim', 'yaml', 'markdown', 'sh', 'json', 'toml'], &filetype) == -1
    nmap <buffer> K <Plug>(lsp-hover)
  endif
  nmap gK <Plug (lsp-hover)
  nmap <buffer> g_ <Plug>(lsp-document-diagnostics)
  nmap <buffer> ga <Plug>(lsp-code-action)
  nmap <buffer> gr <Plug>(lsp-rename)
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> gq <Plug>(lsp-document-format)
  xmap <buffer> gq <Plug>(lsp-document-range-format)
  nmap <buffer> gn <Plug>(lsp-next-diagnostic)
  nmap <buffer> gp <Plug>(lsp-previous-diagnostic)
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
    silent! call writefile([''], pyls_dir .. '/loaded_pyls_ext')
  endif
endfunction

autocmd vimrc BufWritePre *.json LspDocumentFormatSync --server=efm-langserver

autocmd vimrc User lsp_buffer_enabled
      \ call <SID>on_lsp_buffer_enabled()
" autocmd vimrc User lsp_setup
"      \ : call <SID>install_pyls_ext()
