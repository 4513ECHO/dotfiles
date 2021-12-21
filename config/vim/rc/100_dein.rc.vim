let s:dein_dir = g:cache_home .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# s:dein_repo_dir
  if !isdirectory(s:dein_repo_dir)
    call system(printf('git clone https://github.com/Shougo/dein.vim %s',
          \ s:dein_repo_dir))
  endif
  execute 'set runtimepath^=' .. s:dein_repo_dir
endif

let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#install_check_diff = v:true
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
  call s:load_toml('textobj.toml', v:false)
  if !g:denops#disabled
    call s:load_toml('ddc.toml', v:true)
  endif
  call s:load_toml('plugin.toml', v:true)
  call s:load_toml('ftplugin.toml', v:true)

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

if getcwd() =~# expand('~/Develops/github.com')
  let s:git_root = expand(system('git rev-parse --show-toplevel'))
  execute 'set runtimepath^=' .. s:git_root
  if isdirectory(s:git_root .. '/after')
    execute 'set runtimepath+=' .. s:git_root .. '/after'
  endif
endif

syntax enable
" call timer_start(0, { -> execute('syntax enable') })
filetype indent plugin on

call user#colorscheme#random()
