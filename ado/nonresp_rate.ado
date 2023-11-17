* Title: 計算單期資料的「拒答數」與「不知道」數
* Author: Tamao
* Date: 2023.11.17

program define nonresp_rate
version 13.0
syntax anything, id(varname) [keep(varlist)]

	use "`anything'", clear
	global path "`pwd'"
	global file "${S_FN}"

preserve

	transCAI a01 - d71, from("new")
	movetoPSFD a01- d71, version("new")

	foreach v of varlist a01 - d71 {

		cap confirm string var `v'
		if !_rc {
			drop `v'
			continue
		}
		if _rc {
			replace `v' = -6 if `v'==.d
		}
	}

	gen total_ans = 0
	foreach v of varlist a01 - d71 {
		replace total_ans = total_ans + 1 if `v' != -10 & `v' < .
	}
	lab var total_ans "The total questions which are answered"

	gen nonresp_96 = 0
	foreach v of varlist a01 - d71 {
		replace nonresp_96 = nonresp_96 + 1 if `v'== -6
	}
	lab var nonresp_96 "(Don't know) accumulated times"
	gen nonresp_98 = 0
	foreach v of varlist a01 - d71 {
		replace nonresp_98 = nonresp_98 + 1 if `v'== -8
	}
	lab var nonresp_98 "(Refuse) accumulated times"
	gen nonresp_99 = 0
	foreach v of varlist a01 - d71 {
		replace nonresp_99 = nonresp_99 + 1 if `v'== -9
	}
	lab var nonresp_99 "(Missing) accumulated times"

	gen nonresp96_rate = (nonresp_96 / total_ans)
	gen nonresp98_rate = (nonresp_98 / total_ans)
	gen nonresp99_rate = (nonresp_99 / total_ans)
	
	lab var nonresp96_rate "The rate of (Don't know)"
	lab var nonresp98_rate "The rate of (Refuse)"
	lab var nonresp99_rate "The rate of (Missing)"

	keep `id' `keep' total_ans - nonresp99_rate 
	save nonresp_rate, replace
	
restore

end
