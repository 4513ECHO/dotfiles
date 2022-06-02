let s:lightline_ignore_filetypes = ['help', 'ddu-ff', 'ddu-ff-filter', 'molder']

function! user#lightline#colorscheme() abort
  return winwidth(0) > 70 ? g:current_colorscheme : ''
endfunction

function! user#lightline#file_format() abort
  return &fileformat !=# 'unix' && winwidth(0) > 70
        \ ? &fileformat : ''
endfunction

function! user#lightline#file_encoding() abort
  return &fileencoding !=# 'utf-8' && winwidth(0) > 70
        \ ? &fileencoding : ''
endfunction

function! user#lightline#filename() abort
  if &filetype =~# '^ddu'
    return ''
  elseif winwidth(0) > 50
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

function! user#lightline#mode() abort
  if !empty(submode#current())
    let mode = ['Sub', submode#current()]
  elseif skkeleton#is_enabled()
    let skk_mode = skkeleton#mode()
    let mode = [lightline#mode(), get(s:skkeleton_modes, skk_mode, skk_mode)]
  else
    let mode = [lightline#mode()]
  endif
  return winwidth(0) > 70 ? (
        \ !empty(get(mode, 1))
        \ ? printf('%s[%s]', mode[0], mode[1])
        \ : mode[0]
        \ ) : strcharpart(get(mode, 1, mode[0]), 0, 1)
endfunction

function! user#lightline#readonly() abort
  return index(s:lightline_ignore_filetypes, &filetype) >= 0 ? ''
        \ : &readonly ? 'RO' : ''
endfunction

function! user#lightline#modified() abort
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

function! user#lightline#ddu() abort
  let [winid, _, status] = s:get_ddu_status()
  if empty(status) || &filetype !~# 'ddu'
    return ''
  endif
  return trim(printf('[ddu-%s] %d/%d/%d %s',
        \ status.name,
        \ line('.', winid), line('$', winid), status.maxItems,
        \ status.done ? '' : '[async]'))
endfunction
