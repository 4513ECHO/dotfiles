let g:lightline = {}

let g:lightline.colorscheme = user#colorscheme#lightline()

let g:lightline.active = {
      \ 'right': [
      \   ['lsp_errors', 'lsp_warnings', 'lineinfo'],
      \   ['percent'],
      \   ['colorscheme', 'fileformat', 'fileencoding', 'filetype'],
      \ ]}

let g:lightline.inactive = {
      \ 'left': [
      \   ['filename', 'modified'],
      \ ]}

let g:lightline.component_function = {
      \ 'colorscheme': 'user#lightline#colorscheme',
      \ 'fileformat': 'user#lightline#file_format',
      \ 'fileencoding': 'user#lightline#file_encoding',
      \ }

let g:lightline.component_expand = {
      \ 'lsp_errors': 'lightline_lsp#errors',
      \ 'lsp_warnings': 'lightline_lsp#warnings',
      \ }

let g:lightline.component_type = {
      \ 'lsp_errors': 'error',
      \ 'lsp_warnings': 'warning',
      \ }
