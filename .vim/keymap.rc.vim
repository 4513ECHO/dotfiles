let g:mapleader = "\<Space>"
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap <silent> <C-k> "zdd<Up>"zP
nnoremap <silent> <C-j> "zdd"zp
nnoremap Q <Nop>
nnoremap <Leader>p :set paste!<CR>
nnoremap <Leader><Leader> <ESC>
vnoremap <Leader><Leader> <ESC>
nnoremap j gj
nnoremap k gk
nnoremap x "_x
nnoremap s "_s
nnoremap Y y$
nnoremap gj j
nnoremap gk k

nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

nnoremap <Tab> %
vnoremap <Tab> %

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

nnoremap <C-l> :<C-u>nohlsearch<CR><C-l>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

inoremap <Leader>/ \
cnoremap <Leader>/ \
