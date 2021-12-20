function! user#colorscheme#lightline() abort
  if g:current_colorscheme ==# 'random'
    return 'default'
  endif
  let custom_name = get(get(g:colorscheme_customize,
        \ g:current_colorscheme, {}), 'lightline')
  if !empty(custom_name)
    return custom_name
  endif
  return g:current_colorscheme
endfunction

function! s:colorscheme_list() abort
  let keys = keys(g:colorscheme_customize)
  if has_key(g:colorscheme_customize, '_')
    call filter(keys, { _, val -> val !~# '_' })
  endif
  return extend(keys, g:colorscheme_list, 'keep')
endfunction

function! user#colorscheme#random() abort
  if has('nvim')
    let randint = str2nr(matchstr(reltimestr(reltime()),
          \ '\.\@<=\d\+')[1:])
  else
    let randint = rand()
  endif
  call user#colorscheme#colorscheme(
        \ get(s:colorscheme_list(), randint % len(s:colorscheme_list())))
endfunction

function! user#colorscheme#set_customize(colorscheme) abort
  if a:colorscheme !=# '_'
    call user#colorscheme#set_customize('_')
  endif
  let customize = get(g:colorscheme_customize, a:colorscheme)
  if empty(customize)
    return
  endif
  let highlight = get(customize, 'highlight')
  if !empty(highlight)
    " TODO: use hiset() if exists
    for [group, attr] in items(highlight)
      let attrs = ''
      for [name, value] in items(attr)
        let attrs ..= printf('%s=%s ', name, value)
      endfor
      execute 'hi' group attrs
    endfor
  endif
  " TODO: edit v:colornames if exists
  let terminal = get(customize, 'terminal')
  if !empty(terminal)
    let g:terminal_ansi_colors = terminal
  endif
  let link = get(customize, 'link')
  if !empty(link)
    for [linked, base] in items(link)
      execute 'hi link' linked base
    endfor
  endif
endfunction

function! user#colorscheme#colorscheme(colorscheme) abort
  if empty(s:colorscheme_list())
    return
  endif
  let g:current_colorscheme = a:colorscheme
  if a:colorscheme ==# 'random'
    call user#colorscheme#random()
    return
  endif
  autocmd! random_colorscheme ColorScheme
  execute 'autocmd random_colorscheme ColorScheme' a:colorscheme
        \ printf('call user#colorscheme#set_customize("%s")', a:colorscheme)
  silent! unlet g:terminal_ansi_colors
  execute 'colorscheme' a:colorscheme
  " NOTE: `:help lightline-problem-13`
  let g:lightline.colorscheme = user#colorscheme#lightline()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

function! user#colorscheme#completion(ArgLead, CmdLine, CursorPos) abort
  if exists('?matchfuzzy')
    if empty(a:ArgLead)
      return sort(copy(s:colorscheme_list()))
    else
      return matchfuzzy(copy(s:colorscheme_list()), a:ArgLead)
    endif
  else
    return filter(copy(s:colorscheme_list()), {_, val -> val =~? a:ArgLead})
  endif
endfunction

" NOTE: it is require vim v8.2.3578 or later.
function! user#colorscheme#hl_compile() abort
  let result = []
  let ignored_hlgroup = [
        \ 'cssColor', 'perl', 'php', 'purescript', 'netrw', 'molder',
        \ 'Lightline', 'ALE', 'NERDTree', 'agit', 'QuickScope', 'Quickmenu',
        \ 'WhichKey', 'BufTabLine', 'Startify', 'Signature', 'IndentGuide',
        \ 'hitspop', 'Dirvish', 'Signify', 'Vista', 'Tagbar', 'Vimwiki',
        \ 'CtrlP', 'denite', 'Lf_hl', 'Syntastic', 'Neomake', 'Coc', 'plug',
        \ 'Fern', 'cmakeKW', 'haskell', 'scala', 'moon', 'java', 'xml',
        \ 'pandoc', 'Sneak', 'EasyMotion', 'scss', 'sass', 'cpp', 'cucumber',
        \ ]
  let default_links = {
        \ 'String': 'Constant',
        \ 'Character': 'Constant',
        \ 'Number': 'Constant',
        \ 'Boolean': 'Constant',
        \ 'Float': 'Number',
        \ 'Function': 'Identifier',
        \ 'Conditional': 'Statement',
        \ 'Repeat': 'Statement',
        \ 'Label': 'Statement',
        \ 'Operator': 'Statement',
        \ 'Keyword': 'Statement',
        \ 'Exception': 'Statement',
        \ 'Include': 'PreProc',
        \ 'Define': 'PreProc',
        \ 'Macro': 'PreProc',
        \ 'PreCondit': 'PreProc',
        \ 'StorageClass': 'Type',
        \ 'Structure': 'Type',
        \ 'Typedef': 'Type',
        \ 'SpecialChar': 'Special',
        \ 'Tag': 'Special',
        \ 'Delimiter': 'Special',
        \ 'SpecialComment': 'Special',
        \ 'Debug': 'Special',
        \ }
  for entry in hlget()
    if get(entry, 'cleared', v:false) | continue |  endif
    if match(entry.name, join(ignored_hlgroup, '\|')) != -1 | continue | endif
    let cmd = ['hi']
    if !empty(get(entry, 'linksto'))
      if get(default_links, entry.name, '') ==# entry.linksto
        continue
      endif
      if get(entry, 'default', v:false)
        call extend(cmd, ['def', 'link', entry.name, entry.linksto])
      else
        call extend(cmd, ['link', entry.name, entry.linksto])
      endif
      call add(result, join(cmd))
      continue
    endif
    call add(cmd, entry.name)
    let attrs = [
          \ 'cterm', 'ctermbg', 'ctermfg',
          \ 'font', 'gui', 'guibg', 'guifg', 'guisp',
          \ 'start', 'stop', 'term'
          \ ]
    for attr in attrs
      if !empty(get(entry, attr))
        if type(entry[attr]) == v:t_dict
          let value = join(keys(entry[attr]), ',')
        else
          let value = entry[attr]
        endif
        call add(cmd, printf('%s=%s', attr, value))
      endif
    endfor
    call add(result, join(cmd))
  endfor
  return result
endfunction

function! user#colorscheme#compile() abort
  let cmds = user#colorscheme#hl_compile()
  let header = [
        \ 'hi clear',
        \ 'if exists(''syntax_on'')',
        \ '  sy reset',
        \ 'end',
        \ 'let g:colors_name = ' .. string(g:colors_name),
        \ ]
  let result = extend(header, cmds)
  let file = printf('%s/colors/%s.vim', g:config_home, g:colors_name)
  if !filereadable(file)
    call writefile(result, file)
  endif
  return join(result, "\n")
endfunction

