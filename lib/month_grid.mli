(** Stable rectangular layouts for civil months. *)
type layout = Compact | Fixed_six_weeks
type overflow = Adjacent_dates | Empty
(** One date position in a month grid. *)
type cell = { date : Civil_date.t option; row : int; column : int; weekday : Weekday.t; in_requested_month : bool }
(** A month and its rows of seven cells. *)
type t = { year : int; month : int; first_weekday : Weekday.t; rows : cell list list }
(** Generate a grid. Fixed layout has 42 cells; compact layout has the minimum whole weeks. *)
val make : year:int -> month:int -> first_weekday:Weekday.t -> layout:layout -> overflow:overflow -> unit -> (t, Civil_date.error) result
(** Flatten rows in display order. *)
val cells : t -> cell list
(** Number of weeks in this grid. *)
val row_count : t -> int
