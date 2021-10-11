let g:mapleader = ","
noremap <Leader> <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>
inoremap <Leader><Leader> <ESC>
vnoremap <Leader><Leader> <ESC>
noremap <silent> j gj
noremap <silent> k gk
noremap x "_x
noremap s "_s
noremap Y y$
noremap gj j
noremap gk k

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

noremap <S-h> ^
noremap <S-l> $

nnoremap <C-l> <Cmd>nohlsearch<CR><C-l>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

inoremap <Leader>/ \
cnoremap <Leader>/ \

cabbr w!! w !sudo tee > /dev/null %
nnoremap [Toggle] <Nop>
nmap <Leader>t [Toggle]
nnoremap [Toggle]w <Cmd>setlocal wrap! wrap?<CR>
nnoremap [Toggle]p <Cmd>setlocal paste! paste?<CR>
nnoremap [Toggle]c <Cmd>setlocal termguicolors! termguicolors?<CR>
nnoremap [Toggle]n <Cmd>setlocal relativenumber! relativenumber?<CR>
noremap S <Nop>
vnoremap v $

