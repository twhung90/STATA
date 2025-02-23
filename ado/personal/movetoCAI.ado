
* self-defined program

cap which elabel
if _rc {
	ssc install elabel
}

program define movetoCAI
syntax varlist(min=1), version(string)
marksample touse, novarlist strok
	foreach var of local varlist {
		if regexm("`var'", "^x0+[1-4]+") {
			display "Warnning: `var'這變項為PSFD定義的「樣本特質描述」，將不進行轉換！"
			continue
		}
		cap confirm string variable `var'
		if _rc {
			if ustrlower(`"`version'"')=="old" {
				num_movetocai_old `var' `touse'
			}
			if ustrlower(`"`version'"')=="new" {
				num_movetocai_new `var' `touse'
			}
		}
	}
end

program define num_movetocai_old
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
		if ((inrange(r(max),0,9) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99))) | (`lab_min' >= 0 & `lab_max' <= 99)) {
			replace `name' = 93 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 94 if `name'== .k & `touse'    //其他
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if ((inrange(r(max),10,99) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99))) | (`lab_min' >= 0 & `lab_max' <= 99)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 93 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 94 if `name'== .k & `touse'    //其他
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j & `touse'
			replace `name' = 91 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 91 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if ((inrange(r(max),100,999) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 999))) | (`lab_min' >= 0 & `lab_max' <= 999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 996 if `name'== .j & `touse'
			replace `name' = 991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 995 if `name'== .o & `touse'
			replace `name' = 997 if `name'== .d & `touse'
			replace `name' = 998 if `name'== .r & `touse'
			replace `name' = 999 if `name'== .m & `touse'
			replace `name' = 993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 994 if `name'== .y & `touse'    //保留碼 -4			
		}
		if ((inrange(r(max),1000,9999) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 9999))) | (`lab_min' >= 0 & `lab_max' <= 9999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9996 if `name'== .j & `touse'
			replace `name' = 9991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9995 if `name'== .o & `touse'
			replace `name' = 9997 if `name'== .d & `touse'
			replace `name' = 9998 if `name'== .r & `touse'
			replace `name' = 9999 if `name'== .m & `touse'
			replace `name' = 9993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 9994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),10000,99999) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99999))) | (`lab_min' >= 0 & `lab_max' <= 99999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 99996 if `name'== .j & `touse'
			replace `name' = 99991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 99991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 99995 if `name'== .o & `touse'
			replace `name' = 99997 if `name'== .d & `touse'
			replace `name' = 99998 if `name'== .r & `touse'
			replace `name' = 99999 if `name'== .m & `touse'
			replace `name' = 99993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 99994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),100000,999999) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 999999))) | (`lab_min' >= 0 & `lab_max' <= 999999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 999996 if `name'== .j & `touse'
			replace `name' = 999991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 999991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 999995 if `name'== .o & `touse'
			replace `name' = 999997 if `name'== .d & `touse'
			replace `name' = 999998 if `name'== .r & `touse'
			replace `name' = 999999 if `name'== .m & `touse'
			replace `name' = 999993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 999994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),1000000,9999999) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 9999999))) | (`lab_min' >= 0 & `lab_max' <= 9999999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9999996 if `name'== .j & `touse'
			replace `name' = 9999991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9999991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 9999995 if `name'== .o & `touse'
			replace `name' = 9999997 if `name'== .d & `touse'
			replace `name' = 9999998 if `name'== .r & `touse'
			replace `name' = 9999999 if `name'== .m & `touse'
			replace `name' = 9999993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 9999994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),10000000,99999999) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99999999))) | (`lab_min' >= 0 & `lab_max' <= 99999999))  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 99999996 if `name'== .j & `touse'
			replace `name' = 99999991 if `name'== .u & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 99999991 if `name'== .b & `touse'    //991同時包含不固定、虧損 或 打平
			replace `name' = 99999995 if `name'== .o & `touse'
			replace `name' = 99999997 if `name'== .d & `touse'
			replace `name' = 99999998 if `name'== .r & `touse'
			replace `name' = 99999999 if `name'== .m & `touse'
			replace `name' = 99999993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 99999994 if `name'== .y & `touse'    //保留碼 -4
		}
end

program define num_movetocai_new
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
		if ((inrange(r(max),0,9) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99))) | (`lab_min' >= 0 & `lab_max' <= 99)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 93 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 94 if `name'== .k & `touse'    //其他
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if ((inrange(r(max),10,99) & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99))) | (`lab_min' >= 0 & `lab_max' <= 99)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 93 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 94 if `name'== .k & `touse'    //其他
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 96 if `name'== .j  & `touse'
			replace `name' = 91 if `name'== .u & `touse'
			replace `name' = 92 if `name'== .b & `touse'    //「打平」於2022年後，從-91中切分出來
			replace `name' = 95 if `name'== .o & `touse'
			replace `name' = 97 if `name'== .d & `touse'
			replace `name' = 98 if `name'== .r & `touse'
			replace `name' = 99 if `name'== .m & `touse'
		}
		if ((inrange(r(max),100,999)  & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 999))) | (`lab_min' >= 0 & `lab_max' <= 999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 996 if `name'== .j & `touse'
			replace `name' = 991 if `name'== .u & `touse'
			replace `name' = 992 if `name'== .b & `touse'    //「打平」於2022年後，從-91中切分出來
			replace `name' = 995 if `name'== .o & `touse'
			replace `name' = 997 if `name'== .d & `touse'
			replace `name' = 998 if `name'== .r & `touse'
			replace `name' = 999 if `name'== .m & `touse'
			replace `name' = 993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 994 if `name'== .y & `touse'    //保留碼 -4
			
		}
		if ((inrange(r(max),1000,9999)  & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 9999))) | (`lab_min' >= 0 & `lab_max' <= 9999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9996 if `name'== .j & `touse'
			replace `name' = 9991 if `name'== .u & `touse'
			replace `name' = 9992 if `name'== .b & `touse'    //「打平」於2022年後，從-91中切分出來
			replace `name' = 9995 if `name'== .o & `touse'
			replace `name' = 9997 if `name'== .d & `touse'
			replace `name' = 9998 if `name'== .r & `touse'
			replace `name' = 9999 if `name'== .m & `touse'
			replace `name' = 9993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 9994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),10000,99999)  & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99999)) | (`lab_min' >= 0 & `lab_max' <= 99999)) {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 99996 if `name'== .j & `touse'
			replace `name' = 99991 if `name'== .u & `touse'
			replace `name' = 99992 if `name'== .b & `touse'    //「打平」於2022年後，從-91中切分出來
			replace `name' = 99995 if `name'== .o & `touse'
			replace `name' = 99997 if `name'== .d & `touse'
			replace `name' = 99998 if `name'== .r & `touse'
			replace `name' = 99999 if `name'== .m & `touse'
			replace `name' = 99993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 99994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),100000,999999)  & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 999999))) | (`lab_min' >= 0 & `lab_max' <= 999999))  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 999996 if `name'== .j & `touse'
			replace `name' = 999991 if `name'== .u & `touse'
			replace `name' = 999992 if `name'== .b & `touse'    //「打平」於2022年後，從-91中切分出來
			replace `name' = 999995 if `name'== .o & `touse'
			replace `name' = 999997 if `name'== .d & `touse'
			replace `name' = 999998 if `name'== .r & `touse'
			replace `name' = 999999 if `name'== .m & `touse'
			replace `name' = 999993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 999994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),1000000,9999999)  & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 9999999))) | (`lab_min' >= 0 & `lab_max' <= 9999999))  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 9999996 if `name'== .j & `touse'
			replace `name' = 9999991 if `name'== .u & `touse'
			replace `name' = 9999992 if `name'== .b & `touse'    //「打平」於2022年後，從-91中切分出來
			replace `name' = 9999995 if `name'== .o & `touse'
			replace `name' = 9999997 if `name'== .d & `touse'
			replace `name' = 9999998 if `name'== .r & `touse'
			replace `name' = 9999999 if `name'== .m & `touse'
			replace `name' = 9999993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 9999994 if `name'== .y & `touse'    //保留碼 -4
		}
		if ((inrange(r(max),10000000,99999999)  & (`lab_min'==. | (`lab_min' < 0 & `lab_max' <= 99999999))) | (`lab_min' >= 0 & `lab_max' <= 99999999))  {
			replace `name' = -11 if `name'== .a & `touse'
			replace `name' = 99999996 if `name'== .j & `touse'
			replace `name' = 99999991 if `name'== .u & `touse'
			replace `name' = 99999992 if `name'== .b & `touse'    //「打平」於2022年後，從-91中切分出來
			replace `name' = 99999995 if `name'== .o & `touse'
			replace `name' = 99999997 if `name'== .d & `touse'
			replace `name' = 99999998 if `name'== .r & `touse'
			replace `name' = 99999999 if `name'== .m & `touse'
			replace `name' = 99999993 if `name'== .x & `touse'    //保留碼 -3
			replace `name' = 99999994 if `name'== .y & `touse'    //保留碼 -4
		}
end
