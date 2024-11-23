vim9script

def DenoAsNpm(cmd: list<string>): list<string>
  return ['deno', 'run', '--allow-all', '--no-config', '--no-lock', '--node-modules-dir=false']->extend(cmd)
enddef

export def OnLspBufferEnabled(): void
  setlocal omnifunc=lsp#complete tagfunc=lsp#tagfunc

  nnoremap <buffer> gq <Plug>(lsp-document-format)
  xnoremap <buffer> gq <Plug>(lsp-document-range-format)
  if ['lua', 'markdown', 'toml', 'vim']->index(&filetype) < 0
    nnoremap <buffer> K <Plug>(lsp-hover)
  endif
  nnoremap <buffer> gK <Plug>(lsp-hover)
  nnoremap <buffer> gd <ScriptCmd>JumpDefinition()<CR>
  nnoremap <buffer> gi <Plug>(lsp-implementation)
  nnoremap <buffer> gr <Plug>(lsp-rename)
  nnoremap <buffer> ma <Cmd>Ddu -name=codeAction<CR>
  xnoremap <buffer> ma <Cmd>Ddu -name=codeAction<CR>
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

final settings = {
  bash-language-server: { disabled: true },
  deno: {
    workspace_config: {
      deno: {
        enable: true,
        lint: true,
        suggest: {
          autoImports: false,
        },
        unstable: true,
      },
    },
  },
  efm-langserver: {
    allowlist: ['json', 'lua', 'markdown', 'sh', 'yaml'],
    disabled: false,
  },
  pylsp-all: {
    cmd: ['pylsp'],
    workspace_config: {
      pylsp: {
        configurationSources: ['flake8'],
        plugins: {
          black: { enabled: true },
          flake8: { enabled: true },
          mccabe: { enabled: false },
          pycodestyle: { enabled: false },
          pyflakes: { enabled: false },
          pyls_isort: { enabled: true },
          pylsp_mypy: {
            enabled: true,
            overrides: ['--no-pretty', true],
            report_progress: true,
          },
        },
      },
    },
  },
  sumneko-lua-language-server: {
    cmd: ['lua-language-server'],
    workspace_config: {
      Lua: {
        completion: { showWord: 'Disable' },
        diagnostics: {
          disable: ['lowercase-global'],
          enable: true,
          globals: ['vim'],
        },
        # NOTE: Use stylua via efm-langserver instead.
        format: { enable: false },
        runtime: {
          path: ['?.lua', '?/init.lua'],
          pathStrict: true,
          version: 'LuaJIT',
        },
        telemetry: { enable: false },
        workspace: {
          checkThirdParty: false,
          library: [],
          maxPreload: 1000,
        },
      },
    },
  },
  taplo-lsp: {
    cmd: ['taplo', 'lsp', 'stdio'],
    workspace_config: {
      evenBetterToml: {
        schema: {
          associations: {
            '/dpp/[^/]+\.toml$': $'file://{g:config_home}/dein/settings/dein.toml.json',
          },
        },
      },
    },
  },
  vim-language-server: {
    cmd: DenoAsNpm(['npm:vim-language-server@2.3.1', '--stdio']),
    initialization_options: {
      runtimepath: &runtimepath,
      vimruntime: $VIMRUNTIME,
    }
  },
  vscode-json-language-server: {
    cmd: DenoAsNpm([
      'npm:vscode-langservers-extracted@4.10.0/vscode-json-language-server',
      '--stdio',
    ]),
  },
  yaml-language-server: {
    cmd: DenoAsNpm(['npm:yaml-language-server@1.15.0', '--stdio']),
    workspace_config: {
      yaml: {
        completion: true,
        hover: true,
        schemas: {
          'https://mattn.github.io/efm-langserver/schema.json': [
            '/efm-langserver/config.yaml',
          ],
          'https://pax.deno.dev/aquaproj/aqua@v2.21.0/json-schema/aqua-yaml.json': [
            '/aqua/aqua.yaml',
          ],
          'https://pax.deno.dev/aquaproj/aqua@v2.21.0/json-schema/registry.json': [
            '/aqua-registry/pkgs/**/registry.yaml',
            '/aqua-registry/registry.yaml',
            '/aqua/experimental.yaml',
            '/aqua/registry.yaml',
          ],
        },
        validate: true,
      },
    },
  },
}

export def HookAdd(): void
  g:lsp_settings = settings

  g:lsp_async_completion = true
  g:lsp_completion_documentation_delay = 50
  g:lsp_diagnostics_highlights_delay = 100
  g:lsp_diagnostics_highlights_insert_mode_enabled = false
  g:lsp_diagnostics_signs_delay = 200
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
  g:lsp_diagnostics_virtual_text_align = 'after'
  g:lsp_diagnostics_virtual_text_prefix = '■'

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
