include Stdlib.List

let rec reduce_opt (f : 'a -> 'a -> 'a) (l : 'a t) : 'a option =
  match l with
  | [] -> None
  | [ x ] -> Some x
  | x :: y :: xs -> reduce_opt f (f x y :: xs)
;;

(** @raise Invalid_argument if {!l} is empty. *)
let rec reduce (f : 'a -> 'a -> 'a) (l : 'a t) : 'a = Option.get (reduce_opt f l)
