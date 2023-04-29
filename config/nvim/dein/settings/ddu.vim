let s:patch_global = {}
let s:sourceOptions = {}
let s:sourceParams = {}
let s:filterParams = {}
let s:uiParams = {}
let s:kindOptions = {}
let s:actionOptions = {}

call ddu#custom#alias('source', 'color', 'custom-list')
call ddu#custom#alias('source', 'file_git', 'file_external')
call ddu#custom#alias('source', 'mrr', 'mr')
call ddu#custom#alias('source', 'mrw', 'mr')

let s:sourceOptions._ = #{
      \ ignoreCase: v:true,
      \ matchers: ['matcher_fzf'],
      \ }
let s:sourceOptions.dein_update = #{ matchers: ['matcher_dein_update'] }
let s:sourceOptions.file = #{ defaultAction: 'narrow' }

let s:sourceParams.ghq = #{
      \ display: 'relative',
      \ }
let s:sourceParams.file_git = #{
      \ cmd: ['git', 'ls-files', '-co', '--exclude-standard'],
      \ }
let s:sourceParams.color = #{
      \ texts: keys(user#colorscheme#get()),
      \ callbackId: denops#callback#register(
      \   { arg -> user#colorscheme#command(arg) }
      \ ),
      \ }
let s:sourceParams.mrr = #{ kind: 'mrr' }
let s:sourceParams.mrw = #{ kind: 'mrw' }
let s:sourceParams.rg = #{
      \ args: ['--json'],
      \ highlights: #{
      \   path: 'Directory',
      \   lineNr: 'LineNr',
      \   word: 'Search',
      \ },
      \ }

let s:filterParams.matcher_fzf = #{
      \ highlightMatched: 'Search',
      \ }

let s:uiParams.ff = #{
      \ floatingBorder: 'rounded',
      \ highlights: #{
      \   floating: 'Normal,EndOfBuffer:DduEndOfBuffer',
      \   floatingBorder: 'Identifier',
      \ },
      \ previewFloating: v:true,
      \ previewFloatingBorder: 'rounded',
      \ prompt: '>',
      \ split: has('nvim') ? 'floating' : 'horizontal',
      "\ NOTE: Use lightline component instead
      \ statusline: v:false,
      \ }

function! s:on_changed() abort
  if has('nvim')
    " NOTE: eob of 'fillchars' is annoying
    let bgcolor = nvim_get_hl(0, #{ name: 'Normal' })
          \ ->get('bg', 0x000000)
          \ ->printf('#%06x')
    call nvim_set_hl(0, 'DduEndOfBuffer', #{
          \ foreground: bgcolor,
          \ background: bgcolor,
          \ default: v:true,
          \ })
  endif
  let options = #{ uiParams: #{ ff: {} } }
  let options.uiParams.ff = #{
        \ previewWidth: &columns / 3 * 2,
        \ winCol: &columns / 6,
        \ winHeight: &lines / 3 * 2,
        \ winRow: &lines / 6,
        \ winWidth: &columns / 3 * 2,
        \ }
  call ddu#custom#patch_global(options)
  " call ddu#ui#do_action('updateOptions', options)
endfunction

autocmd vimrc ColorScheme,VimResized * call s:on_changed()
autocmd vimrc CursorMoved,TextChangedI ddu* call lightline#update()
call s:on_changed()

call ddu#custom#patch_local('with_preview', 'uiParams', #{
      \ ff: #{
      \   autoAction: #{ name: 'preview' },
      \   previewCol: &columns / 2,
      \   previewHeight: &lines / 3 * 2,
      \   previewRow: &lines / 6,
      \   previewSplit: 'vertical',
      \   previewWidth: &columns / 3,
      \   winWidth: &columns / 3,
      \ },
      \ })
call ddu#custom#patch_local('rg_live', #{
      \ sources: [#{
      \   name: 'rg',
      \   options: #{
      \     matchers: [],
      \     volatile: v:true,
      \   },
      \ }],
      \ uiParams: #{ ff: #{
      \   ignoreEmpty: v:false,
      \   autoResize: v:false,
      \   startFilter: v:true,
      \ } },
      \ })
call ddu#custom#patch_local('UBA', #{
      \ actionOptions: #{
      \   callback: #{ quit: v:false },
      \ },
      \ sources: [#{ name: 'color' }],
      \ uiParams: #{
      \   ff: #{
      \     autoAction: #{ name: 'itemAction' },
      \   },
      \ },
      \ })

let s:kindOptions.action = #{ defaultAction: 'do' }
let s:kindOptions.colorscheme = #{ defaultAction: 'set' }
let s:kindOptions.command_history = #{ defaultAction: 'edit' }
let s:kindOptions.dein_update = #{ defaultAction: 'viewDiff' }
let s:kindOptions.file = #{ defaultAction: 'open' }
let s:kindOptions.help = #{ defaultAction: 'open' }
let s:kindOptions.highlight = #{ defaultAction: 'edit' }
let s:kindOptions.readme_viewer = #{ defaultAction: 'open' }
let s:kindOptions.source = #{ defaultAction: 'execute' }
let s:kindOptions.url = #{ defaultAction: 'open' }
let s:kindOptions.word = #{ defaultAction: 'append' }
let s:kindOptions['custom-list'] = #{ defaultAction: 'callback' }
let s:kindOptions['ui-select'] = #{ defaultAction: 'execute' }

let s:actionOptions.echo = #{ quit: v:false }
let s:actionOptions.echoDiff = #{ quit: v:false }
let s:actionOptions.do = #{ quit: v:false }

let s:patch_global.ui = 'ff'
let s:patch_global.sourceOptions = s:sourceOptions
let s:patch_global.sourceParams = s:sourceParams
let s:patch_global.filterParams = s:filterParams
let s:patch_global.uiParams = s:uiParams
let s:patch_global.kindOptions = s:kindOptions
let s:patch_global.actionOptions = s:actionOptions
call ddu#custom#patch_global(s:patch_global)
