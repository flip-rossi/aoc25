(*
   Day 11 - Reactor
   https://adventofcode.com/2025/day/11
   Start:  2025-12-11 12:54
   Finish: 2025-12-11 13:13, 14:06
*)

open Lib
(* open Printf *)

(* let ( |>> ) = Utils.( |>> ) *)
(* let ( |-> ) = Utils.( |-> ) *)

type device =
  { n_paths : int option
  ; outs : string list
  }

let rec paths_from devices dev =
  let { n_paths; outs } = Hashtbl.find devices dev in
  match n_paths with
  | Some count -> count
  | None ->
    let n_paths = List.fold_left (fun acc d -> acc + paths_from devices d) 0 outs in
    Hashtbl.replace devices dev { n_paths = Some n_paths; outs };
    n_paths
;;

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 devices = paths_from devices "you"

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 devices =
  let rec has_path_to_fft dev =
    if dev = "fft"
    then true
    else (
      let { outs; _ } = Hashtbl.find devices dev in
      if outs = []
      then false
      else List.fold_left (fun acc dev -> acc || has_path_to_fft dev) false outs)
  in
  let cancel_found_devices new_goal base_n =
    Hashtbl.filter_map_inplace
      (fun _dev { n_paths; outs } ->
        match n_paths with
        | None -> Some { n_paths; outs }
        | Some _ -> Some { n_paths = Some 0; outs })
      devices;
    Hashtbl.replace devices new_goal { n_paths = Some base_n; outs = [] }
  in
  let first, second = if has_path_to_fft "dac" then "dac", "fft" else "fft", "dac" in
  cancel_found_devices second (paths_from devices second);
  cancel_found_devices first (paths_from devices first);
  paths_from devices "svr"
;;

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
