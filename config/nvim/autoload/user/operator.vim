let s:replacers = {}
let s:wise_to_type = #{
      \ char: 'v',
      \ line: 'V',
      \ block: "\<C-v>",
      \ }

function! s:operatorfunc(replacer, wise) abort
  let [pos1, pos2] = [getpos("'["), getpos("']")]
  let opts = #{ type: s:wise_to_type[a:wise] }
  for [start_pos, end_pos] in getregionpos(getpos("'["), getpos("']"), opts)
    if start_pos[2] ==# 0
      " Skip empty line
      continue
    endif
    let [text] = getregion(start_pos, end_pos, opts)
    if a:wise ==# 'line' || start_pos[2] ==# 1 && end_pos[2] ==# col('$') - 1
      call setline(start_pos[1], a:replacer(text))
    else
      execute $'normal! {start_pos[1]}G{start_pos[2]}|v{end_pos[1]}G{end_pos[2]}|"_c'
            \ .. a:replacer(text)
    endif
  endfor
endfunction

function! s:prepare(lhs) abort
  let &operatorfunc = function('s:operatorfunc', [s:replacers[a:lhs]])
endfunction

function! user#operator#define(lhs, replacer, options = {}) abort
  let s:replacers[a:lhs] = a:replacer
  let buffer = a:options->get('buffer') ? '<buffer>' : ''
  execute 'nnoremap' buffer a:lhs $'<Cmd>call <SID>prepare({string(a:lhs)})<CR>g@'
  execute 'xnoremap' buffer a:lhs $'<Cmd>call <SID>prepare({string(a:lhs)})<CR>g@'
  execute 'onoremap' buffer a:lhs 'g@'
endfunction
