(*
   Day 10 - Factory
   https://adventofcode.com/2025/day/10
   Start:  2025-12-10 11:54
   Finish: 2025-12-10 13:04
*)
(* open! Core *)

open Lib
open Printf

(** {!Lib.Utils.( |>> )} *)
let ( |>> ) = Utils.( |>> )

(** {!Lib.Utils.( |-> )} *)
let ( |-> ) = Utils.( |-> )

type machine =
  { lightreq : int
  ; buttons : int list
  ; joltreq : int list
  }

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
    (Debug.list int2bin buttons)
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
      acc + Option.get (min_switches lightreq buttons))
    0
    machines
;;

(** {!o |? f} is {!Option.map f o}. *)
let ( |? ) o f = Option.map f o

(** {!o |?* f} is {!Option.bind o f}, or {!Option.join (o |? f)}. *)
let ( |?* ) = Option.bind

(** {!let} binding for {!Option.bind}. *)
let ( let* ) = Option.bind

(*(*(*(*(*(*(*(*(*( PART 2 )*)*)*)*)*)*)*)*)*)
let part2 machines =
  let max_presses btn jolts =
    let rec loop btn jolts acc =
      match jolts with
      | j :: js -> loop (btn lsr 1) js (if btn land 1 = 1 then min acc j else acc)
      | [] -> acc
    in
    loop btn jolts Int.max_int
    (* |>> *)
    (* printf *)
    (*   "max_presses of %s on %s is %d\n" *)
    (*   (int2bin btn) *)
    (*   (Debug.list string_of_int jolts) *)
  in
  let rec dec_jolt btn joltage amount =
    match joltage with
    | [] -> []
    | j :: js ->
      if btn = 0
      then joltage
      else (
        let new_j = j - (btn land 1 * amount) in
        if new_j < 0
        then failwith "Not supposed to happen..."
        else (
          let new_js = dec_jolt (btn lsr 1) js amount in
          new_j :: new_js))
  in
  let dbg_req = ref 0 in
  let rec min_switches buttons joltage =
    if List.for_all (( = ) 0) joltage
    then Some 0
    else (
      match buttons with
      | b :: bn :: bs ->
        (* let rec try_with_presses n = *)
        (*   if n = 0 *)
        (*   then min_switches bs joltage *)
        (*   else ( *)
        (*     let new_jolts = dec_jolt b joltage n in *)
        (*     (* printf "New jolts: %s\n" (Debug.list string_of_int new_jolts); *) *)
        (*     match min_switches bs new_jolts with *)
        (*     | None -> *)
        (*       (* printf "%s * %d failed\n" (int2bin b) n; *) *)
        (*       try_with_presses (n - 1) *)
        (*     | Some x -> Some (x + n)) *)
        (* in *)
        (* try_with_presses (max_presses b joltage) *)
        let new_jolts = dec_jolt b joltage (max_presses b joltage) in
        (match min_switches (bn :: bs) new_jolts with
         | None -> min_switches (bn :: b :: bs) joltage
          | x -> x
        )
      | [ b ] ->
        let new_jolts = dec_jolt b joltage (max_presses b joltage) in
        if List.for_all (( = ) 0) new_jolts then Some 0 else None
      | [] -> None)
  in
  let btn_size max b =
    let rec loop max b size =
      if max = 0 then size else loop (max - 1) (b lsr 1) (size + (b land 1))
    in
    loop max b 0 (* |>> printf "btn:%s size:%d\n" (int2bin b) *)
  in
  List.fold_left
    (fun acc { lightreq; buttons; joltreq } ->
      let len = List.length joltreq in
      let buttons =
        List.sort
          (fun a b -> (* Largest to smallest *) btn_size len b - btn_size len a)
          buttons
      in
      dbg_req := lightreq;
      acc
      + (Option.get (min_switches buttons joltreq)
         |>> printf "FOR %s GOT %d\n" (int2bin lightreq)))
    0
    machines
;;

(*(*(*(*(*(*(*(*(*( PARSE INPUT )*)*)*)*)*)*)*)*)*)
let parsed_input =
  let parse_button s =
    String.sub s 1 (String.length s - 2)
    |> String.split_on_char ','
    |> List.fold_left
         (fun acc xstr ->
           let x = int_of_string xstr in
           acc + (1 lsl x))
         0
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
  print_endline @@ string_of_int @@ (* Core.Tuple2.uncurry *) solve parsed_input
;;

main ()
