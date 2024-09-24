* Title: 打印出Stata描述統計結果至MS Word檔案中
* Version: 1.0.2
* Date: 2024.09.24
* Author: Tamao

program define printdes
version 18
syntax varlist(min=1) [if] [in]
marksample touse, novarlist strok

* 壓縮資料檔
preserve
display in yellow " ● STEP - 1. 資料轉換中 - "
quietly compress
display in yellow " ● STEP - 2. 資料轉換完成 - "

* 先排除特殊碼，例如 -99 或其他遺漏值
quietly transCAI `varlist', from("new")

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
	
		if r(min) <= 90 {
			des_nominal `var1' `touse'
		}
		
		else {
		* 檢查變數類型
		local var_type : type `var1'
		quietly summarize `var1'

			if "`var_type'" == "float" | "`var_type'" == "double" {
				//如果是連續變項，計算平均值和標準差
				des_continuous `var1' `touse'
			} 
			else if "`var_type'" == "int" | "`var_type'" == "long" {
				//如果是整數型連續變項，計算平均值和標準差
				des_continuous `var1' `touse'
			} 
			else if "`var_type'" == "byte" & `lab_max' <= 90 {
				//如果是byte變項，且最大值標籤小於等於90，呈現資料次數分配				
				des_nominal `var1' `touse'
			}
			else if "`var_type'" == "byte" & `lab_max' > 90 & `lab_max' < . {
				//如果是byte變項，且最大值標籤大於90，計算平均值和標準差
				des_continuous `var1' `touse'
			}
			else if r(N)==0 {
				des_continuous `var1' `touse'
			}
			else {
				des_nominal `var1' `touse'
			}
		}
	}
}

putdocx save "output.docx", replace
restore
	
end

program define des_nominal
args name touse

	preserve
	quietly replace `name' = 97 if `touse'  & `name'== .d
	quietly replace `name' = 98 if `touse'  & `name'== .r
	quietly replace `name' = 99 if `touse'  & `name'== .m
	
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
args name touse

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
