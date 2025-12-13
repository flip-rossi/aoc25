(*
   Day 10 - Factory
   https://adventofcode.com/2025/day/10
   Start:  2025-12-10 11:54
   Finish: 2025-12-10 13:04, 2025-12-13 14:06
*)

open Lib
open Printf

(** {!Lib.Utils.( |>> )} *)
let ( |>> ) = Utils.( |>> )

(** {!Lib.Utils.( |-> )} *)
let ( |-> ) = Utils.( |-> )

type machine =
  { lightreq : int
  ; buttons : int list list
  ; joltreq : int list
  }

let buttons_to_bin = List.map (List.fold_left (fun acc x -> acc + (1 lsl x)) 0)
let int_size = Sys.word_size - 1

(** @author nojb from https://discuss.ocaml.org/t/pretty-printing-binary-ints/9062/7 *)
let int2bin =
  let buf = Bytes.create int_size in
  fun n ->
    for i = 0 to int_size - 1 do
      let pos = int_size - 1 - i in
      Bytes.set buf pos (if n land (1 lsl i) != 0 then '1' else '0')
    done;
    (* skip leading zeros *)
    match Bytes.index_opt buf '1' with
    | None -> "0b0"
    | Some i -> "0b" ^ Bytes.sub_string buf i (int_size - i)
;;

let string_of_machine { lightreq; buttons; joltreq } =
  Printf.sprintf
    "{ lightreq:%s; buttons:%s; joltreq:%s }"
    (int2bin lightreq)
    (Debug.list int2bin (buttons_to_bin buttons))
    (Debug.list string_of_int joltreq)
;;

(*(*(*(*(*(*(*(*(*( PART 1 )*)*)*)*)*)*)*)*)*)
let part1 machines =
  (* let req = ref 0 in *)
  let rec min_switches goal buttons =
    if goal = 0
    then (* printf "FOUND GOAL FOR %s!\n" (int2bin !req); *)
      Some 0
    else (
      match buttons with
      | b :: bs ->
        (match
           (* printf "%s SWITCH %s = %s\n" (int2bin goal) (int2bin b) (int2bin (goal lxor b)); *)
           min_switches (goal lxor b) bs, min_switches goal bs
         with
         | Some x, Some y -> Some (min (1 + x) y)
         | Some x, None -> Some (1 + x)
         | None, Some y -> Some y
         | _ -> None)
      | [] -> None)
  in
  List.fold_left
    (fun acc { lightreq; buttons; _ } ->
       (* req := lightreq; *)
       acc + Option.get (min_switches lightreq (buttons_to_bin buttons)))
    0
    machines
;;

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 machines =
  (* Z3 OCaml docs: https://z3prover.github.io/api/html/ml/Z3.html *)
  let open Z3 in
  let module Arith = Z3.Arithmetic in
  (* let cfg = [ "model", "true"; "proof", "false" ] in *)
  let cfg = [] in
  let ctx = mk_context cfg in
  let intsort = Arith.Integer.mk_sort ctx in
  let zero = Arith.Integer.mk_numeral_i ctx 0 in
  let solve_machine { buttons; joltreq; _ } =
    let consts =
      List.to_seq buttons
      |> Stdlib.Seq.mapi (fun i _b ->
        let sym = Symbol.mk_int ctx i in
        Expr.mk_const ctx sym intsort)
      |> List.of_seq
    in
    let eqs =
      List.to_seq joltreq
      |> Stdlib.Seq.(
           mapi (fun i jolt ->
             Boolean.mk_eq
               ctx
               (Arith.Integer.mk_numeral_i ctx jolt)
               (Arith.mk_add
                  ctx
                  (zip (List.to_seq buttons) (List.to_seq consts)
                   |> filter_map (fun (btn, const) ->
                     if List.exists (( = ) i) btn then Some const else None)
                   |> List.of_seq))))
      |> List.of_seq
    in
    let opt = Optimize.mk_opt ctx in
    Optimize.add opt (List.map (fun const -> Arith.mk_ge ctx const zero) consts);
    Optimize.add opt eqs;
    let handle = Optimize.minimize opt (Arith.mk_add ctx consts) in
    let _status = Optimize.check opt in
    let lower = Optimize.get_lower handle in
    (* printf "lower %s\n" (Expr.to_string lower); *)
    int_of_string (Expr.to_string lower)
  in
  List.fold_left (fun acc m -> acc + solve_machine m) 0 machines
;;

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  let parse_button s =
    String.sub s 1 (String.length s - 2)
    |> String.split_on_char ','
    |> List.map int_of_string
  in
  let parse_jolt s =
    String.sub s 1 (String.length s - 2)
    |> String.split_on_char ','
    |> List.map int_of_string
  in
  let parse_line line =
    let ss = String.split_on_char ' ' line in
    let lightstr = List.hd ss in
    let lightstr = String.sub lightstr 1 (String.length lightstr - 2) in
    let lightreq =
      String.fold_right
        (fun c acc ->
           (acc lsl 1)
           +
           match c with
           | '.' -> 0
           | '#' -> 1
           | _ -> failwith "Error parsing light requirement.")
        lightstr
        0
    in
    let ss = List.tl ss in
    let buttons, joltreq =
      List.to_seq ss
      |> Seq.fold_lefti
           (fun (accbs, accj) i s ->
              if i == List.length ss - 1
              then accbs, parse_jolt s
              else parse_button s :: accbs, accj)
           ([], [])
    in
    { lightreq; buttons; joltreq } |>> fun m -> print_endline @@ string_of_machine m
  in
  In_channel.(input_lines stdin) |> List.map parse_line
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
  print_endline
  @@ string_of_int
  @@
  (* Core.Tuple2.uncurry *)
  solve parsed_input
;;

main ()
