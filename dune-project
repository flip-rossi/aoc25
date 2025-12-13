(lang dune 3.16)

(name aoc25)

(generate_opam_files true)

(package
 (name aoc25)
 (depends
   ocaml dune
   core
   ; menhir ocamllex
   ; re2
   ; ppx_hash
   z3))

; (using menhir 3.0)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
