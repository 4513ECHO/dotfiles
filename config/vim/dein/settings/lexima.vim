call lexima#set_default_rules()
call lexima#insmode#map_hook('before', '<CR>', '')
call lexima#insmode#map_hook('before', '<BS>', '')

let s:rules = {}

" common
let s:rules._ = []
let s:rules._ += [
      \ { 'char': '<Tab>', 'at': '\%#\s*)',  'leave': ')'  },
      \ { 'char': '<Tab>', 'at': '\%#\s*\}', 'leave': '}'  },
      \ { 'char': '<Tab>', 'at': '\%#\s*\]', 'leave': ']'  },
      \ { 'char': '<Tab>', 'at': '\%#\s*>',  'leave': '>'  },
      \ { 'char': '<Tab>', 'at': '\%#\s*`',  'leave': '`'  },
      \ { 'char': '<Tab>', 'at': '\%#\s*"',  'leave': '"'  },
      \ { 'char': '<Tab>', 'at': '\%#\s*''', 'leave': '''' },
      \ ]

" from https://github.com/yuki-yano/dotfiles/blob/11bfe29f07/.vimrc#L2848
let s:rules._ += [
      \ { 'char': ';', 'at': '(.*\%#)$',   'input': '<Right>;' },
      \ { 'char': ';', 'at': '^\s*\%#)$',  'input': '<Right>;' },
      \ { 'char': ';', 'at': '(.*\%#\}$',  'input': '<Right>;' },
      \ { 'char': ';', 'at': '^\s*\%#\}$', 'input': '<Right>;' },
      \ ]

" python
let s:rules.python = []
let s:rules.python += [
      \ { 'char': '_',     'at': '\W\+_\%#', 'input': '_',        'input_after': '__' },
      \ { 'char': '<BS>',  'at': '__\%#__',  'input': '<BS><BS>', 'delete': 2 },
      \ { 'char': '<Tab>', 'at': '\%#__',                         'leave': 2 },
      \ ]

" help
let s:rules.help = []
let s:rules.help += [
      \ { 'char': '*',     'input': '*',    'input_after': '*' },
      \ { 'char': '*',     'at': '\%#\*',   'leave': 1 },
      \ { 'char': '<BS>',  'at': '|\%#|',   'delete': 1 },
      \ { 'char': '<BS>',  'at': '\*\%#\*', 'delete': 1 },
      \ { 'char': '<Bar>', 'at': '\%#|',    'leave': 1 },
      \ { 'char': '<Bar>', 'input': '|',    'input_after': '|' },
      \ { 'char': '<Tab>', 'at': '\%#|',    'leave': 1 },
      \ { 'char': '<Tab>', 'at': '\%#\*',   'leave': 1 },
      \ ]

" toml
" NOTE: it is using vim's bug. see also vim-jp/issues#1380
let s:rules.toml = []
let s:rules.toml += [
      \ { 'char': '<CR>', 'at': "'''\\n\\_^\\%#'''", 'input': '<C-o>zz"_D', 'input_after': '<CR>' },
      \ ]

" vim
" from https://github.com/thinca/config/blob/5413e42a18/dotfiles/dot.vim/vimrc#L2755
function! s:vim_input_bslash() abort
  let base = '<CR><C-o>d0a%s<Bslash> '
  let disable_smartindent_string = '<C-o>:setlocal indentkeys-=o<CR>a'
        \ .. '%s<C-o>:setlocal indentkeys+=o<CR>a'
  return printf(disable_smartindent_string,
        \ printf(base, repeat('<Space>', g:vim_indent_cont))
        \ )
endfunction

let s:rules.vim = []
let s:rules.vim += [
      \ { 'char': '<CR>', 'at': '{\%#}',   'input': s:vim_input_bslash(), 'input_after': '<CR><Bslash> '   },
      \ { 'char': '<CR>', 'at': '{\%#$',   'input': s:vim_input_bslash(), 'input_after': '<CR><Bslash> }'  },
      \ { 'char': '<CR>', 'at': '(\%#)',   'input': s:vim_input_bslash(), 'input_after': '<CR><Bslash> '   },
      \ { 'char': '<CR>', 'at': '(\%#$',   'input': s:vim_input_bslash(), 'input_after': '<CR><Bslash> )'  },
      \ { 'char': '<CR>', 'at': '\[\%#\]', 'input': s:vim_input_bslash(), 'input_after': '<CR><Bslash> '   },
      \ { 'char': '<CR>', 'at': '\[\%#$',  'input': s:vim_input_bslash(), 'input_after': '<CR><Bslash> \]' },
      \ ]

" call lexima#add_rule({'char': '>', 'at': '\%#)', 'input': ') => {',
"      \ 'delete':  1, 'input_after':  '}', 'filetype':
"      \ ['typescript', 'typescriptreact', 'javascript', 'javascriptreact']})

" call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'delete': 1,
"      \ 'filetype': ['typesctipt', 'typescriptreact', 'vim', 'html']})

function! s:add_rule(filetype, rule) abort
  if a:filetype !=# '_'
    let base = { 'filetype': a:filetype }
  else
    let base = {}
  endif
  call lexima#add_rule(extend(base, a:rule))
endfunction

call map(s:rules, { filetype, rules -> map(rules,
      \ { _, val -> s:add_rule(filetype, val) },
      \ ) })

