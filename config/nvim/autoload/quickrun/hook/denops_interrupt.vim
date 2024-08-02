function! quickrun#hook#denops_interrupt#new() abort
  return #{
        \ config: {},
        \ on_ready: { -> denops#notify('vimrc', 'registerSweeper', []) },
        \ on_exit: { -> denops#notify('vimrc', 'unregisterSweeper', []) },
        \ }
endfunction
