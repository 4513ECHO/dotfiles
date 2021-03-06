let s:dein_dir = (has('nvim') ? g:cache_home : g:vim_cache_home) .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# s:dein_repo_dir
  if !isdirectory(s:dein_repo_dir)
    call system(printf('git clone --depth 1 '
          \ .. 'https://github.com/Shougo/dein.vim %s',
          \ s:dein_repo_dir))
    if v:shell_error != 0
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
let g:denops#disabled = !executable('deno')

function! s:load_toml(filename, lazy) abort
  call dein#load_toml(fnamemodify(
        \ g:config_home .. '/dein/' .. a:filename, ':p'),
        \ a:lazy ? {'lazy': v:true} : {})
endfunction

if dein#min#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call s:load_toml('init.toml', v:false)
  call s:load_toml('colorscheme.toml', v:false)
  call s:load_toml('textobj.toml', v:true)
  call s:load_toml('ftplugin.toml', v:true)
  call s:load_toml('plugin.toml', v:true)
  if !g:denops#disabled
    call s:load_toml('ddc.toml', v:true)
    call s:load_toml('ddu.toml', v:true)
  endif
  if has('nvim')
    call s:load_toml('neovim.toml', v:false)
  else
    call s:load_toml('vim.toml', v:false)
  endif

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
  if exists('g:dein#install_github_api_token')
        \ && !empty(g:dein#install_github_api_token)
    call dein#check_update(v:true)
  endif
endif

if getcwd() =~# expand('~/Develops/github.com/4513echo/')
  let s:git_root = system('git rev-parse --show-toplevel')
  execute 'set runtimepath^=' .. s:git_root
  if isdirectory(s:git_root .. '/after')
    execute 'set runtimepath+=' .. s:git_root .. '/after'
  endif
endif

syntax enable
filetype indent plugin on

