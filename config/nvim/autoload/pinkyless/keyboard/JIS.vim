let s:keyboard = {}
let s:symbol_map = {
      \ ';': '+',
      \ '1': '!', '2': '"', '3': '#', '4': '$', '5': '%',
      \ '6': '&', '7': "'", '8': '(', '9': ')',
      \ ',': '<', '.': '>', '/': '?', '-': '=', '^': '~',
      \ '[': '{', ']': '}', '@': '`', ':': '*', '¥': '|',
      \ }
let s:symbol_map_r = pinkyless#util#swap(s:symbol_map)

function! s:keyboard.shift(char) abort
  return a:char =~# '\l'
        \ ? toupper(a:char)
        \ : s:symbol_map->get(a:char, a:char)
endfunction

function! s:keyboard.unshift(char) abort
  return a:char =~# '\L'
        \ ? tolower(a:char)
        \ : s:symbol_map_r->get(a:char, a:char)
endfunction

function! s:keyboard.swap(char) abort
  return index(self.keys(), a:char) < 0
        \ ? self.unshift(a:char)
        \ : self.shift(a:char)
endfunction

let s:keys = split('abcdefghijklmnopqrstuvwxyz', '\zs')->extend(keys(s:symbol_map))
function! s:keyboard.keys() abort
  return s:keys
endfunction

let s:shift_keys = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '\zs')->extend(values(s:symbol_map))
function! s:keyboard.shift_keys() abort
  return s:shift_keys
endfunction

function! pinkyless#keyboard#JIS#define() abort
  return s:keyboard
endfunction
