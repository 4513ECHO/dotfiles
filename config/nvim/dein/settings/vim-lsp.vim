let g:lsp_settings = json_decode(join(readfile(
      \ g:config_home .. '/dein/settings/vim-lsp-settings.json'
      \ )))
let g:lsp_settings['taplo-lsp'].workspace_config.evenBetterToml.schema.associations['/dein/.*\.toml']
      \ = 'file://' .. g:config_home .. '/dein/settings/dein.toml.json'
if has('nvim')
  let g:lsp_settings['sumneko-lua-language-server'].workspace_config.Lua.workspace.library
        \ = nvim_get_runtime_file('lua', v:true)
endif

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
let g:lsp_signature_help_enabled = v:false " NOTE: use denops-signature-help
let g:lsp_work_done_progress_enabled = v:true

let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_hint = {'text': '?'}
let g:lsp_diagnostics_signs_information = {'text': 'i'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_document_code_action_signs_enabled = v:false
let g:lsp_diagnostics_virtual_text_prefix = ' ‣ '

let g:lsp_log_file = g:data_home .. '/vim-lsp.log'

let g:lsp_settings_servers_dir = g:data_home .. '/vim-lsp-settings/servers'
let g:lsp_settings_filetype_python = 'pylsp-all'
let g:lsp_settings_filetype_typescript = 'deno'
let g:lsp_settings_filetype_typescriptreact = 'deno'
let g:lsp_settings_filetype_markdown = 'efm-langserver'
let g:lsp_settings_filetype_json = ['json-languageserver', 'efm-langserver']
let g:lsp_settings_filetype_sh = 'efm-langserver'
let g:lsp_settings_filetype_yaml = ['yaml-language-server', 'efm-langserver']
let g:lsp_settings_filetype_toml = 'taplo-lsp'
let g:lsp_settings_filetype_lua = ['sumneko-lua-language-server', 'efm-langserver']

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal tagfunc=lsp#tagfunc
  setlocal signcolumn=number
  if index(['vim', 'yaml', 'markdown', 'sh', 'json', 'toml'], &filetype) == -1
    nnoremap <buffer> K <Plug>(lsp-hover)
  endif
  nnoremap <buffer> mK <Plug>(lsp-hover)
  nnoremap <buffer> md <Plug>(lsp-document-diagnostics)
  nnoremap <buffer> ma <Plug>(lsp-code-action)
  nnoremap <buffer> mi <Plug>(lsp-implementation)
  nnoremap <buffer> mr <Plug>(lsp-rename)
  nnoremap <buffer> mf <Plug>(lsp-references)
  nnoremap <buffer> gd <Cmd>call <SID>jump_definition()<CR>
  nnoremap <buffer> gq <Plug>(lsp-document-format)
  xnoremap <buffer> gq <Plug>(lsp-document-range-format)
  nnoremap <buffer> ]d <Plug>(lsp-next-diagnostic)
  nnoremap <buffer> [d <Plug>(lsp-previous-diagnostic)
endfunction

function! s:jump_definition() abort
  normal! m'
  if index(['typescript', 'typescriptreact'], &filetype) != -1
    LspDenoDefinition
  else
    LspDefinition
  endif
endfunction

autocmd vimrc BufWritePre *.json LspDocumentFormatSync --server=efm-langserver

autocmd vimrc User lsp_buffer_enabled
      \ call <SID>on_lsp_buffer_enabled()
