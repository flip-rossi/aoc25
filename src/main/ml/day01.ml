(*
   Day 1 - Secret Entrance
   https://adventofcode.com/2025/day/1
   Start: 2025-12-01 12:30
   Finish: TODO
*)
open! Core

let dial_init = 50
let dial_max = 100

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parse_input () =
  In_channel.input_lines In_channel.stdin
  |> List.map ~f:(fun line ->
    let n = String.slice line 1 0 |> int_of_string in
    match String.get line 0 with
    | 'L' -> -n
    | 'R' -> n
    | _ -> failwith ("Expected 'L' or 'R' as first element of line: " ^ line))
;;

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 moves =
  let _, count =
    List.fold moves ~init:(dial_init, 0) ~f:(fun (pos, count) dx ->
      let pos = (pos + dx) mod dial_max in
      let count = if pos = 0 then count + 1 else count in
      pos, count)
  in
  count
;;

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 _ = raise (Invalid_argument "Part 2 not solved yet.")

(*(*(*(*(*(*(*(*(*( SOLVE )*)*)*)*)*)*)*)*)*)
let () =
  let solve =
    try
      match int_of_string (Sys.get_argv ()).(1) with
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
  print_endline @@ string_of_int @@ (* Tuple2.uncurry *) solve (parse_input ())
;;
