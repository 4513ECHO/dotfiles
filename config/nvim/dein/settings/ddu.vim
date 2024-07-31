" hook_add {{{
let g:launcher_config.ddu = #{
      \ char: 'd',
      \ run: { -> ddu#start(#{ sources: [#{ name: 'source' }] }) },
      \ }
nnoremap <Leader>d <Cmd>Ddu -resume<CR>
inoremap <C-x><C-e> <Cmd>call ddu#start(#{
      \ sources: [
      \   #{ name: 'emoji', options: #{ defaultAction: 'feedkeys' } },
      \ ],
      \ uiParams: #{
      \   ff: #{ replaceCol: col('.') },
      \ },
      \ })<CR>

function! s:open_current_line_hunk() abort
  if !empty(&buftype)
    return
  endif
  autocmd vimrc User Ddu:uiDone ++once
        \ call ddu#ui#async_action('itemAction', #{ name: 'currentLine' })
  call ddu#start(#{
        \ name: 'git_diff_current',
        \ sourceOptions: #{ _: #{ path: expand('%:p') } },
        \ })
endfunction
nnoremap <Leader>gd <Cmd>call <SID>open_current_line_hunk()<CR>

call timer_start(10, { -> ddu#load('ui', ['ff']) })
" }}}

" hook_source {{{
autocmd vimrc User Ddu:ui:ff:openFilterWindow call s:on_ddu_ff_filter()
autocmd vimrc User Ddu:ui:ff:closeFilterWindow call ddu#ui#ff#restore_cmaps()
function! s:on_ddu_ff_filter() abort
  " NOTE: lexima defines mappings on CmdlineEnter only once, so if we start Ddu from keymap, we need to define <CR> manually
  if empty(maparg('<CR>', 'c'))
    cnoremap <expr> <CR> lexima#expand('<lt>CR>', ':')
  endif
  call ddu#ui#ff#save_cmaps(['<Esc>', '<CR>', '<C-n>', '<C-p>'])
  cnoremap <buffer> <Esc> <CR>
  cnoremap <buffer> <CR>  <CR><Cmd>call ddu#ui#do_action('itemAction')<CR>
  cnoremap <buffer> <C-n> <Cmd>call ddu#ui#multi_actions([
        \ ['cursorNext', #{ loop: v:true }],
        \ ['updateLightline'],
        \ ])<CR>
  cnoremap <buffer> <C-p> <Cmd>call ddu#ui#multi_actions([
        \ ['cursorPrevious', #{ loop: v:true }],
        \ ['updateLightline'],
        \ ])<CR>
  if has('nvim')
    call cmdline#enable()
  endif
endfunction

call ddu#custom#load_config(expand('$DEIN_DIR/settings/ddu.ts'))
" }}}

" hook_post_update {{{
call ddu#set_static_import_path()
echomsg '[ddu] ddu#set_static_import_path() called'
" }}}

" ddu-ff {{{
setlocal cursorline signcolumn=yes
autocmd vimrc-ddu ModeChanged <buffer>
      \ : if v:event.new_mode =~# '^[v\x16]'
      \ |   execute 'normal! V'
      \ | endif
nnoremap <buffer> <CR>
      \ <Cmd>call ddu#ui#do_action('itemAction')<CR>
nnoremap <buffer> <Space>
      \ <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
xnoremap <buffer><silent> <Space>
      \ :call ddu#ui#do_action('toggleSelectItem')<CR>
nnoremap <buffer> a
      \ <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
nnoremap <buffer> c
      \ <Cmd>call ddu#ui#do_action('clearSelectAllItems')<CR>
nnoremap <buffer> i
      \ <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
nnoremap <buffer> <Tab>
      \ <Cmd>call ddu#ui#do_action('chooseAction')<CR>
nnoremap <buffer> <C-l>
      \ <Cmd>call ddu#ui#do_action('redraw', #{ method: 'refreshItems' })<Bar>redraw<CR>
nnoremap <buffer> p
      \ <Cmd>call ddu#ui#do_action('togglePreview')<CR>
nnoremap <buffer> P
      \ <Cmd>call ddu#ui#do_action('toggleAutoAction')<CR>
nnoremap <buffer> q
      \ <Cmd>call ddu#ui#do_action('quit')<CR>
nnoremap <buffer> E
      \ <Cmd>call ddu#ui#do_action('itemAction',
      \ #{ params: eval(input('params: ', "#{}\<lt>Left>")) })<CR>
nnoremap <buffer> d
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'delete' })<CR>
nnoremap <buffer> W
      \ <Cmd>call ddu#ui#do_action('itemAction', #{ params:
      \ #{ command: 'call snipewin#select()<Bar>edit' } })<CR>
nnoremap <buffer> <
      \ <Cmd>call ddu#ui#do_action('collapseItem')<CR>
nnoremap <buffer> >
      \ <Cmd>call ddu#ui#do_action('expandItem', #{ mode: 'toggle' })<CR>
if b:ddu_ui_name ==# 'file_tree'
  nnoremap <buffer><expr> <CR>
        \ ddu#ui#get_item().isTree
        \   ? "<Cmd>call ddu#ui#do_action('expandItem', #{ mode: 'toggle' })<CR>"
        \   : "<Cmd>call ddu#ui#do_action('itemAction', #{ name: 'open' })<CR>"
elseif b:ddu_ui_name ==# 'git_diff_current'
  nnoremap <buffer> <C-@>
        \ <Cmd>call ddu#ui#do_action('itemAction', #{ name: 'currentHunk' })<CR>
endif
" }}}
