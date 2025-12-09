(*
   Day 6 - Trash Compactor
   https://adventofcode.com/2025/day/6
   Start:  2025-12-09 18:45
   Finish: 2025-12-09 19:30, 21:18
*)
(* open! Core *)

open Lib

(* let ( |>> ) = Utils.( |>> ) *)
(* let ( |-> ) = Utils.( |-> ) *)

type op =
  | Sum
  | Mul

let op_of_string_opt str =
  match str with
  | "+" -> Some Sum
  | "*" -> Some Mul
  | _ -> None
;;

let op_of_string str = Option.get (op_of_string_opt str)
let op_of_char_opt c = op_of_string_opt (String.make 1 c)

let identity = function
  | Sum -> 0
  | Mul -> 1
;;

let eval = function
  | Sum -> ( + )
  | Mul -> ( * )
;;

let solve op terms = List.fold_left (eval op) (identity op) terms

let sum_solutions problems =
  List.fold_left (fun acc (op, terms) -> acc + solve op terms) 0 problems
;;

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 num_lines ops_line =
  let problems =
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
      String.split_on_char ' ' ops_line
      |> List.filter_map (fun w -> if w = "" then None else Some (op_of_string w))
      |> List.to_seq
    in
    zip ops nums |> List.of_seq
  in
  sum_solutions problems
;;

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 term_lines ops_line =
  let int_of = function
    | ' ' -> 0
    | c -> int_of_string (String.make 1 c)
  in
  let term_lines = List.rev term_lines in
  let first_line, term_lines = List.hd term_lines, List.tl term_lines in
  let terms = String.to_seq first_line |> Seq.map int_of |> Array.of_seq in
  List.iter
    (String.iteri (fun i c -> if c != ' ' then terms.(i) <- (terms.(i) * 10) + int_of c))
    term_lines;
  let rec sum_sol i op prev curr total =
    if i >= Array.length terms
    then curr + total
    else (
      match op_of_char_opt ops_line.[i] with
      | Some op -> sum_sol (i + 1) op 0 terms.(i) (total + prev)
      | None -> sum_sol (i + 1) op curr (eval op curr terms.(i)) total)
  in
  sum_sol 0 Sum 0 0 0
;;

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  let rec read_loop line acc =
    match In_channel.(input_line stdin) with
    | None -> acc, line
    | Some next_line -> read_loop next_line (line :: acc)
  in
  let num_lines, ops_line = read_loop (Option.get In_channel.(input_line stdin)) [] in
  num_lines, ops_line
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
  print_endline @@ string_of_int @@ (Core.Tuple2.uncurry solve) parsed_input
;;

main ()
