let s:lightline_ignore_filetypes = ['ddu-ff', 'ddu-ff-filter', 'molder']

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
        \ : &filetype ==# 'help' && &buftype ==# 'help' ? ''
        \ : &readonly ? 'RO' : ''
endfunction

function! lightline#component#vimrc#modified() abort
  return index(s:lightline_ignore_filetypes, &filetype) > -1 ? ''
        \ : &filetype ==# 'help' && &buftype ==# 'help' ? ''
        \ : &modified ? '+'
        \ : &modifiable ? '' : '-'
endfunction

function! lightline#component#vimrc#protocol() abort
  return bufname() =~# '^\a\+://' && s:statuswidth() > 70
        \ ? bufname()->matchstr('^\a\+\ze://')->printf('(%s)') : ''
endfunction

function! lightline#component#vimrc#tabname(tabpagenr) abort
  let buflist = tabpagebuflist(a:tabpagenr)
  let bufnr = buflist[tabpagewinnr(a:tabpagenr) - 1]
  let fname = expand($'#{bufnr}:p')
  let cwd = getcwd(-1, a:tabpagenr)
  return buflist->len() > 1 || fname->stridx(cwd) ==# 0
        \ || bufnr->getbufvar('&filetype') ==# 'molder'
        \ ? cwd->fnamemodify(':t')
        \ : fname->fnamemodify(':t') ?? '[No name]'
endfunction
