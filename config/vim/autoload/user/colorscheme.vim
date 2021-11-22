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

function! user#colorscheme#random() abort
  let g:current_colorscheme =
        \ get(g:colorscheme_list, rand() % len(g:colorscheme_list))
  call user#colorscheme#colorscheme(g:current_colorscheme)
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
    for [group, attr] in items(highlight)
      let attrs = ''
      for [name, value] in items(attr)
        let attrs ..= printf('%s=%s ', name, value)
      endfor
      execute 'hi' group attrs
    endfor
  endif
  let link = get(customize, 'link')
  if !empty(link)
    for [linked, base] in items(link)
      execute 'hi link' linked base
    endfor
  endif
  let terminal = get(customize, 'terminal')
  if !empty(terminal)
    let g:terminal_ansi_colors = terminal
  endif
endfunction

function! user#colorscheme#colorscheme(colorscheme) abort
  if empty(g:colorscheme_list)
    return
  endif
  if a:colorscheme ==# 'random'
    call user#colorscheme#random()
    return
  endif
  let g:current_colorscheme = a:colorscheme
  let g:lightline.colorscheme = user#colorscheme#lightline()
  autocmd! user ColorScheme
  execute 'autocmd user ColorScheme' a:colorscheme
        \ printf('call user#colorscheme#set_customize("%s")', a:colorscheme)
  execute 'colorscheme' a:colorscheme
  call lightline#init()
  call lightline#colorscheme()
endfunction

function! user#colorscheme#completion(ArgLead, CmdLine, CursorPos) abort
  return filter(copy(g:colorscheme_list), {_, val -> val =~? a:ArgLead})
endfunction

