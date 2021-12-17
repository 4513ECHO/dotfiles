if &buftype ==# 'help'
  finish
endif

setlocal list tabstop=8 shiftwidth=8 softtabstop=8
setlocal noexpandtab textwidth=78

if exists('+colorcolumn')
  setlocal colorcolumn=+1
endif
if has('conceal')
  setlocal conceallevel=0
  hi link helpBar Special
  hi link helpBacktick Special
  hi link helpStar Special
  hi link helpIgnore Special
  autocmd user ColorScheme <buffer>
        \ : hi link helpBar Special
        \ | hi link helpBacktick Special
        \ | hi link helpStar Special
        \ | hi link helpIgnore Special
endif

nnoremap <buffer> q <Nop>
inoremap <silent><expr> <Leader>= repeat('=', &textwidth)
inoremap <silent><expr> <Leader>- repeat('-', &textwidth)
nnoremap <buffer> [Toggle]c <Cmd>call <SID>toggle_conceal()<CR>

function! s:toggle_conceal() abort
  if &conceallevel == 0
    setlocal conceallevel=3
  else
    setlocal conceallevel=0
  endif
  setlocal conceallevel?
endfunction
