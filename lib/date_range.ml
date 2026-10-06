type t = { first : Civil_date.t; last : Civil_date.t }

let make ~start ~stop =
  if Civil_date.compare start stop > 0 then Error `Reversed
  else Ok { first = start; last = stop }

let start r = r.first
let stop r = r.last
let length r = Civil_date.diff_days r.first r.last + 1

let iter r ~f =
  let rec loop d =
    f d;
    if not (Civil_date.equal d r.last) then
      match Civil_date.add_days d 1 with Some n -> loop n | None -> ()
  in
  loop r.first

let fold r ~init ~f =
  let a = ref init in
  iter r ~f:(fun d -> a := f !a d);
  !a

let to_list r = List.rev (fold r ~init:[] ~f:(fun a d -> d :: a))
