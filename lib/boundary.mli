(** Structured month lengths for boundary-focused tests. *)
type month = { first : Civil_date.t; last : Civil_date.t; length : int }

(** Calendar year with its twelve month boundaries and leap-year flag. *)
type t = { year : int; months : month list; leap_year : bool }

(** Analyze the month boundaries of a valid year. *)
val for_year : int -> (t, Civil_date.error) result
