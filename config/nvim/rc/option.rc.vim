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

" ------------------
" stausline
" NOTE: Set 'laststatus' in lightline.vim hook
set laststatus=0
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
  " let &grepprg = 'rg --vimgrep --hidden --sort=path'
  " set grepformat=%f:%l:%c:%m
  " based on https://github.com/thinca/config/blob/eb27ff47/dotfiles/dot.vim/vimrc#L598
  set grepprg=vimgrep
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
set whichwrap=b,s,h,l,<,>,[,],~
set hidden
set confirm
set timeoutlen=500
set matchpairs& matchpairs+=<:>
set nrformats-=octal
set nojoinspaces
set virtualedit=block

set clipboard-=autoselect
set mouse=a

set completeopt=menuone,noinsert,noselect
if !has('nvim')
  set completeopt+=popup
endif
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
set nofsync
set nolangremap
