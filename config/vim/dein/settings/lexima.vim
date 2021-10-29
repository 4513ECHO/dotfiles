call lexima#set_default_rules()
call lexima#insmode#map_hook('before', '<CR>', '')
call lexima#insmode#map_hook('before', '<BS>', '')

call lexima#add_rule({'char': '<Tab>', 'at': '\%#)', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#"', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#''', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#]', 'leave': 1})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#}', 'leave': 1})

call lexima#add_rule({'char': '<Tab>', 'at': '%# )', 'leave': 2})
call lexima#add_rule({'char': '<Tab>', 'at': '%# "', 'leave': 2})
call lexima#add_rule({'char': '<Tab>', 'at': '%# ''', 'leave': 2})
call lexima#add_rule({'char': '<Tab>', 'at': '%# ]', 'leave': 2})
call lexima#add_rule({'char': '<Tab>', 'at': '%# }', 'leave': 2})

call lexima#add_rule({'char': '__', 'input': '__', 'input_after': '__',
      \ 'filetype': 'python'})
call lexima#add_rule({'char': '<Tab>', 'at': '\%#__', 'leave': 2,
      \ 'filetype': 'python'})

