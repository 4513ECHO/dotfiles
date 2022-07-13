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
  setlocal noswapfile buftype=nofile
  setlocal modifiable nomodified readonly
  let b:undo_ftplugin = 'setlocal list number synmaxcol<'
  if exists(':AnsiEsc') == 2
    autocmd vimrc VimEnter *
          \ : execute 'AnsiEsc'
          \ | silent! keepjump keeppatterns
          \ | %substitute/\v\e\[%(%(\d+;)?\d{1,2})?[mK]//ge
          \ | filetype detect
  else
    silent! keepjump keeppatterns %substitute/\v\e\[%(%(\d+;)?\d{1,2})?[mK]//ge
    filetype detect
  endif
  normal! gg
endfunction

function! user#google(query) abort
  let cmd = ['w3m', printf('https://google.com/search?q=%s', a:query)]
  if has('nvim')
    new
    call termopen(cmd)
  else
    call term_start(cmd, {'term_finish': 'close'})
  endif
endfunction

function! user#auto_mkdir(dir, force) abort
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir))
        \ =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
