;; extends
(uri) @text.uri

((uri
   [ (scheme) ":" ] @conceal
   (authority
     (host) @_host))
 (#eq? @_host "github.com")
 (#set! conceal ""))
((uri
   (authority
     (host) @_host) @conceal)
 (#eq? @_host "github.com")
 (#set! conceal ""))
