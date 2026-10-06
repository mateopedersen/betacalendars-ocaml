type layout=Compact|Fixed_six_weeks
type overflow=Adjacent_dates|Empty
type cell={date:Civil_date.t option;row:int;column:int;weekday:Weekday.t;in_requested_month:bool}
type t={year:int;month:int;first_weekday:Weekday.t;rows:cell list list}
let make ~year ~month ~first_weekday ~layout ~overflow ()=match Civil_date.make ~year ~month ~day:1 with Error e->Error e|Ok first->let len=Civil_date.days_in_month ~year ~month in let leading=(Weekday.to_index(Civil_date.weekday first)-Weekday.to_index first_weekday+7)mod 7 in let count=match layout with Compact->((leading+len+6)/7)*7|Fixed_six_weeks->42 in let base=Option.value(Civil_date.add_days first (-leading))~default:first in let cs=List.init count(fun i->let row=i/7 and column=i mod 7 in let date=if i>=leading&&i<leading+len then Civil_date.add_days first(i-leading)else match overflow with Empty->None|Adjacent_dates->Civil_date.add_days base i in let in_requested_month=match date with Some d->Civil_date.year d=year&&Civil_date.month d=month|None->false in{date;row;column;weekday=Weekday.of_index((Weekday.to_index first_weekday+column)mod 7);in_requested_month})in let rec chunks acc=function []->List.rev acc|xs->let a=List.filteri(fun i _->i<7)xs and b=List.filteri(fun i _->i>=7)xs in chunks(a::acc)b in Ok{year;month;first_weekday;rows=chunks[]cs}
let cells g=List.concat g.rows
let row_count g=List.length g.rows
