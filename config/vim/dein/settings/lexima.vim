call lexima#set_default_rules()
call lexima#insmode#map_hook('before', '<CR>', '')
call lexima#insmode#map_hook('before', '<BS>', '')

call lexima#add_rule({'char': '<Tab>', 'at': '\%#)', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#"', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#''', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#]', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#}', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#`', 'leave': 1})

" python
autocmd user FileType python
      \ : call lexima#add_rule({'char': '__', 'input': '__', 'input_after': '__',
      \   'filetype': 'python'})
      \ | call lexima#add_rule({'char': '<Tab>', 'at': '\%#__', 'leave': 2,
      \   'filetype': 'python'})
      \ | call lexima#add_rule({'char': '<BS>', 'at': '__\%#__', 'delete': 2,
      \   'filetype': 'python'})

" help
call lexima#add_rule({'char': '<Bar>', 'input': '|', 'input_after': '|',
      \ 'filetype': 'help'})
call lexima#add_rule({'char': '*', 'input': '*', 'input_after': '*',
      \ 'filetype': 'help'})
call lexima#add_rule({'char': '<Bar>', 'at': '\%#|', 'leave': 1,
      \ 'filetype': 'help'})
call lexima#add_rule({'char': '*', 'at': '\%#\*', 'leave': 1,
      \ 'filetype': 'help'})
call lexima#add_rule({'char': '<BS>', 'at': '|\%#|', 'delete': 1,
      \ 'filetype': 'help'})
call lexima#add_rule({'char': '<BS>', 'at': '\*\%#\*', 'delete': 1,
      \ 'filetype': 'help'})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#|', 'leave': 1,
      \ 'filetype': 'help'})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#\*', 'leave': 1,
      \ 'filetype': 'help'})

" toml
call lexima#add_rule({'at': "'''\\n\\_^\\%#'''", 'char': '<CR>',
      \ 'input': '<C-o>zz"_D', 'input_after': '<CR>',
      \ 'filetype': 'toml'})

" vim
" from https://github.com/thinca/config/blob/5413e42a18/dotfiles/dot.vim/vimrc#L2755
" TODO: it is in conflict with 'smartindent' when spaces are exist
"       before brackets.
call lexima#add_rule({
     \ 'char': '<CR>', 'at': '{\%#}',
     \ 'input': printf('<CR>%s<Bslash> ', repeat(' ', g:vim_indent_cont)),
     \ 'input_after': '<CR><Bslash> ',
     \ 'filetype': 'vim',
     \ })
call lexima#add_rule({
     \ 'char': '<CR>', 'at': '{\%#$',
     \ 'input': printf('<CR>%s<Bslash> ', repeat(' ', g:vim_indent_cont)),
     \ 'input_after': '<CR><Bslash> }',
     \ 'filetype': 'vim',
     \ })

" call lexima#add_rule({'char': '>', 'at': '\%#)', 'input': ') => {',
"      \ 'delete':  1, 'input_after':  '}', 'filetype':
"      \ ['typescript', 'typescriptreact', 'javascript', 'javascriptreact']})

" call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'delete': 1,
"      \ 'filetype': ['typesctipt', 'typescriptreact', 'vim', 'html']})


