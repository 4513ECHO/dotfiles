let s:dpp_dir = g:cache_home .. '/dpp'
let s:dpp_ts = g:config_home .. '/rc/dpp.ts'

if &runtimepath->stridx(s:dpp_dir) < 0
  if !isdirectory(s:dpp_dir)
    let s:cmd = 'deno run --allow-read --allow-write=%s --allow-run=git --allow-net=api.github.com %s %s %s'
    execute '!' printf(s:cmd, s:dpp_dir, s:dpp_ts, s:dpp_dir, expand('$VIMRCDIR/dpp/dpp.toml'))
  endif
  execute $'set runtimepath^={s:dpp_dir}/repos/github.com/Shougo/dpp.vim'
endif

if dpp#min#load_state(s:dpp_dir)
  for s:path in readfile(s:dpp_dir .. '/runtimepath_cache')
    execute $'set runtimepath^={s:path}'
  endfor
  autocmd vimrc User Dpp:makeStatePost cquit
  autocmd vimrc User DenopsReady call dpp#make_state(s:dpp_dir, s:dpp_ts)
else
  function! s:check_install() abort
    if !empty(dpp#sync_ext_action('installer', 'getNotInstalled'))
      autocmd vimrc User Dpp:makeStatePost cquit
      call dpp#async_ext_action('installer', 'install')
    endif
  endfunction
  autocmd vimrc User DenopsReady call s:check_install()
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
