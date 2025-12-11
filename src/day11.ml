(*
   Day 11 - Reactor
   https://adventofcode.com/2025/day/11
   Start:  2025-12-11 12:54
   Finish: 2025-12-11 13:13, TODO
*)
(* open! Core *)

open Lib
open Printf

let ( |>> ) = Utils.( |>> )
let ( |-> ) = Utils.( |-> )

type device =
  { n_paths : int option
  ; outs : string list
  }

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 devices =
  let rec paths_from dev =
    let {n_paths; outs} = Hashtbl.find devices dev in
    match n_paths with
    | Some count -> count
    | None -> List.fold_left (fun acc dev -> acc + paths_from dev) 0 outs
  in
  paths_from "you"


(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 _ = raise (Invalid_argument "Part 2 not yet solved.")

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  let devices = Hashtbl.create 700 in
  In_channel.(input_lines stdin)
  |> List.iter (fun line ->
    match String.split_on_char ' ' line with
    | [] -> failwith ("Error parsing line " ^ line)
    | dev :: outs ->
      Hashtbl.add
        devices
        (String.sub dev 0 (String.length dev - 1))
        { n_paths = None; outs });
  Hashtbl.add devices "out" { n_paths = Some 1; outs = [] };
  devices
;;

(*(*(*(*(*(*(*(*(*( SOLVE )*)*)*)*)*)*)*)*)*)
let main () =
  let solve =
    try
      match int_of_string Sys.argv.(1) with
      | 1 -> part1
      | 2 -> part2
      | _ ->
        Printf.eprintf "Part must be 1 or 2.\n";
        exit 1
    with
    | Invalid_argument _ ->
      Printf.eprintf "Please specify the part to solve.\n";
      exit 1
  in
  print_endline @@ string_of_int @@ (* Core.Tuple2.uncurry *) solve parsed_input
;;

main ()
