let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config/nvim') : $XDG_CONFIG_HOME .. '/nvim'
set runtimepath&
let &runtimepath = join([s:config_home, &runtimepath, s:config_home .. '/after'], ',')
let $MYVIMRC = expand('<sfile>:p')

function! s:source_vimrc(vimrc) abort
  execute 'source' printf('%s/rc/%s.rc.vim', s:config_home, a:vimrc)
endfunction
call s:source_vimrc('init')
call s:source_vimrc('keymap')
call s:source_vimrc('options')
if empty($VIM_DISABLE_DEIN)
  call s:source_vimrc('dein')
endif

set secure
