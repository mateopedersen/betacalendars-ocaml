(** Valid proleptic Gregorian dates, independent of timestamps and time zones. *)
type t
type error = Invalid_year of int | Invalid_month of int | Invalid_day of {year:int; month:int; day:int}
val make : year:int -> month:int -> day:int -> (t,error) result
val year : t -> int
val month : t -> int
val day : t -> int
val equal : t -> t -> bool
val compare : t -> t -> int
val is_leap_year : int -> bool
val days_in_month : year:int -> month:int -> int
val day_of_year : t -> int
val weekday : t -> Weekday.t
val add_days : t -> int -> t option
val diff_days : t -> t -> int
val to_string : t -> string
