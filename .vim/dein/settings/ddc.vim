inoremap <silent><expr> <C-n> ddc#complete_common_string()
inoremap <silent><expr> <TAB>
      \ pumvisible() ? '<C-n>' :
      \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
      \ '<TAB>' : ddc#manual_complete()

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
