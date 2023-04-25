* self-defined program

cap ssc install lookfor2
cap program drop _all

program define 改特殊碼
syntax [varlist(min=1)]
marksample touse, novarlist strok
	foreach var of local varlist {
		if !inlist(`var',.a,.b,.j,.d,.r,.m) {
			cap confirm string variable `var'
			if _rc {
				num_sp `var' `touse'
			}
		}
	}
end

program define num_sp
args name touse
	quietly sum `name' 
		if inrange(r(max),0,9)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .d if `name'==6 & `touse'
			replace `name' = .r if `name'==8 & `touse'
			replace `name' = .m if `name'==9 & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .b if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==96 & `touse'
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .b if `name'==991 & `touse'
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if (`name'==992 | `name'==996) & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .b if `name'==9991 & `touse'
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if (`name'==9992 | `name'==9996) & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
		}
		if inrange(r(max),100000,999999)  {
			*replace `name' = .j if `name'==0 & `touse'    //通常此類數值為金額，0通常兼具跳答意涵，不予轉換
			replace `name' = .b if `name'==999991 & `touse'
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if (`name'==999992 | `name'==999996) & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			*replace `name' = .j if `name'==0 & `touse'    //通常此類數值為金額，0通常兼具跳答意涵，不予轉換
			replace `name' = .b if `name'==9999991 & `touse'
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if (`name'==9999992 | `name'==9999996) & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			*replace `name' = .j if `name'==0 & `touse'    //通常此類數值為金額，0通常兼具跳答意涵，不予轉換
			replace `name' = .b if `name'==99999991 & `touse'
			replace `name' = .o if `name'==99999995 & `touse'
			replace `name' = .d if (`name'==99999992 | `name'==99999996) & `touse'
			replace `name' = .r if `name'==99999998 & `touse'
			replace `name' = .m if `name'==99999999 & `touse'
		}
end
