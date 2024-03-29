* self-defined program
 	
cap program drop _all

program define transCAI
syntax [varlist(min=1)]
marksample touse, novarlist strok
	foreach var of local varlist {
	quietly misstable sum `var'
		if `r(N_gt_dot)'==. | `r(N_gt_dot)'==0  {
			if regexm("`var'", "^x0+[1-4]+") {
				display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
				continue
			}
			cap confirm string variable `var'
			if _rc {
				num_sp `var' `touse'
			}
		}
		else {
			misstable sum `var'
			display "`var'：這變項已經包含PSFD所特殊定義的「特殊碼」，請確認！"
		
		}
	}
end

program define num_sp
args name touse

	quietly sum `name' 
		if inrange(r(max),0,9)  {
			replace `name' = .j if `name'==96 & `touse'
			replace `name' = .d if `name'==97 & `touse'
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = .j if `name'==96  & `touse'
			replace `name' = .b if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==97 & `touse'
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==996 & `touse'
			replace `name' = .b if `name'==991 & `touse'
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if (`name'==992 | `name'==997) & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
			
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==9996 & `touse'
			replace `name' = .b if `name'==9991 & `touse'
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if (`name'==9992 | `name'==9997) & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==999996 & `touse'
			replace `name' = .b if `name'==999991 & `touse'
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if (`name'==999992 | `name'==999997) & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==9999996 & `touse'
			replace `name' = .b if `name'==9999991 & `touse'
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if (`name'==9999992 | `name'==9999997) & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==99999996 & `touse'
			replace `name' = .b if `name'==99999991 & `touse'
			replace `name' = .o if `name'==99999995 & `touse'
			replace `name' = .d if (`name'==99999992 | `name'==99999997) & `touse'
			replace `name' = .r if `name'==99999998 & `touse'
			replace `name' = .m if `name'==99999999 & `touse'
		}
end
