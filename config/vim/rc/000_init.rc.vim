augroup vimrc
  autocmd!
augroup END

" TODO: use config/nvim instead of config/vim
let g:cache_home = empty($XDG_CACHE_HOME) ?
      \ expand('~/.cache/vim') : $XDG_CACHE_HOME .. '/vim'
let g:config_home = empty($XDG_CONFIG_HOME) ?
      \ expand('~/.config/vim') : $XDG_CONFIG_HOME .. '/vim'
let g:data_home = empty($XDG_DATA_HOME) ?
      \ expand('~/.local/share/vim') : $XDG_DATA_HOME .. '/vim'

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
let g:colorscheme_customize = get(g:, 'colorscheme_customize', {'_': {}})

augroup random_colorscheme
  autocmd!
  " autocmd ColorScheme,VimEnter * ++nested
  "      \ call user#colorscheme#colorscheme(g:current_colorscheme)
  autocmd VimEnter * ++nested
     \ call user#colorscheme#random()
augroup END

" echo message vim start up time
if has('vim_starting')
  let g:startuptime = reltime()
  autocmd vimrc VimEnter *
        \ : let g:startuptime = reltime(g:startuptime)
        \ | redraw
        \ | echomsg printf('startuptime: %fms', reltimefloat(g:startuptime) * 1000)
endif

if has('nvim')
  let g:python3_host_prog = stdpath('data') .. '/venv/bin/python'
  if !filereadable(stdpath('data') .. '/venv/installed')
    call timer_start(10, { ->
          \ system('python3 -m venv ' .. stdpath('data') .. '/venv') })
    call timer_start(10, { ->
          \ system(stdpath('data') .. '/venv/bin/pip install pynvim neovim') })
    call writefile([''], stdpath('data') .. '/venv/installed')
  endif
endif

command! -nargs=1 Runtime runtime! g:config_home <args>

" from https://github.com/thinca/config/blob/d92e41cebd/dotfiles/dot.vim/vimrc#L1382
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

command! -bar RandomColorScheme call user#colorscheme#random()

command! -nargs=? -bar -bang -complete=customlist,user#colorscheme#completion
      \ ColorScheme call user#colorscheme#command(<q-args>, <bang>0)

" from https://qiita.com/gorilla0513/items/11be5413405792337558
command! -nargs=1 WWW call user#google(<q-args>)

" from https://zenn.dev/kawarimidoll/articles/0ff5d28fa584d6
command! -bar -bang DenoRun call user#deno_run(<bang>0)

" from https://qiita.com/gorilla0513/items/f59e54606f6f4d7e3514
command! PopupTerminal
      \ call popup_create(term_start(
      \     [&shell], { 'hidden': v:true, 'term_finish': 'close' }
      \   ), {
      \   'border': [], 'minwidth': winwidth(0)/2, 'minheight': &lines/2
      \ })

command! -bar HtmlFormat
      \ : silent! keepjumps keeppattern substitute+\v\>(\<)@=+>\r+ge
      \ | silent! keepjumps normal! gg=G¬

" TODO: if bang is exists, include untracked file
command! -bar -bang TodoList vimgrep 'TODO\ze:' `git ls-files`

command! -nargs=? -bar -complete=filetype MiniNote
      \ : execute (empty(<q-mods>) ? 'botright' : <q-mods>) 'new'
      \ | setlocal bufhidden=wipe filetype=<args>

command! -bar DeinUpdateMine
      \ call dein#update(keys(filter(copy(dein#get()),
      \ { key, val -> val.repo =~? '^4513ECHO/' })))

if filereadable(expand('~/.vimrc_secret'))
  source ~/.vimrc_secret
endif

" restore cursor
" from `:help restore-cursor`
autocmd vimrc BufReadPost *
      \ : if line('''"') > 1 && line('''"') <= line('$')
      \ |   execute 'normal! g`"'
      \ | endif

autocmd vimrc BufEnter *
      \ : if &filetype ==# ''
      \ |   execute 'nnoremap <buffer> q <C-w>q'
      \ | endif

" vim as a pager
autocmd vimrc StdinReadPost * call user#pager()

" auto make directories
" from https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
autocmd vimrc BufWritePre *
      \ call user#auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

if has('nvim')
  autocmd vimrc TermOpen * startinsert
  autocmd vimrc TermOpen * setlocal nonumber
endif

" auto disable paste mode
autocmd vimrc InsertLeave * setlocal nopaste

" auto quickfix opener
" from https://github.com/monaqa/dotfiles/blob/424b0ab2d7/.config/nvim/scripts/autocmd.vim
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost l* lwindow

" faster syntax highlight
autocmd vimrc Syntax *
      \ : if line('$') > 1000
      \ |   syntax sync minlines=100
      \ | endif

autocmd vimrc BufWinEnter *
      \ : if empty(&buftype) && line('.') > winheight(0) / 3 * 2
      \ |   execute 'normal! zz' .. repeat("\<C-y>", winheight(0) / 6)
      \ | endif

" from https://qiita.com/Bakudankun/items/649aa6d8b9eccc1712b5
" TODO: modify the color of EndOfBuffer
" NOTE: I'm working in progress that making plugin...
autocmd vimrc ColorScheme *
      \ : if !hlexists('NormalNC')
      \ |   execute 'hi NormalNC guibg='
      \   .. lightsout#darken(lightsout#get_hl('Normal', 'guibg'), 0.03)
      \ | endif
if !has('nvim')
  autocmd vimrc BufWinEnter,WinEnter * setlocal wincolor=
  autocmd vimrc WinLeave * setlocal wincolor=NormalNC
endif

" from https://github.com/yuki-yano/dotfiles/blob/11bfe29f07/.vimrc#L696
autocmd vimrc FocusGained * checktime

" from https://github.com/kuuote/dotvim/blob/46760385c2/conf/rc/autocmd.vim#L5
function! s:chmod(file) abort
  let perm = getfperm(a:file)
  let newperm = printf("%sx%sx%sx", perm[0:1], perm[3:4], perm[6:7])
  if perm != newperm
    call setfperm(a:file, newperm)
  endif
endfunction

autocmd vimrc BufWritePost *
      \ : if getline(1) =~# "^#!"
      \ |   call s:chmod(expand("<afile>"))
      \ | endif

if has('nvim')
  autocmd vimrc TextYankPost *
        \ silent! lua vim.highlight.on_yank { timeout = 150 }
endif
