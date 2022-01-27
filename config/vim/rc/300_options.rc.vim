
" ------------------
" encoding/char
set encoding=utf-8
scriptencoding utf-8
if &modifiable
  set fileencoding=utf-8
endif
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

" ------------------
" color/sequence
set background=dark
set termguicolors
if !has('gui_running') && !has('nvim')
  set t_Co=256
  let &t_Cs = "\<Esc>[4:3m"
  let &t_Ce = "\<Esc>[4:0m"
  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
endif

" ------------------
" stausline
set laststatus=2
set noshowmode
set showcmd
set noruler

" ------------------
" indent
set expandtab
set tabstop=8
set softtabstop=8
set autoindent
set smartindent
set indentkeys& indentkeys-=!^F
set shiftwidth=2

" ------------------
" search
set incsearch
set ignorecase
set smartcase
set hlsearch
set report=0
if executable('rg')
  let &grepprg = 'rg --vimgrep --hidden --sort path'
  set grepformat=%f:%l:%c:%m
endif

" ------------------
" display
set number
set nocursorline
set list
set nowrap
set linebreak
set display=lastline,uhex
set shortmess+=acs
set lazyredraw
set nofoldenable
set synmaxcol=200
set redrawtime=1000

set t_vb=
set novisualbell
set belloff=all

set listchars=tab:»-,trail:-,extends:»,precedes:«,eol:¬
let &showbreak = '> '
if exists('+fillchars')
  set fillchars& fillchars+=diff:/,eob:.
endif

set pumheight=10
set helpheight=12
set cmdheight=2

" ------------------
" editing
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
set hidden
set confirm
set timeoutlen=500

set matchpairs& matchpairs+=<:>

set clipboard=unnamed
set mouse=a

set completeopt=menuone,noinsert,noselect
if !has('nvim')
  set completeopt+=popup
endif
set isfname-==

" ------------------
" commandline
set wildmenu
set wildmode=longest,full
set history=200
set cedit=

" ------------------
" buckup
set backup
set writebackup
set swapfile
set updatetime=200
let &backupdir = g:data_home .. '/backup'
let &directory = g:data_home .. '/swap'
call mkdir(&backupdir, 'p')
call mkdir(&directory, 'p')
set undofile
if has('nvim')
  let &undodir = g:data_home .. '/nvimundo'
  call mkdir(&undodir, 'p')
else
  let &undodir = g:data_home .. '/undo'
  call mkdir(&undodir, 'p')
endif
" TODO: use shada instead in neovim
if !has('nvim')
  let &viminfofile = g:data_home .. '/viminfo'
endif

" ------------------
" title
set title
set titlestring=%{user#title_string()}
let &titleold = pathshorten(fnamemodify(getcwd(), ':~'))

" ------------------
" various
set helplang=ja,en
set keywordprg=:help

set packpath=
set ttyfast
set autoread
set tildeop
set diffopt=internal,filler,vertical,algorithm:histogram,indent-heuristic

