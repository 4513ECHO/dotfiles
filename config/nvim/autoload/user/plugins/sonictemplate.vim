function! user#plugins#sonictemplate#help() abort
  return expand('%:t:r')->substitute('_', '-', 'g')
endfunction
