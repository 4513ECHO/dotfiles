vim9script

export def OnLspBufferEnabled(): void
  setlocal omnifunc=lsp#complete
  setlocal tagfunc=lsp#tagfunc
  setlocal signcolumn=number

  nnoremap <buffer> gq <Plug>(lsp-document-format)
  xnoremap <buffer> gq <Plug>(lsp-document-range-format)
  if ['lua', 'markdown', 'toml', 'vim']->index(&filetype) < 0
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

export def JumpDefinition(): void
  normal! m'
  if ['typescript', 'typescriptreact']->index(&filetype) > -1
    execute 'LspDenoDefinition'
  else
    execute 'LspDefinition'
  endif
enddef

export def OnColorScheme(): void
  var hl = [
    # from autoload/lsp/internal/diagnostics/highlights.vim
    { name: 'LspErrorHighlight', linksto: 'Error', default: true },
    { name: 'LspWarningHighlight', linksto: 'Todo', default: true },
    { name: 'LspInformationHighlight', linksto: 'Normal', default: true },
    { name: 'LspHintHighlight', linksto: 'Normal', default: true },
    # from autoload/lsp/internal/diagnostics/signs.vim
    { name: 'LspErrorText', linksto: 'Error', default: true },
    { name: 'LspWarningText', linksto: 'Todo', default: true },
    { name: 'LspInformationText', linksto: 'Normal', default: true },
    { name: 'LspHintText', linksto: 'Normal', default: true },
    # from autoload/lsp/internal/diagnostics/virtual_text.vim
    { name: 'LspErrorVirtualText', linksto: 'Error', default: true },
    { name: 'LspWarningVirtualText', linksto: 'Todo', default: true },
    { name: 'LspInformationVirtualText', linksto: 'Normal', default: true },
    { name: 'LspHintVirtualText', linksto: 'Normal', default: true },
    # from autoload/lsp/internal/document_code_action/signs.vim
    { name: 'LspCodeActionText', linksto: 'Normal', default: true },
    # from autoload/lsp/internal/document_highlight.vim
    { name: 'lspReference', linksto: 'CursorColumn', default: true },
    # from autoload/lsp/internal/semantic.vim
    { name: 'LspSemanticType', linksto: 'Type', default: true },
    { name: 'LspSemanticClass', linksto: 'Type', default: true },
    { name: 'LspSemanticEnum', linksto: 'Type', default: true },
    { name: 'LspSemanticInterface', linksto: 'TypeDef', default: true },
    { name: 'LspSemanticStruct', linksto: 'Type', default: true },
    { name: 'LspSemanticTypeParameter', linksto: 'Type', default: true },
    { name: 'LspSemanticParameter', linksto: 'Identifier', default: true },
    { name: 'LspSemanticVariable', linksto: 'Identifier', default: true },
    { name: 'LspSemanticProperty', linksto: 'Identifier', default: true },
    { name: 'LspSemanticEnumMember', linksto: 'Constant', default: true },
    { name: 'LspSemanticEvent', linksto: 'Identifier', default: true },
    { name: 'LspSemanticFunction', linksto: 'Function', default: true },
    { name: 'LspSemanticMethod', linksto: 'Function', default: true },
    { name: 'LspSemanticMacro', linksto: 'Macro', default: true },
    { name: 'LspSemanticKeyword', linksto: 'Keyword', default: true },
    { name: 'LspSemanticModifier', linksto: 'Type', default: true },
    { name: 'LspSemanticComment', linksto: 'Comment', default: true },
    { name: 'LspSemanticString', linksto: 'String', default: true },
    { name: 'LspSemanticNumber', linksto: 'Number', default: true },
    { name: 'LspSemanticRegexp', linksto: 'String', default: true },
    { name: 'LspSemanticOperator', linksto: 'Operator', default: true },
    { name: 'LspSemanticDecorator', linksto: 'Macro', default: true },
  ]
  hlset(hl)
enddef

export def HookAdd(): void
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
  g:lsp_document_code_action_signs_enabled = false
  g:lsp_semantic_enabled = true
  g:lsp_semantic_delay = 200
  g:lsp_document_highlight_enabled = false
  g:lsp_fold_enabled = false
  g:lsp_signature_help_enabled = false # NOTE: use denops-signature-help
  g:lsp_work_done_progress_enabled = true

  g:lsp_diagnostics_signs_error = { text: '✗' }
  g:lsp_diagnostics_signs_hint = { text: '?' }
  g:lsp_diagnostics_signs_information = { text: 'i' }
  g:lsp_diagnostics_signs_warning = { text: '‼' }
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

  autocmd vimrc ColorScheme * OnColorScheme()
  autocmd vimrc BufWritePre *.json LspDocumentFormatSync --server=efm-langserver
  autocmd vimrc BufRead,BufNewFile .env {
    lsp#disable_diagnostics_for_buffer(bufnr(expand('<afile>')))
  }
  autocmd vimrc User lsp_buffer_enabled OnLspBufferEnabled()
enddef
