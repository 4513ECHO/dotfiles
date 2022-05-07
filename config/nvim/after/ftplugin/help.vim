" from https://thinca.hatenablog.com/entry/20110903/1314982646
if &buftype ==# 'help'
  finish
endif

setlocal list tabstop=8 shiftwidth=8 softtabstop=8
setlocal noexpandtab textwidth=78

function! s:set_highlight(group) abort
  for group in ['helpBar', 'helpBacktick', 'helpStar', 'helpIgnore']
    execute 'hi link' group a:group
  endfor
endfunction

if exists('+colorcolumn')
  setlocal colorcolumn=+1
endif
if has('conceal')
  setlocal conceallevel=0
  call s:set_highlight('Special')
  augroup vimrc_help
    autocmd!
    autocmd BufUnload <buffer>
          \ : call <SID>set_highlight('Ignore')
          \ | autocmd! vimrc_help
    autocmd ColorScheme * call <SID>set_highlight('Special')
  augroup END
endif

nnoremap <buffer> q <Nop>
nnoremap <buffer> <CR> <CR>
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
