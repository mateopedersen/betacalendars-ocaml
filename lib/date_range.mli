(** Inclusive finite date interval. *)
type t
val make : start:Civil_date.t -> stop:Civil_date.t -> (t,[ `Reversed ]) result
val start : t -> Civil_date.t
val stop : t -> Civil_date.t
val length : t -> int
val iter : t -> f:(Civil_date.t -> unit) -> unit
val fold : t -> init:'a -> f:('a -> Civil_date.t -> 'a) -> 'a
val to_list : t -> Civil_date.t list
