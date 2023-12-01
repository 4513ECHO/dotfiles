" restore cursor
" from `:help restore-cursor`
autocmd vimrc BufReadPost *
      \ : if line('''"') > 1 && line('''"') <= line('$')
      \ |   execute 'normal! g`"'
      \ | endif

" auto make directories
" from https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
autocmd vimrc BufWritePre *
      \ call user#auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

" auto disable paste mode
autocmd vimrc InsertLeave * setlocal nopaste

" auto quickfix opener
" from https://github.com/monaqa/dotfiles/blob/424b0ab2/.config/nvim/scripts/autocmd.vim
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

" from https://github.com/yuki-yano/dotfiles/blob/11bfe29f/.vimrc#L696
autocmd vimrc FocusGained * checktime

" from https://github.com/kuuote/dotvim/blob/46760385/conf/rc/autocmd.vim#L5
function! s:chmod(file) abort
  let perm = getfperm(a:file)
  let newperm = printf('%sx%sx%sx', perm[0:1], perm[3:4], perm[6:7])
  if perm != newperm
    call setfperm(a:file, newperm)
  endif
endfunction
autocmd vimrc BufWritePost *
      \ : if getline(1) =~# '^#!/'
      \ |   call s:chmod(expand('<afile>'))
      \ | endif

" always highlight special comment
autocmd vimrc ColorScheme * silent! hi def link TodoExt Todo
autocmd vimrc BufEnter,WinEnter,Syntax *
      \ silent! let g:todo_match =  matchadd('TodoExt',
      \ '\v\zs(TODO|NOTE|XXX|FIXME|INFO)\ze%(\(.{-}\))?\:')

autocmd vimrc BufWritePost *
      \ : if empty(&filetype)
      \ |   filetype detect
      \ | endif

" from https://github.com/aiotter/dotfiles/blob/8e759221/.vimrc#L185
autocmd vimrc WinEnter *
      \ : if winnr('$') == 1 && &buftype ==# 'quickfix'
      \ |   quit
      \ | endif

autocmd vimrc VimResized *
      \ : if &equalalways
      \ |   wincmd =
      \ | endif

if !has('nvim')
  autocmd vimrc TerminalWinOpen *
        \ setlocal nonumber norelativenumber signcolumn=no nocursorline
endif
