" mapleader
let g:mapleader = ","
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>
inoremap <Leader><Space> <Leader>
inoremap <Leader><Leader> <ESC>
xnoremap <Leader><Leader> <ESC>

nnoremap ZZ <Nop>
nnoremap Q <Nop>
nnoremap S <Nop>

nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk
nnoremap gj j
xnoremap gj j
nnoremap gk k
xnoremap gk k

nnoremap x "_x
xnoremap x "_x
nnoremap s "_s
xnoremap s "_s
nnoremap Y y$
xnoremap Y y$

nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

nnoremap <S-h> <Home>
nnoremap <S-l> <End>
xnoremap <S-h> <Home>
xnoremap <S-l> <End>

nnoremap <C-l> <Cmd>nohlsearch<CR><C-l>
nnoremap <Leader>r <Cmd>source $MYVIMRC<CR>
nnoremap <Space> <Cmd>update<CR>
nnoremap ^ <C-^>

xnoremap v $

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

cabbrev w!! w !sudo tee > /dev/null %

" toggle options
nnoremap [Toggle] <Nop>
nmap <Leader>t [Toggle]
nnoremap [Toggle]w <Cmd>setlocal wrap! wrap?<CR>
nnoremap [Toggle]p <Cmd>setlocal paste! paste?<CR>
nnoremap [Toggle]c <Cmd>setlocal termguicolors! termguicolors?<CR>
nnoremap [Toggle]n <Cmd>setlocal relativenumber! relativenumber?<CR>

