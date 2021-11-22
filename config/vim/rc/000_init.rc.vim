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
let g:loaded_matchit           = v:true
let g:loaded_matchparen        = v:true
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

let g:current_colorscheme = get(g:, 'current_colorscheme', 'random')
let g:colorscheme_list = get(g:, 'colorscheme_list', [])
let g:colorscheme_customize = get(g:, 'colorscheme_customize', {'_': {}})

command! -nargs=1 Runtime runtime! g:config_home <args>
command! -nargs=1 SourceConf
      \ execute 'source' printf('%s/dein/settings/%s',
      \ g:config_home, <q-args>)
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')
command! -bar RandomColorScheme call user#colorscheme#random()
command! -nargs=1 -bar -complete=customlist,user#colorscheme#completion
      \ ColorScheme call user#colorscheme#colorscheme(<q-args>)
command! -nargs=+ SetFileType call user#set_filetype(<f-args>)
command! -nargs=1 WWW call user#google(<q-args>)
command! -bar -bang DenoRun call user#deno_run(<bang>0)
command! PopupTerminal
      \ call popup_create(term_start(
      \     [&shell], { 'hidden': v:true, 'term_finish': 'close' }
      \   ), {
      \   'border': [], 'minwidth': winwidth(0)/2, 'minheight': &lines/2
      \ })

SetFileType *.lark lark
SetFileType *.grammar,grammar.txt grammar
SetFileType robots.txt robots-txt
SetFileType *[._]curlrc curlrc
SetFileType *[._]gitignore,*/git/ignore gitignore
SetFileType */git/config gitconfig

autocmd user BufReadPost * call user#remember_cursor()
autocmd user ColorScheme,VimEnter * ++nested
      \ call user#colorscheme#colorscheme(g:current_colorscheme)

" echo message vim start up time
if has('vim_starting')
  let g:startuptime = reltime()
  autocmd user VimEnter * call user#startuptime()
endif

autocmd user BufEnter *
      \ if &filetype ==# '' |
      \   execute 'nnoremap <buffer> q <C-w>q' |
      \ endif

" vim as a pager
autocmd user StdinReadPost * call user#pager()

" enable cursorline in only needing it
autocmd user CursorHold,CursorHoldI *
      \ call user#auto_cursorline('CursorHold')
autocmd user CursorMoved *
      \ call user#auto_cursorline('CoursorMoved')
autocmd user WinEnter *
      \ call user#auto_cursorline('WinEnter')
autocmd user WinLeave *
      \ call user#auto_cursorline('WinLeave')

" vim-jp Hack #202
autocmd user BufWritePre *
      \ call user#auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
