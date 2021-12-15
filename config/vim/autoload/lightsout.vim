" color functions is based on https://github.com/cocopon/pgmnt.vim/blob/main/autoload/pgmnt/color.vim
" {{{
function! s:color_rgb(r, g, b) abort
  return printf(
        \   '#%02x%02x%02x',
        \   float2nr(a:r),
        \   float2nr(a:g),
        \   float2nr(a:b)
        \ )
endfunction

function! s:constrain(value, min, max) abort
  return (a:value < a:min)
        \ ? a:min
        \ : (a:value > a:max)
        \ ? a:max
        \ : a:value
endfunction


function! s:cycle(comp, min, max) abort
  let c = a:comp
  let result = 0.0

  if c >= 0.0 && c < 60.0
    let result = a:min + (a:max - a:min) * c / 60.0
  elseif c >= 60.0 && c < 180.0
    let result = a:max
  elseif c >= 180.0 && c < 240.0
    let result = a:min + (a:max - a:min) * (240.0 - c) / 60.0
  else
    let result = a:min
  endif

  return result * 255.0
endfunction


function! s:hex_to_rgb_comps(hex) abort
  let results = matchlist(
        \   a:hex,
        \   '^#\(\x\x\)\(\x\x\)\(\x\x\)'
        \ )
  return [
        \   str2nr(results[1], 16) * 1.0,
        \   str2nr(results[2], 16) * 1.0,
        \   str2nr(results[3], 16) * 1.0,
        \ ]
endfunction


function! s:rgb_comps_to_hsl_comps(rgb_comps) abort
  let r = s:constrain(a:rgb_comps[0] / 255.0, 0.0, 1.0)
  let g = s:constrain(a:rgb_comps[1] / 255.0, 0.0, 1.0)
  let b = s:constrain(a:rgb_comps[2] / 255.0, 0.0, 1.0)

  let max = (r > g) ? r : g
  let max = (max > b) ? max : b
  let min = (r < g) ? r : g
  let min = (min < b) ? min : b
  let c = max - min
  let h = 0.0
  let s = 0.0
  let l = (min + max) / 2.0

  if c != 0.0
    let s = (l > 0.5) ? (c / (2 - min - max)) : (c / (max + min))

    if r == max
      let h = (g - b) / c
    elseif g == max
      let h = 2.0 + (b - r) / c
    elseif b == max
      let h = 4.0 + (r - g) / c
    endif

    let h = h / 6.0 + ((h < 0) ? 1.0 : 0.0)
  endif

  return [h * 360.0, s, l]
endfunction


function! s:color_hsl(h, s, l) abort
  let h = s:constrain(a:h * 1.0, 0.0, 360.0)
  let s = s:constrain(a:s * 1.0, 0.0, 1.0)
  let l = s:constrain(a:l * 1.0, 0.0, 1.0)
  let max = (l <= 0.5)
        \ ? (l * (1.0 + s))
        \ : (l * (1.0 - s) + s)
  let min = 2.0 * l - max

  let hh = h + 120.0
  if hh >= 360.0
    let hh -= 360.0
  endif
  let r = s:cycle(hh, min, max)

  let hh = h
  if hh >= 360.0
    let hh = 0.0
  endif
  let g = s:cycle(hh, min, max)

  let hh = h - 120.0
  if hh < 0.0
    let hh += 360.0
  endif
  let b = s:cycle(hh, min, max)

  return s:color_rgb(r, g, b)
endfunction

function! lightsout#darken(hex, amount) abort
  let hsl_comps = s:rgb_comps_to_hsl_comps(
        \   s:hex_to_rgb_comps(a:hex)
        \ )
  return s:color_hsl(
        \   hsl_comps[0],
        \   hsl_comps[1],
        \   hsl_comps[2] - a:amount
        \ )
endfunction
" }}}

function lightsout#get_hl(name, attr) abort
  let raw = substitute(execute('hi ' .. a:name), '\n', '', 'g')
  let result = matchstr(raw, a:attr .. '=\zs[0-9a-fA-F#]\+\ze')
  return result
endfunction

" echo 'result:' string(lightsout#get_hl('Normal', 'guifg'))
" echo 'result:' string(lightsout#darken(lightsout#get_hl('Normal', 'guifg'), 0.1))

