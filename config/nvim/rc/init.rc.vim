augroup vimrc
  autocmd!
augroup END

let g:cache_home = $XDG_CACHE_HOME .. '/nvim'
let g:config_home = $XDG_CONFIG_HOME .. '/nvim'
let g:data_home = $XDG_DATA_HOME .. '/nvim'
let g:vim_cache_home = $XDG_CACHE_HOME .. '/vim'
let g:vim_data_home = $XDG_DATA_HOME .. '/vim'

let g:launcher_config = get(g:, 'launcher_config', {})
nnoremap <C-s> <Cmd>call user#launcher#select()<CR>
let g:launcher_config.color = #{
      \ char: 'r',
      \ run: 'RandomColorScheme',
      \ }

autocmd vimrc VimEnter * ++nested call user#colorscheme#random()
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
" https://github.com/lighttiger2505/.dotfiles/blob/6d0d4b8392/.vimrc#L11
if has('vim_starting')
  let g:startuptime = reltime()
  autocmd vimrc VimEnter *
        \ : let g:startuptime = reltime(g:startuptime)
        \ | redraw
        \ | echomsg printf('startuptime: %fms', reltimefloat(g:startuptime) * 1000)
endif

command! -nargs=1 Runtime runtime! g:config_home <args>

" from https://github.com/thinca/config/blob/d92e41cebd/dotfiles/dot.vim/vimrc#L1382
command! -bar RTP echo substitute(&runtimepath, ',', "\n", 'g')

command! -bar RandomColorScheme call user#colorscheme#random()

command! -nargs=? -bar -bang -complete=customlist,user#colorscheme#completion
      \ ColorScheme call user#colorscheme#command(<q-args>, <bang>0)

" from https://qiita.com/gorilla0513/items/11be5413405792337558
command! -nargs=1 WWW call user#google(<q-args>)

command! -bar HtmlFormat
      \ : silent! keepjumps keeppattern substitute+\v\>(\<)@=+>\r+ge
      \ | silent! keepjumps normal! gg=G

command! -bar -bang TodoList vimgrep '\vTODO\ze%(\(.{-}\))?:' `git ls-files`

command! -nargs=? -bar -complete=filetype MiniNote
      \ : execute (empty(<q-mods>) ? 'botright' : <q-mods>) 'new mininote'
      \ | setlocal bufhidden=wipe buftype=nofile filetype=<args>

command! -bar DeinUpdateMine
      \ call dein#update(dein#get()->copy()
      \ ->filter({ _, val -> val.repo =~? '^4513ECHO/' })->keys())

" from `:help :DiffOrig`
command! -bar DiffOrig
      \ : vertical new | setlocal buftype=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis

if filereadable(expand('~/.vimrc_secret'))
  source ~/.vimrc_secret
endif

" custom autocmd
nnoremap <Plug>(VimrcSearchPost) <Cmd>doautocmd <nomodeline> User VimrcSearchPost<CR>
autocmd vimrc User VimrcSearchPost :

if has('nvim')
  lua vim.loader.enable()
  lua require('vimrc.autocmd')
endif
