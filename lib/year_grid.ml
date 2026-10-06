type t = Month_grid.t list

let make ~year ~first_weekday ~layout ~overflow =
  if year < 1 || year > 9999 then Error (Civil_date.Invalid_year year)
  else
    let rec loop m acc =
      if m = 13 then Ok (List.rev acc)
      else
        match
          Month_grid.make ~year ~month:m ~first_weekday ~layout ~overflow ()
        with
        | Error e -> Error e
        | Ok g -> loop (m + 1) (g :: acc)
    in
    loop 1 []
