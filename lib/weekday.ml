type t = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
let all = [Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday]
let to_index = function Monday->0|Tuesday->1|Wednesday->2|Thursday->3|Friday->4|Saturday->5|Sunday->6
let of_index n = List.nth all (((n mod 7)+7) mod 7)
let to_string = function Monday->"Monday"|Tuesday->"Tuesday"|Wednesday->"Wednesday"|Thursday->"Thursday"|Friday->"Friday"|Saturday->"Saturday"|Sunday->"Sunday"
