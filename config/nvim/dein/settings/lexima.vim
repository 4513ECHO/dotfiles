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

let s:rules._ += [
      \ { 'char': '<',     'at': '\<\h\w*\%#', 'input_after': '>' },
      \ { 'char': '<BS>',  'at': '<\%#>',      'delete': '>'      },
      \ { 'char': '>',     'at': '\%#>',       'leave': '>'       },
      \ { 'char': '<Tab>', 'at': '\%#\s*>',    'leave': '>'       },
      \ ]

" python
let s:rules.python = []
let s:rules.python += [
      \ { 'char': '_',     'at': '\W\+_\%#', 'input': '_',        'input_after': '__' },
      \ { 'char': '<BS>',  'at': '__\%#__',  'input': '<BS><BS>', 'delete': 2         },
      \ { 'char': '<Tab>', 'at': '\%#__',                         'leave': 2          },
      \ ]

" help
let s:rules.help = []
let s:rules.help += [
      \ { 'char': '*',     'input': '*',    'input_after': '*' },
      \ { 'char': '*',     'at': '\%#\*',   'leave':  '*'      },
      \ { 'char': '<BS>',  'at': '|\%#|',   'delete': '|'      },
      \ { 'char': '<BS>',  'at': '\*\%#\*', 'delete': '*'      },
      \ { 'char': '<Bar>', 'at': '\%#|',    'leave':  '|'      },
      \ { 'char': '<Bar>', 'input': '|',    'input_after': '|' },
      \ { 'char': '<Tab>', 'at': '\%#|',    'leave':  '|'      },
      \ { 'char': '<Tab>', 'at': '\%#\*',   'leave':  '*'      },
      \ ]

" toml
let s:rules.toml = []
let s:rules.toml += [
      \ { 'char': '<CR>', 'at': "=\\s*'''\\%#'''$", 'input': '<CR>', 'input_after': '<CR>' },
      \ { 'char': '<CR>', 'at': '=\s*"""\%#"""$',   'input': '<CR>', 'input_after': '<CR>' },
      \ ]

" vim
" from https://github.com/thinca/config/blob/5413e42a18/dotfiles/dot.vim/vimrc#L2755
function! s:vim_input_bslash() abort
  let base = '<CR><C-o>d0a%s<Bslash> '
  let disable_smartindent_string = '<C-o>:setlocal indentkeys-=o<CR>a'
        \ .. '%s<C-o>:setlocal indentkeys+=o<CR>a'
  return printf(disable_smartindent_string,
        \ printf(base, repeat('<Space>', g:vim_indent_cont),
        \ ))
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
      \ { 'char': '-',     'at': '^\s*\%#$',        'input': '-<Space>',                 },
      \ { 'char': '*',     'at': '^\s*\%#$',        'input': '*<Space>',                 },
      \ ]
" smart checkbox
let s:rules.markdown += [
      \ { 'char': '<Space>', 'at': '^\s*[-*]\s*\[\%#\]$', 'input': '<Space><Right>'  },
      \ { 'char': 'x',       'at': '^\s*[-*]\s*\[\%#\]$', 'input': 'x<Right>'        },
      \ ]
" smart bold, italic and strikethrough
let s:rules.markdown += [
      \ { 'char': '*',     'input': '*',    'input_after': '*' },
      \ { 'char': '~',     'input': '~',    'input_after': '~' },
      \ { 'char': '<Tab>', 'at': '\%#\*',   'leave':  '*'      },
      \ { 'char': '<Tab>', 'at': '\%#\~',   'leave':  '~'      },
      \ ]

" typescript
let s:rules.typescript = []
let s:rules.typescript += [
      \ { 'char': '>', 'at': '([a-zA-Z, ]*>\%#)', 'delete': ')', 'input': '<BS>) => {', 'input_after': '}' },
      \ ]
let s:rules.typescriptreact = copy(s:rules.typescript)

" lua
" from https://github.com/cohama/lexima.vim/issues/107
function! s:make_rule(at, end, filetype, syntax)
  return {
        \ 'char': '<CR>',
        \ 'input': '<CR>',
        \ 'input_after': '<CR>' .. a:end,
        \ 'at': a:at,
        \ 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1' .. a:end,
        \ 'filetype': a:filetype,
        \ 'syntax': a:syntax,
        \ }
endfunction

let s:rules.lua = []
let s:rules.lua += [
      \ s:make_rule('\%(^\s*--.*\)\@<!\<function\>\%(.*\<end\>\)\@!.*\%#', 'end', 'lua', []),
      \ s:make_rule('\%(^\s*--.*\)\@<!\<do\s*\%#', 'end', 'lua', []),
      \ s:make_rule('\%(^\s*--.*\)\@<!\<then\s*\%#', 'end', 'lua', []),
      \ ]

" sh
let s:rules.sh = []
let s:rules.sh += [
      \ { 'char': '<Tab>', 'at': '\%#\s\]\]', 'leave': 3 },
      \ ]
let s:rules.zsh = copy(s:rules.sh)

" jq
let s:rules.jq = []
" string interpolation
let s:rules.jq += [
      \ { 'char': '(', 'at': '\\\%#', 'input_after': ')' },
      \ ]

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
  for char in ['<CR>', '<Space>', '!']
    call lexima#add_rule({
          \ 'char': char,
          \ 'mode': ':',
          \ 'at': '^\(''<,''>\)\?' .. a:original .. '\%#',
          \ 'input': '<C-w>' .. a:altanative ..  char,
          \ })
  endfor
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
LeximaAlterCommand dei\%[n]                     Dein
LeximaAlterCommand deinr\%[eadme]               DeinReadme
LeximaAlterCommand readm\%[e]                   DeinReadme
LeximaAlterCommand helpfu\%[lversion]           HelpfulVersion
LeximaAlterCommand tsp\%[laygroundtoggle]       TSPlaygroundToggle
LeximaAlterCommand tsh\%[ighlightcaptureundercursor]    TSHighlightCaptureUnderCursor
LeximaAlterCommand colo\%[rscheme]              ColorScheme
LeximaAlterCommand ra\%[ndomcolorscheme]        RandomColorScheme
LeximaAlterCommand todo\%[list]                 TodoList
LeximaAlterCommand mi\%[ninote]                 MiniNote
LeximaAlterCommand not\%[e]                     MiniNote
LeximaAlterCommand deinu\%[pdatemine]           DeinUpdateMine

