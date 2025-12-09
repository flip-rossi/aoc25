(*
   Day 9 - Movie Theater
   https://adventofcode.com/2025/day/9
   Start:  2025-12-09 12:41
   Finish: 2025-12-09 13:09, TODO
*)
(* open! Core *)

open Lib

let area (ax, ay) (bx, by) = abs ((ax - bx + 1) * (ay - by + 1))

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 tiles =
  let rec largest tiles acc =
    match tiles with
    | a :: ts ->
      List.fold_left (fun acc b -> max acc (area a b)) 0 ts |> max acc |> largest ts
    | [] -> acc
  in
  largest tiles 0
;;

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 _ = raise (Invalid_argument "Part 2 not solved yet.")

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  In_channel.input_lines In_channel.stdin
  |> List.map (fun line ->
    match String.split_on_char ',' line with
    | [ x; y ] -> int_of_string x, int_of_string y
    | _ -> failwith ("Error parsing line " ^ line))
;;

(*(*(*(*(*(*(*(*(*( SOLVE )*)*)*)*)*)*)*)*)*)
let main () =
  let solve =
    try
      match int_of_string Sys.argv.(1) with
      | 1 -> part1
      | 2 -> part2
      | _ ->
        print_endline "Part must be 1 or 2.";
        exit 1
    with
    | Invalid_argument _ ->
      print_endline "Please specify the part to solve.";
      exit 1
  in
  print_endline @@ string_of_int @@ (* Core.Tuple2.uncurry *) solve parsed_input
;;

main ()
