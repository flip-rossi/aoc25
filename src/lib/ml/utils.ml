(** Applies {!x} to {!f}, ignoring its result, and returns {!x}. Same as {!( |>> )}. *)
let passthrough x f =
  ignore (f x);
  x
;;

(** Evaluates {!_}, ignoring its result, and returns {!x}. Same as {!( |-> )}. *)
let skip x _ = x

(** Applies {!x} to {!f}, ignoring its result, and returns {!x}. Same as {!passthrough}. *)
let ( |>> ) = passthrough

(** Evaluates {!_}, ignoring its result, and returns {!x}. Same as {!skip}. *)
let ( |-> ) = skip

let bin_search_all cmp arr =
  let rec loop min max found =
    if min > max
    then found
    else (
      let mid = (min + max) / 2 in
      let ord = cmp arr.(mid) in
      if ord < 0
      then loop (mid + 1) max found
      else if ord > 0
      then loop min (mid - 1) found
      else loop min (mid - 1) [] @ loop (mid + 1) max (arr.(mid) :: found))
  in
  loop 0 (Array.length arr - 1) []
;;
