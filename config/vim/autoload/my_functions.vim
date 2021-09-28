function! s:get_syn_id(transparent) abort
  let synid = synID(line("."), col("."), v:true)
  return a:transparent ? synIDtrans(synid) : synid
endfunction

function! s:get_syn_attr(synid) abort
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {"name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg
        \ }
endfunction

function! s:get_syn_info() abort
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  let base_result = baseSyn.name .
        \ (baseSyn.ctermfg != "" ? " ctermfg: " . baseSyn.ctermfg : "") .
        \ (baseSyn.ctermbg != "" ? " ctermbg: " . baseSyn.ctermbg : "") .
        \ (baseSyn.guifg != "" ? " guifg: " . baseSyn.guifg : "") .
        \ (baseSyn.guibg != "" ? " guibg: " . baseSyn.guibg : "")
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  let linked_result = linkedSyn.name .
        \ (linkedSyn.ctermfg != "" ? " ctermfg: " . linkedSyn.ctermfg : "") .
        \ (linkedSyn.ctermbg != "" ? " ctermbg: " . linkedSyn.ctermbg : "") .
        \ (linkedSyn.guifg != "" ? " guifg: " . linkedSyn.guifg : "") .
        \ (linkedSyn.guibg != "" ? " guibg: " . linkedSyn.guibg : "")
  return base_result . (linked_result != "" ? " -> " . linked_result : "")
endfunction

function! my_functions#syntax_info() abort
  echo s:get_syn_info()
endfunction

function! my_functions#has_deno() abort
  call system("deno")
  return v:shell_error == 0 ? v:true : v:false
endfunction

function! my_functions#set_filetype(pattern, filetype) abort
  execute 'autocmd vimrc BufRead,BufNewFile' a:pattern 'setfiletype' a:filetype
endfunction
