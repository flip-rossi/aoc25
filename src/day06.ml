(*
   Day 6 - Trash Compactor
   https://adventofcode.com/2025/day/6
   Start:  2025-12-09 18:45
   Finish: 2025-12-09 19:30, TODO
*)
(* open! Core *)

open Lib

let ( |>> ) = Utils.( |>> )

type op =
  | Sum
  | Mul

let op_of_string str =
  match str with
  | "+" -> Sum
  | "*" -> Mul
  | _ -> failwith "op_of_string"
;;

let identity = function
  | Sum -> 0
  | Mul -> 1
;;

let eval = function
  | Sum -> ( + )
  | Mul -> ( * )
;;

let solve op terms = List.fold_left (eval op) (identity op) terms

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 problems =
  List.fold_left (fun acc (op, terms) -> acc + solve op terms) 0 problems
;;

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 _ = raise (Invalid_argument "Part 2 not solved yet.")

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  let rec read_loop line acc =
    match In_channel.(input_line stdin) with
    | None -> acc, line
    | Some next_line -> read_loop next_line (line :: acc)
  in
  let num_lines, op_line = read_loop (Option.get In_channel.(input_line stdin)) [] in
  let open Seq in
  let nums =
    List.to_seq num_lines
    |> map (fun line ->
      String.split_on_char ' ' line
      |> List.to_seq
      |> filter_map (fun w -> if w = "" then None else Some (int_of_string w)))
    |> transpose
    |> map List.of_seq
  in
  let ops =
    String.split_on_char ' ' op_line
    |> List.filter_map (fun w -> if w = "" then None else Some (op_of_string w))
    |> List.to_seq
  in
  zip ops nums |> List.of_seq
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
