(*
   Day 5 - Cafeteria
   https://adventofcode.com/2025/day/5
   Start:  2025-12-09 01:16
   Finish: 2025-12-09 02:16, TODO
*)

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  let rec parse lines ranges_acc =
    match lines with
    | "" :: ls -> ranges_acc, List.map int_of_string ls
    | l :: ls ->
      parse
        ls
        ((match String.split_on_char '-' l |> List.map int_of_string with
          | [ x; y ] -> x, y
          | _ -> failwith ("Error parsing line " ^ l))
         :: ranges_acc)
    | [] -> failwith "Unexpected end of file."
  in
  parse (In_channel.input_lines In_channel.stdin) []
;;

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let overlap (xl, xh) (yl, yh) = xl <= yh && yl <= xh
let merge (xl, xh) (yl, yh) = min xl yl, max xh yh
let within x (yl, yh) = yl <= x && x <= yh

let part1 ranges ids =
  let rec merge_ranges ranges =
    match ranges with
    | x :: y :: rs -> if overlap x y then merge x y :: rs else y :: rs |> merge_ranges
    | _ -> ranges
  in
  let rec count_fresh ranges ids acc =
    match ranges, ids with
    | (rl, rh) :: rs, id :: idss ->
      if id < rl
      then count_fresh ranges idss acc
      else if id <= rh
      then count_fresh ranges idss (acc + 1)
      else count_fresh rs ids acc
    | _ -> acc
  in
  let ranges = List.sort (fun (xl, _) (yl, _) -> xl - yl) ranges in
  (* print_endline @@ Core.List.to_string ~f:(fun (x,y) -> string_of_int x ^ "-" ^ string_of_int y) ranges; *)
  let ids = List.sort Stdlib.compare ids in
  count_fresh ranges ids 0
;;

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 _ _ = raise (Invalid_argument "Part 2 not solved yet.")

(*(*(*(*(*(*(*(*(*( SOLVE )*)*)*)*)*)*)*)*)*)
let () =
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
  print_endline @@ string_of_int @@ (Core.Tuple2.uncurry solve) parsed_input
;;
