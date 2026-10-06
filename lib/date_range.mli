(** Inclusive finite date interval. *)
type t

(** Build an inclusive range; reject an end before the start. *)
val make : start:Civil_date.t -> stop:Civil_date.t -> (t, [ `Reversed ]) result

(** Inclusive first date. *)
val start : t -> Civil_date.t

(** Inclusive last date. *)
val stop : t -> Civil_date.t

(** Number of dates in the inclusive interval. *)
val length : t -> int

(** Visit each date in ascending order using constant auxiliary memory. *)
val iter : t -> f:(Civil_date.t -> unit) -> unit

(** Fold over dates in ascending order using constant auxiliary memory. *)
val fold : t -> init:'a -> f:('a -> Civil_date.t -> 'a) -> 'a

(** Materialize all dates; use [iter] or [fold] for large ranges. *)
val to_list : t -> Civil_date.t list
