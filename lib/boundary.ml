type month={first:Civil_date.t;last:Civil_date.t;length:int}
type t={year:int;months:month list;leap_year:bool}
let for_year year=if year<1||year>9999 then Error(Civil_date.Invalid_year year)else let months=List.init 12(fun i->let month=i+1 in let length=Civil_date.days_in_month ~year ~month in{first=Result.get_ok(Civil_date.make ~year ~month ~day:1);last=Result.get_ok(Civil_date.make ~year ~month ~day:length);length})in Ok{year;months;leap_year=Civil_date.is_leap_year year}
