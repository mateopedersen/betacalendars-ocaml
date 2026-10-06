(** Weekday ordering and conversions. *)
type t = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday

(** Weekdays in Monday-first order. *)
val all : t list

(** Return the Monday-first index from 0 through 6. *)
val to_index : t -> int

(** Convert any integer to its weekday, wrapping modulo seven. *)
val of_index : int -> t

(** Return the English name of a weekday. *)
val to_string : t -> string
