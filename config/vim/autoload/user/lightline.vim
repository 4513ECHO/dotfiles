function! user#lightline#colorscheme() abort
  return winwidth(0) > 70 ? g:current_colorscheme : ''
endfunction

function! user#lightline#file_format() abort
  if &fileformat !=# 'unix'
    return winwidth(0) > 70 ? &fileformat : ''
  else
    return ''
  endif
endfunction

function! user#lightline#file_encoding() abort
  if &fileencoding !=# 'utf-8'
    return winwidth(0) > 70 ? &fileencoding : ''
  else
    return ''
  endif
endfunction

function! user#lightline#mode() abort
  if empty(submode#current())
    return lightline#mode()
  else
    return 'SUB:' .. submode#current()
  endif
endfunction
