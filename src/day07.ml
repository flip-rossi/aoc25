(*
   Day 7 - Laboratories
   https://adventofcode.com/2025/day/7
   Start:  2025-12-09 21:44
   Finish: 2025-12-09 22:47, 22:56
*)
(* open! Core *)

open Lib

(* open Printf *)
(* let ( |>> ) = Utils.( |>> ) *)
(* let ( |-> ) = Utils.( |-> ) *)

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 map (i0, j0) =
  let rec merge beams =
    match beams with
    | b0 :: b1 :: bs when b0 = b1 -> b0 :: merge bs
    | _ -> beams
  in
  let count = ref 0 in
  let rec loop i beams =
    let rec step beams =
      let beams = merge beams in
      match beams with
      | [] -> []
      | b :: bs ->
        if map.(i).(b)
        then (
          incr count;
          (b - 1) :: (b + 1) :: step bs)
        else b :: step bs
    in
    if i < Array.length map then loop (i + 1) (step beams)
  in
  loop i0 [ j0 ];
  !count
;;

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 map (i0, j0) =
  let rec merge beams =
    match beams with
    | (b0, t0) :: (b1, t1) :: bs when b0 = b1 -> (b0, t0 + t1) :: merge bs
    | _ -> beams
  in
  let rec loop i beams =
    let rec step beams =
      let beams = merge beams in
      match beams with
      | [] -> []
      | (b, t) :: bs ->
        if map.(i).(b) then (b - 1, t) :: (b + 1, t) :: step bs else (b, t) :: step bs
    in
    if i >= Array.length map then beams else loop (i + 1) (step beams)
  in
  loop i0 [ j0, 1 ] |> List.fold_left (fun acc (_b, t) -> acc + t) 0
;;

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  let start = ref (-1, -1) in
  let map =
    In_channel.(input_lines stdin)
    |> List.mapi (fun i line ->
      line
      |> String.to_seq
      |> Seq.mapi (fun j ->
           function
           | '.' -> false
           | '^' -> true
           | 'S' ->
             start := i, j;
             false
           | c ->
             failwith
               (Printf.sprintf "Error parsing char '%c' of at %d:%d" c (i + 1) (j + 1)))
      |> Array.of_seq)
    |> Array.of_list
    (* |>> fun (mat : bool array array) -> print_endline (Debug.matrix (fun x -> if x then "#" else ".") mat) *)
  in
  map, !start
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
