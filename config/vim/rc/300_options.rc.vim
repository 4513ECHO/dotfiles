
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
" color
set background=dark
set synmaxcol=200
if has('termguicolors')
  set termguicolors
endif
if !has('gui_running')
  set t_Co=256
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
set shiftwidth=2

" ------------------
" search
set incsearch
set ignorecase
set smartcase
set hlsearch
set report=0
set nowrapscan

" ------------------
" display
set number
set nocursorline
set list
set nowrap
set linebreak
set display=lastline,uhex
set shortmess+=cs
set lazyredraw
set nofoldenable

set t_vb=
set novisualbell
set belloff=all

set listchars=tab:»-,trail:-,extends:»,precedes:«,eol:¬
set fillchars& fillchars+=diff:/

set pumheight=10
set helpheight=12
set cmdheight=2

" ------------------
" editing
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,],~
set hidden
set confirm

set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>

set clipboard=unnamed
set mouse=a

set completeopt=menuone,popup,noinsert,noselect
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
set updatetime=10000
let &backupdir = g:data_home .. '/backup'
let &directory = g:data_home .. '/swap'
call mkdir(&backupdir, 'p')
call mkdir(&directory, 'p')
if has('persistent_undo')
  set undofile
  let &undodir = g:data_home .. '/undo'
  call mkdir(&undodir, 'p')
endif
if has('viminfo')
  execute 'set viminfo+=n' .. g:data_home .. '/viminfo'
endif

" ------------------
" various
set helplang=ja,en
set keywordprg=:help

set packpath=
set ttyfast
set title
set autoread

