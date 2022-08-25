let s:lightline_ignore_filetypes = ['help', 'ddu-ff', 'ddu-ff-filter', 'molder']

function! s:statuswidth() abort
  return &laststatus > 2 ? &columns : winwidth(0)
endfunction

function! lightline#component#vimrc#colorscheme() abort
  return s:statuswidth() > 70 ? g:current_colorscheme : ''
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
    let filename = fnamemodify(bufname(), ':t')
    return empty(filename) ? '[No name]' : filename
  endif
  return ''
endfunction

" from https://github.com/thinca/config/blob/4b02d5abcb/dotfiles/dot.vim/vimrc#L2263
let s:skkeleton_modes = {
      \ 'hira': 'あ',
      \ 'kata': 'ア',
      \ 'hankata': 'ｧｱ',
      \ 'zenkaku': 'ａ',
      \ 'abbrev': '/a',
      \ }

function! lightline#component#vimrc#mode() abort
  if !empty(submode#current())
    let mode = ['Sub', submode#current()]
  elseif exists('*skkeleton#is_enabled') && skkeleton#is_enabled()
    let skk_mode = skkeleton#mode()
    let mode = [lightline#mode(), get(s:skkeleton_modes, skk_mode, skk_mode)]
  else
    let mode = [lightline#mode()]
  endif
  return s:statuswidth() > 70 ? (
        \ !empty(get(mode, 1))
        \ ? printf('%s[%s]', mode[0], mode[1])
        \ : mode[0]
        \ ) : strcharpart(get(mode, 1, mode[0]), 0, 1)
endfunction

function! lightline#component#vimrc#readonly() abort
  return index(s:lightline_ignore_filetypes, &filetype) >= 0 ? ''
        \ : &readonly ? 'RO' : ''
endfunction

function! lightline#component#vimrc#modified() abort
  return index(s:lightline_ignore_filetypes, &filetype) >= 0 ? ''
        \ : &modified ? '+'
        \ : &modifiable ? '' : '-'
endfunction

function! s:get_ddu_status() abort
  let winid = &filetype =~# 'filter'
        \ ? get(g:, 'ddu#ui#ff#_filter_parent_winid', 0)
        \ : win_getid()
  let [_, winnr] = win_id2tabwin(winid)
  let status = getwinvar(winnr, 'ddu_ui_ff_status', {})
  return [winid, winnr, status]
endfunction

function! lightline#component#vimrc#ddu() abort
  let [winid, _, status] = s:get_ddu_status()
  if empty(status) || &filetype !~# 'ddu'
    return ''
  endif
  return trim(printf('[ddu-%s] %d/%d/%d %s',
        \ status.name,
        \ line('.', winid), line('$', winid), status.maxItems,
        \ status.done ? '' : '[async]'))
endfunction

function! lightline#component#vimrc#protocol() abort
  return bufname() =~# '^\a\+://' && s:statuswidth() > 70
        \ ? printf('(%s)', matchstr(bufname(), '^\a\+\ze://')) : ''
endfunction
