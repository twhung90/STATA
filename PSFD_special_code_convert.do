cap program drop _all

* self-defined program

cap program drop transCAI

program define transCAI
syntax varlist(min=1), from(string asis)
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
				if `from'=="old" {
					num_transcai_old `var' `touse'
				}
				if `from'=="new" {
					num_transcai_new `var' `touse'
				}
			}
		}
		else {
			misstable sum `var'
			display "`var'：這變項已經包含PSFD所特殊定義的「特殊碼」，請確認！"
		
		}
	}	
end

program define num_transcai_old
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
			replace `name' = .u if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==97 & `touse'
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==996 & `touse'
			replace `name' = .u if `name'==991 & `touse'
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if (`name'==992 | `name'==997) & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
			
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==9996 & `touse'
			replace `name' = .u if `name'==9991 & `touse'
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if (`name'==9992 | `name'==9997) & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==999996 & `touse'
			replace `name' = .u if `name'==999991 & `touse'
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if (`name'==999992 | `name'==999997) & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==9999996 & `touse'
			replace `name' = .u if `name'==9999991 & `touse'
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if (`name'==9999992 | `name'==9999997) & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==99999996 & `touse'
			replace `name' = .u if `name'==99999991 & `touse'
			replace `name' = .o if `name'==99999995 & `touse'
			replace `name' = .d if (`name'==99999992 | `name'==99999997) & `touse'
			replace `name' = .r if `name'==99999998 & `touse'
			replace `name' = .m if `name'==99999999 & `touse'
		}
end

program define num_transcai_new
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
			replace `name' = .u if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==97 & `touse'
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==996 & `touse'
			replace `name' = .u if `name'==991 & `touse'
			replace `name' = .b if `name'==992 & `touse'   //-92重新定義為「打平」
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if `name'==997 & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
			
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==9996 & `touse'
			replace `name' = .u if `name'==9991 & `touse'
			replace `name' = .b if `name'==9992 & `touse'   //-92重新定義為「打平」
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if `name'==9997 & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==999996 & `touse'
			replace `name' = .u if `name'==999991 & `touse'
			replace `name' = .b if `name'==999992 & `touse'   //-92重新定義為「打平」
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if `name'==999997 & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==9999996 & `touse'
			replace `name' = .u if `name'==9999991 & `touse'
			replace `name' = .b if `name'==9999992 & `touse'   //-92重新定義為「打平」
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if `name'==9999997 & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .j if `name'==99999996 & `touse'
			replace `name' = .u if `name'==99999991 & `touse'
			replace `name' = .b if `name'==99999992 & `touse'   //-92重新定義為「打平」
			replace `name' = .o if `name'==99999995 & `touse'
			replace `name' = .d if `name'==99999997 & `touse'
			replace `name' = .r if `name'==99999998 & `touse'
			replace `name' = .m if `name'==99999999 & `touse'
		}
end


* self-defined program

cap which lookfor2
if _rc {
	ssc install lookfor2
}
 	
cap program drop transPSFD

program define transPSFD
syntax varlist(min=1), from(string asis)
marksample touse, novarlist strok
	foreach var of local varlist {
	quietly misstable sum `var'
		if `r(N_gt_dot)'==. | `r(N_gt_dot)'==0  {
			if regexm("`var'", "^x0+[1-4]+") {
				display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
				continue
			}
		}
		else {
			misstable sum `var'
			display "`var'：這變項已經包含PSFD所特殊定義的「特殊碼」，請確認！"
			continue
		}
		cap confirm string variable `var'
			if _rc {
				if `from'=="old" {
					num_transpsfd_old `var' `touse'    //資料需有變項標籤內容
				}
				if `from'=="new" {
					num_transpsfd_new `var' `touse'
				}
			}
	}
end

