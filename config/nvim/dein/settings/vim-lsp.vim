" hook_add {{{
vim9cmd user#plugins#lsp#HookAdd()
" }}}

" hook_source {{{
if v:vim_did_enter
  call timer_start(0, { -> lsp#enable() })
else
  autocmd vimrc VimEnter * call timer_start(0, { -> lsp#enable() })
endif
" }}}
