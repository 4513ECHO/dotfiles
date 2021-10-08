function! user#lightline#colorscheme() abort
  return winwidth(0) > 70 ?  g:current_colorscheme : ''
endfunction

function! user#lightline#file_format() abort
  return winwidth(0) > 70 ? (&fileformat !=# 'unix' ? &fileformat : '') : ''
endfunction

function! user#lightline#file_encoding() abort
  return winwidth(0) > 70 ? (&fileencoding !=# 'utf-8' ? &fileencoding : '') : ''
endfunction
