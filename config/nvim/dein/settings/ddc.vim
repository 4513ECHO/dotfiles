" hook_add {{{
autocmd vimrc CmdlineEnter [:] call ddc#enable_cmdline_completion()
" }}}

" hook_source {{{
" based on https://github.com/kuuote/dotvim/blob/0e8dd6a4/conf/ddc.toml#L170
autocmd vimrc OptionSet buftype
      \ : if &buftype ==# 'acwrite' || bufname() ==# 'mininote'
      \ |   call ddc#custom#patch_buffer('specialBufferCompletion', v:true)
      \ | endif

" key mappings
inoremap <silent><expr> <C-n> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Down>'
inoremap <silent><expr> <C-p> pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Up>'
cnoremap <expr> <C-n> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Down>'
cnoremap <expr> <C-p> pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Up>'
cnoremap <expr> <BS>  pum#visible() ? '<Cmd>call pum#map#cancel()<CR>' : '<BS>'
cnoremap <expr> <Tab> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : ddc#map#manual_complete()

" NOTE: define these in hook_source to ensure it is loaded after lexima.vim is sourced
inoremap <silent><expr> <BS> pum#visible() ? '<Cmd>call pum#map#cancel()<CR>'  : lexima#expand('<lt>BS>', 'i')
inoremap <silent><expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<lt>CR>', 'i')
cnoremap         <expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<lt>CR>', ':')

" emulate default mappings (see `:help ins-completion`)
function! s:ddc_complete(...) abort
  return ddc#map#manual_complete(#{ sources: a:000 })
endfunction
inoremap <silent><expr> <C-x><C-l> <SID>ddc_complete('line')
inoremap <silent><expr> <C-x><C-n> <SID>ddc_complete('around')
inoremap <silent><expr> <C-x><C-f> <SID>ddc_complete('file')
inoremap <silent><expr> <C-x><C-d> <SID>ddc_complete('vim-lsp')
inoremap <silent><expr> <C-x><C-v> <SID>ddc_complete('cmdline')
inoremap <silent><expr> <C-x><C-u> <SID>ddc_complete()
inoremap <silent><expr> <C-x><C-o> <SID>ddc_complete('omni')
inoremap <silent><expr> <C-x><C-s> <SID>ddc_complete('mocword')
inoremap <silent><expr> <C-x><C-t> <SID>ddc_complete('tmux')

if bufname() =~# '^/tmp/\d\+\.md$'
  inoremap <silent><expr><buffer> <C-x><C-g> <SID>ddc_complete('github_issue', 'github_pull_request')
endif

call ddc#custom#load_config(expand('$DEIN_DIR/settings/ddc.ts'))
call ddc#enable(#{
      \ context_filetype: has('nvim') ? 'treesitter': 'context_filetype',
      \ })
" }}}
