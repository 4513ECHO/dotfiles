function! s:get_syn_id(transparent) abort
  let synid = synID(line('.'), col('.'), v:true)
  return a:transparent ? synIDtrans(synid) : synid
endfunction

function! s:get_syn_attr(synid) abort
  let name = synIDattr(a:synid, 'name')
  let ctermfg = synIDattr(a:synid, 'fg', 'cterm')
  let ctermbg = synIDattr(a:synid, 'bg', 'cterm')
  let guifg = synIDattr(a:synid, 'fg', 'gui')
  let guibg = synIDattr(a:synid, 'bg', 'gui')
  return {'name': name,
        \ 'ctermfg': ctermfg,
        \ 'ctermbg': ctermbg,
        \ 'guifg': guifg,
        \ 'guibg': guibg
        \ }
endfunction

function! s:return_var(dict, name) abort
  return a:dict[a:name] != ''
        \ ? ' ' .. a:name .. ': ' .. a:dict[a:name]
        \ : ''
endfunction

function! s:get_syn_info() abort
  let baseSyn = s:get_syn_attr(s:get_syn_id(v:false))
  let base_result = baseSyn['name'] ..
        \ s:return_var(baseSyn, 'ctermfg') ..
        \ s:return_var(baseSyn, 'ctermbg') ..
        \ s:return_var(baseSyn, 'guifg') ..
        \ s:return_var(baseSyn, 'guibg')
  let linkedSyn = s:get_syn_attr(s:get_syn_id(v:true))
  let linked_result = linkedSyn.name ..
        \ s:return_var(linkedSyn, 'ctermfg') ..
        \ s:return_var(linkedSyn, 'ctermbg') ..
        \ s:return_var(linkedSyn, 'guifg') ..
        \ s:return_var(linkedSyn, 'guibg')
  return base_result .. (linked_result != '' ? ' -> ' .. linked_result : '')
endfunction

function! user#syntax_info() abort
  echo s:get_syn_info()
endfunction

function! user#set_filetype(pattern, filetype) abort
  execute 'autocmd user BufRead,BufNewFile' a:pattern 'setfiletype' a:filetype
endfunction

function! user#remember_cursor() abort
  if line("'\"") > 1 && line("'\"") <= line('$')
    execute "normal! g`\""
  endif
endfunction
