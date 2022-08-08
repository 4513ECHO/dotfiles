if empty($VIM_DISABLE_DEIN)
  function! user#colorscheme#get(...) abort
    let update = get(a:000, 0, v:false)
    if exists('s:cache') && !update
      return s:cache
    endif
    let s:cache = {}
    for plugins in values(filter(copy(dein#get()),
          \ { _, v -> has_key(v, 'colorschemes') }))
      if has_key(plugins, 'if') && !eval(plugins.if)
        continue
      endif
      for colorscheme in plugins.colorschemes
        " let s:cache[colorscheme.name] = extend(colorscheme, { 'plugin': plugins.name })
        let s:cache[colorscheme.name] = colorscheme
      endfor
    endfor
    return s:cache
  endfunction
else
  function! user#colorscheme#get(...) abort
    return {}
  endfunction
endif

function! user#colorscheme#lightline() abort
  if g:current_colorscheme ==# 'random'
    return 'default'
  endif
  let custom_name = get(get(user#colorscheme#get(),
        \ g:current_colorscheme, {}), 'lightline')
  return empty(custom_name)
        \ ? g:current_colorscheme
        \ : custom_name
endfunction

function! user#colorscheme#random() abort
  if exists('*rand')
    let randint = rand()
  elseif has('nvim')
    lua math.randomseed(os.time())
    let randint = luaeval('math.random(1000)')
  else
    let randint = str2nr(matchstr(reltimestr(reltime()),
          \ '\.\@<=\d\+')[1:])
  endif
  let list = keys(user#colorscheme#get())
  call user#colorscheme#command(
        \ get(list, randint % len(list)),
        \ )
endfunction

function! user#colorscheme#set_customize(colorscheme) abort
  let customize = get(user#colorscheme#get(), a:colorscheme)
  if empty(customize)
    return
  endif
  let highlight = get(customize, 'highlight')
  if !empty(highlight)
    " TODO: use hiset() if exists
    for [group, attr] in items(highlight)
      let attrs = ''
      for [name, value] in items(attr)
        let attrs ..= printf('%s=%s ', name, value)
      endfor
      execute 'hi' group attrs
    endfor
  endif
  " TODO: edit v:colornames if exists
  let terminal = get(customize, 'terminal')
  if !empty(terminal)
    call s:set_terminal_colors(
          \ type(terminal) == v:t_string && terminal ==# 'mini'
          \ ? [
          \ '#1d1f21', '#cc6666', '#b5bd68', '#f0c674', '#81a2be', '#b294bb', '#8abeb7', '#d3d7cf',
          \ '#707880', '#cc6666', '#b5bd68', '#de955f', '#729fcf', '#b294bb', '#005f5f', '#707880']
          \ : terminal
          \ )
  elseif !has('nvim') && exists('g:terminal_color_0')
    let g:terminal_ansi_colors = []
    for i in range(16)
      silent! call add(g:terminal_ansi_colors, g:terminal_color_{i})
    endfor
  elseif has('nvim') && exists('g:terminal_ansi_colors')
    for i in range(16)
      let g:terminal_color_{i} = g:terminal_ansi_colors[i]
    endfor
  endif
  let link = get(customize, 'link')
  if !empty(link)
    for [linked, base] in items(link)
      execute 'hi! link' linked base
    endfor
  endif
endfunction

function! s:set_terminal_colors(list) abort
  if has('nvim')
    for i in range(16)
      let g:terminal_color_{i} = a:list[i]
    endfor
  else
    let g:terminal_ansi_colors = a:list
  endif
endfunction

function! user#colorscheme#command(colorscheme, ...) abort
  let reload = get(a:000, 0, v:false)
  if empty(user#colorscheme#get())
    return
  endif
  let colorscheme = reload
        \ ? g:current_colorscheme
        \ : a:colorscheme
  if empty(colorscheme) && !reload
    echo g:current_colorscheme
    return
  endif
  if colorscheme ==# 'random'
    call user#colorscheme#random()
    return
  endif
  for i in range(16)
    unlet! g:terminal_color_{i}
  endfor
  unlet! g:terminal_color_foreground g:terminal_color_background g:terminal_ansi_colors
  execute 'colorscheme' colorscheme
  call user#colorscheme#set_customize(colorscheme)
  let g:current_colorscheme = colorscheme
  if !exists('g:lightline')
    return
  endif
  " NOTE: `:help lightline-problem-13`
  let g:lightline.colorscheme = user#colorscheme#lightline()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! user#colorscheme#completion(ArgLead, CmdLine, CursorPos) abort
  let list = keys(user#colorscheme#get())
  if exists('*matchfuzzy')
    if empty(a:ArgLead)
      return sort(copy(list))
    else
      return matchfuzzy(copy(list), a:ArgLead)
    endif
  else
    return filter(copy(list), {_, val -> val =~? a:ArgLead})
  endif
endfunction

