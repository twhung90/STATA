* self-defined program

program define 缺漏
syntax varlist(min=1) [if] [in]
marksample touse, novarlist strok    //使得syntax 後的「條件」argument能被以`touse'的型態被呼叫使用
	foreach var of local varlist {
		cap confirm string variable `var'
		if !_rc {
			dostr_miss `var' `touse'
		}
		if _rc {
			donum_miss `var' `touse'
		}
	}
end

program define donum_miss
args name touse
	quietly sum `name' 
		if inrange(r(max),0,99)  {
			replace `name' = 99 if `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = 999 if `touse'
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = 9999 if `touse'
		}
		if inrange(r(max),10000,99999)  {
			replace `name' = 99999 if `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = 999999 if `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = 9999999 if `touse'
		}
end

program define dostr_miss
args name touse
		if strmatch(`name', "*99") {
		replace `name' = "99" if `touse'
		}
		else {
		replace `name' = "" if `touse'
		}
end
