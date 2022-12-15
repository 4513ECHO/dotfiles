let s:patch_global = {}
let s:sources = ['file', 'around', 'vsnip', 'tmux', 'buffer']
let s:sourceOptions = {}
let s:sourceParams = {}
let s:filterParams = {}

let s:sourceOptions._ = {
      \ 'ignoreCase': v:true,
      \ 'matchers': ['matcher_fuzzy'],
      \ 'sorters': ['sorter_fuzzy'],
      \ 'converters': [
      \   'converter_remove_overlap',
      \   'converter_truncate',
      \   'converter_fuzzy',
      \ ],
      \ 'maxItems': 10,
      \ }
let s:sourceOptions.around = {
      \ 'mark': '[ard]',
      \ 'isVolatile': v:true,
      \ 'maxItems': 8,
      \ }
let s:sourceOptions.file = {
      \ 'mark': '[file]',
      \ 'minAutoCompleteLength': 30,
      \ 'isVolatile': v:true,
      \ 'forceCompletionPattern': '[\w@:~._-]/[\w@:~._-]*',
      \ }
let s:sourceOptions['vim-lsp'] = {
      \ 'mark': '[lsp]',
      \ 'isVolatile': v:true,
      \ 'forceCompletionPattern': '\.|:\s*|->\s*',
      \ }
let s:sourceOptions.skkeleton = {
      \ 'mark': '[skk]',
      \ 'matchers': ['skkeleton'],
      \ 'sorters': [],
      \ 'converters': [],
      \ 'minAutoCompleteLength': 1,
      \ 'isVolatile': v:true,
      \ }
let s:sourceOptions.necovim = {
      \ 'mark': '[vim]',
      \ 'isVolatile': v:true,
      \ 'maxItems': 8,
      \ }
let s:sourceOptions.vsnip = {
      \ 'mark': '[snip]',
      \ 'dup': v:true,
      \ }
let s:sourceOptions.zsh = {
      \ 'mark': '[zsh]',
      \ 'isVolatile': v:true,
      \ 'forceCompletionPattern': '[\w@:~._-]/[\w@:~._-]*',
      \ 'maxItems': 8,
      \ }
let s:sourceOptions.nextword = {
      \ 'mark': '[word]',
      \ 'minAutoCompleteLength': 3,
      \ 'isVolatile': v:true,
      \ }
let s:sourceOptions.github_issue = {
      \ 'mark': '[issue]',
      \ 'forceCompletionPattern': '#\d*',
      \ }
let s:sourceOptions.github_pull_request = {
      \ 'mark': '[PR]',
      \ 'forceCompletionPattern': '#\d*',
      \ }
let s:sourceOptions.cmdline = {
      \ 'mark': '[cmd]',
      \ 'isVolatile': v:true,
      \ }
let s:sourceOptions.buffer = {'mark': '[buf]'}
let s:sourceOptions.tmux = {'mark': '[tmux]'}
let s:sourceOptions.omni = {'mark': '[omni]'}
let s:sourceOptions.line = {'mark': '[line]'}

let s:sourceParams.around = {'maxSize': 500}
let s:sourceParams.buffer = {
      \ 'requireSameFiletype': v:false,
      \ 'fromAltBuf': v:true,
      \ 'bufNameStyle': 'basename',
      \ }
let s:sourceParams.file = {
      \ 'trailingSlash': v:true,
      \ 'followSymlinks': v:true,
      \ }
let s:sourceParams.tmux = {
      \ 'currentWinOnly': v:true,
      \ 'excludeCurrentPane': v:true,
      \ 'kindFormat': '#{pane_index}.#{pane_current_command}',
      \ }
let s:sourceParams['vim-lsp'] = {
      \ 'ignoreCompleteProvider': v:true,
      \ }

let s:filterParams.converter_truncate = {
      \ 'maxAbbrWidth': 40,
      \ 'maxInfoWidth': 40,
      \ 'maxKindWidth': 20,
      \ 'maxMenuWidth': 20,
      \ 'ellipsis': '..',
      \ }

call ddc#custom#patch_filetype(
      \ ['vim'], {
      \ 'sources': extend(['necovim'], s:sources),
      \ })
call ddc#custom#patch_filetype(
      \ ['toml'], {
      \ 'sourceOptions': {
      \   'vim-lsp': {'forceCompletionPattern': '\.|[={[,"]\s*'},
      \ }})
call ddc#custom#patch_filetype(
      \ ['python', 'typescript', 'typescriptreact', 'rust', 'markdown', 'yaml',
      \ 'json', 'sh', 'lua', 'toml', 'go'], {
      \ 'sources': extend(['vim-lsp'], s:sources),
      \ })
call ddc#custom#patch_filetype(
      \ ['markdown', 'gitcommit', 'help'], {
      \ 'sources': extend([
      \   'nextword',
      \   'github_issue', 'github_pull_request',
      \ ], s:sources),
      \ 'keywordPattern': '[a-zA-Z_:#]\k*',
      \ })
call ddc#custom#patch_filetype(
      \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
      \ 'sourcesOptions': {
      \   'file': {'forceCompletionPattern': '[\w@:~._-]\\[\w@:~._-*'},
      \ },
      \ 'sourceParams': {
      \   'file': {'mode': 'win32'},
      \ }})
call ddc#custom#patch_filetype(
      \ ['ddu-ff-filter'], {
      \ 'sources': [],
      \ })
call ddc#custom#patch_filetype(
      \ ['sh', 'zsh'], {
      \ 'sources': extend(['zsh'], s:sources),
      \ })

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
let s:patch_global.ui = 'pum'

call ddc#custom#patch_global(s:patch_global)

" key mappings
inoremap <silent><expr> <C-n> pum#visible() ? '<Cmd>call pum#map#select_relative(+1)<CR>' : '<Down>'
inoremap <silent><expr> <C-p> pum#visible() ? '<Cmd>call pum#map#select_relative(-1)<CR>' : '<Up>'
" NOTE: define these in hook_source to ensure it is loaded after lexima.vim is sourced
inoremap <silent><expr> <BS> pum#visible() ? '<Cmd>call pum#map#cancel()<CR>'  : lexima#expand('<lt>BS>', 'i')
inoremap <silent><expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<lt>CR>', 'i')
cnoremap         <expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : lexima#expand('<lt>CR>', ':')
" emulate default mappings (see `:help ins-completion`)
inoremap <silent><expr> <C-x><C-l> ddc#map#manual_complete('line')
inoremap <silent><expr> <C-x><C-n> ddc#map#manual_complete('around')
inoremap <silent><expr> <C-x><C-f> ddc#map#manual_complete('file')
inoremap <silent><expr> <C-x><C-d> ddc#map#manual_complete('vim-lsp')
inoremap <silent><expr> <C-x><C-v> ddc#map#manual_complete('cmdline')
inoremap <silent><expr> <C-x><C-u> ddc#map#manual_complete()
inoremap <silent><expr> <C-x><C-o> ddc#map#manual_complete('omni')
inoremap <silent><expr> <C-x><C-s> ddc#map#manual_complete('nextword')

function! s:on_gh() abort
  if fnamemodify(bufname(), ':h') ==# '/tmp' && getcwd() !=# '/tmp'
    inoremap <silent><expr><buffer> <C-x><C-g>
          \ ddc#map#manual_complete(['github_issue', 'github_pull_request'])
  endif
endfunction
autocmd vimrc FileType markdown call <SID>on_gh()

call ddc#enable()
