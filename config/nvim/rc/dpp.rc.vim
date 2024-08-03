let s:dpp_dir = (has('nvim') ? g:cache_home : g:vim_cache_home) .. '/dpp'
let s:dpp_ts = g:config_home .. '/rc/dpp.ts'
let $DEIN_DIR = g:config_home .. '/dein'

if &runtimepath->stridx(s:dpp_dir) < 0
  if !isdirectory(s:dpp_dir)
    execute printf('!deno run --allow-read --allow-run=git %s %s %s',
          \ s:dpp_ts, s:dpp_dir, expand('$DEIN_DIR/dpp.toml'))
  endif
  for s:plugin in [
        \ 'github.com/vim-denops/denops.vim',
        \ 'github.com/Shougo/dpp.vim',
        \ 'github.com/Shougo/dpp-ext-installer',
        \ 'github.com/Shougo/dpp-ext-lazy',
        \ 'github.com/Shougo/dpp-ext-toml',
        \ 'github.com/Shougo/dpp-protocol-git',
        \ ]
    execute $'set runtimepath^={s:dpp_dir}/repos/{s:plugin}'
  endfor
endif

if dpp#min#load_state(s:dpp_dir)
  " autocmd vimrc User Dpp:makeStatePost cquit
  autocmd vimrc User DenopsReady call dpp#make_state(s:dpp_dir, s:dpp_ts)
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
