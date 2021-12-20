function! user#colorscheme#lightline() abort
  if g:current_colorscheme ==# 'random'
    return 'default'
  endif
  let custom_name = get(get(g:colorscheme_customize,
        \ g:current_colorscheme, {}), 'lightline')
  if !empty(custom_name)
    return custom_name
  endif
  return g:current_colorscheme
endfunction

function! s:colorscheme_list() abort
  let keys = keys(g:colorscheme_customize)
  if has_key(g:colorscheme_customize, '_')
    call filter(keys, { _, val -> val !~# '_' })
  endif
  return extend(keys, g:colorscheme_list, 'keep')
endfunction

function! user#colorscheme#random() abort
  if has('nvim')
    let randint = str2nr(matchstr(reltimestr(reltime()),
          \ '\.\@<=\d\+')[1:])
  else
    let randint = rand()
  endif
  call user#colorscheme#colorscheme(
        \ get(s:colorscheme_list(), randint % len(s:colorscheme_list())))
endfunction

function! user#colorscheme#set_customize(colorscheme) abort
  if a:colorscheme !=# '_'
    call user#colorscheme#set_customize('_')
  endif
  let customize = get(g:colorscheme_customize, a:colorscheme)
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
    let g:terminal_ansi_colors = terminal
  endif
  let link = get(customize, 'link')
  if !empty(link)
    for [linked, base] in items(link)
      execute 'hi link' linked base
    endfor
  endif
endfunction

function! user#colorscheme#colorscheme(colorscheme) abort
  if empty(s:colorscheme_list())
    return
  endif
  let g:current_colorscheme = a:colorscheme
  if a:colorscheme ==# 'random'
    call user#colorscheme#random()
    return
  endif
  autocmd! random_colorscheme ColorScheme
  execute 'autocmd random_colorscheme ColorScheme' a:colorscheme
        \ printf('call user#colorscheme#set_customize("%s")', a:colorscheme)
  silent! unlet g:terminal_ansi_colors
  execute 'colorscheme' a:colorscheme
  " NOTE: `:help lightline-problem-13`
  let g:lightline.colorscheme = user#colorscheme#lightline()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! user#colorscheme#completion(ArgLead, CmdLine, CursorPos) abort
  if exists('?matchfuzzy')
    if empty(a:ArgLead)
      return sort(copy(s:colorscheme_list()))
    else
      return matchfuzzy(copy(s:colorscheme_list()), a:ArgLead)
    endif
  else
    return filter(copy(s:colorscheme_list()), {_, val -> val =~? a:ArgLead})
  endif
endfunction