program define num_transpsfd_old
args name touse
local var `"`name'"'   //注意：這裡使用了跳脫字元`" "'
local list_str "跳答 不適用"    //將「跳答」與「不適用」等不同元素存在macro之中，將轉變成list形式
quietly lookfor2 `list_str', nonote
local skip `"`r(varlist)'"'    //注意：這裡使用了跳脫字元`" "'
local test: list var in skip

	if `test'==1 {
	quietly sum `name' 
		if inrange(r(max),0,9)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .d if `name'==6 & `touse'
			replace `name' = .r if `name'==8 & `touse'
			replace `name' = .m if `name'==9 & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = .j if `name'==0  & `touse'
			replace `name' = .u if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==96 & `touse'
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==991 & `touse'
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if (`name'==992 | `name'==996) & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==9991 & `touse'
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if (`name'==9992 | `name'==9996) & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==999991 & `touse'
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if (`name'==999992 | `name'==999996) & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==9999991 & `touse'
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if (`name'==9999992 | `name'==9999996) & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==99999991 & `touse'
			replace `name' = .o if `name'==99999995 & `touse'
			replace `name' = .d if (`name'==99999992 | `name'==99999996) & `touse'
			replace `name' = .r if `name'==99999998 & `touse'
			replace `name' = .m if `name'==99999999 & `touse'
		}
	}
	else {
	quietly sum `name' 
		if inrange(r(max),0,9)  {
			
			replace `name' = .d if `name'==6 & `touse'
			replace `name' = .r if `name'==8 & `touse'
			replace `name' = .m if `name'==9 & `touse'
		}
		if inrange(r(max),10,99)  {
			
			replace `name' = .u if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==96 & `touse'
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999)  {
			
			replace `name' = .u if `name'==991 & `touse'
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if (`name'==992 | `name'==996) & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
		}
		if inrange(r(max),1000,9999)  {
			
			replace `name' = .u if `name'==9991 & `touse'
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if (`name'==9992 | `name'==9996) & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
		}
		if inrange(r(max),100000,999999)  {
			
			replace `name' = .u if `name'==999991 & `touse'
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if (`name'==999992 | `name'==999996) & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			
			replace `name' = .u if `name'==9999991 & `touse'
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if (`name'==9999992 | `name'==9999996) & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			
			replace `name' = .u if `name'==99999991 & `touse'
			replace `name' = .o if `name'==99999995 & `touse'
			replace `name' = .d if (`name'==99999992 | `name'==99999996) & `touse'
			replace `name' = .r if `name'==99999998 & `touse'
			replace `name' = .m if `name'==99999999 & `touse'
		}
	}
end

program define num_transpsfd_new
args name touse

	quietly sum `name' 
		if inrange(r(max),0,9)  {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = .j if `name'== -10  & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
end



* self-defined program

cap program drop movetoCAI

program define movetoCAI
syntax varlist(min=1), version(string asis)
marksample touse, novarlist strok
	foreach var of local varlist {
		if regexm("`var'", "^x0+[1-4]+") {
			display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
			continue
		}
		cap confirm string variable `var'
		if _rc {
			if `version'=="old" {
				num_movetocai_old `var' `touse'
			}
			if `version'=="new" {
				num_movetocai_old `var' `touse'
			}
		}
	}
end

