let array (item_fmt : 'a -> string) (arr : 'a array) : string =
  "[|" ^ (Array.to_seq arr |> Seq.map item_fmt |> String.concat_seq "; ") ^ "|]"
;;

let matrix (item_fmt : 'a -> string) (mat : 'a array array) : string = 
  "[|" ^ (Array.to_seq mat |> Seq.map (array item_fmt) |> String.concat_seq "\n; ") ^ "|]"

let list (item_fmt : 'a -> string) ?(sep="; ") (l : 'a list) : string =
  "[" ^ (List.to_seq l |> Seq.map item_fmt |> String.concat_seq sep) ^ "]"
