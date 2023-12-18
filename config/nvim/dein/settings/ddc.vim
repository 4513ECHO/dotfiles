" hook_add {{{
nnoremap : :<Cmd>call ddc#enable_cmdline_completion()<CR>
xnoremap : :<Cmd>call ddc#enable_cmdline_completion()<CR>
autocmd vimrc User SearchxEnter call ddc#enable_cmdline_completion()
" }}}

" hook_source {{{
" based on https://github.com/kuuote/dotvim/blob/0e8dd6a4/conf/ddc.toml#L170
autocmd vimrc OptionSet buftype
      \ : if &buftype ==# 'acwrite' || bufname() ==# 'mininote'
      \ |   call ddc#custom#patch_buffer('specialBufferCompletion', v:true)
      \ | endif

" key mappings
inoremap <expr> <C-n> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Down>'
inoremap <expr> <C-p> pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Up>'
cnoremap <expr> <C-n> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Down>'
cnoremap <expr> <C-p> pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Up>'
cnoremap <expr> <Tab> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : ddc#map#manual_complete()

inoremap <expr> <C-e> pum#visible() ? '<Cmd>call pum#map#cancel()<CR>'  : user#is_at_end() ? '<C-e>' : '<End>'
inoremap <expr> <C-y> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<C-r>"'
cnoremap <expr> <C-e> pum#visible() ? '<Cmd>call pum#map#cancel()<CR>' : '<C-e>'
cnoremap <expr> <C-y> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<C-r>"'

" emulate default mappings (see `:help ins-completion`)
function! s:ddc_complete(...) abort
  return ddc#map#manual_complete(#{ sources: a:000 })
endfunction
inoremap <expr> <C-x><C-l> <SID>ddc_complete('line')
inoremap <expr> <C-x><C-n> <SID>ddc_complete('around')
inoremap <expr> <C-x><C-f> <SID>ddc_complete('file')
inoremap <expr> <C-x><C-d> <SID>ddc_complete('lsp')
inoremap <expr> <C-x><C-v> <SID>ddc_complete('cmdline')
inoremap <expr> <C-x><C-u> <SID>ddc_complete()
inoremap <expr> <C-x><C-o> <SID>ddc_complete('omni')
inoremap <expr> <C-x><C-s> <SID>ddc_complete('mocword')
inoremap <expr> <C-x><C-t> <SID>ddc_complete('tmux')

if bufname() =~# '^/tmp/\d\+\.md$'
  inoremap <buffer><expr> <C-x><C-g> <SID>ddc_complete('github_issue', 'github_pull_request')
endif

call ddc#custom#load_config(expand('$DEIN_DIR/settings/ddc.ts'))
call ddc#enable(#{
      \ context_filetype: has('nvim') ? 'treesitter': 'context_filetype',
      \ })
" }}}

" hook_post_update {{{
call ddc#set_static_import_path()
echomsg '[ddc] ddc#set_static_import_path() called'
" }}}
