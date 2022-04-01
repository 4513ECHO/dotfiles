let s:config_home = empty($XDG_CONFIG_HOME) ? expand('~/.config/nvim') : $XDG_CONFIG_HOME .. '/nvim'
set runtimepath&
let &runtimepath = s:config_home .. ',' .. &runtimepath .. ',' .. s:config_home .. '/after'
let $MYVIMRC = expand('<sfile>:p')

function! s:source_vimrc(vimrc) abort
  execute 'source' printf('%s/rc/%s.rc.vim', s:config_home, a:vimrc)
endfunction

" TODO: remove digits of filenames
call s:source_vimrc('000_init')
call s:source_vimrc('200_keymap')
call s:source_vimrc('300_options')
call s:source_vimrc('100_dein')

set secure
