let s:patch_global = {}
let s:sources = ['file', 'around', 'buffer']
let s:sourceOptions = {}
let s:sourceParams = {}
let s:filterParams = {}

let s:sourceOptions._ = {
      \ 'ignoreCase': v:true,
      \ 'matchers': ['matcher_fuzzy'],
      \ 'sorters': ['sorter_fuzzy'],
      \ 'converters': ['converter_remove_overlap', 'converter_truncate',
      \                'converter_fuzzy'],
      \ 'maxCandidates': 15,
      \ }


let s:sourceOptions.around = {
      \ 'mark': 'ard',
      \ 'minAutoCompleteLength': 3,
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

let s:sourceOptions.necovim = {'mark': 'vim'}
let s:sourceOptions.skkeleton = {
      \ 'mark': 'skk',
      \ 'matchers': ['skkeleton'],
      \ 'sorters': [],
      \ 'converters': ['converter_remove_overlap'],
      \ 'minAutoCompleteLength': 2,
      \ }

let s:sourceOptions.buffer = {'mark': 'buf'}
" let s:sourceOptions['cmdline-history'] = {'mark': 'hist'}
let s:sourceOptions.cmdline = {'mark': 'cmd'}

let s:sourceParams.around = {'maxSize': 500}
let s:sourceParams.buffer = {
      \ 'requireSameFiletype': v:false,
      \ 'fromAltBuf': v:true,
      \ }
" let s:sourceParams['cmdline-history'] = {'maxSize': 100}

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

" Use pum.vim
let s:patch_global.autoCompleteEvents = [
      \ 'InsertEnter', 'TextChangedI', 'TextChangedP',
      \ 'CmdlineEnter', 'CmdlineChanged',
      \ ]

let s:patch_global.completionMenu = 'pum.vim'

call ddc#custom#patch_global(s:patch_global)

" keymappings

inoremap <silent><expr> <C-n>
      \ pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>'
      \ : ddc#manual_complete()
inoremap <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <silent><expr> <BS> user#ddc#imap_bs()
inoremap <silent><expr> <CR> user#ddc#imap_cr()
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>

call ddc#enable()
