let s:dein_dir = g:cache_home .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim' .. ' ' .. s:dein_repo_dir)
  endif
  let &runtimepath = fnamemodify(s:dein_repo_dir, ':p') .. ',' .. &runtimepath
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml_dir = g:config_home .. '/dein'
  let s:nolazy_toml = map(['/init.toml', '/ftplguin.toml'],
        \ 's:toml_dir .. v:val')
  let s:tomls = glob(s:toml_dir .. '/*.toml', v:false, v:true)

  for s:toml in s:tomls
    if index(s:nolazy_toml, s:toml) != -1
      call dein#load_toml(s:toml, {'lazy': v:false})
      continue
    endif
    call dein#load_toml(s:toml, {'lasy': v:true})
  endfor

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

syntax enable
filetype indent plugin on
