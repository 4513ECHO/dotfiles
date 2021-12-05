function! user#set_filetype(pattern, filetype) abort
  execute 'autocmd user BufRead,BufNewFile' a:pattern
        \ 'setfiletype' a:filetype
endfunction

function! user#title_string() abort
  if &buftype ==# 'help'
    let dirname = 'help'
  elseif &buftype ==# 'terminal'
    let dirname = 'terminal'
  else
    let dirname = pathshorten(expand(('%:~:h')))
  endif
  return printf('%s (%s) - VIM', expand('%:t'), dirname)
endfunction

let s:cursorline_lock = 0
function! user#auto_cursorline(event) abort
  if a:event ==? 'WinEnter'
    setlocal cursorline
    let s:cursorline_lock = 2
  elseif a:event ==? 'WinLeave'
    setlocal nocursorline
  elseif a:event ==? 'CursorMoved'
    if s:cursorline_lock
      if 1 < s:cursorline_lock
        let s:cursorline_lock = 1
      else
        setlocal nocursorline
        let s:cursorline_lock = 0
      endif
    endif
  elseif a:event ==? 'CursorHold'
    setlocal cursorline
    let s:cursorline_lock = 1
  endif
endfunction

function! user#pager() abort
  setlocal noswapfile buftype=nofile bufhidden=hide
  setlocal modifiable nomodified readonly
  if exists(':AnsiEsc') == 2
    autocmd user ColorScheme * ++once AnsiEsc
  else
    silent! keepjump keeppatterns %substitute/\v\e\[%(%(\d;)?\d{1,2})?[mK]//ge
  endif
  nnoremap <buffer> q <C-w>q
  normal! gg
endfunction
function! user#google(word) abort
  execute 'terminal' '++close' '++shell' 'w3m'
        \ printf('"https://google.com/search?q=%s"', a:word)
endfunction

function! user#deno_run(no_check) abort
  if &filetype !~# 'typescript'
    echoerr 'Execute this command in typescript file buffer'
    return
  endif
  let subcmd =  expand('%:t') =~# '\v^(.*[._])?test\.(ts|tsx|js|jsx|mjs|jsx)$'
        \ ? 'test': 'run'
  let opts = '--allow-all --unstable --watch'
  if a:no_check
    let opts ..= ' --no-check'
  endif
  execute 'topleft terminal ++close ++rows=12'
        \ 'deno' subcmd opts expand('%:p')
  setlocal bufhidden=wipe
  autocmd BufEnter <buffer> if winnr('$') | quit! | endif
  wincmd j
endfunction

function! user#auto_mkdir(dir, force) abort
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir))
        \ =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

function! user#profile(file) abort
  if !empty(a:file)
    let file = a:file
  else
    let fileformat = fnamemodify(g:config_home .. '/profile_%s.log', 'p')
    let lnum = 1
    let file = printf(fileformat, lnum)
    while filereadable(file)
      let file = printf(fileformat, lnum)
      let lnum = lnum + 1
    endwhile
  endif
  execute 'profile start' file
  profile func *
  profile file *
  source $MYVIMRC
  echomsg 'Profiling to:' file
  exit
endfunction

