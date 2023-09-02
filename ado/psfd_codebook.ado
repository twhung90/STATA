* Title: PSFD編碼簿產生器
* Author: Tamao
* Version: 3.2.1
* Date: 2023.08.15

program define psfd_codebook
version 17
syntax anything
marksample touse, strok
! if not exist ".\documents\rawdata\" mkdir ".\documents\rawdata\"
	
	global file "${S_FN}"
	global path "`pwd'"
	global part = 1
	cap blocks `anything'   //使用自定義的程式
	
	* export the table to Word (需使用Stata 17)
	quietly cd ".\documents"
	
	putdocx clear
	putdocx begin, pagesize("A4") margin(top, 1 cm) margin(bottom, 1 cm) margin(left, 1.2 cm) margin(right, 1.2 cm)     //stata 17適用
	putdocx paragraph, font("新細明體",12) spacing(after, 12 pt) halign("center")    //設定段落與後段間距為12點
	putdocx text ("家庭動態調查："), bold font("新細明體",12)
	putdocx text ("2022"), bold font("Times New Roman",12)
	putdocx text ("追蹤問卷（"), bold font("新細明體",12)
	putdocx text ("RR 2022"), bold font("Times New Roman",12)
	putdocx text ("）"), bold font("新細明體",12)
	putdocx text ("Codebook"), bold font("Times New Roman",12)

	putdocx paragraph, font("新細明體",12) spacing(after, 0 pt) halign("left")
	putdocx text ("變項名稱之形式如下   □ □□ □ □□ □□"), allcaps
	putdocx paragraph, font("Times New Rowman",12) spacing(line, 12 pt) halign("left")
	putdocx text ("                                        1   2 3    4    5 6    7 8")
	putdocx paragraph, font("新細明體",12) spacing(line, 12 pt) halign("left")
	putdocx text ("說明：")
	putdocx paragraph, spacing(after, 0 pt)
	putdocx paragraph, font("新細明體",12) spacing(before, 12 pt) halign("center")
	putdocx text ("[說明表格置於此]")
	putdocx paragraph, spacing(after, 0 pt)
	putdocx paragraph, font("新細明體",12) spacing(after, 12 pt) halign("left")
	putdocx text ("過錄的基本原則：")
	putdocx table tb0 = (9, 3), width(35,20,45) border(all, nil)
	putdocx paragraph
	putdocx text ("● 注意：家庭動態調查自2022年起，將特殊碼轉換為「負值」")
	
	putdocx table tb0(1,1) = ("「不合理值」"), halign(left)
	putdocx table tb0(1,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(1,3) = ("-11"), halign(left)
	putdocx table tb0(2,1) = ("「跳答、不適用」 "), halign(left)
	putdocx table tb0(2,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(2,3) = ("-10"), halign(left)
	putdocx table tb0(3,1) = ("「遺漏值」 "), halign(left)
	putdocx table tb0(3,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(3,3) = ("-9"), halign(left)
	putdocx table tb0(4,1) = ("「拒答」 "), halign(left)
	putdocx table tb0(4,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(4,3) = ("-8"), halign(left)
	putdocx table tb0(5,1) = ("「不知道、不清楚、不記得」"), halign(left)
	putdocx table tb0(5,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(5,3) = ("-6"), halign(left)
	putdocx table tb0(6,1) = ("「（數值）超過欄位上限範圍」"), halign(left)
	putdocx table tb0(6,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(6,3) = ("-5"), halign(left)
	putdocx table tb0(7,1) = ("「（金額）虧損或打平」"), halign(left)
	putdocx table tb0(7,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(7,3) = ("-2"), halign(left)
	putdocx table tb0(8,1) = ("「（數值）不固定」"), halign(left)
	putdocx table tb0(8,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(8,3) = ("-1"), halign(left)
	putdocx table tb0(9,1) = ("「其他」"), halign(left)
	putdocx table tb0(9,2) = ("---------->過錄為："), halign(left)
	putdocx table tb0(9,3) = ("97、997、9997"), halign(left)
	
	putdocx paragraph, font("新細明體",12) indent(left, 200 twip) halign("left") spacing(after, 0 pt)
	putdocx text ("行業及職業代碼說明：")
	putdocx table tb1 = (2, 2)
	putdocx table tb1(1,1) = ("行業代碼"), halign(center)
	putdocx table tb1(1,2) = ("職業代碼"), halign(center)
	putdocx table tb1(2,1) = ("中華民國行業標準分類：第10次修訂"), linebreak(1)
	putdocx table tb1(2,1) = ("（民國105年1月）"), append
	putdocx table tb1(2,2) = ("中華民國職業標準分類：第6次修訂") , linebreak(1)
	putdocx table tb1(2,2) = ("（民國99年5月）") , append

	putdocx pagebreak    //插入分頁符號
	putdocx save _codebook_cover_.docx, replace
	
	if $part==1 {
		quietly putdocx append "_codebook_cover_.docx" "_codebook_table_part_1_.docx"
		erase "_codebook_table_part_1_.docx"
	}
	else if $part > 1 {
		local tt = $part - 1
		forvalue n = 1/`tt' {
		quietly putdocx append "_codebook_cover_.docx" "_codebook_table_part_`n'_.docx"
		erase "_codebook_table_part_`n'_.docx"
		}
	}
	
	! rmdir /s /q ".\rawdata"    //刪除所有rawdatay資料夾中的資料
	quietly cd "..\"
	disp "------------恭喜！已順利完成 PSFD 編碼簿的製作------------"
end

