open Betacalendars

let date y m d = Result.get_ok (Civil_date.make ~year:y ~month:m ~day:d)

let dates () =
  Alcotest.(check bool) "1900" false (Civil_date.is_leap_year 1900);
  Alcotest.(check bool) "2000" true (Civil_date.is_leap_year 2000);
  Alcotest.(check bool) "2400" true (Civil_date.is_leap_year 2400);
  Alcotest.(check bool)
    "0001-01-01 Monday" true
    (Civil_date.weekday (date 1 1 1) = Weekday.Monday);
  Alcotest.(check bool)
    "2027-01-01 Friday" true
    (Civil_date.weekday (date 2027 1 1) = Weekday.Friday);
  Alcotest.(check int)
    "turn" 1
    (Civil_date.day (Option.get (Civil_date.add_days (date 2026 12 31) 1)));
  for y = 1900 to 2100 do
    for m = 1 to 12 do
      let n = Civil_date.days_in_month ~year:y ~month:m in
      for d = 1 to n do
        let x = date y m d in
        if d < n then
          Alcotest.(check int)
            "next day" 1
            (Civil_date.diff_days x (Option.get (Civil_date.add_days x 1)))
      done;
      let g =
        Result.get_ok
          (Month_grid.make ~year:y ~month:m ~first_weekday:Weekday.Monday
             ~layout:Month_grid.Fixed_six_weeks
             ~overflow:Month_grid.Adjacent_dates ())
      in
      Alcotest.(check int) "42" 42 (List.length (Month_grid.cells g));
      Alcotest.(check int)
        "all dates" n
        (List.length
           (List.filter
              (fun c -> c.Month_grid.in_requested_month)
              (Month_grid.cells g)))
    done
  done

let turn () =
  Alcotest.(check int)
    "Feb 2027" 28
    (Civil_date.days_in_month ~year:2027 ~month:2);
  Alcotest.(check int)
    "Feb 2028" 29
    (Civil_date.days_in_month ~year:2028 ~month:2);
  Alcotest.(check int)
    "fixture" 121
    (List.length (Result.get_ok (Fixture.year_turn_window 2027)))

let recurrence () =
  let r =
    Result.get_ok
      (Date_range.make ~start:(date 2027 1 1) ~stop:(date 2027 3 31))
  in
  let x =
    Result.get_ok
      (Recurrence.expand
         (Recurrence.Nth_weekday { ordinal = 1; weekday = Weekday.Monday })
         ~within:r)
  in
  Alcotest.(check int) "3 first Mondays" 3 (List.length x);
  let monthly =
    Result.get_ok
      (Recurrence.expand
         (Recurrence.Monthly_day
            { day = 31; policy = Recurrence.Clamp_to_last_day })
         ~within:r)
  in
  Alcotest.(check int) "clamped months" 3 (List.length monthly);
  let skipped =
    Result.get_ok
      (Recurrence.expand
         (Recurrence.Monthly_day { day = 31; policy = Recurrence.Skip })
         ~within:r)
  in
  Alcotest.(check int) "skipped February" 2 (List.length skipped);
  Alcotest.(check bool)
    "invalid day policy errors" true
    (Result.is_error
       (Recurrence.expand
          (Recurrence.Monthly_day { day = 31; policy = Recurrence.Error })
          ~within:r))

let grid_edges () =
  let boundary_grid =
    Result.get_ok
      (Month_grid.make ~year:1 ~month:1 ~first_weekday:Weekday.Sunday
         ~layout:Month_grid.Fixed_six_weeks ~overflow:Month_grid.Adjacent_dates
         ())
  in
  Alcotest.(check bool)
    "out-of-range adjacent date is empty" true
    ((List.hd (Month_grid.cells boundary_grid)).Month_grid.date = None);
  let jan =
    Result.get_ok
      (Month_grid.make ~year:2027 ~month:1 ~first_weekday:Weekday.Monday
         ~layout:Month_grid.Fixed_six_weeks ~overflow:Month_grid.Empty ())
  in
  Alcotest.(check int)
    "empty outside dates" 11
    (List.length
       (List.filter (fun c -> c.Month_grid.date = None) (Month_grid.cells jan)));
  Alcotest.(check int)
    "12 months" 12
    (List.length
       (Result.get_ok
          (Year_grid.make ~year:2028 ~first_weekday:Weekday.Monday
             ~layout:Month_grid.Compact ~overflow:Month_grid.Empty)))

let fixture_errors () =
  Alcotest.(check bool)
    "year turn refuses year 9999" true
    (Result.is_error (Fixture.year_turn_window 9999));
  Alcotest.(check int)
    "year fixture" 365
    (List.length (Result.get_ok (Fixture.year 2027)))

let () =
  Alcotest.run "betacalendars"
    [
      ( "core",
        [
          Alcotest.test_case "date and grid" `Quick dates;
          Alcotest.test_case "year turn" `Quick turn;
          Alcotest.test_case "recurrence policies" `Quick recurrence;
          Alcotest.test_case "grid edge cases" `Quick grid_edges;
          Alcotest.test_case "fixture bounds" `Quick fixture_errors;
        ] );
    ]
