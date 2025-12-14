{ pkgs ? import <nixpkgs> { } }:
let inherit (pkgs) lib;
in {
  mod = x: y: x - (builtins.div x y) * y;
}
