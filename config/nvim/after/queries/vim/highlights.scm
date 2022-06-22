[
 "echohl"
 "echon"
 "filetype"
] @keyword

(filetype_statement [
  "detect"
  "indent"
  "plugin"
] @keyword)
(filetype_statement (state) @constant)

; Literal Dictionary

(literal_dictionary
  key: (literal_key) @field)

[
  "#{"
] @punctuation.bracket

; Function Options

((set_item
   option: (option_name) @_option
   value: (set_value) @function)
  (#any-of? @_option
    "balloonexpr" "bexpr"
    "diffexpr" "dex"
    "foldexpr" "fde"
    "formatexpr" "fex"
    "includeexpr" "inex"
    "indentexpr" "inde"
    "modelineexpr" "mle"
    "patchexpr" "pex"))
