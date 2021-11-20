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

function! user#google(word) abort
  execute 'terminal' '++close' '++shell' 'w3m'
        \ printf('"https://google.com/search?q=%s"', a:word)
endfunction

function! user#deno_run(no_check) abort
  execute 'terminal ++close deno'
        \ (expand('%:t') =~
        \   '^\(.*[._]\)\?test\.\(ts\|tsx\|js\|mjs\|jsx\)$' ?
        \   'test' : 'run')
        \ '--allow-all --unstable --watch'
        \ ((a:no_check) ? '--no-check' : '')
        \ expand('%:p')
  resize 20
  stopinsert
  normal! G
  setlocal bufhidden=wipe
  wincmd j
endfunction

function! user#startuptime() abort
  let g:startuptime = reltime(g:startuptime)
  redraw
  echomsg printf('startuptime: %fms', reltimefloat(g:startuptime) * 1000)
endfunction

function! user#pager() abort
  setlocal noswapfile buftype=nofile bufhidden=hide
  setlocal modifiable nomodified readonly
  if exists(':AnsiEsc') == 2
    autocmd user ColorScheme <buffer> ++once AnsiEsc
    autocmd user ColorScheme <buffer> silent! keepjump keeppatterns
          \ %substitute/\v^\s+(\e\[%(%(\d;)?\d{1,2})?[mK])*$//ge
  else
    silent! keepjump keeppatterns %substitute/\v\e\[%(%(\d;)?\d{1,2})?[mK]//ge
  endif
  nnoremap <buffer> q <C-w>q
endfunction

let s:cursorline_lock = 0
function! user#auto_cursorline(event) abort
  if a:event ==? 'WinEnter'
    setlocal cursorline
    let s:cursorline_lock = 2
  elseif a:event ==? 'WinLeave'
    setlocal nocursorline
  elseif a:event ==? 'CursorMoved'
    if s:cursorline_lock
      if 1 < s:cursorline_lock
        let s:cursorline_lock = 1
      else
        setlocal nocursorline
        let s:cursorline_lock = 0
      endif
    endif
  elseif a:event ==? 'CursorHold'
    setlocal cursorline
    let s:cursorline_lock = 1
  endif
endfunction

function! user#auto_mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir))
        \ =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

