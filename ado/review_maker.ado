* Title: PSFD調查補問問卷產生器(需要區分問卷別)
* Author: Tamao
* Version: 1.0.2
* Date: 2024.10.02

program define review_maker
syntax anything, year(integer) mode(string) merge_data(string) [id(name) attr_set(namelist)]
marksample touse, strok

if "`id'"=="" {
	local id = `"id"'
}

if "`attr_set'"=="" {
	local attr_set `"Group Name Sex"'
	tokenize "`attr_set'"
}
else {
	tokenize "`attr_set'"
	local attr_set `"`1' `2' `3'"'
}

import excel `anything', firstrow clear
drop if strtrim(review)==""    //刪除不需要補問的條目與內容
merge m:1 `id' using `merge_data', keepusing(`attr_set')    //併入當期的屬性資料檔
drop if _merge==2
drop _merge

gen type = ""
replace type = "C" + "`year'-" + "`mode'" + "問卷" if `1'==1
replace type = "RCI" + "`year'-" + "`mode'" + "問卷" if `1'==2
replace type = "RR" + "`year'-" + "`mode'" + "問卷" if `1'==3

gen sex = ""
replace sex = "先生" if `3'==1
replace sex = "女士" if `3'==2

bysort `id': gen idn = _n
bysort `id': gen id_total = _N

local a = 1

local total = _N
while `a' <= `total' {
	preserve
	keep if `id'==`id'[`a']
	display in yellow "-----------Reading at rows `a'-----------"

	output_docx `year' `id' `1' `2' `3' `touse'
	
	local a = `a' + id_total[1]
	restore
	}

end

program define output_docx
args number ID Group Name Sex touse
version 17

local id = `ID'[1]
local name = `Name'[1]
local type = type[1]
local sex = sex[1]
local rows = (id_total[1] * 4)    //共計入選4個欄位：Description, Result, Review, Remark
local total = id_total[1]

	putdocx clear
	putdocx begin, pagesize("A4") margin(top, 1.27 cm) margin(bottom, 1.27 cm) margin(left, 1.27 cm) margin(right, 1.27 cm)
	putdocx paragraph, font("標楷體",14) spacing(after, 12 pt) halign("center")    //設定段落與後段間距為12點
	putdocx text ("家庭動態調查─"), bold font("標楷體",18)
	putdocx text ("`number'"), bold font("Times New Roman",18)
	putdocx text ("補問問卷"), bold font("標楷體",18)
	
	putdocx table inform = (3,9), halign("left") 
	putdocx table inform(1,1) = ("受訪者編號："+"`id'"), colspan(3) font("標楷體",12)
	putdocx table inform(1,2) = ("姓名："+"`name'"+"（`sex'）"), colspan(3) font("標楷體",12)
	putdocx table inform(1,3) = ("問卷別："+"`type'"), colspan(3) font("標楷體",12)
	putdocx table inform(2,1) = ("補充說明："), colspan(9) font("標楷體",12)
	putdocx table inform(3,1) = ("補問題目"), colspan(9) halign(center) font("標楷體",14) border(top, double)
	putdocx paragraph, font("標楷體",12) halign("left")
	
	local list_rows = `rows' + 1
	putdocx table list = (`list_rows',9), halign("left")
	putdocx table list(1,1) = ("補問邏輯（"+"`total'）"), colspan(9) font("標楷體",12)
	
	local co = 1
	local sp = 1
	forvalues r = 1/`rows' {
		if mod(`r',4)==1 {
			local ++sp
			putdocx table list(`sp',1) = ("Description= "+ description[`co']), colspan(9) font("新細明體",12)
		}
		if mod(`r',4)==2 {
			local ++sp
			putdocx table list(`sp',1) = ("Result= "+ result[`co']), colspan(9) font("新細明體",12) border(top, nil)
		}
		if mod(`r',4)==3 {
			local ++sp
			putdocx table list(`sp',1) = ("Review： "+ review[`co']+"；"), colspan(9) font("新細明體",12) border(top, nil)
			putdocx table list(`sp',1) = ("Modify： "+ modify[`co']), font("新細明體",12, cornflowerblue) append
		}
		if mod(`r',4)==0 {
			local ++sp
			putdocx table list(`sp',1) = ("Remark= "+ remark[`co']), colspan(9) font("新細明體",12) border(top, nil)
			local ++co
		}
	}

putdocx save "`number'年補問單_`id'.docx", replace

end
