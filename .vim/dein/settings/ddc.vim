inoremap <silent><expr> <C-n>
      \ pumvisible() ? '<Down>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<C-n>' : ddc#manual_complete()

set completeopt=menuone,noinsert
inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<CR>'
inoremap <expr><C-p> pumvisible() ? '<Up>' : '<C-p>'

call ddc#custom#patch_global(
      \ 'sources', ['around', 'file', 'ddc-vim-lsp']
      \ )

call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'ignoreCase': v:true,
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ 'around': {
      \   'mark': 'A',
      \ },
      \ 'file': {
      \   'mark': 'F',
      \   'isVolatile': v:true,
      \   'forceCompletionPattern': '\S/\S*',
      \ },
      \ 'vim-lsp': {
      \   'mark': 'lsp'
      \ },
      \ })

call ddc#enable()
