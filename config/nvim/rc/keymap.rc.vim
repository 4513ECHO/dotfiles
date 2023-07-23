" mapleader
let g:mapleader = ','
nnoremap <Leader> <Nop>
xnoremap <Leader> <Nop>

" disable dengerous/annoying mapping
" NOTE: ZQ is useful when cmdline is broken
nnoremap ZZ <Nop>
nnoremap q <Nop>
nnoremap S <Nop>
xnoremap q <Nop>
xnoremap S <Nop>

" Record macro like ["x]Q (in default use 'q' register)
nnoremap <expr> Q empty(reg_recording())
      \ ? 'q' .. (v:register =~# '["*+]' ? 'q' : v:register)
      \ : 'q'

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

nnoremap n nzzzv<Plug>(VimrcSearchPost)
nnoremap N Nzzzv<Plug>(VimrcSearchPost)
nnoremap * *zzzv<Plug>(VimrcSearchPost)
nnoremap # #zzzv<Plug>(VimrcSearchPost)
nnoremap g* g*zzzv<Plug>(VimrcSearchPost)
nnoremap g# g#zzzv<Plug>(VimrcSearchPost)

" disable arrow keys
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

" better aliases of <Home>/<End>
nnoremap <expr> H getline('.')[:col('.') - 2] =~# '^\s*$' ? '0' : '^'
nnoremap L <End>
xnoremap <expr> H getline('.')[:col('.') - 2] =~# '^\s*$' ? '0' : '^'
xnoremap L <End>

inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

nnoremap [Space] <Nop>
nmap <Space> [Space]
nnoremap <C-l> <Cmd>nohlsearch<Bar>diffupdate<CR><C-l>
nnoremap [Space]w <Cmd>update<CR>
nnoremap [Space]W <Cmd>write<CR>
nnoremap ^ <C-^><Cmd>edit<CR>
nnoremap [Space]f <Cmd>edit %:p:h<CR>
nnoremap <expr> [Space]q &filetype !=# 'gitcommit' ? '<Cmd>confirm qall<CR>' : '<C-w>q'
nnoremap gf gF
cnoremap <expr> / getcmdtype() ==# '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() ==# '?' ? '\?' : '?'
" open native cmdline
nnoremap g/ /
" from https://github.com/pesblog/dots-base/blob/a0762b8f/home/.vimrc#L140
nnoremap <expr> gp $'`[{getregtype()->strpart(0, 1)}`]'
" from https://baqamore.hatenablog.com/entry/2016/07/07/201856
xnoremap <expr> p $'pgv"{v:register}ygv<Esc>'
" from https://vim-jp.org/vim-users-jp/2009/08/31/Hack-65.html
xnoremap / <Esc>/\%V
" from https://github.com/nnsnico/dotfiles/blob/cf9ce83c/vim/vimrcs/basic.vim#L150-L151
" center horizontally on cursor position
nnoremap z. zszH
" based on https://github.com/romgrk/nvim/blob/ba305c52/rc/keymap.vim#L98-L99
nnoremap <expr> i getline('.') =~# '^\s*$' ? 'cc' : 'i'
" from https://github.com/monaqa/dotfiles/blob/de4bdb9f/.config/nvim/lua/rc/keymap.lua#L436
nnoremap <expr> dd empty(getline('.')) && v:count1 ==# 1 && v:register ==# '"'
      \ ? '"_dd' : 'dd'

" NOTE: `g_` is almost same as `$h`
xnoremap <expr> v mode() ==# 'v' ? 'g_' : 'v'
xnoremap <Space> t<Space>
xnoremap ) t)
xnoremap < <gv
xnoremap > >gv
onoremap <Space> t<Space>
onoremap ) t)

inoremap <C-g><C-z> <C-o>zz
inoremap <C-g><C-p> <Cmd>setlocal paste! paste?<CR>
inoremap <C-g><C-y> <C-y>
inoremap <C-g><C-d> <C-d>

" emacs-like insert/cmdline mode mapping {{{
noremap! <C-a> <Home>
inoremap <expr> <C-e> user#is_at_end() ? '<C-e>' : '<End>'
noremap! <C-b> <Left>
noremap! <C-n> <Down>
noremap! <C-p> <Up>
noremap! <C-f> <Right>
noremap! <expr> <C-d> user#is_at_end() ? '<C-d>' : '<Del>'
inoremap <expr> <C-k> user#is_at_end() ? '<C-o>gJ' : '<C-o>D'
cnoremap <C-k> <Cmd>call setcmdline(
      \ getcmdpos() > 1 ? getcmdline()[:getcmdpos() - 2] : '')<CR>
noremap! <C-y> <C-r>"
" }}}

function! s:term_insert(content) abort
  if has('nvim')
    call chansend(b:terminal_job_id, a:content)
  else
    call term_sendkeys(bufnr(), a:content->join("\n"))
    call term_wait(bufnr())
  endif
endfunction

function! s:put(regname) abort
  if has('nvim')
    if a:regname ==# '='
      autocmd vimrc ModeChanged c:nt ++once call feedkeys('i', 'n')
      autocmd vimrc ModeChanged nt:t ++once call s:term_insert(getreg('='))
      return "\<C-\>\<C-n>\"="
    endif
    return $"\<C-\>\<C-n>\"{a:regname}pi"
  endif
  return a:regname ==# '=' ? "\<C-w>\"="
        \ : s:term_insert(getreg(a:regname, 1, 1)) ?? ''
endfunction

tnoremap <expr> <C-\><C-y> <SID>put(v:register)
tnoremap <expr> <C-\><C-r> <SID>put(getcharstr())

" Use backslack instead of ¥
map! ¥     <Bslash>
map  ¥     <Bslash>
tmap ¥     <Bslash>
map! <C-¥> <C-\>
map  <C-¥> <C-\>
tmap <C-¥> <C-\>

" insert current file fullpath
cnoremap <C-x><C-x> <C-r>=expand('%:p')<CR>

" toggle options
nnoremap [Toggle] <Nop>
nmap <C-t> [Toggle]
nnoremap [Toggle]w <Cmd>setlocal wrap! wrap?<CR>
nnoremap [Toggle]n <Cmd>setlocal relativenumber! relativenumber?<CR>

" buffer move
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
