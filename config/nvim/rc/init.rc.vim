augroup vimrc
  autocmd!
augroup END

let $VIM_PID = getpid()
let g:cache_home = $XDG_CACHE_HOME .. '/nvim'
let g:config_home = $XDG_CONFIG_HOME .. '/nvim'
let g:data_home = $XDG_DATA_HOME .. '/nvim'
let g:vim_cache_home = $XDG_CACHE_HOME .. '/vim'
let g:vim_data_home = $XDG_DATA_HOME .. '/vim'

let g:launcher_config = g:->get('launcher_config', {})
nnoremap <C-s> <Cmd>call user#launcher#select()<CR>
let g:launcher_config.color = #{
      \ char: 'r',
      \ run: 'RandomColorScheme',
      \ }

autocmd vimrc VimEnter,DirChanged * ++nested call user#colorscheme#random()
autocmd vimrc ColorSchemePre *
      \ : unlet! g:terminal_color_foreground
      \          g:terminal_color_background
      \          g:terminal_ansi_colors
      \ | for s:i in range(16)
      \ |   unlet! g:terminal_color_{s:i}
      \ | endfor
autocmd vimrc ColorScheme *
      \ : call user#colorscheme#update_lightline()
      \ | call user#colorscheme#set_customize()

" echo message vim start up time
" based on https://github.com/lighttiger2505/.dotfiles/blob/6d0d4b83/.vimrc#L11
if has('vim_starting') && (!has('nvim') || v:argv->index('--headless') < 0)
  let g:startuptime = reltime()
  autocmd vimrc VimEnter *
        \ : let g:startuptime = reltime(g:startuptime)
        \ | redraw
        \ | echomsg printf('startuptime: %fms', reltimefloat(g:startuptime) * 1000)
endif

" from https://github.com/thinca/config/blob/d92e41ce/dotfiles/dot.vim/vimrc#L1382
command! -bar RTP echo &runtimepath->substitute(',', "\n", 'g')

command! -bar RandomColorScheme call user#colorscheme#random()

command! -nargs=? -bar -bang -complete=custom,user#colorscheme#completion
      \ ColorScheme call user#colorscheme#command(<q-args>, <bang>0)

" from https://qiita.com/gorilla0513/items/11be5413405792337558
command! -nargs=1 WWW call user#google(<q-args>)

command! -nargs=? -bar -complete=filetype MiniNote
      \ : execute (<q-mods> ?? 'belowright 10') 'new mininote'
      \ | setlocal bufhidden=wipe buftype=nofile filetype=<args> winfixheight

command! -bar DeinUpdateMine
      \ call dein#get()->copy()->filter({ -> v:val.repo =~? '/4513ECHO/' })
      \ ->keys()->dein#update()

" from `:help :DiffOrig`
command! -bar DiffOrig
      \ : vertical new | setlocal buftype=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis

command! -bar VTerminal execute (<q-mods> ?? 'topleft vertical')
      \ has('nvim') ? 'split +terminal' : 'terminal ++close'

command! -bar Udd let $NO_COLOR = 1 | execute '!udd %' | unlet $NO_COLOR

if filereadable(expand('~/.vimrc_secret'))
  source ~/.vimrc_secret
endif

" custom autocmd
noremap  <Plug>(search-post) <Cmd>doautocmd <nomodeline> User VimrcSearchPost<CR>
noremap! <Plug>(search-post) <Cmd>doautocmd <nomodeline> User VimrcSearchPost<CR>
autocmd vimrc User VimrcSearchPost normal! zzzv

if has('nvim')
  lua require('vimrc')
endif
