(** Bounded synchronous recurrence expansion; not a full RFC 5545 implementation. *)
type invalid_day_policy=Skip|Clamp_to_last_day|Error
type rule=Every_n_days of int|Weekly of Weekday.t list|Monthly_day of{day:int;policy:invalid_day_policy}|Nth_weekday of{ordinal:int;weekday:Weekday.t}|Last_weekday of Weekday.t|Annual_date of{month:int;day:int;policy:invalid_day_policy}
val expand : rule -> within:Date_range.t -> (Civil_date.t list,[ `Invalid_rule ]) result