program define num_movetocai_old
args name touse

	quietly sum `name' 
		if inrange(r(max),0,9)  {
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j  & `touse'
			replace `name' = 91 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 91 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 996 if `name'== .j & `touse'
			replace `name' = 991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 995 if `name'== .o & `touse'
			replace `name' = 997 if `name'== .d & `touse'
			replace `name' = 998 if `name'== .r & `touse'
			replace `name' = 999 if `name'== .m & `touse'
			
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9996 if `name'== .j & `touse'
			replace `name' = 9991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9995 if `name'== .o & `touse'
			replace `name' = 9997 if `name'== .d & `touse'
			replace `name' = 9998 if `name'== .r & `touse'
			replace `name' = 9999 if `name'== .m & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 999996 if `name'== .j & `touse'
			replace `name' = 999991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 999991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 999995 if `name'== .o & `touse'
			replace `name' = 999997 if `name'== .d & `touse'
			replace `name' = 999998 if `name'== .r & `touse'
			replace `name' = 999999 if `name'== .m & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9999996 if `name'== .j & `touse'
			replace `name' = 9999991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9999991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9999995 if `name'== .o & `touse'
			replace `name' = 9999997 if `name'== .d & `touse'
			replace `name' = 9999998 if `name'== .r & `touse'
			replace `name' = 9999999 if `name'== .m & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 99999996 if `name'== .j & `touse'
			replace `name' = 99999991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 99999991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 99999995 if `name'== .o & `touse'
			replace `name' = 99999997 if `name'== .d & `touse'
			replace `name' = 99999998 if `name'== .r & `touse'
			replace `name' = 99999999 if `name'== .m & `touse'
		}
end

program define num_movetocai_new
args name touse

	quietly sum `name' 
		if inrange(r(max),0,9)  {
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j  & `touse'
			replace `name' = 91 if `name'== .u & `touse'
			replace `name' = 92 if `name'== .b & `touse'    //「打平」於2022年後，從991中切分出來
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 996 if `name'== .j & `touse'
			replace `name' = 991 if `name'== .u & `touse'
			replace `name' = 992 if `name'== .b & `touse'    //「打平」於2022年後，從991中切分出來
			replace `name' = 995 if `name'== .o & `touse'
			replace `name' = 997 if `name'== .d & `touse'
			replace `name' = 998 if `name'== .r & `touse'
			replace `name' = 999 if `name'== .m & `touse'
			
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9996 if `name'== .j & `touse'
			replace `name' = 9991 if `name'== .u & `touse'
			replace `name' = 9992 if `name'== .b & `touse'    //「打平」於2022年後，從991中切分出來
			replace `name' = 9995 if `name'== .o & `touse'
			replace `name' = 9997 if `name'== .d & `touse'
			replace `name' = 9998 if `name'== .r & `touse'
			replace `name' = 9999 if `name'== .m & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 999996 if `name'== .j & `touse'
			replace `name' = 999991 if `name'== .u & `touse'
			replace `name' = 999992 if `name'== .b & `touse'    //「打平」於2022年後，從991中切分出來
			replace `name' = 999995 if `name'== .o & `touse'
			replace `name' = 999997 if `name'== .d & `touse'
			replace `name' = 999998 if `name'== .r & `touse'
			replace `name' = 999999 if `name'== .m & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9999996 if `name'== .j & `touse'
			replace `name' = 9999991 if `name'== .u & `touse'
			replace `name' = 9999992 if `name'== .b & `touse'    //「打平」於2022年後，從991中切分出來
			replace `name' = 9999995 if `name'== .o & `touse'
			replace `name' = 9999997 if `name'== .d & `touse'
			replace `name' = 9999998 if `name'== .r & `touse'
			replace `name' = 9999999 if `name'== .m & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 99999996 if `name'== .j & `touse'
			replace `name' = 99999991 if `name'== .u & `touse'
			replace `name' = 99999992 if `name'== .b & `touse'    //「打平」於2022年後，從991中切分出來
			replace `name' = 99999995 if `name'== .o & `touse'
			replace `name' = 99999997 if `name'== .d & `touse'
			replace `name' = 99999998 if `name'== .r & `touse'
			replace `name' = 99999999 if `name'== .m & `touse'
		}
end



* self-defined program

cap program drop movetoPSFD

program define movetoPSFD
syntax varlist(min=1), version(string asis)
marksample touse, novarlist strok
	foreach var of local varlist {
	if regexm("`var'", "^x0+[1-4]+") {
		display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
		continue
	}
	cap confirm string variable `var'
		if _rc {
			if `version'=="old" {
				num_movetopsfd_old `var' `touse'
			}
			if `version'=="new" {
				num_movetopsfd_new `var' `touse'
			}
		}
	}
end

