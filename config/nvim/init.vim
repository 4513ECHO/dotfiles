let s:config_home = $XDG_CONFIG_HOME .. '/nvim'
set runtimepath&
let &runtimepath = [s:config_home, &runtimepath, s:config_home .. '/after']->join(',')
let $MYVIMRC = expand('<sfile>:p')
let $MYVIMDIR = expand('<sfile>:p:h')

function! s:source_vimrc(vimrc) abort
  execute $'source {s:config_home}/rc/{a:vimrc}.rc.vim'
endfunction
call s:source_vimrc('init')
call s:source_vimrc('dpp')

set secure
