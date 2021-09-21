inoremap <silent><expr> <CR>
      \ pumvisible() ? '<C-y>' : '<CR>'
inoremap <silent><expr> <C-n>
      \ pumvisible() ? '<Down>' : ddc#manual_complete()
inoremap <silent><expr> <C-p>
      \ pumvisible() ? '<Up>' : '<Nop>'
inoremap <silent><expr> <BS>
      \ pumvisible() ? '<C-e>' : '<BS>'

let s:sources = ['around', 'file', 'ddc-vim-lsp', 'buffer', 'tabnine']

call ddc#custom#patch_global(
      \ 'sources', s:sources
      \ )

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'ignoreCase': v:true,
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']
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
      \ 'tabnine': {
      \   'mark': 'TN',
      \   'maxCardidates': 5,
      \   'isVolatile': v:true,
      \ },
      \ 'ddc-vim-lsp': {'mark': 'lsp'},
      \ 'necovim': {'mark': 'vim'},
      \ 'buffer': {'mark': 'B'},
      \ })

call ddc#custom#patch_global('sourceParams', {
	    \ 'buffer': {'requireSameFiletype': v:false},
      \ 'tabnine': {'maxNumResults': 10},
	    \ })

call ddc#custom#patch_filetype(
      \ ['vim'], 'sources',
      \ add(s:sources, 'necovim')
      \ )

call ddc#enable()
