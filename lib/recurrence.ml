type invalid_day_policy = Skip | Clamp_to_last_day | Error

type rule =
  | Every_n_days of int
  | Weekly of Weekday.t list
  | Monthly_day of { day : int; policy : invalid_day_policy }
  | Nth_weekday of { ordinal : int; weekday : Weekday.t }
  | Last_weekday of Weekday.t
  | Annual_date of { month : int; day : int; policy : invalid_day_policy }

let expand rule ~within =
  let first = Date_range.start within and last = Date_range.stop within in
  let emit y m day policy =
    let md = Civil_date.days_in_month ~year:y ~month:m in
    let day =
      if day > md then
        match policy with Skip -> 0 | Clamp_to_last_day -> md | Error -> -1
      else day
    in
    if day < 1 then None
    else Civil_date.make ~year:y ~month:m ~day |> Result.to_option
  in
  match rule with
  | Every_n_days n when n > 0 ->
      let acc = ref [] and d = ref (Some first) in
      while
        match !d with Some x -> Civil_date.compare x last <= 0 | None -> false
      do
        match !d with
        | Some x ->
            acc := x :: !acc;
            d := Civil_date.add_days x n
        | None -> ()
      done;
      Ok (List.rev !acc)
  | Every_n_days _ -> Error `Invalid_rule
  | Weekly days ->
      if days = [] then Ok []
      else
        let acc = ref [] in
        Date_range.iter within ~f:(fun d ->
            if List.mem (Civil_date.weekday d) days then acc := d :: !acc);
        Ok (List.rev !acc)
  | r ->
      let acc = ref [] and invalid = ref false in
      for y = Civil_date.year first to Civil_date.year last do
        for m = 1 to 12 do
          let month_first =
            Result.get_ok (Civil_date.make ~year:y ~month:m ~day:1)
          in
          let month_last =
            Result.get_ok
              (Civil_date.make ~year:y ~month:m
                 ~day:(Civil_date.days_in_month ~year:y ~month:m))
          in
          let intersects =
            Civil_date.compare month_last first >= 0
            && Civil_date.compare month_first last <= 0
          in
          let candidate =
            if not intersects then None
            else
              match r with
              | Monthly_day { day; policy } ->
                  if day < 1 || day > 31 then (
                    invalid := true;
                    None)
                  else
                    let x = emit y m day policy in
                    if
                      policy = Error
                      && day > Civil_date.days_in_month ~year:y ~month:m
                    then invalid := true;
                    x
              | Nth_weekday { ordinal; _ } when ordinal < 1 || ordinal > 5 ->
                  invalid := true;
                  None
              | Nth_weekday { ordinal; weekday } ->
                  let f =
                    Result.get_ok (Civil_date.make ~year:y ~month:m ~day:1)
                  in
                  let delta =
                    (Weekday.to_index weekday
                    - Weekday.to_index (Civil_date.weekday f)
                    + 7)
                    mod 7
                  in
                  let d = 1 + delta + (7 * (ordinal - 1)) in
                  if d <= Civil_date.days_in_month ~year:y ~month:m then
                    Civil_date.make ~year:y ~month:m ~day:d |> Result.to_option
                  else None
              | Last_weekday weekday ->
                  let n = Civil_date.days_in_month ~year:y ~month:m in
                  let d =
                    Result.get_ok (Civil_date.make ~year:y ~month:m ~day:n)
                  in
                  let day =
                    n
                    - (Weekday.to_index (Civil_date.weekday d)
                      - Weekday.to_index weekday + 7)
                      mod 7
                  in
                  Civil_date.make ~year:y ~month:m ~day |> Result.to_option
              | Annual_date { month; day; _ }
                when month < 1 || month > 12 || day < 1 || day > 31 ->
                  invalid := true;
                  None
              | Annual_date { month; day; policy } when month = m ->
                  let x = emit y m day policy in
                  if
                    policy = Error
                    && day > Civil_date.days_in_month ~year:y ~month:m
                  then invalid := true;
                  x
              | _ -> None
          in
          match candidate with
          | Some d
            when Civil_date.compare d first >= 0
                 && Civil_date.compare d last <= 0 ->
              acc := d :: !acc
          | _ -> ()
        done
      done;
      if !invalid then Error `Invalid_rule else Ok (List.rev !acc)
