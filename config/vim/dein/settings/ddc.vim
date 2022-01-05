let s:patch_global = {}
let s:sources = ['file', 'around', 'tmux', 'buffer']
let s:sourceOptions = {}
let s:sourceParams = {}
let s:filterParams = {}

let s:sourceOptions._ = {
      \ 'ignoreCase': v:true,
      \ 'matchers': ['matcher_fuzzy'],
      \ 'sorters': ['sorter_fuzzy'],
      \ 'converters': [
      \   'converter_remove_overlap', 'converter_truncate',
      \   'converter_fuzzy'
      \ ],
      \ 'maxCandidates': 15,
      \ }
let s:sourceOptions.around = {
      \ 'mark': 'ard',
      \ 'isVolatile': v:true,
      \ 'maxCandidates': 10,
      \ }
let s:sourceOptions.file = {
      \ 'mark': 'file',
      \ 'minAutoCompleteLength': 30,
      \ 'isVolatile': v:true,
      \ 'forceCompletionPattern': '(\f*/\f*)+',
      \ }
let s:sourceOptions['vim-lsp'] = {
      \ 'mark': 'lsp',
      \ 'isVolatile': v:true,
      \ 'forceCompletionPattern': '\.\w*|:\w*|->\w*',
      \ }
let s:sourceOptions.skkeleton = {
      \ 'mark': 'skk',
      \ 'matchers': ['skkeleton'],
      \ 'sorters': [],
      \ 'converters': ['converter_remove_overlap'],
      \ 'minAutoCompleteLength': 2,
      \ }
let s:sourceOptions.necovim = {
      \ 'mark': 'vim',
      \ 'isVolatile': v:true,
      \ }
let s:sourceOptions.emoji = {
      \ 'mark': 'emoji',
      \ 'matchers': ['emoji'],
      \ 'sorters': [],
      \ }
let s:sourceOptions['cmdline-history'] = {
      \ 'mark': 'hist',
      \ 'maxCandidates': 5,
      \ }
let s:sourceOptions.buffer = {'mark': 'buf'}
let s:sourceOptions.cmdline = {'mark': 'cmd'}
let s:sourceOptions.tmux = {'mark': 'tmux'}

let s:sourceParams.around = {'maxSize': 500}
let s:sourceParams.buffer = {
      \ 'requireSameFiletype': v:false,
      \ 'fromAltBuf': v:true,
      \ }
let s:sourceParams['cmdline-history'] = {'maxSize': 100}
let s:sourceParams.tmux = {
      \ 'currentWinOnly': v:true,
      \ 'excludeCurrentPane': v:true,
      \ 'kindFormat': '#{pane_index}.#{pane_current_command}',
      \ }

let s:filterParams.converter_truncate = {'maxInfoWidth': 30}

call ddc#custom#patch_filetype(
      \ ['vim', 'toml'], {
      \ 'sources': extend(['necovim'], s:sources),
      \ })

call ddc#custom#patch_filetype(
      \ ['python', 'typescript', 'typescriptreact', 'rust'], {
      \ 'sources': extend(['vim-lsp'], s:sources),
      \ })
call ddc#custom#patch_filetype(
      \ ['markdown', 'gitcommit'], {
      \ 'sources': extend(['emoji'], s:sources),
      \ 'keywordPattern': '[a-zA-z_:]\k*',
      \ })
call ddc#custom#patch_filetype(
      \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
      \ 'sourcesOptions': {
      \   'file': {'forceCompletionPattern': '(\f*\\\f*)+'},
      \ },
      \ 'sourceParams': {
      \   'file': {'mode': 'win32'},
      \ }})

let s:patch_global.sources = s:sources
let s:patch_global.sourceOptions = s:sourceOptions
let s:patch_global.sourceParams = s:sourceParams
let s:patch_global.filterParams = s:filterParams
let s:patch_global.backspaceCompletion = v:true
let s:patch_global.specialBufferCompletion = v:true

" Use pum.vim
let s:patch_global.autoCompleteEvents = [
      \ 'InsertEnter', 'TextChangedI', 'TextChangedP',
      \ 'CmdlineEnter', 'CmdlineChanged',
      \ ]
let s:patch_global.completionMenu = 'pum.vim'

call ddc#custom#patch_global(s:patch_global)

" keymappings

call user#ddc#define_map('i', '<C-n>', 'pum#map#select_relative(+1)', '<Down>')
call user#ddc#define_map('i', '<C-p>', 'pum#map#select_relative(-1)', '<Up>')
inoremap <silent><expr> <BS> user#ddc#imap_bs()
inoremap <silent><expr> <CR> user#ddc#imap_cr()

call ddc#enable()
