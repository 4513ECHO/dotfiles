function! gf#vimrc#find() abort
  let path = expand('<cfile>')
  let [line, col] = [0, 0]
  if path =~# '\v:\d+%(:\d+)?:?$'
    let line = matchstr(path, '\v\d+\ze%(:\d+)?:?$')
    let col = matchstr(path, '\v:\d+:\zs\d+\ze:?$')
    let path = matchstr(path, '\v.{-}\ze:\d+%(:\d+)?:?$')
  endif
  if path =~# '^file://'
    let path = substitute(path, '^file://', '', '')
  endif
  return {
        \ 'path': path,
        \ 'line': line,
        \ 'col': empty(col) ? 0 : col,
        \ }
endfunction
