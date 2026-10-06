(** Valid proleptic Gregorian dates, independent of timestamps and time zones. *)
type t
type error = Invalid_year of int | Invalid_month of int | Invalid_day of { year : int; month : int; day : int }
(** Construct a valid Gregorian date in years 1 through 9999. *)
val make : year:int -> month:int -> day:int -> (t, error) result
(** Return the year component. *)
val year : t -> int
(** Return the month component from 1 through 12. *)
val month : t -> int
(** Return the day component. *)
val day : t -> int
(** Test structural date equality. *)
val equal : t -> t -> bool
(** Compare dates chronologically. *)
val compare : t -> t -> int
(** Gregorian leap-year predicate. Input is not otherwise range-limited. *)
val is_leap_year : int -> bool
(** Number of days in a valid Gregorian month; returns zero for invalid months. *)
val days_in_month : year:int -> month:int -> int
(** Return the one-based ordinal day within the year. *)
val day_of_year : t -> int
(** Return the ISO weekday with Monday first. *)
val weekday : t -> Weekday.t
(** Add signed days; return [None] if the result leaves years 1 through 9999. *)
val add_days : t -> int -> t option
(** Signed day distance from [a] to [b]. *)
val diff_days : t -> t -> int
(** Canonical zero-padded [YYYY-MM-DD] form. *)
val to_string : t -> string
