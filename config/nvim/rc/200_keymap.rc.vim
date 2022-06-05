" mapleader
let g:mapleader = ','
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>
inoremap <Leader><Space> <Leader>
" NOTE: enable remap because of lexima.vim
imap <silent> <Leader><Leader> <Esc>
xnoremap <Leader><Leader> <Esc>

if has('nvim')
  tnoremap <Leader><Leader> <C-\><C-n>
else
  tnoremap <Leader><Leader> <C-w>N
endif
tnoremap <Leader><Space> <Leader>

" disable dengerous/annoying mapping
" NOTE: ZQ is useful when cmdline is broken
nnoremap ZZ <Nop>
nnoremap q <Nop>
nnoremap S <Nop>
xnoremap q <Nop>
xnoremap S <Nop>

nnoremap <expr> Q empty(reg_recording())
      \ ? 'qq' .. '<Cmd>call user#notify("register recording started")<CR>'
      \ : 'q' .. '<Cmd>call user#notify("register recording finished")<CR>'

" disable tmux prefix key
nnoremap <C-q> <Nop>
xnoremap <C-q> <Nop>
noremap! <C-q> <Nop>

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
xnoremap j gj
xnoremap k gk
xnoremap gj j
xnoremap gk k

nnoremap x "_x
nnoremap s "_s
nnoremap Y y$
xnoremap x "_x
xnoremap s "_s
xnoremap Y y$

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv
nnoremap g* g*zzzv
nnoremap g# g#zzzv

" disable arrow keys
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
xnoremap <Up> <Nop>
xnoremap <Down> <Nop>
xnoremap <Left> <Nop>
xnoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" better aliases of <Home>/<End>
nnoremap <silent><expr> <S-h>
      \ getline('.')[:col('.') - 2] =~# '^\s*$' ? '0' : '^'
nnoremap <S-l> <End>
xnoremap <silent><expr> <S-h>
      \ getline('.')[:col('.') - 2] =~# '^\s*$' ? '0' : '^'
xnoremap <S-l> <End>

inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

nnoremap [Space] <Nop>
nmap <Space> [Space]
nnoremap <C-l> <Cmd>nohlsearch<Bar>diffupdate<CR><C-l>
nnoremap <Leader><C-r>
      \ <Cmd>source $MYVIMRC<Bar>nohlsearch<Bar>echomsg 'reloaded!'<CR>
nnoremap [Space]w <Cmd>update<CR>
nnoremap [Space]W <Cmd>write<CR>
nnoremap ^ <C-^><Cmd>edit<CR>
nnoremap [Space]f <Cmd>edit %:p:h<CR>
nnoremap [Space]q <Cmd>confirm qall<CR>
nnoremap gf gF
cnoremap <expr> / getcmdtype() ==# '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() ==# '?' ? '\?' : '?'
" open native cmdline
nnoremap g: :
nnoremap g/ /
" from https://github.com/pesblog/dots-base/blob/a0762b8ffe/home/.vimrc#L140
nnoremap <expr> gp '`[' .. strpart(getregtype(), 0, 1) .. '`]'
" from https://baqamore.hatenablog.com/entry/2016/07/07/201856
xnoremap <expr> p 'pgv"' .. v:register .. 'ygv<Esc>'
" from https://vim-jp.org/vim-users-jp/2009/08/31/Hack-65.html
xnoremap / <Esc>/\%V
" from https://github.com/nnsnico/dotfiles/blob/cf9ce83cfa/vim/vimrcs/basic.vim#L150-L151
" center horizontally on cursor position
nnoremap z. <Cmd>normal! zszH<CR>
" from https://github.com/romgrk/nvim/blob/ba305c52/rc/keymap.vim#L98-L99
nnoremap <expr> i getline('.') =~# '^\s\+$' ? 'cc' : 'i'

xnoremap v $
xnoremap <Space> t<Space>
xnoremap ) t)
xnoremap < <gv
xnoremap > >gv
onoremap <Space> t<Space>
onoremap ) t)

inoremap <Leader>z <C-o>zz
inoremap <Leader>p <Cmd>setlocal paste! paste?<CR>

" emacs-like insert/cmdline mode mapping {{{
noremap! <C-a> <Home>
noremap! <C-e> <End>

noremap! <C-b> <Left>
noremap! <C-n> <Down>
noremap! <C-p> <Up>
noremap! <C-f> <Right>

noremap! <C-d> <Del>
inoremap <C-k> <C-o>D
cnoremap <expr> <C-k>
     \ repeat("\<Del>", strchars(getcmdline()[getcmdpos() - 1:]))

noremap! <C-y> <C-r>*
" }}}

noremap! ¥ <Bslash>

" insert current file fullpath
cnoremap <C-x> <C-r>=expand('%:p')<CR>

cnoreabbrev <expr> w!!
      \ (getcmdtype() ==# ':' && getcmdline() ==# 'w!!')
      \ ? 'write !sudo tee > /dev/null %' : 'w!!'

" toggle options
nnoremap [Toggle] <Nop>
nmap <C-t> [Toggle]
nnoremap [Toggle]w <Cmd>setlocal wrap! wrap?<CR>
nnoremap [Toggle]p <Cmd>setlocal paste! paste?<CR>
nnoremap [Toggle]c <Cmd>setlocal termguicolors! termguicolors?<CR>
nnoremap [Toggle]n <Cmd>setlocal relativenumber! relativenumber?<CR>

" moving mappings {{{
" buffer move
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" quickfix move
" NOTE: conflict with diff move (see `:help jumpto-diffs`)
" nnoremap <silent> [c :cprevious<CR>
" nnoremap <silent> ]c :cnext<CR>
" nnoremap <silent> [C :cfirst<CR>
" nnoremap <silent> ]C :clast<CR>

" locationlist move
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>

" tabpage move
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [T :tabfirst<CR>
nnoremap <silent> ]T :tablast<CR>
" }}}
