augroup vimrc
  autocmd!
augroup END

let g:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache/vim') : $XDG_CACHE_HOME . '/vim'
let g:config_home = expand('~/.vim')
let g:data_home = empty($XDG_DATA_HOME) ? expand('~/.local/share/vim') : $XDG_DATA_HOME . '/vim'

autocmd vimrc BufRead,BufNewFile * setlocal formatoptions-=ro
autocmd vimrc BufRead,BufNewFile *.lark setfiletype lark

autocmd vimrc BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line('$') |
  \   exe "normal! g`\"" |
  \ endif

command! SyntaxInfo call my_functions#syntax_info()
