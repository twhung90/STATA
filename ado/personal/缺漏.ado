* self-defined program

cap which elabel
if _rc {
	ssc install elabel
}

program define 缺漏
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
		if (inrange(r(max),0,99) & (`lab_min'==. | `lab_max' <= 99)) | (`lab_max' > 90 & `lab_max' <= 99)  {
			replace `name' = 99 if `touse'
		}
		if (inrange(r(max),100,999) & (`lab_min'==. | `lab_max' <= 999)) | (`lab_max' > 990 & `lab_max' <= 999)  {
			replace `name' = 999 if `touse'
		}
		if (inrange(r(max),1000,9999) & (`lab_min'==. | `lab_max' <= 9999)) | (`lab_max' > 9990 & `lab_max' <= 9999)  {
			replace `name' = 9999 if `touse'
		}
		if (inrange(r(max),10000,99999) & (`lab_min'==. | `lab_max' <= 99999)) | (`lab_max' > 99990 & `lab_max' <= 99999)  {
			replace `name' = 99999 if `touse'
		}
		if (inrange(r(max),100000,999999) & (`lab_min'==. | `lab_max' <= 999999)) | (`lab_max' > 999990 & `lab_max' <= 999999)  {
			replace `name' = 999999 if `touse'
		}
		if (inrange(r(max),1000000,9999999) & (`lab_min'==. | `lab_max' <= 9999999)) | (`lab_max' > 9999990 & `lab_max' <= 9999999)  {
			replace `name' = 9999999 if `touse'
		}
		if (inrange(r(max),10000000,99999999) & (`lab_min'==. | `lab_max' <= 99999999)) | (`lab_max' > 99999990 & `lab_max' <= 99999999)  {
			replace `name' = 99999999 if `touse'
		}
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
