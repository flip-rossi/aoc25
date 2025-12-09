include Stdlib.Seq

let rec reduce_opt (f : 'a -> 'a -> 'a) (seq : 'a t) : 'a option =
  match seq () with
  | Nil -> None
  | Cons (x, xs) ->
    (match xs () with
     | Nil -> Some x
     | Cons (y, xss) -> reduce_opt f (cons (f x y) xss))
;;

(** @raise Invalid_argument if {!seq} is empty. *)
let rec reduce (f : 'a -> 'a -> 'a) (seq : 'a t) : 'a = Option.get (reduce_opt f seq)
