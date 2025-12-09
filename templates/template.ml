(*
   Day ${day} - ${title}
   ${url}
   Start:  ${fetch_time}
   Finish: TODO
*)
(* open! Core *)

open Lib

let ( |>> ) = Utils.( |>> )
let ( |-> ) = Utils.( |-> )

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 _ = raise (Invalid_argument "Part 1 not yet solved.")

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 _ = raise (Invalid_argument "Part 2 not yet solved.")

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  In_channel.(input_lines stdin) |> List.map (fun line -> failwith "TODO")
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
