let g:lightline = {}

let g:lightline.colorsheme = user#colorscheme#lightline()

let g:lightline.active = {
      \ 'right': [
      \   ['lineinfo'],
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
