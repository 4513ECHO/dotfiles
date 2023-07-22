let s:lightline_ignore_filetypes = ['help', 'ddu-ff', 'ddu-ff-filter', 'molder']

let s:statuswidth = { -> &laststatus > 2 ? &columns : winwidth(0) }

function! lightline#component#vimrc#colorscheme() abort
  return s:statuswidth() > 70 ? g:colors_name : ''
endfunction

function! lightline#component#vimrc#file_format() abort
  return &fileformat !=# 'unix' && s:statuswidth() > 70
        \ ? &fileformat : ''
endfunction

function! lightline#component#vimrc#file_encoding() abort
  return &fileencoding !=# 'utf-8' && s:statuswidth() > 70
        \ ? &fileencoding : ''
endfunction

function! lightline#component#vimrc#filename() abort
  if &filetype =~# '^ddu'
    return ''
  elseif s:statuswidth() > 50
    return bufname()->fnamemodify(':t') ?? '[No name]'
  endif
  return ''
endfunction

" from https://github.com/thinca/config/blob/4b02d5ab/dotfiles/dot.vim/vimrc#L2263
let s:skkeleton_modes = #{
      \ hira: 'あ',
      \ kata: 'ア',
      \ hankata: 'ｧｱ',
      \ zenkaku: 'ａ',
      \ abbrev: '/a',
      \ }

function! lightline#component#vimrc#mode() abort
  if exists('*submode#current') && submode#current() !=# ''
    let mode = submode#current()
  elseif exists('*skkeleton#is_enabled') && skkeleton#is_enabled()
    let skk_mode = skkeleton#mode()
    let mode = s:skkeleton_modes->get(skk_mode, skk_mode)
  elseif b:->get('pinkyless_capslock', v:false)
    let mode = 'Capslock'
  else
    let mode = lightline#mode()
  endif
  return s:statuswidth() > 70 ? mode : mode->strcharpart(0, 1)
endfunction

function! lightline#component#vimrc#readonly() abort
  return index(s:lightline_ignore_filetypes, &filetype) > -1 ? ''
        \ : &readonly ? 'RO' : ''
endfunction

function! lightline#component#vimrc#modified() abort
  return index(s:lightline_ignore_filetypes, &filetype) > -1 ? ''
        \ : &modified ? '+'
        \ : &modifiable ? '' : '-'
endfunction

function! s:get_ddu_status() abort
  let winid = &filetype =~# 'filter'
        \ ? g:->get('ddu#ui#ff#_filter_parent_winid', 0)
        \ : win_getid()
  let winnr = win_id2win(winid)
  let status = winnr->getwinvar('ddu_ui_ff_status', {})
  return [winid, winnr, status]
endfunction

function! lightline#component#vimrc#ddu() abort
  let [winid, winnr, status] = s:get_ddu_status()
  if empty(status) || &filetype !~# 'ddu'
    return ''
  endif
  let [cur, avail, max] = [line('.', winid), line('$', winid), status.maxItems]
  if [cur, avail] + winbufnr(winnr)->getbufline(1) ==# [1, 1, '']
    let [cur, avail] = [0, 0]
  endif
  return ['[ddu-%s] %d/%d/%d %s',
        \ status.name, cur, avail, max, status.done ? '' : '[async]',
        \ ]->{ args -> call('printf', args) }()->trim()
endfunction

function! lightline#component#vimrc#protocol() abort
  return bufname() =~# '^\a\+://' && s:statuswidth() > 70
        \ ? bufname()->matchstr('^\a\+\ze://')->printf('(%s)') : ''
endfunction
