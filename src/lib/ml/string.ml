include Stdlib.String

let concat_seq (sep : t) (ss : t Seq.t) : t =
  match Seq.reduce_opt (fun acc s -> acc ^ sep ^ s) ss with
  | None -> ""
  | Some s -> s
;;

let concat_array (sep : t) (arr : t array) : t =
  concat_seq sep (Array.to_seq arr)
;;

let concat_matrix (row_sep : t) (col_sep : t) (mat : t array array) =
  concat_seq row_sep (Array.to_seq mat |> Seq.map (concat_array col_sep))
;;
