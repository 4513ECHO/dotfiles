" mapleader
let g:mapleader = ","
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>
inoremap <Leader><Space> <Leader>
inoremap <Leader><Leader> <ESC>
xnoremap <Leader><Leader> <ESC>

if has('nvim')
  tnoremap <Leader><Leader> <C-\><C-n>
else
  tnoremap <Leader><Leader> <C-w>N
endif
tnoremap <Leader><Space> <Leader>

nnoremap ZZ <Nop>
nnoremap q <Nop>
nnoremap Q q
nnoremap S <Nop>
xnoremap q <Nop>
xnoremap Q q
xnoremap S <Nop>

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

nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

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

nnoremap <silent><expr> <S-h>
      \ getline('.')[:col('.') - 1] =~# '^\s*$' ? '^' : '0'
nnoremap <S-l> <End>
xnoremap <silent><expr> <S-h>
      \ getline('.')[:col('.') - 1] =~# '^\s*$' ? '^' : '0'
xnoremap <S-l> <End>

nnoremap [Space] <Nop>
nmap <Space> [Space]
nnoremap <C-l> <Cmd>nohlsearch<CR><C-l>
nnoremap <Leader><C-r>
      \ <Cmd>source $MYVIMRC<Bar>nohlsearch<Bar>echomsg 'reloaded!'<CR>
nnoremap [Space]w <Cmd>update<CR>
nnoremap [Space]W <Cmd>write<CR>
nnoremap ^ <C-^><Cmd>edit<CR>
" nnoremap ^ <C-^>
nnoremap <silent><expr> <Tab> shiftwidth() .. 'l'
nnoremap [Space]f <Cmd>edit %:p:h<CR>

xnoremap v $
xnoremap < <gv
xnoremap > >gv

inoremap <Leader>z <C-o>zz
inoremap <Leader>p <Cmd>setlocal paste! paste?<CR>

" moving
noremap! <C-h> <Left>
noremap! <C-j> <Down>
noremap! <C-k> <Up>
noremap! <C-l> <Right>
noremap! <C-a> <Home>
noremap! <C-e> <End>

" paste
noremap! <C-p> <C-r>*

noremap! <Leader>/ \

cnoremap <C-x> <C-r>=expand('%:p')<CR>

cnoreabbrev <expr> w!!
      \ (getcmdtype() ==# ':' && getcmdline() ==# 'w!!')
      \ ? 'write !sudo tee > /dev/null %' : 'w!!'

" toggle options
nnoremap [Toggle] <Nop>
nmap <Leader>t [Toggle]
nnoremap [Toggle]w <Cmd>setlocal wrap! wrap?<CR>
nnoremap [Toggle]p <Cmd>setlocal paste! paste?<CR>
nnoremap [Toggle]c <Cmd>setlocal termguicolors! termguicolors?<CR>
nnoremap [Toggle]n <Cmd>setlocal relativenumber! relativenumber?<CR>

