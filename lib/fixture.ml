let month ~year ~month=let n=Civil_date.days_in_month ~year ~month in List.init n(fun i->Result.get_ok(Civil_date.make ~year ~month ~day:(i+1)))
let year year=List.concat(List.init 12(fun i->month ~year ~month:(i+1)))
let year_turn_window y=List.concat(List.map(fun(y,m)->month ~year:y ~month:m)[y,11;y,12;y+1,1;y+1,2])
let leap_year_matrix ys=List.map(fun y->y,Civil_date.is_leap_year y)ys
