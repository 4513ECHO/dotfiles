vim9script

# TODO: Move to dict from json
g:lsp_settings = (g:config_home .. '/dein/settings/vim-lsp-settings.json')
  ->readfile()->join()->json_decode()
g:lsp_settings['taplo-lsp'].workspace_config.evenBetterToml.schema.associations['/dein/.*\.toml'] =
  $'file://{g:config_home}/dein/settings/dein.toml.json'
g:lsp_settings['yaml-language-server'].cmd = [
  g:cache_home .. '/ls/node_modules/yaml-language-server/bin/yaml-language-server',
  '--stdio',
]

g:lsp_async_completion = true
g:lsp_completion_documentation_delay = 50
g:lsp_diagnostics_echo_cursor = true
g:lsp_diagnostics_echo_delay = 200
g:lsp_diagnostics_highlights_delay = 100
g:lsp_diagnostics_highlights_insert_mode_enabled = false
g:lsp_diagnostics_signs_delay = 200
g:lsp_diagnostics_signs_insert_mode_enabled = false
g:lsp_diagnostics_virtual_text_delay = 200
g:lsp_document_code_action_signs_delay = 200
g:lsp_document_highlight_enabled = false
g:lsp_fold_enabled = false
g:lsp_signature_help_enabled = false # NOTE: use denops-signature-help
g:lsp_work_done_progress_enabled = true

g:lsp_diagnostics_signs_error = { text: '✗' }
g:lsp_diagnostics_signs_hint = { text: '?' }
g:lsp_diagnostics_signs_information = { text: 'i' }
g:lsp_diagnostics_signs_warning = { text: '‼' }
g:lsp_document_code_action_signs_enabled = false
g:lsp_diagnostics_virtual_text_prefix = ' ‣ '

g:lsp_log_file = g:data_home .. '/vim-lsp.log'

g:lsp_settings_servers_dir = g:data_home .. '/vim-lsp-settings/servers'
g:lsp_settings_filetype_python = 'pylsp-all'
g:lsp_settings_filetype_typescript = 'deno'
g:lsp_settings_filetype_typescriptreact = 'deno'
g:lsp_settings_filetype_markdown = 'efm-langserver'
g:lsp_settings_filetype_json = ['vscode-json-language-server', 'efm-langserver']
g:lsp_settings_filetype_sh = 'efm-langserver'
g:lsp_settings_filetype_yaml = ['yaml-language-server', 'efm-langserver']
g:lsp_settings_filetype_toml = 'taplo-lsp'
g:lsp_settings_filetype_lua = ['sumneko-lua-language-server', 'efm-langserver']

def OnLspBufferEnabled(): void
  setlocal omnifunc=lsp#complete
  setlocal tagfunc=lsp#tagfunc
  setlocal signcolumn=number

  nnoremap <buffer> gq <Plug>(lsp-document-format)
  xnoremap <buffer> gq <Plug>(lsp-document-range-format)
  if index(['lua', 'markdown', 'toml', 'vim'], &filetype) < 0
    nnoremap <buffer> K <Plug>(lsp-hover)
  endif
  nnoremap <buffer> gK <Plug>(lsp-hover)
  nnoremap <buffer> gd <ScriptCmd>JumpDefinition()<CR>
  nnoremap <buffer> gi <Plug>(lsp-implementation)
  nnoremap <buffer> gr <Plug>(lsp-rename)
  nnoremap <buffer> ma <Plug>(lsp-code-action)
  nnoremap <buffer> md <Plug>(lsp-document-diagnostics)
  nnoremap <buffer> mf <Plug>(lsp-references)
  nnoremap <buffer> ]d <Plug>(lsp-next-diagnostic)
  nnoremap <buffer> [d <Plug>(lsp-previous-diagnostic)
enddef

def JumpDefinition(): void
  normal! m'
  if index(['typescript', 'typescriptreact'], &filetype) > -1
    LspDenoDefinition
  else
    LspDefinition
  endif
enddef

autocmd vimrc BufWritePre *.json LspDocumentFormatSync --server=efm-langserver
autocmd vimrc BufReadPost .env {
  lsp#disable_diagnostics_for_buffer(bufnr(expand('<afile>')))
}
autocmd vimrc User lsp_buffer_enabled {
  OnLspBufferEnabled()
}
