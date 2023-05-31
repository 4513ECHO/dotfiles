function! user#title_string() abort
  let f = expand('%:t')
  let d = expand('%:~:h')->pathshorten()
  let r = getcwd()->fnamemodify(':~')->pathshorten()
  if &buftype ==# 'help'
    let [dir, file] = ['help', f]
  elseif &buftype ==# 'terminal'
    let [dir, file] = ['terminal', f]
  elseif &buftype ==# 'nofile'
    let [dir, file] = &filetype ==# 'molder'
          \ ? [d, f]
          \ : [r, bufname()]
  elseif &buftype ==# 'quickfix'
    let [dir, file] = [r, 'QuickFix']
  else
    let [dir, file] = [d ?? r, f]
  endif
  return $'{file} ({dir}) - {toupper(v:progname)}'
endfunction

function! user#google(query) abort
  let cmd = ['w3m', $'https://google.com/search?q={a:query}']
  if has('nvim')
    new
    call termopen(cmd)
  else
    call term_start(cmd, #{ term_finish: 'close' })
  endif
endfunction

function! user#auto_mkdir(dir, force) abort
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir))
        \ =~? '^y\%[es]$')
    call mkdir(a:dir, 'p')
  endif
endfunction
