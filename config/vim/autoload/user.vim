function! user#title_string() abort
  let f = expand('%:t')
  let d = pathshorten(expand('%:~:h'))
  let r = pathshorten(fnamemodify(getcwd(), ':~'))
  if &buftype ==# 'help'
    let [dir, file] = ['help', f]
  elseif &buftype ==# 'terminal'
    let [dir, file] = ['terminal', f]
  elseif &buftype ==# 'nofile'
    if &filetype ==# 'molder'
      let [dir, file] = [d, f]
    else
      let [dir, file] = [r, bufname()]
    endif
  elseif &buftype ==# 'quickfix'
    let [dir, file] = [r, 'QuickFix']
  else
    let [dir, file] = [(!empty(d) ? d : r), f]
  endif
  return printf('%s (%s) - %s', file, dir,
        \ has('nvim') ? 'NVIM' : 'VIM')
endfunction

function! user#pager() abort
  setlocal noswapfile buftype=nofile bufhidden=hide
  setlocal modifiable nomodified readonly nonumber synmaxcol&
  if exists(':AnsiEsc') == 2
    autocmd user VimEnter * ++once
          \ : execute 'AnsiEsc'
          \ | silent! keepjump keeppatterns
          \ | %substitute/\v\e\[%(%(\d+;)?\d{1,2})?[mK]//ge
          \ | filetype detect
  else
    silent! keepjump keeppatterns %substitute/\v\e\[%(%(\d+;)?\d{1,2})?[mK]//ge
    filetype detect
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

