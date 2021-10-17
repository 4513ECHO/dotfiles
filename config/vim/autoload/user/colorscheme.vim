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
      \     String: #{ ctermfg: 144, guifg: 0xa7ba9, },
      \ }},
      \ gruvbox: #{
      \   highlight: #{
      \     Visual: #{ ctermbg: 239, cterm: 'NONE', guibg: 0x565656, gui: 'NONE', },
      \ }},
      \ }

function! s:get_customize(colorscheme) abort
  let customize = get(s:colorscheme_customize, a:colorscheme)
  if !customize | return | endif
  let highlight = get(customize, 'highlight')
  if !empty(highlight)
    for [group, attr] in items(l:highlight)
      execute 'hi' group
    endfor
  endif
  let term_ansi = get(customize, 'terminal')
  if !empty(term_ansi)
    let g:terminal_ansi_colors = term_ansi
  endif
endfunction

function! user#colorscheme#colorscheme(colorscheme) abort
  if a:colorscheme ==# 'random'
    call user#colorscheme#random()
    return g:current_colorscheme
  endif
  let g:current_colorscheme = a:colorscheme
  let g:lightline['colorscheme'] = user#colorscheme#lightline()
  execute 'colorscheme' a:colorscheme

  " customize
  if a:colorscheme ==# 'iceberg'
    hi String ctermfg=144 guifg=#a7b1a9
  elseif a:colorscheme ==# 'gruvbox'
    hi Visual cterm=NONE ctermbg=239 gui=NONE guibg=#565656
  " elseif a:colorscheme ==# 'hydrangea'
  "   hi Constant
  "   hi Number
  endif

  call lightline#init()
  call lightline#colorscheme()
  return g:current_colorscheme
endfunction

