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
  autocmd user ColorScheme <buffer> hi link helpBar Special
  autocmd user ColorScheme <buffer> hi link helpBacktick Special
  autocmd user ColorScheme <buffer> hi link helpStar Special
  autocmd user ColorScheme <buffer> hi link helpIgnore Special
endif

nnoremap <buffer> q <Nop>
inoremap <silent><expr> <Leader>= repeat('=', &textwidth)
inoremap <silent><expr> <Leader>- repeat('-', &textwidth)


