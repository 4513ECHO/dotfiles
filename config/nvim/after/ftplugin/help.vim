" from https://thinca.hatenablog.com/entry/20110903/1314982646
if &buftype ==# 'help'
  finish
endif

setlocal list tabstop=8 shiftwidth=8 softtabstop=8
setlocal noexpandtab textwidth=78 colorcolumn=+1 conceallevel=0
if has('nvim')
  setlocal winhighlight=helpBar:Special,helpBacktick:Special,helpStar:Special,helpIgnore:Special
endif

nnoremap <buffer> q <Nop>
nnoremap <buffer> <CR> <CR>
inoremap <silent><expr> <Leader>= repeat('=', &textwidth)
inoremap <silent><expr> <Leader>- repeat('-', &textwidth)
nnoremap <buffer> [Toggle]c <Cmd>call <SID>toggle_conceal()<CR>

function! s:toggle_conceal() abort
  let &l:conceallevel = &l:conceallevel ? 0 : 3
  setlocal conceallevel?
endfunction
