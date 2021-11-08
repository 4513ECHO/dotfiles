function! user#colorscheme#lightline() abort
  if g:current_colorscheme ==# 'random'
    return 'default'
  elseif g:current_colorscheme ==# 'snow'
    return 'snow_dark'
  else
    return g:current_colorscheme
  endif
endfunction

function! user#colorscheme#random() abort
  let g:current_colorscheme =
        \ get(g:colorscheme_list, (rand() % len(g:colorscheme_list)))
  call user#colorscheme#colorscheme(g:current_colorscheme)
  return g:current_colorscheme
endfunction

let s:colorscheme_customize = #{
      \ iceberg: #{
      \   highlight: #{
      \     String: #{ ctermfg: 144, guifg: '#a7b1a9', },
      \ }},
      \ gruvbox: #{
      \   highlight: #{
      \     Visual: #{ ctermbg: 239, cterm: 'NONE', guibg: '#565656', gui: 'NONE', },
      \ }},
      \ hydrangea: #{
      \   highlight: #{
      \     Constant: #{ ctermbg: 'NONE', guibg: 'NONE',  },
      \     Number: #{ ctermbg: 'NONE', guibg: 'NONE',  },
      \     SpecialKey: #{ ctermbg: 'NONE', guibg: 'NONE',  },
      \ }},
      \ }

function! s:set_customize(colorscheme) abort
  let customize = get(s:colorscheme_customize, a:colorscheme)
  if empty(customize)
    return
  endif
  let highlight = get(customize, 'highlight')
  if !empty(highlight)
    for [group, attr] in items(l:highlight)
      let attrs = ''
      for [name, value] in items(attr)
        let attrs ..= printf('%s=%s ', name, value)
      endfor
      execute 'hi' group attrs
    endfor
  endif
  let term_ansi = get(customize, 'terminal')
  if !empty(term_ansi)
    let g:terminal_ansi_colors = term_ansi
  endif
endfunction

function! user#colorscheme#colorscheme(colorscheme) abort
  if empty(g:colorscheme_list)
    return 'default'
  endif
  if a:colorscheme ==# 'random'
    call user#colorscheme#random()
    return g:current_colorscheme
  endif
  let g:current_colorscheme = a:colorscheme
  let g:lightline['colorscheme'] = user#colorscheme#lightline()
  execute 'colorscheme' a:colorscheme
  call s:set_customize(a:colorscheme)
  call lightline#init()
  call lightline#colorscheme()
  return g:current_colorscheme
endfunction

function! user#colorscheme#completion(ArgLead, CmdLine, CursorPos) abort
  return filter(copy(g:colorscheme_list),
        \ {_, val -> val =~? a:ArgLead})
endfunction

