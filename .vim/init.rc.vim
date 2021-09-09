augroup vimrc
  autocmd!
augroup END

autocmd BufRead,BufNewFile * setlocal formatoptions-=ro
autocmd BufRead,BufNewFile *.py setfiletype python
autocmd BufRead,BufNewFile *.lark setfiletype lark

autocmd vimrc BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line('$') |
  \   exe "normal! g`\"" |
  \ endif

command! SyntaxInfo call my_functions#syntaxinfo#get_syn_info()
