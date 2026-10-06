type t = { year : int; month : int; day : int }

type error =
  | Invalid_year of int
  | Invalid_month of int
  | Invalid_day of { year : int; month : int; day : int }

let year d = d.year
let month d = d.month
let day d = d.day
let is_leap_year y = y mod 4 = 0 && (y mod 100 <> 0 || y mod 400 = 0)

let days_in_month ~year:y ~month:m =
  match m with
  | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
  | 4 | 6 | 9 | 11 -> 30
  | 2 -> if is_leap_year y then 29 else 28
  | _ -> 0

let make ~year ~month ~day =
  if year < 1 || year > 9999 then Error (Invalid_year year)
  else if month < 1 || month > 12 then Error (Invalid_month month)
  else if day < 1 || day > days_in_month ~year ~month then
    Error (Invalid_day { year; month; day })
  else Ok { year; month; day }

let equal a b = a = b

let compare a b =
  Stdlib.compare (a.year, a.month, a.day) (b.year, b.month, b.day)

let ordinal d =
  let y = d.year - 1 in
  let rec months m acc =
    if m >= d.month then acc
    else months (m + 1) (acc + days_in_month ~year:d.year ~month:m)
  in
  (365 * y) + (y / 4) - (y / 100) + (y / 400) + months 1 0 + d.day - 1

let from_ordinal n =
  let total = (365 * 9999) + (9999 / 4) - (9999 / 100) + (9999 / 400) in
  if n < 0 || n >= total then None
  else
    let lo = ref 1 and hi = ref 10000 in
    while !lo + 1 < !hi do
      let mid = (!lo + !hi) / 2 in
      let days =
        (365 * (mid - 1))
        + ((mid - 1) / 4)
        - ((mid - 1) / 100)
        + ((mid - 1) / 400)
      in
      if days <= n then lo := mid else hi := mid
    done;
    let y = !lo in
    let r =
      ref
        (n
        - ((365 * (y - 1)) + ((y - 1) / 4) - ((y - 1) / 100) + ((y - 1) / 400))
        )
    and m = ref 1 in
    while !r >= days_in_month ~year:y ~month:!m do
      r := !r - days_in_month ~year:y ~month:!m;
      incr m
    done;
    Some { year = y; month = !m; day = !r + 1 }

let day_of_year d = ordinal d - ordinal { d with month = 1; day = 1 } + 1
let weekday d = Weekday.of_index (ordinal d mod 7)
let add_days d n = from_ordinal (ordinal d + n)
let diff_days a b = ordinal b - ordinal a
let to_string d = Printf.sprintf "%04d-%02d-%02d" d.year d.month d.day
