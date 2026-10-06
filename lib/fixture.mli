(** Pure deterministic fixtures for regression suites. *)
val month : year:int -> month:int -> (Civil_date.t list, Civil_date.error) result

(** All dates in a valid year in ascending order. *)
val year : int -> (Civil_date.t list, Civil_date.error) result

(** Dates from November [y] through February [y+1], inclusive. *)
val year_turn_window : int -> (Civil_date.t list, Civil_date.error) result

(** Pair each requested year with its Gregorian leap-year status. *)
val leap_year_matrix : int list -> (int * bool) list
