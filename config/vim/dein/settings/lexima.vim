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
      \ { 'char': ';', 'at': '(.*\%#)$',   'leave': ')', 'input': ';' },
      \ { 'char': ';', 'at': '^\s*\%#)$',  'leave': ')', 'input': ';' },
      \ { 'char': ';', 'at': '(.*\%#\}$',  'leave': '}', 'input': ';' },
      \ { 'char': ';', 'at': '^\s*\%#\}$', 'leave': '}', 'input': ';' },
      \ ]

let s:rules._ += [
      \ { 'char': '<',     'at': '\<\h\w*\%#', 'input_after': '>' },
      \ { 'char': '<BS>',  'at': '<\%#>',    'delete': '>'      },
      \ { 'char': '>',     'at': '\%#>',     'leave': '>'       },
      \ { 'char': '<Tab>', 'at': '\%#\s*>',  'leave': '>'       },
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
      \ { 'char': '*',     'at': '\%#\*',   'leave':  '*' },
      \ { 'char': '<BS>',  'at': '|\%#|',   'delete': '|' },
      \ { 'char': '<BS>',  'at': '\*\%#\*', 'delete': '*' },
      \ { 'char': '<Bar>', 'at': '\%#|',    'leave':  '|' },
      \ { 'char': '<Bar>', 'input': '|',    'input_after': '|' },
      \ { 'char': '<Tab>', 'at': '\%#|',    'leave':  '|' },
      \ { 'char': '<Tab>', 'at': '\%#\*',   'leave':  '*' },
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

" markdown
let s:rules.markdown = []
" smart itemize indent
let s:rules.markdown += [
      \ { 'char': '<Tab>', 'at': '^\s*[-*]\s*\%#$', 'input': '<Home><Space><Space><End>' },
      \ { 'char': '<BS>',  'at': '^\s*[-*]\s*\%#$', 'input': '<Home><Del><Del><End>'     },
      \ ]
" smart checkbox
let s:rules.markdown += [
      \ { 'char': '[', 'at': '^\s*[-*]\s*\%#$',      'input': '[<Space>]'                 },
      \ { 'char': 'x', 'at': '^\s*[-*]\s*\[ \]\%#$', 'input': '<Left><BS>x<Right><Space>' },
      \ ]

" typescript
let s:rules.typescript = []
let s:rules.typescript += [
     \ { 'char': '>', 'at': '([a-zA-Z, ]*>\%#)', 'delete': ')', 'input': '<BS>) => {', 'input_after': '}' },
     \ ]
let s:rules.typescriptreact = copy(s:rules.typescript)

function! s:debug() abort
  return string(s:rules)
endfunction

function! s:lexima_init() abort
  for [filetype, rules] in items(s:rules)
    for val in rules
      if filetype !=# '_'  && type(filetype) == v:t_string
        let base = { 'filetype': filetype }
      else
        let base = {}
      endif
      call lexima#add_rule(extend(base, val))
    endfor
  endfor
endfunction
call s:lexima_init()

" from https://github.com/yuki-yano/dotfiles/blob/9bfee6c807/.vimrc#L3335
function! s:lexima_alter_command(original, altanative) abort
  let input_space = '<C-w>' .. a:altanative .. '<Space>'
  let input_cr    = '<C-w>' .. a:altanative .. '<CR>'

  let rule = {
        \ 'mode': ':',
        \ 'at': '^\(''<,''>\)\?' .. a:original .. '\%#',
        \ }

  call lexima#add_rule(extend(rule, { 'char': '<Space>', 'input': input_space }))
  call lexima#add_rule(extend(rule, { 'char': '<CR>',    'input': input_cr    }))
endfunction

command! -nargs=+ LeximaAlterCommand call <SID>lexima_alter_command(<f-args>)

LeximaAlterCommand hg\%[rep]                    helpgrep
LeximaAlterCommand bon\%[ew]                    botright<Space>new
LeximaAlterCommand hea\%[lthcheck]              checkhealth
LeximaAlterCommand cap\%[ture]                  Capture
LeximaAlterCommand capturej\%[son]              CaptureJson
LeximaAlterCommand capj\%[son]                  CaptureJson
LeximaAlterCommand quic\%[krun]                 QuickRun
LeximaAlterCommand qr\%[un]                     QuickRun
LeximaAlterCommand fixw\%[hitespace]            FixWhitespace
LeximaAlterCommand dd\%[u]                      Ddu
LeximaAlterCommand dei\%[nreadme]               DeinReadme
LeximaAlterCommand readm\%[e]                   DeinReadme
LeximaAlterCommand colo\%[rscheme]              ColorScheme
LeximaAlterCommand ra\%[ndomcolorscheme]        RandomColorScheme
LeximaAlterCommand todo\%[list]                 TodoList
LeximaAlterCommand mi\%[ninote]                 MiniNote
LeximaAlterCommand not\%[e]                     MiniNote

