" ------------------
" encoding/char
set encoding=utf-8
if &modifiable
  set fileencoding=utf-8
endif
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
set ambiwidth=single

" ------------------
" color/sequence
set background=dark
if !has('mac') || $COLORTERM ==# 'truecolor'
  set termguicolors
endif
if !has('gui_running') && !has('nvim')
  set t_Co=256
  let &t_Cs = "\<Esc>[4:3m"
  let &t_Ce = "\<Esc>[4:0m"
  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  let &t_SI ..= "\<Esc>[6 q"
  let &t_EI ..= "\<Esc>[2 q"
  let &t_SR ..= "\<Esc>[4 q"
endif
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor

" ------------------
" stausline
" NOTE: Set 'laststatus' lazily in hook_source of lightline
set laststatus=0
set noshowmode
set showcmd
set noruler

" ------------------
" indent
set copyindent
set preserveindent
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
  " based on https://github.com/thinca/config/blob/eb27ff47/dotfiles/dot.vim/vimrc#L598
  let &grepprg = 'rg --json $* --sort=path | jq -r ''include "4513echo/ripgrep"; parse'''
  set grepformat=%f:%l:%k:%c:%m
endif

" ------------------
" display
set number
set nocursorline
set list
set nowrap
set linebreak
set display=lastline,uhex
if has('nvim')
  set display+=msgsep
endif
set shortmess=aoOsTcFS
set lazyredraw
set nofoldenable
set synmaxcol=200
set redrawtime=1000
set signcolumn=number
set tabclose=uselast

set sidescroll=1
set sidescrolloff=2

set belloff=
set visualbell

set listchars=tab:»-,trail:-,extends:»,precedes:«,eol:¬,nbsp:%
let &showbreak = '» '
set fillchars& fillchars+=stl:\ ,stlnc:\ ,diff:/,eob:.
if has('nvim')
  set fillchars+=msgsep:\|
endif

set pumheight=10
set helpheight=12
set cmdheight=2
if has('nvim')
  set pumblend=20
  set winblend=20
endif

" ------------------
" editing
set backspace=indent,eol,start
set whichwrap=b,s,h,l
set hidden
set confirm
set timeoutlen=500
" NOTE: Use vim-parenmatch instead of 'showmatch' and 'matchtime'
set matchpairs& matchpairs+=<:>
set nrformats=hex,bin,blank
set nojoinspaces
set virtualedit=block

set clipboard-=autoselect
set mouse=nr
set mousemodel=popup_setpos

set completeopt=menuone,noinsert,noselect,popup
set isfname& isfname-== isfname+=@-@

" ------------------
" commandline
set wildmenu
set wildmode=longest,full
set wildoptions=pum,tagfile,fuzzy
set wildignorecase
set history=400
set cedit=

" ------------------
" backup
set backup
set writebackup
set swapfile
set updatetime=100
let &backupdir = g:data_home .. '/backup//'
let &directory = g:data_home .. '/swap//'
call mkdir(&backupdir, 'p')
call mkdir(&directory, 'p')
set undofile
if !has('nvim')
  let &undodir = g:vim_data_home .. '/undo'
  call mkdir(&undodir, 'p')
  let &viminfofile = g:vim_data_home .. '/viminfo'
endif

" ------------------
" title
set title
set titlestring=%{user#title_string()}
let &titleold = getcwd()->fnamemodify(':~')->pathshorten()

" ------------------
" various
set helplang=ja,en
set keywordprg=:help

set packpath=
set ttyfast
set autoread
set tildeop
set diffopt=internal,filler,vertical,algorithm:histogram,indent-heuristic
set nofsync
set nolangremap
