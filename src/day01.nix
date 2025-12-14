# Day 1 - Secret Entrance
# https://adventofcode.com/2025/day/1
#
# Start:  2025-12-14 17:15
# Finish: 2025-12-14 18:05, 18:42
#
# Run with, e.g.:
# nix eval -f ./src/dayX.nix --arg-from-stdin input partY < ./inputs/inputX.txt
{ input, pkgs ? import <nixpkgs> { }
, utils ? import ./lib/nix { inherit pkgs; } }:
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

  part2 = (moves:
    (lib.foldl (prev: dx:
      let
        absolute_pos = prev.pos + dx;
        inc = if dx == 0 then
          0
        else if absolute_pos == 0 then
          1
        else if absolute_pos > 0 then
          absolute_pos / DIAL_MOD
        else
          ((-absolute_pos / DIAL_MOD) + (if absolute_pos == dx then 0 else 1));
      in {
        pos = mod ((mod absolute_pos DIAL_MOD) + DIAL_MOD) DIAL_MOD;
        count = prev.count + inc;
      }) {
        pos = DIAL_INIT;
        count = 0;
      } moves).count);
in {
  # Parsed input available as attribute for debugging with `nix eval`
  inherit parsedInput;

  part1 = part1 parsedInput;
  part2 = part2 parsedInput;
}
