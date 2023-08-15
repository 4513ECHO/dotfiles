;; extends

; :execute command
((execute_statement
  (string_literal) @injection.content)
 (#set! injection.language "vim")
 (#offset! @injection.content 0 1 0 -1))

; command-modifiers
((unknown_builtin_statement
 (unknown_command_name) @_cmd
 (arguments) @injection.content)
 (#any-of? @_cmd
  "abroveleft" "belowright"
  "botright" "browse" "confirm" "hide" "keepalt"
  "keepjumps" "keepmarks" "keeppatterns" "leftabrove"
  "lockmarks" "noswapfile" "rightbelow" "silent" "tab"
  "topleft" "verbose" "vertical"
  "noautocmd" "sandbox" "unsilent")
 (#set! injection.language "vim"))

((comment) @injection.content
 (function_definition)
 (#set! injection.language "jsdoc")
 (#offset! @injection.content 0 1 0 0))
