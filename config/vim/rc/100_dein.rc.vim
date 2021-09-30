let s:dein_dir = g:cache_home .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim' .. ' ' .. s:dein_repo_dir)
  endif
  execute 'set runtimepath^=' .. fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml_dir = g:config_home .. '/dein'
  let s:init_toml = s:toml_dir .. '/init.toml'
  let s:tomls = []
  call add(s:tomls, s:toml_dir .. '/plugin.toml')
  call add(s:tomls, s:toml_dir .. '/ftplugin.toml')
  call add(s:tomls, s:toml_dir .. '/colorscheme.toml')
  call add(s:tomls, s:toml_dir .. '/ddc.toml')

  call dein#load_toml(s:init_toml, {'lazy': 0})
  for s:toml in s:tomls
    call dein#load_toml(s:toml, {'lasy': 1})
  endfor

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

syntax enable
filetype indent on
filetype plugin on
