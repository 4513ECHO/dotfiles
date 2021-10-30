set encoding=utf-8
scriptencoding utf-8
if &modifiable
  set fileencoding=utf-8
endif
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=double

set shortmess+=cs
set completeopt=menuone,popup,noinsert,noselect
set isfname-==

set wildmenu
set wildmode=longest,full
set history=200

if has('termguicolors')
  set termguicolors
endif

if !has('gui_running')
  set t_Co=256
endif

set laststatus=2
set noshowmode
set showcmd
set ruler

set expandtab
set tabstop=8
set softtabstop=8
set autoindent
set smartindent
set shiftwidth=2

set incsearch
set ignorecase
set smartcase
set hlsearch

set formatoptions-=ro
set whichwrap=b,s,h,l,<,>,[,],~
set number
set cursorline
set backspace=indent,eol,start

set helplang=ja,en
set keywordprg=:help

set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>

set background=dark
set list
set nowrap
set display=lastline
set t_vb=
set novisualbell
set listchars=tab:»-,trail:-,extends:»,precedes:«,eol:¬
set hidden
set synmaxcol=200

set pumheight=10
set cmdheight=2
set clipboard=unnamed
set mouse=a

set packpath=

" buckup settings
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
