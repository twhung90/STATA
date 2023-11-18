* Title: 計算單期資料的「拒答數」與「不知道」數
* Author: Tamao
* Date: 2023.11.17

program define nonresp_rate
version 13.0
syntax anything, id(varname) range(varlist) [keep(varlist) form(string) version(string)]  //form defuult = "psfd"; version default = "old"

	use "`anything'", clear
	global path "`pwd'"
	global file "${S_FN}"
	
preserve

	if ustrlower(`"`form'"') =="cai" {
		if ustrlower(`"`version'"')=="new" {
			disp "--------- Convert the CAI data form now ---------"
			quietly transCAI `range', from(`"`version'"')
		}
		else {
			disp "--------- Convert the CAI data form now ---------"
			quietly transCAI `range', from("old")
		}
	}
	else {
		if ustrlower(`"`version'"')=="new" {
			disp "--------- Convert the PSFD data form now ---------"
			quietly transPSFD `range', from(`"`version'"')
		}
		else {
			disp "--------- Convert the PSFD data form now ---------"
			quietly transPSFD `range', from("old")
		}
	}	

	quietly movetoPSFD `range', version("new")
	disp "--------- Form conversion have been finished! ---------"
	
	gen total_ans = 0
	lab var total_ans "The total number of questions answered"
	gen skip_ans = 0
	lab var skip_ans "The total number of questions skipped"
	gen nonresp_96 = 0
	lab var nonresp_96 "(Don't know) accumulated number"
	gen nonresp_98 = 0
	lab var nonresp_98 "(Refuse) accumulated number"
	gen nonresp_99 = 0
	lab var nonresp_99 "(Missing) accumulated number"

	foreach v of local range {

		cap confirm string var `v'
		if !_rc {
			continue
		}
		if _rc {
			quietly replace total_ans = total_ans + 1 if `v' != -10 & `v' < .
			quietly replace skip_ans = skip_ans + 1 if `v'== -10 & `v' < .
			quietly replace nonresp_96 = nonresp_96 + 1 if `v'== -6
			quietly replace nonresp_98 = nonresp_98 + 1 if `v'== -8
			quietly replace nonresp_99 = nonresp_99 + 1 if `v'== -9
		}
	}
	
	gen nonresp96_rate = (nonresp_96 / total_ans)
	gen nonresp98_rate = (nonresp_98 / total_ans)
	gen nonresp99_rate = (nonresp_99 / total_ans)
	
	lab var nonresp96_rate "The rate of (Don't know)"
	lab var nonresp98_rate "The rate of (Refuse)"
	lab var nonresp99_rate "The rate of (Missing)"

	keep `id' `keep' total_ans - nonresp99_rate 
	save Nonresponse_Rate, replace
	disp "The new data `""Nonresponse_Rate.dta""' has been saved in the folder"
	
restore

end