program define blocks
syntax [anything]
	local rest "`anything'"
	while "`rest'" != "" {
		tokenize "`rest'", parse("|")
			local v1 `1'
				data_process `v1'   //使用自定義的程式
			local which = 2
			macro shift `which'    //將macro的參照對象移至第二個結果
			local rest `*'
	}
end

program define data_process
syntax [varlist(min=1)]
local varlists "`varlist'"

	cap which elabel
		if _rc {
	ssc install elabel
	}
	
	use "${file}", clear
	local i = 1
	foreach var of local varlists {
	cap confirm string variable `var'

		if !_rc {
		continue
		}

		if _rc {
		preserve
		cap elabel list (`var')
		local lab: variable label `var'
		
			clear   //清空資料
			set obs 1    //僅設定單一個觀察值
			cap gen novar = `i'    //變項流水號
			cap gen description = "`lab'"    //變項說明 
                           		
			cap gen item = ustrtitle(regexs(1)) + strtrim(regexs(3)) ///
						   if regexm("`var'", "^([a-z]+[0-9]?[0-9]?)([a-z 0-9]*)([cfmprs]?[0-9]*)$"), before(description)
			cap gen variable = "`var'"
			cap gen var_val = r(values)
			cap gen var_lab = r(labels)
		
			cap split var_val, p(" ")
			cap destring var_val?*, replace
			cap egen item_num = anycount(var_val?*), value(0/90)
			cap egen val_max = rowmax(var_val?*)
			cap egen val_min = rowmin(var_val?*)
		
			cap tostring val_max, replace
			cap gen var_lens = length(val_max) 
		
			cap split var_lab, p(`"" ""')    //使用跳脫字元，以「字串」與「字串」之間的" "間隙進行切分
			cap drop var_val var_lab
		
			cap reshape long var_val var_lab, i(variable) j(n)
			drop n
			cap replace var_lab = subinstr(var_lab,`"""',"", .)    //消除字串中多餘的"字元符號

			cap split var_lab, p(" ") gen(little)   //僅擷取值標籤中，後半段的文字
			cap replace var_lab = little2 if strtrim(little2)!=""
			cap replace var_lab = little1 if strtrim(little2)==""
			cap drop little*
		
			cap gen var_vals = string(var_val)
			cap replace var_vals = ("00" + var_vals) if (item_num >= 100 & item_num < 991) & (var_val >=0 & var_val < 10)
			cap replace var_vals = ("0" + var_vals) if (item_num >= 10 & item_num < 91) & (var_val >=0 & var_val < 10)
			cap replace var_vals = ("("+ var_vals + ")" + " " + var_lab)
		
			cap order var_vals, before(var_lab)
			cap order var_lens, after(var_lab)
			cap drop item_num val_max var_lab

		    	keep if var_val > 0 & var_val < .    //保留標籤數值為大於0的正值
			gen n = _n, after(variable)

			egen max_n = max(n)
			if max_n > 100 {
				drop if var_val > 99 & var_val < 9991     //僅保留小於100以下的選項名稱，通常為「郵遞區號」或「行職業碼」等地會被刪除
			}
			
			save ".\documents\rawdata\_`var'_.dta", replace    //只有選項總數小於100以下才存檔
		restore
		
		}
	local ++i
	}
	preserve    //保存原初資料檔
		seg_data_collecting   //使用自定義的程式
	restore     //回復原初資料檔
end

program define seg_data_collecting
	cd ".\documents\rawdata"
	! del label_rr2022_part_*.dta    // delete temp data in the folder (for Windows)
	! dir *.dta /a-d /b >"label_information.txt"

	clear

	file open myfile using "label_information.txt", read

	file read myfile line
	use `line'
	save "label_rr2022_part_${part}.dta", replace
	file read myfile line
	while r(eof)==0 { 
		append using `line'
		file read myfile line
	}
	file close myfile

	bysort variable: gen span = _N    //計算重複的間格格數
	replace description = "" if (n != 1 & n != .)
	replace variable = "" if (n != 1 & n != .)
	
	gen remark = ""
	sort novar n   //按變項流水號排序
	gen nn =_n, before(n)
	gen i = nn if n==1
	order i span, after(n)
	
	save "label_rr2022_part_${part}.dta", replace
	! del _*_.dta    // delete temp data in the folder (for Windows)
	
	printdocx "label_rr2022_part_${part}"
	quietly cd "..\.."
end

program define printdocx
version 17
syntax anything
local pdata `anything'
	use "`pdata'", clear
	putdocx clear
	putdocx begin, pagesize("A4") margin(top, 1 cm) margin(bottom, 1 cm) margin(left, 1.2 cm) margin(right, 1.2 cm)     //stata 17適用
	putdocx table tab1 = data(item variable description var_vals var_lens remark), ///
					 varnames halign("left") headerrow(1) width(3,3,30,35,3,26) 
	local total = _N
	forvalue i = 1/`total' {
		local b = (`i' + 1)   //需要加1，因為varnames也算一個row cell
		putdocx table tab1(`b',4), border(top, nil)
	
	while n[`i']==1 {
		local s = span[`i']
		local p = (`i' + 1)   //需要加1，因為varnames也算一個row cell
		putdocx table tab1(`p',1) = (item[`i']), rowspan(`s')
		putdocx table tab1(`p',2) = (variable[`i']), rowspan(`s')
		putdocx table tab1(`p',3) = (description[`i']), rowspan(`s')
		putdocx table tab1(`p',4), border(top, single)
		putdocx table tab1(`p',5) = (var_lens[`i']), rowspan(`s')
		continue, break
		}
	}
	quietly cd "..\"
	putdocx save "_codebook_table_part_${part}_.docx", replace
	cap global part = $part + 1
	quietly cd ".\rawdata\"
end
