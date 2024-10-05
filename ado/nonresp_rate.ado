* Title: 計算單期資料的「拒答數」與「不知道」數（僅計算數值變項，不包含字串）
* Author: Tamao
* Version: 1.1.0
* Date: 2024.10.06

program define nonresp_rate, rclass
version 13.0
syntax varlist(min=1), id(name) [keep(varlist) form(string) version(string) saveto(string)]    //form default = "psfd"; version default = "old"
marksample touse, novar strok

global path: pwd
global file "${S_FN}"
	
preserve

	if ustrlower(`"`form'"') =="cai" {
		if ustrlower(`"`version'"')=="new" {
			disp "--------- Convert the CAI data format now ---------"
			quietly transCAI `varlist', from(`"`version'"')
		}
		else {
			disp "--------- Convert the CAI data format now ---------"
			quietly transCAI `varlist', from("old")
		}
	}
	else {
		if ustrlower(`"`version'"')=="new" {
			disp "--------- Convert the PSFD data format now ---------"
			quietly transPSFD `varlist', from(`"`version'"')
		}
		else {
			disp "--------- Convert the PSFD data format now ---------"
			quietly transPSFD `varlist', from("old")
		}
	}	

	quietly movetoPSFD `varlist', version("new")
	disp in yellow "Format conversion have been finished!"
	
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
	gen skip_string = 0
	lab var skip_string "The total number of String variables that do not be counted into"

	foreach v of local varlist {
		cap confirm string var `v'
		if !_rc {
			quietly replace skip_string = skip_string + 1
			continue
		}
		if _rc {
			quietly replace total_ans = total_ans + 1 if `v' != -10 & `v' < .
			quietly replace skip_ans = skip_ans + 1 if `v'== -10
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
	
	return scalar total_var = (skip_string + total_ans + skip_ans)    //return the number of variables

	keep `id' `keep' total_ans - nonresp99_rate 
	if "`saveto'" != "" {
		save "`saveto'", replace
		disp "The results (`saveto'.dta) have been saved in working directory"
	}
	else {
		save Nonresponse_Rate, replace
		disp "The results (Nonresponse_Rate.dta) have been saved in working directory"
	}
	
restore

end
