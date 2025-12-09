let passthrough f x =
  ignore (f x);
  x
;;

let ( |>> ) x f = passthrough f x

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
