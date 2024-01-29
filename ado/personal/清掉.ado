* self-defined program

cap which elabel
if _rc {
	ssc install elabel
}

program define 清掉
syntax varlist(min=1) [if] [in]
marksample touse, novarlist strok    //使得syntax 後的「條件」argument能被以`touse'的型態被呼叫使用
	foreach var of local varlist {
		if regexm("`var'", "^x0[1-4]+.*|^id+") {
				display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
				continue
		}
		cap confirm string variable `var'
		if !_rc {
			dostr_skip `var' `touse'
		}
		if _rc {
			donum_skip `var' `touse'
		}
	}
end

program define donum_skip
args name touse
	cap elabel list (`name')
	cap local val `r(values)'
	quietly sum `name'
		if inrange(r(max),0,99)  {
		local p 96
		cap local test: list p in val
			replace `name' = 96 if `test' & `touse'
		}
		if inrange(r(max),100,999)  {
		local p 996
		cap local test: list p in val
			replace `name' = 996 if `test' & `touse'
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = 9996 if `touse'
		}
		if inrange(r(max),10000,99999)  {
			replace `name' = 99996 if `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = 999996 if `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = 9999996 if `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = 99999996 if `touse'
		}
end

program define dostr_skip
args name touse
		if (strmatch(`name', "*96") | strmatch(`name', "*97") | strmatch(`name', "*98")) {
		replace `name' = "96" if `touse'
		}
		else {
		replace `name' = "" if `touse'
		}
end
