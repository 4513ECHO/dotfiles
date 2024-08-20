function! user#colorscheme#get() abort
  return g:->get('user#colorscheme#_colorschemes', {})
endfunction

function! user#colorscheme#lightline() abort
  return g:colors_name ==# 'random' ? 'default'
        \ : user#colorscheme#get()
        \   ->get(g:colors_name, {})
        \   ->get('lightline', g:colors_name)
endfunction

function! user#colorscheme#random() abort
  let list = user#colorscheme#get()->keys()
  return list->get(rand() % list->len())
        \ ->user#colorscheme#command()
endfunction

function! user#colorscheme#set_customize() abort
  let customize = user#colorscheme#get()->get(g:colors_name)
  if empty(customize)
    return
  endif
  let highlight = customize->get('highlight')
  if !empty(highlight)
    " TODO: use hlset() or nvim_set_hl()
    for [group, attr] in items(highlight)
      let attrs = ''
      for [name, value] in items(attr)
        let attrs ..= $'{name}={value} '
      endfor
      execute 'hi' group attrs
    endfor
  endif
  " TODO: edit v:colornames if exists
  let terminal = customize->get('terminal')
  if !empty(terminal)
    call s:set_terminal_colors(
          \ terminal is# 'mini' ? [
          \   '#1d1f21', '#cc6666', '#b5bd68', '#f0c674', '#81a2be', '#b294bb', '#8abeb7', '#d3d7cf',
          \   '#707880', '#cc6666', '#b5bd68', '#de955f', '#729fcf', '#b294bb', '#005f5f', '#707880',
          \ ]
          \ : terminal
          \ )
  elseif !has('nvim') && exists('g:terminal_color_0')
    let g:terminal_ansi_colors = range(16)
          \ ->map({ -> g:->get($'terminal_color_{v:val}', '#000000') })
  elseif has('nvim') && exists('g:terminal_ansi_colors')
    for i in range(16)
      let g:terminal_color_{i} = g:terminal_ansi_colors[i]
    endfor
  endif
  let link = customize->get('link')
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

function! user#colorscheme#command(colorscheme, reload = v:false) abort
  if empty(user#colorscheme#get())
    return
  endif
  let colorscheme = a:reload ? g:colors_name : a:colorscheme
  if empty(colorscheme) && !a:reload
    echo g:colors_name
    return
  endif
  if colorscheme ==# 'random'
    return user#colorscheme#random()
  endif
  " NOTE: Use :silent to ignore W18
  execute 'silent colorscheme' colorscheme
  if !has('nvim')
    " Reload syntax for typescript-vim
    let &l:syntax = &l:syntax
  endif
endfunction

function! user#colorscheme#update_lightline() abort
  if !exists('g:lightline')
    return
  endif
  " NOTE: See `:help lightline-problem-13`
  let name = user#colorscheme#lightline()
  let g:lightline.colorscheme = name
  " NOTE: Reload colorscheme file to support 'background' change
  execute $'runtime autoload/lightline/colorscheme/{name}.vim'
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! user#colorscheme#completion(...) abort
  return user#colorscheme#get()->keys()->sort()->join("\n")
endfunction
