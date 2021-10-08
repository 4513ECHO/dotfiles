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
  let g:current_colorscheme =  get(g:colorscheme_list, (rand() % len(g:colorscheme_list)))
  let g:lightline['colorscheme'] = user#colorscheme#lightline()
  call user#colorscheme#{g:current_colorscheme}()
  call lightline#init()
  call lightline#colorscheme()
  return g:current_colorscheme
endfunction

function! user#colorscheme#jellybeans() abort
  colorscheme jellybeans
endfunction

function! user#colorscheme#iceberg() abort
  colorscheme iceberg
  hi String ctermfg=144 guifg=#a7b1a9
endfunction

function! user#colorscheme#gruvbox() abort
  colorscheme gruvbox
  hi Visual cterm=NONE ctermbg=239 gui=NONE guibg=#565656
endfunction

function! user#colorscheme#one() abort
  colorscheme one
endfunction

function! user#colorscheme#hybrid() abort
  colorscheme hybrid
endfunction

function! user#colorscheme#onedark() abort
  colorscheme onedark
endfunction

function! user#colorscheme#nord() abort
  colorscheme nord
endfunction

function! user#colorscheme#tokyonight() abort
  colorscheme tokyonight
endfunction

function! user#colorscheme#falcon() abort
  colorscheme falcon
endfunction

function! user#colorscheme#snow() abort
  colorscheme snow
endfunction

function! user#colorscheme#hydrangea() abort
  colorscheme hydrangea
endfunction