program define num_movetopsfd_old
args name touse

	quietly sum `name' 
		if inlist(r(max),0,1,2,3,4,5,7)  {
			replace `name' = 0 if `name'== .j & `touse'
			replace `name' = 6 if `name'== .d & `touse'
			replace `name' = 8 if `name'== .r & `touse'
			replace `name' = 9 if `name'== .m & `touse'
		}
		if inrange(r(max),6,9)  {
			replace `name' = 0 if `name'== .j & `touse'
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = 0 if `name'== .j  & `touse'
			replace `name' = 91 if `name'== .u & `touse'
			replace `name' = 91 if `name'== .b & `touse'
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 0 if `name'== .j & `touse'
			replace `name' = 991 if `name'== .u & `touse'
			replace `name' = 991 if `name'== .b & `touse'
			replace `name' = 995 if `name'== .o & `touse'
			replace `name' = 996 if `name'== .d & `touse'
			replace `name' = 998 if `name'== .r & `touse'
			replace `name' = 999 if `name'== .m & `touse'
			
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 0 if `name'== .j & `touse'
			replace `name' = 9991 if `name'== .u & `touse'
			replace `name' = 9991 if `name'== .b & `touse'
			replace `name' = 9995 if `name'== .o & `touse'
			replace `name' = 9996 if `name'== .d & `touse'
			replace `name' = 9998 if `name'== .r & `touse'
			replace `name' = 9999 if `name'== .m & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 0 if `name'== .j & `touse'
			replace `name' = 999991 if `name'== .u & `touse'
			replace `name' = 999991 if `name'== .b & `touse'
			replace `name' = 999995 if `name'== .o & `touse'
			replace `name' = 999996 if `name'== .d & `touse'
			replace `name' = 999998 if `name'== .r & `touse'
			replace `name' = 999999 if `name'== .m & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 0 if `name'== .j & `touse'
			replace `name' = 9999991 if `name'== .u & `touse'
			replace `name' = 9999991 if `name'== .b & `touse'
			replace `name' = 9999995 if `name'== .o & `touse'
			replace `name' = 9999996 if `name'== .d & `touse'
			replace `name' = 9999998 if `name'== .r & `touse'
			replace `name' = 9999999 if `name'== .m & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 0 if `name'== .j & `touse'
			replace `name' = 99999991 if `name'== .u & `touse'
			replace `name' = 99999991 if `name'== .b & `touse'
			replace `name' = 99999995 if `name'== .o & `touse'
			replace `name' = 99999996 if `name'== .d & `touse'
			replace `name' = 99999998 if `name'== .r & `touse'
			replace `name' = 99999999 if `name'== .m & `touse'
		}
		else {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 96 if `name'== .j & `touse'
			replace `name' = 91 if `name'== .u & `touse'
			replace `name' = 91 if `name'== .b & `touse'
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
end

program define num_movetopsfd_new
args name touse

	quietly sum `name' 
		if inlist(r(max),0,1,2,3,4,5,7)  {
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
		if inrange(r(max),6,9)  {
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
		if inrange(r(max),10,99)  {
			replace `name' = -10 if `name'== .j  & `touse'
			replace `name' = -1 if `name'== .u & `touse'
			replace `name' = -2 if `name'== .b & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
		if inrange(r(max),100,999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -1 if `name'== .u & `touse'
			replace `name' = -2 if `name'== .b & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
			
		}
		if inrange(r(max),1000,9999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -1 if `name'== .u & `touse'
			replace `name' = -2 if `name'== .b & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
		if inrange(r(max),100000,999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -1 if `name'== .u & `touse'
			replace `name' = -2 if `name'== .b & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
		if inrange(r(max),1000000,9999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -1 if `name'== .u & `touse'
			replace `name' = -2 if `name'== .b & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
		if inrange(r(max),10000000,99999999)  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -1 if `name'== .u & `touse'
			replace `name' = -2 if `name'== .b & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
		else {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = -10 if `name'== .j & `touse'
			replace `name' = -1 if `name'== .u & `touse'
			replace `name' = -2 if `name'== .b & `touse'
			replace `name' = -5 if `name'== .o & `touse'
			replace `name' = -6 if `name'== .d & `touse'
			replace `name' = -8 if `name'== .r & `touse'
			replace `name' = -9 if `name'== .m & `touse'
		}
end
