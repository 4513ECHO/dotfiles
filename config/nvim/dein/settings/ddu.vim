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

let s:sourceOptions._ = {
      \ 'ignoreCase': v:true,
      \ 'matchers': ['matcher_fzf'],
      \ }
let s:sourceOptions.file_old = {
      \ 'matchers': ['matcher_fzf', 'matcher_hidden'],
      \ }
let s:sourceOptions.file_external = {
      \ 'matchers': ['matcher_fzf', 'matcher_hidden'],
      \ }
let s:sourceOptions.dein_update = {
      \ 'matchers': ['matcher_dein_update'],
      \ }

let s:sourceParams.ghq = {
      \ 'display': 'relative',
      \ }
let s:sourceParams.file_git = {
      \ 'cmd': ['git', 'ls-files', '-co', '--exclude-standard'],
      \ }
let s:sourceParams.color = {
      \ 'texts': keys(user#colorscheme#get()),
      \ 'callbackId': denops#callback#register(
      \   { arg -> user#colorscheme#command(arg) }
      \ ),
      \ }
let s:sourceParams.mrr = {'kind': 'mrr'}
let s:sourceParams.mrw = {'kind': 'mrw'}

let s:filterParams.matcher_fzf = {
      \ 'highlightMatched': 'Search',
      \ }

let s:uiParams.ff = {
      \ 'floatingBorder': 'rounded',
      \ 'previewFloating': v:true,
      \ 'previewWidth': &columns / 3 * 2,
      \ 'prompt': '>',
      \ 'split': has('nvim') ? 'floating' : 'horizontal',
      \ 'statusline': v:false,
      \ 'winCol': &columns / 6,
      \ 'winHeight': &lines / 2,
      \ 'winRow': &lines / 4,
      \ 'winWidth': &columns / 3 * 2,
      \ }
autocmd vimrc VimResized * call ddu#custom#patch_global('uiParams', {'ff': {
      \ 'previewWidth': &columns / 3 * 2,
      \ 'winCol': &columns / 6,
      \ 'winHeight': &lines / 2,
      \ 'winRow': &lines / 4,
      \ 'winWidth': &columns / 3 * 2,
      \ }})
autocmd vimrc TextChangedI,CursorMoved ddu*
      \ : if get(g:, 'loaded_lightline', v:false)
      \ |   call lightline#update()
      \ | endif

let s:kindOptions.action = {'defaultAction': 'do'}
let s:kindOptions.colorscheme = {'defaultAction': 'set'}
let s:kindOptions.command_history = {'defaultAction': 'edit'}
let s:kindOptions.dein_update = {'defaultAction': 'viewDiff'}
let s:kindOptions.file = {'defaultAction': 'open'}
let s:kindOptions.help = {'defaultAction': 'open'}
let s:kindOptions.highlight = {'defaultAction': 'edit'}
let s:kindOptions.readme_viewer = {'defaultAction': 'open'}
let s:kindOptions.source = {'defaultAction': 'execute'}
let s:kindOptions.url = {'defaultAction': 'open'}
let s:kindOptions.word = {'defaultAction': 'append'}
let s:kindOptions['custom-list'] = {'defaultAction': 'callback'}

let s:actionOptions.echo = {'quit': v:false}
let s:actionOptions.echoDiff = {'quit': v:false}

let s:patch_global.ui = 'ff'
let s:patch_global.sourceOptions = s:sourceOptions
let s:patch_global.sourceParams = s:sourceParams
let s:patch_global.filterParams = s:filterParams
let s:patch_global.uiParams = s:uiParams
let s:patch_global.kindOptions = s:kindOptions
let s:patch_global.actionOptions = s:actionOptions
call ddu#custom#patch_global(s:patch_global)
