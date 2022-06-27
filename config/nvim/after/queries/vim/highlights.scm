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

; ; <expr> mapping
; ((map_statement
;   lhs: (map_side) @_map_side
;   rhs: (ternary_expression
;     left: (string_literal) @_expr
;     right: (string_literal) @_expr))
;    (#set! @_expr @_map_side)
;    (#offset! @_expr 0 1 0 -1))
