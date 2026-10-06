(** Stable rectangular layouts for civil months. *)
type layout=Compact|Fixed_six_weeks
type overflow=Adjacent_dates|Empty
type cell={date:Civil_date.t option;row:int;column:int;weekday:Weekday.t;in_requested_month:bool}
type t={year:int;month:int;first_weekday:Weekday.t;rows:cell list list}
val make : year:int -> month:int -> first_weekday:Weekday.t -> layout:layout -> overflow:overflow -> unit -> (t,Civil_date.error) result
val cells : t -> cell list
val row_count : t -> int
