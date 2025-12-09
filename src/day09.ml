(*
   Day 9 - Movie Theater
   https://adventofcode.com/2025/day/9
   Start:  2025-12-09 12:41
   Finish: 2025-12-09 13:09, 16:45
*)

(* open! Core *)
open! Lib

(* let ( |>> ) = Utils.( |>> ) *)
let area (ax, ay) (bx, by) = (abs (ax - bx) + 1) * (abs (ay - by) + 1)

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

(* There was no need to check for whether the area was in a concave section! *)
let part2 tiles =
  let first_tile = List.hd tiles in
  let rec get_lines tiles (horis, verts) =
    match tiles with
    | (ax, ay) :: (bx, by) :: ts when ax = bx ->
      get_lines ((bx, by) :: ts) (horis, (ax, min ay by, max ay by) :: verts)
    | (ax, ay) :: (bx, by) :: ts when ay = by ->
      get_lines ((bx, by) :: ts) ((ay, min ax bx, max ax bx) :: horis, verts)
    | [ a ] when a <> first_tile -> get_lines [ a; first_tile ] (horis, verts)
    | [ _ ] -> horis, verts
    | [] -> horis, verts
    | _ -> failwith "Error getting lines"
  in
  let horis, vertis =
    let horisl, vertsl = get_lines tiles ([], []) in
    Array.of_list horisl, Array.of_list vertsl
  in
  let cmp (x, _, _) (y, _, _) = x - y in
  Array.sort cmp horis;
  Array.sort cmp vertis;
  (* let tostr l1 l2 (x, yl, yh) = Printf.sprintf "%s:%d %s:%d-%d" l1 x l2 yl yh in *)
  (* Array.iter (fun line -> print_endline (tostr "y" "x" line)) horis; Array.iter (fun line -> print_endline (tostr "x" "y" line)) vertis; *)
  let inside (ax, ay) (bx, by) =
    let top, left, bottom, right = min ay by, min ax bx, max ay by, max ax bx in
    let mk_cmp low high (x, _, _) = if x <= low then -1 else if high <= x then 1 else 0 in
    let intersects low high (_, x0, x1) =
      x0 < high && low < x1
      (* |>> function true -> Printf.printf "Intersects %d %d-%d\n" x x0 x1 | false -> () *)
    in
    Utils.bin_search_all (mk_cmp top bottom) horis
    (* |>> (fun x -> Printf.printf "(%d,%d)-(%d,%d) found [%s]\n" left top right bottom (String.concat "; " (List.map (tostr "y" "x") x))) *)
    |> List.exists (intersects left right)
    |> not
    && Utils.bin_search_all (mk_cmp left right) vertis
       (* |>> (fun x -> Printf.printf "(%d,%d)-(%d,%d) found [%s]\n" left top right bottom (String.concat "; " (List.map (tostr "x" "y") x))) *)
       |> List.exists (intersects top bottom)
       |> not
  in
  let rec largest tiles acc =
    match tiles with
    | a :: ts ->
      List.fold_left
        (fun acc b ->
          if inside a b
          then
            (* let (ax, ay), (bx, by) = a, b in Printf.printf "Getting area (%d,%d)*(%d,%d)=%d\n" ax ay bx by (area a b); *)
            max acc (area a b)
          else acc)
        0
        ts
      |> max acc
      |> largest ts
    | [] -> acc
  in
  largest tiles 0
;;

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  In_channel.input_lines In_channel.stdin
  |> List.map (fun line ->
    match String.split_on_char ',' line |> List.map int_of_string with
    | [ x; y ] -> x, y
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
