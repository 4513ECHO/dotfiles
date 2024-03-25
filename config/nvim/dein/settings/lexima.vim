" hook_add {{{
let g:lexima_no_default_rules = v:true
let g:lexima_ctrlh_as_backspace = v:true
" }}}

" hook_source {{{
call lexima#set_default_rules()

let s:rules = {}

" common
let s:rules._ = []
let s:rules._ += [
      \ #{ char: '<Tab>', at: '\%#\s*)',  leave: ')'  },
      \ #{ char: '<Tab>', at: '\%#\s*\}', leave: '}'  },
      \ #{ char: '<Tab>', at: '\%#\s*\]', leave: ']'  },
      \ #{ char: '<Tab>', at: '\%#\s*>',  leave: '>'  },
      \ #{ char: '<Tab>', at: '\%#\s*`',  leave: '`'  },
      \ #{ char: '<Tab>', at: '\%#\s*"',  leave: '"'  },
      \ #{ char: '<Tab>', at: '\%#\s*''', leave: '''' },
      \ ]

let s:rules._ += [
      \ #{ char: '<',     at: '\<\h\w*\%#', input_after: '>' },
      \ #{ char: '<BS>',  at: '<\%#>',      delete: 1        },
      \ #{ char: '>',     at: '\%#>',       leave: '>'       },
      \ #{ char: '<Tab>', at: '\%#\s*>',    leave: '>'       },
      \ ]

" python
let s:rules.python = []
let s:rules.python += [
      \ #{ char: '_',     at: '\W\+_\%#', input: '_',        input_after: '__' },
      \ #{ char: '<BS>',  at: '__\%#__',  input: '<BS><BS>', delete: 2         },
      \ #{ char: '<Tab>', at: '\%#__',                       leave: 2          },
      \ ]

" help
let s:rules.help = []
let s:rules.help += [
      \ #{ char: '*',     input: '*',    input_after: '*' },
      \ #{ char: '*',     at: '\%#\*',   leave: '*'       },
      \ #{ char: '<BS>',  at: '|\%#|',   delete: 1        },
      \ #{ char: '<BS>',  at: '\*\%#\*', delete: 1        },
      \ #{ char: '<Bar>', at: '\%#|',    leave: '|'       },
      \ #{ char: '<Bar>', input: '|',    input_after: '|' },
      \ #{ char: '<Tab>', at: '\%#|',    leave: '|'       },
      \ #{ char: '<Tab>', at: '\%#\*',   leave: '*'       },
      \ ]

" toml
let s:rules.toml = []
let s:rules.toml += [
      \ #{ char: '<CR>', at: "=\\s*'''\\%#'''$", input: '<CR>', input_after: '<CR>' },
      \ #{ char: '<CR>', at: '=\s*"""\%#"""$',   input: '<CR>', input_after: '<CR>' },
      \ ]

" vim
" based on https://github.com/thinca/config/blob/5413e42a/dotfiles/dot.vim/vimrc#L2755
let s:vim_input_bslash = '<Space>'->repeat(g:vim_indent_cont)->printf('<CR>%s<Bslash><Space>')

let s:rules.vim = []
let s:rules.vim += [
      \ #{ char: '<CR>', at: '{\%#}',   input: s:vim_input_bslash, input_after: '<CR><Bslash> '   },
      \ #{ char: '<CR>', at: '{\%#$',   input: s:vim_input_bslash, input_after: '<CR><Bslash> }'  },
      \ #{ char: '<CR>', at: '(\%#)',   input: s:vim_input_bslash, input_after: '<CR><Bslash> '   },
      \ #{ char: '<CR>', at: '(\%#$',   input: s:vim_input_bslash, input_after: '<CR><Bslash> )'  },
      \ #{ char: '<CR>', at: '\[\%#\]', input: s:vim_input_bslash, input_after: '<CR><Bslash> '   },
      \ #{ char: '<CR>', at: '\[\%#$',  input: s:vim_input_bslash, input_after: '<CR><Bslash> \]' },
      \ ]
" endmarker
let s:rules.vim += [
      \ #{ char: '<CR>', at: '<<\s*\%(trim\s\+\)\?\(\h\w*\)\%#$', input: '<CR>', input_after: '<CR>\1', with_submatch: v:true },
      \ ]

" sh
let s:rules.sh = []
let s:rules.sh += [
      \ #{ char: '<Tab>', at: '\%#\s\]\]', leave: 3 },
      \ ]
let s:rules.zsh = copy(s:rules.sh)

" jq
let s:rules.jq = []
" string interpolation
let s:rules.jq += [
      \ #{ char: '(', at: '\\\%#', input_after: ')' },
      \ ]

eval s:rules
      \ ->map({ ft, rules -> rules
      \   ->map({ -> (ft ==# '_' ? {} : #{ filetype: ft })
      \     ->extend(v:val)->lexima#add_rule() }) })

" based on https://github.com/yuki-yano/dotfiles/blob/9bfee6c8/.vimrc#L3335
function! s:lexima_alter_command(original, altanative) abort
  eval ['<CR>', '<Space>', '!']->map({ ->
        \ lexima#add_rule(#{
        \   char: v:val,
        \   mode: ':',
        \   at: $'\c^\(''<,''>\)\?{a:original}\%#',
        \   input: $'<C-w>{a:altanative}{v:val}',
        \ }) })
endfunction
command! -nargs=+ -complete=command LeximaAlterCommand call <SID>lexima_alter_command(<f-args>)

" Plugin Commands
LeximaAlterCommand cap\%[ture]                  Capture
LeximaAlterCommand capturej\%[son]              CaptureJson
LeximaAlterCommand capj\%[son]                  CaptureJson
LeximaAlterCommand quic\%[krun]                 QuickRun
LeximaAlterCommand qr\%[un]                     QuickRun
LeximaAlterCommand fixw\%[hitespace]            FixWhitespace
LeximaAlterCommand dd\%[u]                      Ddu
LeximaAlterCommand dei\%[n]                     Dein
LeximaAlterCommand deinr\%[eadme]               DeinReadme
LeximaAlterCommand rg                           Rg
LeximaAlterCommand helpfu\%[lversion]           HelpfulVersion
LeximaAlterCommand copi\%[lot]                  Copilot
LeximaAlterCommand gi\%[n]                      Gin

" Original Commands
LeximaAlterCommand colo\%[rscheme]              ColorScheme
LeximaAlterCommand ra\%[ndomcolorscheme]        RandomColorScheme
LeximaAlterCommand mi\%[ninote]                 MiniNote
LeximaAlterCommand den\%[opssharedserver]       DenopsSharedServer
LeximaAlterCommand deinu\%[pdatemine]           DeinUpdateMine
LeximaAlterCommand vt\%[erminal]                VTerminal
" }}}
