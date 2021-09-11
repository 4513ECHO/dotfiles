set fileencoding=utf-8
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac "
set ambiwidth=double

set wildmenu
set history=300

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
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set shiftwidth=2

set incsearch
set ignorecase
set smartcase
set hlsearch

set whichwrap=b,s,h,l,<,>,[,],~
set number
set cursorline
set backspace=indent,eol,start

set showmatch
set matchtime=1
set matchpairs& matchpairs+=<:>
source $VIMRUNTIME/macros/matchit.vim

set nowritebackup
set nobackup
set noswapfile

set list
set wrap
set display=lastline
set t_vb=
set novisualbell
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
