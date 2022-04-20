function! user#title_string() abort
  let f = expand('%:t')
  let d = pathshorten(expand('%:~:h'))
  let r = pathshorten(fnamemodify(getcwd(), ':~'))
  if &buftype ==# 'help'
    let [dir, file] = ['help', f]
  elseif &buftype ==# 'terminal'
    let [dir, file] = ['terminal', f]
  elseif &buftype ==# 'nofile'
    if &filetype ==# 'molder'
      let [dir, file] = [d, f]
    else
      let [dir, file] = [r, bufname()]
    endif
  elseif &buftype ==# 'quickfix'
    let [dir, file] = [r, 'QuickFix']
  else
    let [dir, file] = [(!empty(d) ? d : r), f]
  endif
  return printf('%s (%s) - %s', file, dir, toupper(v:progname))
endfunction

function! user#pager() abort
  setlocal nolist nonumber synmaxcol&
  if index(v:argv, '+MANPAGER') != -1
    return
  endif
  setlocal noswapfile buftype=nofile bufhidden=hide
  setlocal modifiable nomodified readonly
  if exists(':AnsiEsc') == 2
    autocmd vimrc VimEnter * ++once
          \ : execute 'AnsiEsc'
          \ | silent! keepjump keeppatterns
          \ | %substitute/\v\e\[%(%(\d+;)?\d{1,2})?[mK]//ge
          \ | filetype detect
  else
    silent! keepjump keeppatterns %substitute/\v\e\[%(%(\d+;)?\d{1,2})?[mK]//ge
    filetype detect
  endif
  nnoremap <buffer> q <C-w>q
  normal! gg
endfunction

function! user#google(word) abort
  execute 'terminal' '++close' '++shell' 'w3m'
        \ printf('"https://google.com/search?q=%s"', a:word)
endfunction

function! user#deno_run(no_check) abort
  if &filetype !~# 'typescript'
    echoerr 'Execute this command in typescript file buffer'
    return
  endif
  let subcmd =  expand('%:t') =~# '\v^(.*[._])?test\.(ts|tsx|js|jsx|mjs|jsx)$'
        \ ? 'test': 'run'
  let opts = '--allow-all --unstable --watch'
  if a:no_check
    let opts ..= ' --no-check'
  endif
  execute 'topleft terminal ++close ++rows=12'
        \ 'deno' subcmd opts expand('%:p')
  setlocal bufhidden=wipe
  wincmd j
endfunction

function! user#auto_mkdir(dir, force) abort
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir))
        \ =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

function! user#notify(msg, ...) abort
  let title = get(a:000, 0, '')
  if has('nvim')
    if dein#util#_luacheck('notify')
      call luaeval('require("notify")(_A.msg, "info",'
            \ .. '{ title=_A.title })',
            \ { 'msg': a:msg, 'title': title })
    else
      call nvim_notify(a:msg, 1, {})
    endif
  else
    if dein#is_available('vim-notification') || exists('g:loaded_notification')
      call notification#show({
            \ 'text': a:msg,
            \ 'title': title,
            \ })
    else
      call popup_notification(a:msg, {
            \ 'title': title,
            \ })
    endif
  endif
endfunction
