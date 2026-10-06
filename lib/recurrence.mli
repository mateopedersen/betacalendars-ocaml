(** Bounded synchronous recurrence expansion; this is not full RFC 5545. *)
type invalid_day_policy = Skip | Clamp_to_last_day | Error

(** A bounded recurrence rule with an explicit invalid-day policy. *)
type rule = Every_n_days of int | Weekly of Weekday.t list | Monthly_day of { day : int; policy : invalid_day_policy } | Nth_weekday of { ordinal : int; weekday : Weekday.t } | Last_weekday of Weekday.t | Annual_date of { month : int; day : int; policy : invalid_day_policy }

(** Expand only inside the required finite inclusive range. *)
val expand : rule -> within:Date_range.t -> (Civil_date.t list, [ `Invalid_rule ]) result
