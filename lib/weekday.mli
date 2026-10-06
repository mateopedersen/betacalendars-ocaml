(** Weekday ordering and conversions. *)
type t = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
val all : t list
val to_index : t -> int
val of_index : int -> t
val to_string : t -> string
