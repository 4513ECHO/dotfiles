augroup vimrc
  autocmd!
augroup END

let g:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache/vim') : $XDG_CACHE_HOME . '/vim'
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config/vim') : $XDG_CONFIG_HOME . '/vim'
let g:data_home = empty($XDG_DATA_HOME) ? expand('~/.local/share/vim') : $XDG_DATA_HOME . '/vim'

let g:loaded_gzip              = v:true
let g:loaded_tar               = v:true
let g:loaded_tarPlugin         = v:true
let g:loaded_zip               = v:true
let g:loaded_zipPlugin         = v:true
let g:loaded_rrhelper          = v:true
let g:loaded_2html_plugin      = v:true
let g:loaded_vimball           = v:true
let g:loaded_vimballPlugin     = v:true
let g:loaded_getscript         = v:true
let g:loaded_getscriptPlugin   = v:true
let g:loaded_netrw             = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_netrwSettings     = v:true
let g:loaded_netrwFileHandlers = v:true

command! -nargs=+ SetFileType call my_functions#set_filetype(<f-args>)

SetFileType *.lark lark
SetFileType *.grammar grammar
SetFileType grammar.txt grammar
SetFileType robots.txt robots-txt
SetFileType *[._]curlrc curlrc
SetFileType *[._]gitignore gitignore

autocmd vimrc BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line('$')
  \ | execute "normal! g`\""
  \ |endif

command! SyntaxInfo call my_functions#syntax_info()
