" from https://thinca.hatenablog.com/entry/20110903/1314982646
if &buftype ==# 'help'
  finish
endif

setlocal list tabstop=8 shiftwidth=8 softtabstop=8
setlocal noexpandtab textwidth=78 colorcolumn=+1 conceallevel=0
setlocal iskeyword+=- iskeyword+=# iskeyword+=:
if has('nvim')
  setlocal winhighlight=helpBar:Special,helpBacktick:Special,helpStar:Special,helpIgnore:Special
endif

nnoremap <buffer> q <Nop>
nnoremap <buffer> <CR> <CR>
inoremap <expr> <C-g>= repeat('=', &textwidth)
inoremap <expr> <C-g>- repeat('-', &textwidth)
nnoremap <buffer> [Toggle]c <Cmd>call <SID>toggle_conceal()<CR>

function! s:toggle_conceal() abort
  let &l:conceallevel = &l:conceallevel ? 0 : 3
  setlocal conceallevel?
endfunction

" based on https://github.com/Shougo/shougo-s-github/blob/553c4e3c/vim/rc/deinft.vim#L136
function! s:right_align(lnum) abort
  let m = a:lnum->getline()->matchlist('\v' .. [
        \ '^(\s*\S+%(\s\S+)?)?\s+(\*\S+\*)\s*$',
        \ '^(\*\S+\*)\s\s+(\S.+)\s*$']->join('|'))
  if empty(m)
    return
  endif
  let [m1, m2] = [m[1] ?? m[3], m[2] ?? m[4]]

  return (m1 .. repeat(' ', &l:textwidth - len(m1) - len(m2)) .. m2)
        \ ->setline(a:lnum)
endfunction
function! s:right_aligns(start, end) abort
  call range(a:start, a:end)->map({ _, lnum -> s:right_align(lnum) })
endfunction
command! -bar -buffer -range RightAlign
      \ call s:right_aligns(expand('<line1>'), expand('<line2>'))

nnoremap <buffer>         mm <Cmd>RightAlign<CR>
xnoremap <buffer><silent> mm :RightAlign<CR>
