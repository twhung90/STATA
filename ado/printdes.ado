* Title: 可打印出Stata變項的基礎描述統計結果至MS Word檔案中
* Version: 1.0.3
* Date: 2024.09.26
* Author: Tamao

program define printdes
version 18
syntax varlist(min=1) [if] [in] [, form(string) version(string)]  //form defuult = "CAI"; version default = "new"
marksample touse, novarlist strok

* 壓縮資料檔
preserve
display in yellow " ● STEP - 1. 資料格式轉換中 - "
quietly compress

* 先轉換特殊碼
if ustrlower(`"`form'"') =="psfd" {
	if ustrlower(`"`version'"')=="old" {
		disp "--------- Convert the PSFD data format now ---------"
		quietly transPSFD `varlist', from(`"`version'"')
	}
	else {
		disp "--------- Convert the PSFD data format now ---------"
		quietly transPSFD `varlist', from("new")
	}
}
else {
	if ustrlower(`"`version'"')=="old" {
		disp "--------- Convert the CAI data format now ---------"
		quietly transCAI `varlist', from(`"`version'"')
	}
	else {
		disp "--------- Convert the CAI data format now ---------"
		quietly transCAI `varlist', from("new")
	}
}

display in yellow " ● STEP - 2. 資料轉換完成 - "

* 創建及設定MS Word文檔頁面
putdocx clear
putdocx begin, pagesize("A4") margin(top, 1.2 cm) margin(bottom, 1.2 cm) margin(left, 1.2 cm) margin(right, 1.2 cm)

foreach var1 of local varlist {
	local var_name : var l `var1'
	capture confirm string variable `var1'
	
	if !_rc {
		continue
	}
	if _rc {
		//計算缺失值
		quietly count if `touse' & `var1'==.d
		global dont = r(N)
		quietly count if `touse' & `var1'==.r
		global refus = r(N)
		quietly count if `touse' & `var1'==.m
		global miss = r(N)
		quietly count if `touse' & `var1' < .
		global total = r(N)
	
		//讀取elabel值標籤
		cap quietly elabel list (`var1')
		if !_rc {
			local lab_min = r(min)
			local lab_max = r(max)
		}
		if _rc {
			local lab_min = .
			local lab_max = .
		}
		putdocx paragraph
		putdocx text ("`var1'的描述性統計：`var_name'")
	
		if (r(min) > 0 & r(min) <= 90) {
			des_nominal `var1' `form' `version' `touse'
		}
		
		else {
		* 檢查變數類型
		local var_type : type `var1'
		quietly summarize `var1'

			if "`var_type'" == "float" | "`var_type'" == "double" {
				//如果是連續變項，計算平均值和標準差
				des_continuous `var1' `form' `version' `touse'
			} 
			else if "`var_type'" == "int" | "`var_type'" == "long" {
				//如果是整數型連續變項，計算平均值和標準差
				des_continuous `var1' `form' `version' `touse'
			} 
			else if "`var_type'" == "byte" & ((`lab_min' >= 0 & `lab_max' <= 90) | (`lab_min' < 0 & (`lab_max' > 0 & `lab_max' <= 90))) {
				//如果是byte變項，且最大值標籤小於等於90，呈現資料次數分配				
				des_nominal `var1' `form' `version' `touse'
			}
			else if "`var_type'" == "byte" & ((`lab_min' < 0  & `lab_max' < 0)  | (`lab_max' > 90 & `lab_max' < .)) {
				//如果是byte變項，且最大值標籤大於90，計算平均值和標準差
				des_continuous `var1' `form' `version' `touse'
			}
			else if r(N)==0 {
				des_continuous `var1' `form' `version' `touse'
			}
			else {
				des_nominal `var1'  `form' `version' `touse'
			}
		}
	}
}

putdocx save "output.docx", replace
restore
	
end

program define des_nominal
args name type vers touse
preserve
	if ustrlower(`"`type'"') =="cai" & ustrlower("`vers'")=="new" {
		quietly replace `name' = .s if `name'==.j
		quietly movetoCAI `name', version("`vers'")
	}
	if ustrlower(`"`type'"') =="cai" & ustrlower(`"`vers'"')=="old" {
		quietly replace `name' = .s if `name'==.j
		quietly movetoCAI `name', version("`vers'")
	}
	if ustrlower(`"`type'"') =="psfd" & ustrlower(`"`vers'"')=="new" {
		quietly replace `name' = .s if `name'==.j
		quietly movetoPSFD `name', version("`vers'")
	}
	if ustrlower(`"`type'"') =="psfd" & ustrlower(`"`vers'"')=="old" {
		quietly replace `name' = .s if `name'==.j
		quietly movetoPSFD `name', version("`vers'")
	}
	
	lab var `name' ""    //清除變項名稱
	table `name' if `touse', stat(freq) stat (percent)     //stata 18 版本適用
	restore
		
	putdocx collect
	putdocx paragraph
	putdocx text ("不知道： ${dont}，拒答： ${refus}，遺漏值： ${miss}")
	putdocx paragraph, font("", 11, gray)
	putdocx text ("============================分 隔 線============================")
	
end

program define des_continuous
args name type vers touse

	summarize `name' if `touse'
	local mean = round(r(mean), 0.001)
	local sd = round(r(sd), 0.001)

	//將結果寫入MS Word文檔
	putdocx paragraph
	putdocx text ("平均值為: `mean'，標準差為: `sd'"), font("", 12) bold
	putdocx paragraph
	putdocx text ("不知道： ${dont}，拒答： ${refus}，遺漏值： ${miss}，")
	putdocx text ("觀察值： ${total}"), bold
	putdocx paragraph, font("", 11, gray)
	putdocx text ("============================分 隔 線============================")
	
end