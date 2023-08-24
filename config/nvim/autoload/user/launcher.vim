function! s:echo(...) abort
  for chunk in a:000
    execute 'echohl' chunk->get(1, 'NONE')
    echon chunk[0]
    echohl NONE
  endfor
endfunction

function! user#launcher#select(config = g:launcher_config) abort
  call copy(a:config)->map({ -> s:echo([$'{v:key}: '], [v:val.char, 'Statement'], [' ']) })
  let char = getcharstr()
  redraw | echo ''
  call user#launcher#run(copy(a:config)->filter({ -> v:val.char ==# char }))
endfunction

function! user#launcher#run(launcher) abort
  let launcher = values(a:launcher)->get(0)
  if empty(launcher)
    return
  endif
  let Run = launcher.run
  if launcher->get('nested', v:false) && type(Run) == v:t_dict
    call user#launcher#select(Run)
  elseif type(Run) == v:t_func
    call call(Run, [])
  elseif type(Run) == v:t_string
    execute Run
  endif
endfunction
