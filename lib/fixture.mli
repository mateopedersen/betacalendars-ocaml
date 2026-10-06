(** Pure deterministic fixtures for regression suites. *)
val month : year:int -> month:int -> Civil_date.t list
val year : int -> Civil_date.t list
val year_turn_window : int -> Civil_date.t list
val leap_year_matrix : int list -> (int*bool) list
