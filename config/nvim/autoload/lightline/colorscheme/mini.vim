let s:bg = ['#1d1f21', 15]
let s:fg = ['#707880', 0]

let s:p = { 'normal': {}, 'inactive': {}, 'tabline': {}}
let s:p.normal.info    = [ [ s:bg, s:fg ] ]
let s:p.normal.error   = [ [ s:bg, s:fg ] ]
let s:p.normal.warning = [ [ s:bg, s:bg ] ]
let s:p.normal.right   = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.normal.middle  = [ [ s:fg, s:bg ] ]
let s:p.normal.left  = [ [ s:bg, s:fg ], [ s:fg, s:bg ] ]
let s:p.inactive.left   = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.inactive.right  = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.inactive.middle = [ [ s:fg, s:bg ] ]
let s:p.tabline.left   = [ [ s:fg, s:bg ] ]
let s:p.tabline.tabsel = [ [ s:fg, s:bg ] ]
let s:p.tabline.middle = [ [ s:fg, s:bg ] ]
let s:p.tabline.right  = [ [ s:fg, s:bg ] ]

let g:lightline#colorscheme#mini#palette = lightline#colorscheme#flatten(s:p)
