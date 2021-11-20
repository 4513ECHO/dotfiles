let s:dein_dir = g:cache_home .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# s:dein_repo_dir
  if !isdirectory(s:dein_repo_dir)
    call system(printf('git clone https://github.com/Shougo/dein.vim %s',
          \ s:dein_repo_dir))
  endif
  let &runtimepath = s:dein_repo_dir .. ',' .. &runtimepath
endif

let g:dein#auto_recache = v:true
let g:dein#lazy_rplugins = v:true
let g:dein#install_check_diff = v:true

if dein#min#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml_dir = g:config_home .. '/dein'
  let s:nonlazy_toml = map(['init.toml', 'colorscheme.toml', 'textobj.toml'],
        \ {_, val -> s:toml_dir .. '/' .. val})
  let s:tomls = glob(s:toml_dir .. '/*.toml', v:false, v:true)

  for s:toml in s:tomls
    if index(s:nonlazy_toml, s:toml) != -1
      call dein#load_toml(s:toml)
      continue
    endif
    if s:toml =~# 'ddc.toml'
      call dein#load_toml(s:toml, {'lazy': v:true,
            \ 'if': executable('deno')})
      continue
    endif
    call dein#load_toml(s:toml, {'lazy': v:true})
  endfor

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

syntax enable
filetype indent plugin on

