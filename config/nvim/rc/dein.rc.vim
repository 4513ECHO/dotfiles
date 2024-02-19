let s:dein_dir = (has('nvim') ? g:cache_home : g:vim_cache_home) .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if &runtimepath->stridx(s:dein_repo_dir) < 0
  if !isdirectory(s:dein_repo_dir)
    execute ['!git', 'clone', '--filter=blob:none',
          \ 'https://github.com/Shougo/dein.vim', s:dein_repo_dir]->join()
    if v:shell_error
      echohl ErrorMsg
      echomsg 'Could not install dein.vim to' s:dein_repo_dir
      echohl NONE
      finish
    endif
  endif
  execute $'set runtimepath^={s:dein_repo_dir}'
endif

let g:dein#auto_recache = v:true
let g:dein#auto_remote_plugins = v:false
let g:dein#enable_notification = v:true
let g:dein#install_check_diff = v:true
let g:dein#install_progress_type = 'floating'
let g:dein#lazy_rplugins = v:true
let g:dein#types#git#enable_partial_clone = v:true
let $DEIN_DIR = g:config_home .. '/dein'

if dein#min#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml('$DEIN_DIR/init.toml')
  call dein#load_toml('$DEIN_DIR/colorscheme.toml')
  call dein#load_toml('$DEIN_DIR/textobj.toml')
  call dein#load_toml('$DEIN_DIR/ftplugin.toml')
  call dein#load_toml('$DEIN_DIR/plugin.toml')
  call dein#load_toml('$DEIN_DIR/ddc.toml')
  call dein#load_toml('$DEIN_DIR/ddu.toml')
  call dein#load_toml($'$DEIN_DIR/{has('nvim') ? 'neovim' : 'vim'}.toml')

  call dein#end()
  call dein#save_state()
  if dein#check_install()
    call dein#install()
  endif
endif

if getcwd() =~? expand('~/Develops/github.com/4513ECHO/')
  let s:git_root = systemlist('git rev-parse --show-toplevel')[0]
  execute $'set runtimepath^={s:git_root}'
  if isdirectory(s:git_root .. '/after')
    execute $'set runtimepath+={s:git_root}/after'
  endif
endif

syntax enable
filetype indent plugin on
