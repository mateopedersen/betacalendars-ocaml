let month ~year ~month =
  match Civil_date.make ~year ~month ~day:1 with
  | Error e -> Error e
  | Ok _ ->
      let n = Civil_date.days_in_month ~year ~month in
      Ok
        (List.init n (fun i ->
             Result.get_ok (Civil_date.make ~year ~month ~day:(i + 1))))

let year year =
  match Civil_date.make ~year ~month:1 ~day:1 with
  | Error e -> Error e
  | Ok _ ->
      let rec collect m acc =
        if m = 13 then Ok (List.concat (List.rev acc))
        else
          match month ~year ~month:m with
          | Error e -> Error e
          | Ok dates -> collect (m + 1) (dates :: acc)
      in
      collect 1 []

let year_turn_window year =
  if year < 1 || year >= 9999 then Error (Civil_date.Invalid_year year)
  else
    match
      ( month ~year ~month:11,
        month ~year ~month:12,
        month ~year:(year + 1) ~month:1,
        month ~year:(year + 1) ~month:2 )
    with
    | Ok nov, Ok dec, Ok jan, Ok feb -> Ok (nov @ dec @ jan @ feb)
    | Error e, _, _, _ | _, Error e, _, _ | _, _, Error e, _ | _, _, _, Error e
      ->
        Error e

let leap_year_matrix years =
  List.map (fun year -> (year, Civil_date.is_leap_year year)) years
