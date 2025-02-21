* self-defined program

program define 遺漏
syntax varlist(min=1) [if] [in]
marksample touse, novarlist strok    //使得syntax 後的「條件」argument能被以`touse'的型態被呼叫使用
	foreach var of local varlist {
		if regexm("`var'", "^x0+[1-4]+|^id+") {
			display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
			continue
		}
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
		replace `name' = -9 if `touse'
end

program define dostr_miss
args name touse
		if (strmatch(`name', "*96") | strmatch(`name', "*97") | strmatch(`name', "*98") | strmatch(`name', "*99")) {
			replace `name' = "99" if `touse'
		}
		else {
			replace `name' = "" if `touse'
		}
end
