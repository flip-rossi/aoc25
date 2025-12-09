include Stdlib.Array

let reduce_opt (f : 'a -> 'a -> 'a) (arr : 'a t) : 'a option =
  let rec loop i acc =
    if i >= length arr then Some acc else loop (i + 1) (f acc (get arr i))
  in
  match arr with
  | [||] -> None
  | _ -> loop 1 (get arr 0)
;;

(** @raise Invalid_argument if {!arr} is empty. *)
let rec reduce (f : 'a -> 'a -> 'a) (arr : 'a t) : 'a = Option.get (reduce_opt f arr)
