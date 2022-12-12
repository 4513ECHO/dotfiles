;; extends

; :execute command
((execute_statement
  (string_literal) @vim)
 (#offset! @vim 0 1 0 -1))

; command-modifiers
((unknown_builtin_statement
 (unknown_command_name) @_cmd
 (arguments) @vim)
 (#any-of? @_cmd
  "abroveleft" "belowright"
  "botright" "browse" "confirm" "hide" "keepalt"
  "keepjumps" "keepmarks" "keeppatterns" "leftabrove"
  "lockmarks" "noswapfile" "rightbelow" "silent" "tab"
  "topleft" "verbose" "vertical"
  "noautocmd" "sandbox" "unsilent"))

((comment) @jsdoc
 (function_definition)
 (#offset! @jsdoc 0 1 0 0))
