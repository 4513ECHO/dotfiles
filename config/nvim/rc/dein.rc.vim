let s:dein_dir = (has('nvim') ? g:cache_home : g:vim_cache_home) .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# s:dein_repo_dir
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone --depth 1 https://github.com/Shougo/dein.vim '
          \ .. s:dein_repo_dir
    if v:shell_error
      echohl ErrorMsg
      echomsg 'Could not install dein.vim to' s:dein_repo_dir
      echohl NONE
      finish
    endif
  endif
  execute 'set runtimepath^=' .. s:dein_repo_dir
endif

let g:dein#types#git#clone_depth = 1
let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#install_check_diff = v:true
let g:dein#install_progress_type = 'floating'
let g:dein#auto_remote_plugins = v:false
let g:dein#enable_notification = v:true

if dein#min#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#load_toml(g:config_home .. '/dein/init.toml',        #{ lazy: v:false })
  call dein#load_toml(g:config_home .. '/dein/colorscheme.toml', #{ lazy: v:false })
  call dein#load_toml(g:config_home .. '/dein/textobj.toml',     #{ lazy: v:true })
  call dein#load_toml(g:config_home .. '/dein/ftplugin.toml',    #{ lazy: v:true })
  call dein#load_toml(g:config_home .. '/dein/plugin.toml',      #{ lazy: v:true })
  call dein#load_toml(g:config_home .. '/dein/ddc.toml',         #{ lazy: v:true })
  call dein#load_toml(g:config_home .. '/dein/ddu.toml',         #{ lazy: v:true })
  call dein#load_toml(g:config_home .. '/dein/' ..
        \ (has('nvim') ? 'neovim.toml' : 'vim.toml'),            #{ lazy: v:false })

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
  if !empty(get(g:, 'dein#install_github_api_token', ''))
    call timer_start(0, { -> dein#check_update(v:true) })
  endif
endif

if getcwd() =~? expand('~/Develops/github.com/4513ECHO/')
  let s:git_root = system('git rev-parse --show-toplevel')
  execute 'set runtimepath^=' .. s:git_root
  if isdirectory(s:git_root .. '/after')
    execute 'set runtimepath+=' .. s:git_root .. '/after'
  endif
endif

syntax enable
filetype indent plugin on
