(** Structured month lengths for boundary-focused tests. *)
type month={first:Civil_date.t;last:Civil_date.t;length:int}
type t={year:int;months:month list;leap_year:bool}
val for_year : int -> (t,Civil_date.error) result
