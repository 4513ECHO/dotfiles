(document
  .
  (thematic_break)
  (setext_heading
    (heading_content)
    (setext_h2_underline)) @yaml
  )

; from https://github.com/monaqa/dotfiles/blob/8abb1f48/.config/nvim/after/queries/markdown/injections.scm

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(py|python)(:.*)?$")
 (#set! language "python")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(yaml|yml)(:.*)?$")
 (#set! language "yaml")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(json)(:.*)?$")
 (#set! language "json")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(sh|bash)(:.*)?$")
 (#set! language "bash")
)

(fenced_code_block
 (info_string) @lang
 (code_fence_content) @content
 (#vim-match? @lang "^(lua)(:.*)?$")
 (#set! language "lua")
)

