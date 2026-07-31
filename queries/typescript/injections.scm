; extends

; upstream's gql rule only matches a call_expression whose function is a plain
; identifier, so it misses every generic form. the ts/tsx grammars parse those
; two different ways -- the same ambiguity nvim-treesitter works around for
; styled.div<T>`...`.

; gql<Type>`...` -- one type argument parses as a pair of comparisons
(binary_expression
  left: (binary_expression
    left: (identifier) @_name
    (#eq? @_name "gql"))
  right: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "graphql"))

; gql<Type, Variables>`...` -- the comma disambiguates, so this parses as a
; call on an instantiation_expression (with a MISSING "!" recovery artifact)
(call_expression
  function: (non_null_expression
    (instantiation_expression
      (identifier) @_name
      (#eq? @_name "gql")))
  arguments: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "graphql"))
