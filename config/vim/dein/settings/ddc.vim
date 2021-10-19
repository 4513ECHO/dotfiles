let s:sources = ['file', 'around', 'buffer']

call ddc#custom#patch_global(
      \ 'sources', s:sources
      \ )

call ddc#custom#patch_global('sourceOptions', #{
      \ _: #{
      \   ignoreCase: v:true,
      \   matchers: ['matcher_fuzzy'],
      \   sorters: ['sorter_fuzzy'],
      \   converters: ['converter_remove_overlap', 'converter_truncate',
      \                'converter_fuzzy'],
      \   maxCandidates: 15,
      \ },
      \ around: #{
      \   mark: 'ard',
      \   minAutoCompleteLength: 3,
      \   isVolatile: v:true,
      \   maxCandidates: 10,
      \ },
      \ file: #{
      \   mark: 'file',
      \   minAutoCompleteLength: 30,
      \   isVolatile: v:true,
      \   forceCompletionPattern: '(\f*/\f*)+',
      \ },
      \ vim-lsp: #{
      \   mark: 'lsp',
      \   isVolatile: v:true,
      \   forceCompletionPattern: '\.\w*|:\w*|->\w*',
      \ },
      \ necovim: #{mark: 'vim'},
      \ buffer: #{mark: 'buf'},
      \ cmdline-history: #{mark: 'hist'},
      \ cmdline: #{mark: 'cmd'},
      \ })

call ddc#custom#patch_global('sourceParams', #{
      \ around: #{maxSize: 500},
      \ buffer: #{
      \   requireSameFiletype: v:false,
      \   fromAltBuf: v:true,
      \ },
      \ cmdline-history: #{maxSize: 100},
      \ })

call ddc#custom#patch_global('filterParams', #{
      \ converter_truncate: #{maxInfoWidth: 30},
      \ })

call ddc#custom#patch_filetype(
      \ ['vim'], 'sources',
      \ extendnew(['necovim'], s:sources)
      \ )

call ddc#custom#patch_filetype(
      \ ['python', 'typescript'], 'sources',
      \ extendnew(['vim-lsp'], s:sources)
      \ )

call ddc#custom#patch_filetype(
      \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], #{
      \ sourcesOptions: #{
      \   file: #{forceCompletionPattern: '(\f*\\\f*)+'},
      \ },
      \ sourceParams: #{
      \   file: #{mode: 'win32'},
      \ }})

" Use pum.vim
call ddc#custom#patch_global('autoCompleteEvents', [
      \ 'InsertEnter', 'TextChangedI', 'TextChangedP',
      \ 'CmdlineEnter', 'CmdlineChanged',
      \ ])

call ddc#custom#patch_global('completionMenu', 'pum.vim')

" keymappings

inoremap <silent><expr> <C-n>
      \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>'
      \ : ddc#manual_complete()
inoremap <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <silent><expr> <BS>
     \ pum#visible() ? '<Cmd>call pum#map#cancel()<CR>'
     \ : lexima#expand('<BS>', 'i')
inoremap <silent><expr> <CR>
     \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>'
     \ : lexima#expand('<CR>', 'i')
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

call ddc#enable()
