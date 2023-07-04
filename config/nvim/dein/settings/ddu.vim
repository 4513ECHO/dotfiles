function! s:colorscheme() abort
  " NOTE: eob of 'fillchars' is annoying
  let bgcolor = nvim_get_hl(0, #{ name: 'Normal' })
        \ ->get('bg', 0x000000)
        \ ->printf('#%06x')
  call nvim_set_hl(0, 'DduEndOfBuffer', #{
        \ foreground: bgcolor,
        \ background: bgcolor,
        \ default: v:true,
        \ })
endfunction

if has('nvim')
  autocmd vimrc ColorScheme * call s:colorscheme()
  call s:colorscheme()
endif

call ddu#custom#load_config(expand('$DEIN_DIR/settings/ddu.ts'))
