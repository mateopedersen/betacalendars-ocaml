(** Twelve ordered month grids. *)
type t = Month_grid.t list
(** Generate January through December for a valid year. *)
val make : year:int -> first_weekday:Weekday.t -> layout:Month_grid.layout -> overflow:Month_grid.overflow -> (t, Civil_date.error) result
