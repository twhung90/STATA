* self-defined program

cap which lookfor2
if _rc {
	ssc install lookfor2
}
cap which elabel
if _rc {
	ssc install elabel
}

program define transPSFD
syntax varlist(min=1), from(string)
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
				if ustrlower(`"`from'"')=="old" {
					num_transpsfd_old `var' `touse'    //資料需有變項標籤內容
				}
				if ustrlower(`"`from'"')=="new" {
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

	capture quietly elabel list (`name')
	if !_rc {
		local lab_min = r(min)
		local lab_max = r(max)
	}
	if _rc {
		local lab_min = .
		local lab_max = .
	}

	if `test'==1 {
	quietly sum `name' 
		if inrange(r(max),0,9) & (`lab_min'==. | `lab_max' <= 99) {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .d if `name'==6 & `touse'
			replace `name' = .k if `name'==7 & `touse'    //其他
			replace `name' = .r if `name'==8 & `touse'
			replace `name' = .m if `name'==9 & `touse'
		}
		if inrange(r(max),10,99) & (`lab_min'==. | `lab_max' <= 99) {
			replace `name' = .j if `name'==0  & `touse'
			replace `name' = .u if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==96 & `touse'
			replace `name' = .k if `name'==97 & `touse'    //其他
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999) & (`lab_min'==. | `lab_max' <= 999) {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==991 & `touse'
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if (`name'==992 | `name'==996) & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
			replace `name' = .x if `name'==993 & `touse'    //保留碼
			replace `name' = .y if `name'==994 & `touse'    //保留碼
		}
		if inrange(r(max),1000,9999) & (`lab_min'==. | `lab_max' <= 9999) {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==9991 & `touse'
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if (`name'==9992 | `name'==9996) & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
			replace `name' = .x if `name'==9993 & `touse'    //保留碼
			replace `name' = .y if `name'==9994 & `touse'    //保留碼
		}
		if inrange(r(max),10000,99999) & (`lab_min'==. | `lab_max' <= 99999) {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==99991 & `touse'
			replace `name' = .o if `name'==99995 & `touse'
			replace `name' = .d if (`name'==99992 | `name'==99996) & `touse'
			replace `name' = .r if `name'==99998 & `touse'
			replace `name' = .m if `name'==99999 & `touse'
			replace `name' = .x if `name'==99993 & `touse'    //保留碼
			replace `name' = .y if `name'==99994 & `touse'    //保留碼
		}
		if inrange(r(max),100000,999999) & (`lab_min'==. | `lab_max' <= 999999) {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==999991 & `touse'
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if (`name'==999992 | `name'==999996) & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999) & (`lab_min'==. | `lab_max' <= 9999999) {
			replace `name' = .j if `name'==0 & `touse'
			replace `name' = .u if `name'==9999991 & `touse'
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if (`name'==9999992 | `name'==9999996) & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999) & (`lab_min'==. | `lab_max' <= 99999999) {
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
		if inrange(r(max),0,9) & (`lab_min'==. | `lab_max' <= 99) {
			
			replace `name' = .d if `name'==6 & `touse'
			replace `name' = .k if `name'==7 & `touse'    //其他
			replace `name' = .r if `name'==8 & `touse'
			replace `name' = .m if `name'==9 & `touse'
		}
		if inrange(r(max),10,99) & (`lab_min'==. | `lab_max' <= 99) {
			
			replace `name' = .u if `name'==91 & `touse'
			replace `name' = .o if `name'==95 & `touse'
			replace `name' = .d if `name'==96 & `touse'
			replace `name' = .k if `name'==97 & `touse'    //其他
			replace `name' = .r if `name'==98 & `touse'
			replace `name' = .m if `name'==99 & `touse'
		}
		if inrange(r(max),100,999) & (`lab_min'==. | `lab_max' <= 999) {
			
			replace `name' = .u if `name'==991 & `touse'
			replace `name' = .o if `name'==995 & `touse'
			replace `name' = .d if (`name'==992 | `name'==996) & `touse'
			replace `name' = .r if `name'==998 & `touse'
			replace `name' = .m if `name'==999 & `touse'
		}
		if inrange(r(max),1000,9999) & (`lab_min'==. | `lab_max' <= 9999) {
			
			replace `name' = .u if `name'==9991 & `touse'
			replace `name' = .o if `name'==9995 & `touse'
			replace `name' = .d if (`name'==9992 | `name'==9996) & `touse'
			replace `name' = .r if `name'==9998 & `touse'
			replace `name' = .m if `name'==9999 & `touse'
		}
		if inrange(r(max),10000,99999) & (`lab_min'==. | `lab_max' <= 99999) {
			
			replace `name' = .u if `name'==99991 & `touse'
			replace `name' = .o if `name'==99995 & `touse'
			replace `name' = .d if (`name'==99992 | `name'==99996) & `touse'
			replace `name' = .r if `name'==99998 & `touse'
			replace `name' = .m if `name'==99999 & `touse'
		}
		if inrange(r(max),100000,999999) & (`lab_min'==. | `lab_max' <= 999999) {
			
			replace `name' = .u if `name'==999991 & `touse'
			replace `name' = .o if `name'==999995 & `touse'
			replace `name' = .d if (`name'==999992 | `name'==999996) & `touse'
			replace `name' = .r if `name'==999998 & `touse'
			replace `name' = .m if `name'==999999 & `touse'
		}
		if inrange(r(max),1000000,9999999) & (`lab_min'==. | `lab_max' <= 9999999) {
			
			replace `name' = .u if `name'==9999991 & `touse'
			replace `name' = .o if `name'==9999995 & `touse'
			replace `name' = .d if (`name'==9999992 | `name'==9999996) & `touse'
			replace `name' = .r if `name'==9999998 & `touse'
			replace `name' = .m if `name'==9999999 & `touse'
		}
		if inrange(r(max),10000000,99999999) & (`lab_min'==. | `lab_max' <= 99999999) {
			
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

	capture quietly elabel list (`name')
	if !_rc {
		local lab_min = r(min)
		local lab_max = r(max)
	}
	if _rc {
		local lab_min = .
		local lab_max = .
	}

	quietly sum `name' 
		if inrange(r(max),0,9) & (`lab_min'==. | `lab_max' <= 99) {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
			replace `name' = .k if `name'== 97 & `touse'
		}
		if inrange(r(max),10,99) & (`lab_min'==. | `lab_max' <= 99) {
			replace `name' = .j if `name'== -10  & `touse'
			replace `name' = .a if `name'== -11  & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .x if `name'== -3 & `touse'    //保留碼
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
			replace `name' = .k if `name'== 97 & `touse'
		}
		if inrange(r(max),100,999) & (`lab_min'==. | `lab_max' <= 999) {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .x if `name'== -3 & `touse'    //保留碼
			replace `name' = .y if `name'== -4 & `touse'    //保留碼
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),1000,9999) & (`lab_min'==. | `lab_max' <= 9999) {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .x if `name'== -3 & `touse'    //保留碼
			replace `name' = .y if `name'== -4 & `touse'    //保留碼
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),10000,99999) & (`lab_min'==. | `lab_max' <= 99999) {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .x if `name'== -3 & `touse'    //保留碼
			replace `name' = .y if `name'== -4 & `touse'    //保留碼
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),100000,999999) & (`lab_min'==. | `lab_max' <= 999999) {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .x if `name'== -3 & `touse'    //保留碼
			replace `name' = .y if `name'== -4 & `touse'    //保留碼
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),1000000,9999999) & (`lab_min'==. | `lab_max' <= 9999999) {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .x if `name'== -3 & `touse'    //保留碼
			replace `name' = .y if `name'== -4 & `touse'    //保留碼
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
		if inrange(r(max),10000000,99999999) & (`lab_min'==. | `lab_max' <= 99999999) {
			replace `name' = .j if `name'== -10 & `touse'
			replace `name' = .a if `name'== -11 & `touse'
			replace `name' = .u if `name'== -1 & `touse'
			replace `name' = .b if `name'== -2 & `touse'
			replace `name' = .x if `name'== -3 & `touse'    //保留碼
			replace `name' = .y if `name'== -4 & `touse'    //保留碼
			replace `name' = .o if `name'== -5 & `touse'
			replace `name' = .d if `name'== -6 & `touse'
			replace `name' = .r if `name'== -8 & `touse'
			replace `name' = .m if `name'== -9 & `touse'
		}
end
