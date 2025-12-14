# Day ${day} - ${title}
# ${url}
#
# Start:  ${fetch_time}
# Finish: TODO
#
# Run with, e.g.:
# nix eval -f ./src/dayX.nix --arg-from-stdin input partY < ./inputs/inputX.txt
{ input, pkgs ? import <nixpkgs> { }
, utils ? import ./lib/nix/utils.nix { inherit pkgs; } }:
let
  inherit (pkgs) lib;

  parsedInput = builtins.map (line: builtins.throw "TODO")
    (lib.splitString "\n" (lib.trim input));

  part1 = _: builtins.throw "TODO: part 1 not yet done.";

  part2 = _: builtins.throw "TODO: part 1 not yet done.";
in {
  inherit parsedInput;

  part1 = part1 parsedInput;
  part2 = part2 parsedInput;
}
