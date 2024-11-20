* self-defined program

program define 清除
syntax varlist(min=1) [if] [in]
marksample touse, novarlist strok    //使得syntax 後的「條件」argument能被以`touse'的型態被呼叫使用
	foreach var of local varlist {
		if regexm("`var'", "^x0+[1-4]+|^id+") {
			display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
			continue
		}
		cap confirm string variable `var'
		if !_rc {
			dostr_96 `var' `touse'
		}
		if _rc {
			donum_96 `var' `touse'
		}
	}
end

program define donum_96
args name touse
	replace `name' = -10 if `touse'
end
program define dostr_96
args name touse
	tempvar reg_test
	quietly gen `reg_test' = 1 if regexm(`name',"[9][6-9]$")
	quietly sum `reg_test'
		if (r(max) >=1 & r(max) < .) {
			replace `name' = "96" if `touse'
		}
		else {
			replace `name' = "" if `touse'
		}
end
