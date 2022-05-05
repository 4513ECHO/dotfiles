function! s:echo(...) abort
  for chunk in a:000
    execute 'echohl' get(chunk, 1, 'NONE')
    echon chunk[0]
    echohl NONE
  endfor
endfunction

function! user#launcher#select(...) abort
  let launcher_config = get(a:000, 0, g:launcher_config)
  call map(copy(launcher_config),
        \ { k, v -> s:echo([printf('%s: ', k)], [v.char, 'Statement'], [' ']) })
  let char = getcharstr()
  redraw | echo ''
  let launcher = filter(copy(launcher_config), { _, v -> v.char ==# char })
  call user#launcher#run(launcher)
endfunction

function! user#launcher#run(launcher) abort
  if empty(a:launcher)
    return
  endif
  let launcher = values(a:launcher)[0]
  if get(launcher, 'nested', v:false)
    call user#launcher#select(launcher.run)
    return
  endif
  let Run = launcher.run
  if type(Run) == v:t_func
    call call(Run, [])
  elseif type(Run) == v:t_string
    execute Run
  endif
endfunction
