function! user#lightline#colorscheme() abort
  return winwidth(0) > 70 ? g:current_colorscheme : ''
endfunction

function! user#lightline#file_format() abort
  if &fileformat !=# 'unix' && winwidth(0) > 70
    return &fileformat
  endif
  return ''
endfunction

function! user#lightline#file_encoding() abort
  if &fileencoding !=# 'utf-8' && winwidth(0) > 70
    return &fileencoding
  endif
  return ''
endfunction

function! user#lightline#mode() abort
  if !empty(submode#current())
    return 'SUB:' .. submode#current()
  elseif get(b:, 'skkeleton_enabled', v:false) && !empty(skkeleton#mode())
    " TODO: make skkeleton modes table
    return printf('%s(%s)', lightline#mode(), skkeleton#mode())
  endif
  return lightline#mode()
endfunction

function! user#lightline#char_counter() abort
  if get(b:, 'skkeleton_enabled', v:false) && winwidth(0) > 70
    let wordcount = wordcount()
    if has_key(wordcount, 'visual_chars')
      return wordcount.visual_chars .. 'C'
    endif
    return wordcount.chars .. 'C'
  endif
  return ''
endfunction

function! user#lightline#readonly() abort
  if &readonly && &filetype !~# 'help' && winwidth(0) > 70
    return 'RO'
  endif
  return ''
endfunction
