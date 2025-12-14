# Day 1 - Secret Entrance
# https://adventofcode.com/2025/day/1
#
# Start:  2025-12-14 17:15
# Finish: 2025-12-14 18:05 (part 1)
#
# Run with, e.g.:
# nix eval -f ./src/dayX.nix --arg-from-stdin input partY < ./inputs/inputX.txt
{ input, pkgs ? import <nixpkgs> { }
, utils ? import ./lib/nix/utils.nix { inherit pkgs; } }:
let
  inherit (pkgs) lib;
  inherit (utils) mod;

  DIAL_INIT = 50;
  DIAL_MOD = 100;

  parsedInput = builtins.map (line:
    let
      sign = if (builtins.substring 0 1 line == "L") then -1 else 1;
      n = lib.toIntBase10 (builtins.substring 1 (-1) line);
    in sign * n) (lib.splitString "\n" (lib.trim input));

  part1 = (moves:
    (lib.foldl (prev: dx: rec {
      pos = mod (prev.pos + dx) DIAL_MOD;
      count = prev.count + (if pos == 0 then 1 else 0);
    }) {
      pos = DIAL_INIT;
      count = 0;
    } moves).count);

in {
  inherit parsedInput;

  part1 = part1 parsedInput;
  part2 = builtins.throw "TODO: part 2 not yet done.";
}
