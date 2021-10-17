augroup user
  autocmd!
augroup END

let g:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache/vim') : $XDG_CACHE_HOME .. '/vim'
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config/vim') : $XDG_CONFIG_HOME .. '/vim'
let g:data_home = empty($XDG_DATA_HOME) ? expand('~/.local/share/vim') : $XDG_DATA_HOME .. '/vim'

let g:loaded_2html_plugin      = v:true
let g:loaded_getscript         = v:true
let g:loaded_getscriptPlugin   = v:true
let g:loaded_gzip              = v:true
let g:loaded_gtags             = v:true
let g:loaded_gtags_cscope      = v:true
let g:loaded_logiPat           = v:true
let g:loaded_man               = v:true
let g:loaded_netrw             = v:true
let g:loaded_netrwFileHandlers = v:true
let g:loaded_netrwPlugin       = v:true
let g:loaded_netrwSettings     = v:true
let g:loaded_rrhelper          = v:true
let g:loaded_shada_plugin      = v:true
let g:loaded_spellfile_plugin  = v:true
let g:loaded_tar               = v:true
let g:loaded_tarPlugin         = v:true
let g:loaded_tutor_mode_plugin = v:true
let g:loaded_vimball           = v:true
let g:loaded_vimballPlugin     = v:true
let g:loaded_zip               = v:true
let g:loaded_zipPlugin         = v:true

let g:current_colorscheme = 'random'
let g:colorscheme_list = []

command! -nargs=1 Runtime runtime! g:config_home <args>
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')
command! -bar SyntaxInfo call user#syntax_info()
command! -bar RandomColorScheme call user#colorscheme#random()
command! -nargs=1 -bar -complete=customlist,<SID>colorscheme ColorScheme
      \ call user#colorscheme#colorscheme(<q-args>)
command! -nargs=+ SetFileType call user#set_filetype(<f-args>)
command! -nargs=1 WWW call <SID>www(<q-args>)

SetFileType *.lark lark
SetFileType *.grammar,grammar.txt grammar
SetFileType robots.txt robots-txt
SetFileType *[._]curlrc curlrc
SetFileType *[._]gitignore,*/git/ignore gitignore
SetFileType */git/config gitconfig

autocmd user BufReadPost * call user#remember_cursor()
autocmd user VimEnter * ++nested
      \ call user#colorscheme#colorscheme(g:current_colorscheme)

autocmd user FileType help nnoremap <buffer> q <C-w>q
autocmd user VimEnter * if &filetype ==# '' | execute 'nnoremap <buffer> q <C-w>q' | endif

function! s:www(word) abort
  execute 'terminal' '++close' '++shell' 'w3m'
        \ printf('"https://google.com/search?q=%s"', a:word)
endfunction

function! s:colorscheme(ArgLead, CmdLine, CursorPos) abort
  return filter(g:colorscheme_list, 'v:val =~# a:ArgLead')
endfunction
