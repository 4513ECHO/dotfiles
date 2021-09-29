let s:sources = ['around', 'file', 'vim-lsp', 'buffer']

call ddc#custom#patch_global(
      \ 'sources', s:sources
      \ )

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'ignoreCase': v:true,
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank'],
      \ },
      \ 'around': {
      \   'mark': 'A',
      \   'matchers': ['matcher_head', 'matcher_length'],
      \ },
      \ 'file': {
      \   'mark': 'F',
      \   'isVolatile': v:true,
      \   'forceCompletionPattern': '\S/\S*',
      \ },
      \ 'vim-lsp': {
      \   'mark': 'lsp',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*',
      \ },
      \ 'necovim': {'mark': 'vim'},
      \ 'buffer': {'mark': 'B'},
      \ })

call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ 'buffer': {
      \   'requireSameFiletype': v:false,
      \   'fromAltBuf': v:true,
      \ }})

call ddc#custom#patch_filetype(
      \ ['vim'], 'sources',
      \ add(s:sources, 'necovim')
      \ )

call ddc#custom#patch_filetype(
      \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
      \ 'sourcesOptions': {
      \   'file': {'forceCompletionPattern': '\S\\\S*'},
      \ },
      \ 'sourceParams': {
      \   'file': {'mode': 'win32'},
      \ }})

inoremap <silent><expr> <CR>
      \ pumvisible() ? '<C-y>' : '<CR>'
inoremap <silent><expr> <C-n>
      \ pumvisible() ? '<Down>' : ddc#manual_complete()
inoremap <silent><expr> <C-p>
      \ pumvisible() ? '<Up>' : '<Nop>'
inoremap <silent><expr> <BS>
      \ pumvisible() ? '<C-e>' : '<BS>'

call ddc#enable()
