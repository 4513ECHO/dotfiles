augroup vimrc
  autocmd!
augroup END

let g:cache_home = $XDG_CACHE_HOME .. '/nvim'
let g:config_home = $XDG_CONFIG_HOME .. '/nvim'
let g:data_home = $XDG_DATA_HOME .. '/nvim'
let g:vim_cache_home = $XDG_CACHE_HOME .. '/vim'
let g:vim_data_home = $XDG_DATA_HOME .. '/vim'

let g:launcher_config = get(g:, 'launcher_config', {})
nnoremap <C-s> <Cmd>call user#launcher#select()<CR>
let g:launcher_config.color = #{
      \ char: 'r',
      \ run: 'RandomColorScheme',
      \ }

autocmd vimrc VimEnter * ++nested call user#colorscheme#random()
autocmd vimrc ColorSchemePre *
      \ : unlet! g:terminal_color_foreground g:terminal_color_background
      \          g:terminal_ansi_colors
      \ | for i in range(16)
      \ |   unlet! g:terminal_color_{i}
      \ | endfor
autocmd vimrc ColorScheme *
      \ : call user#colorscheme#update_lightline()
      \ | call user#colorscheme#set_customize()

" echo message vim start up time
" https://github.com/lighttiger2505/.dotfiles/blob/6d0d4b8392/.vimrc#L11
if has('vim_starting')
  let g:startuptime = reltime()
  autocmd vimrc VimEnter *
        \ : let g:startuptime = reltime(g:startuptime)
        \ | redraw
        \ | echomsg printf('startuptime: %fms', reltimefloat(g:startuptime) * 1000)
endif

command! -nargs=1 Runtime runtime! g:config_home <args>

" from https://github.com/thinca/config/blob/d92e41cebd/dotfiles/dot.vim/vimrc#L1382
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

command! -bar RandomColorScheme call user#colorscheme#random()

command! -nargs=? -bar -bang -complete=customlist,user#colorscheme#completion
      \ ColorScheme call user#colorscheme#command(<q-args>, <bang>0)

" from https://qiita.com/gorilla0513/items/11be5413405792337558
command! -nargs=1 WWW call user#google(<q-args>)

" from https://qiita.com/gorilla0513/items/f59e54606f6f4d7e3514
command! PopupTerminal
      \ call popup_create(term_start(
      \     [&shell], { 'hidden': v:true, 'term_finish': 'close' }
      \   ), {
      \   'border': [], 'minwidth': winwidth(0)/2, 'minheight': &lines/2,
      \ })

command! -bar HtmlFormat
      \ : silent! keepjumps keeppattern substitute+\v\>(\<)@=+>\r+ge
      \ | silent! keepjumps normal! gg=G

command! -bar -bang TodoList vimgrep '\vTODO\ze%(\(.{-}\))?:' `git ls-files`

command! -nargs=? -bar -complete=filetype MiniNote
      \ : execute (empty(<q-mods>) ? 'botright' : <q-mods>) 'new mininote'
      \ | setlocal bufhidden=wipe buftype=nofile filetype=<args>

command! -bar DeinUpdateMine
      \ call dein#update(keys(filter(copy(dein#get()),
      \ { key, val -> val.repo =~? '^4513ECHO/' })))

" from `:help :DiffOrig`
command! -bar DiffOrig
      \ : vertical new | setlocal buftype=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis

if filereadable(expand('~/.vimrc_secret'))
  source ~/.vimrc_secret
endif

" custom autocmd
nnoremap <Plug>(VimrcSearchPost) <Cmd>doautocmd <nomodeline> User VimrcSearchPost<CR>
autocmd vimrc User VimrcSearchPost :

if has('nvim')
  lua require('vimrc.autocmd')
endif

" restore cursor
" from `:help restore-cursor`
autocmd vimrc BufReadPost *
      \ : if line('''"') > 1 && line('''"') <= line('$')
      \ |   execute 'normal! g`"'
      \ | endif

" vim as a pager
autocmd vimrc StdinReadPost * call user#pager()

" auto make directories
" from https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
autocmd vimrc BufWritePre *
      \ call user#auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

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

" from https://github.com/yuki-yano/dotfiles/blob/11bfe29f07/.vimrc#L696
autocmd vimrc FocusGained * checktime

" from https://github.com/kuuote/dotvim/blob/46760385c2/conf/rc/autocmd.vim#L5
function! s:chmod(file) abort
  let perm = getfperm(a:file)
  let newperm = printf('%sx%sx%sx', perm[0:1], perm[3:4], perm[6:7])
  if perm != newperm
    call setfperm(a:file, newperm)
  endif
endfunction
autocmd vimrc BufWritePost *
      \ : if getline(1) =~# '^#!'
      \ |   call s:chmod(expand('<afile>'))
      \ | endif

" always highlight special comment
autocmd vimrc ColorScheme * silent! hi def link TodoExt Todo
autocmd vimrc BufEnter,WinEnter,Syntax *
      \ silent! let g:todo_match =  matchadd('TodoExt',
      \ '\v\zs(TODO|NOTE|XXX|FIXME|INFO)\ze%(\(.{-}\))?\:')

autocmd vimrc ColorScheme *
      \ : if &laststatus == 3
      \ |   hi clear VertSplit
      \ | endif

autocmd vimrc BufWritePost *
      \ : if empty(&filetype)
      \ |   filetype detect
      \ | endif

autocmd vimrc SwapExists *
      \ : let v:swapchoice = 'o'
      \ | echohl ErrorMsg
      \ | echomsg 'Swapfile is found:' v:swapname
      \ | echohl NONE

" from https://github.com/aiotter/dotfiles/blob/8e759221/.vimrc#L185
autocmd vimrc WinEnter *
      \ : if winnr('$') == 1 && &buftype ==# 'quickfix'
      \ |   quit
      \ | endif

autocmd vimrc VimResized *
      \ : if &equalalways
      \ |   wincmd =
      \ | endif
