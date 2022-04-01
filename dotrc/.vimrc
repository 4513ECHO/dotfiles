" for vim-tiny and vim-small
if !1 | finish | endif

if &compatible
  set nocompatible
endif

let s:config_home = empty($XDG_CONFIG_HOME)
      \ ? expand('~/.config/nvim')
      \ : $XDG_CONFIG_HOME .. '/nvim'
execute 'source' s:config_home .. '/init.vim'
