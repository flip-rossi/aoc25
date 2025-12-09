let array (fmt : 'a -> string) (arr : 'a array) : string =
  "[" ^ (Array.to_seq arr |> Seq.map fmt |> String.concat_seq "; ") ^ "]"
;;

let matrix (fmt : 'a -> string) (mat : 'a array array) : string = 
  "[ " ^ (Array.to_seq mat |> Seq.map (array fmt) |> String.concat_seq "\n; ") ^ " ]"

