
program define CAI_label_refine
version 15
syntax [anything]
marksample touse, strok

local data `anything'
use "`data'", clear

cap which elabel
if _rc {
	ssc install elabel
}

quietly ds, has(vallabel)
local valist "`r(varlist)'"

 local i = 1
 foreach var of varlist * {
 	local test: list var in valist    //判斷變項是否有定義值標籤
	
   if `test'==0 {
	 continue
   }

   if `test'==1 {
   cap confirm string variable `var'

	 if !_rc {
	 continue
	 }

	 if _rc {
	 preserve
	 cap elabel list (`var') 
		
	 	 clear   //清空資料
		 set obs 1    //僅設定單一個觀察值
		 cap gen novar = `i'    //變項流水號                
		
		 cap gen variable = "`var'"
		 cap gen var_val = r(values)
		 cap gen var_lab = r(labels)
		
		 cap split var_val, p(" ")
		 cap destring var_val?*, replace
		
		 cap egen nomiss = rownonmiss(var_val?*), strok
		 if nomiss < 100 {
			 cap egen item_num = anycount(var_val?*), value(0/90 94)
		 }
		 if nomiss > 100 & nomiss < 1000 {
			 cap egen item_num = anycount(var_val?*), value(0/990)
		 }
		 cap egen val_max = rowmax(var_val?*)
		 cap egen val_min = rowmin(var_val?*)
		
		 cap tostring val_max, replace
		 cap gen var_mlens = length(val_max)    //包含特殊碼，便項的字元長度 
		 cap destring val_max, replace
		
		 cap split var_lab, p(`"" ""')    //使用跳脫字元，以「字串」與「字串」之間的" "間隙進行切分
		 cap drop var_val var_lab
		
		 * 轉換為long format資料(新版PSFDy特殊碼)
		 cap reshape long var_val var_lab, i(variable) j(n)
		
		 cap replace var_lab = subinstr(var_lab,`"""',"", .)    //消除字串中多餘的"字元符號
		
		 if var_mlens==1 {
		 	 replace var_val = -10 if var_val==96
			 replace var_val = -6 if var_val==97
			 replace var_val = -8 if var_val==98
			 replace var_val = -9 if var_val==99
			 replace var_val = 97 if var_val==94    //其他，轉為編碼97
			
			 cap gen var_vals = string(var_val)
		 }
		 if var_mlens==2 {
			 replace var_val = -10 if var_val==96
			 replace var_val = -6 if var_val==97
			 replace var_val = -8 if var_val==98
			 replace var_val = -9 if var_val==99
			 replace var_val = 97 if var_val==94    //其他，轉為編碼97
			
			 cap gen var_vals = string(var_val)
			 cap replace var_vals = ("0" + var_vals) if var_val >= 0 & var_val < 10 & (item_num >= 10 & item_num < .) 
		 }
		 if var_mlens==3 {
			 replace var_val = -10 if var_val==996
			 replace var_val = -10 if var_val==9996
			 replace var_val = -6 if var_val==997
			 replace var_val = -6 if var_val==9997
			 replace var_val = -8 if var_val==998
			 replace var_val = -8 if var_val==9998
			 replace var_val = -9 if var_val==999
			 replace var_val = -9 if var_val==9999
			
			 cap gen var_vals = string(var_val)
			 cap replace var_vals = ("00" + var_vals) if var_val >= 0 & var_val < 10 & (item_num >= 10 & item_num < .) 
			 cap replace var_vals = ("0" + var_vals) if var_val >= 10 & var_val < 100 & (item_num >= 10 & item_num < .) 
		 }
		 if var_mlens==4 {
			 replace var_val = -10 if var_val==9996
			 replace var_val = -10 if var_val==99996
			 replace var_val = -6 if var_val==9997
			 replace var_val = -6 if var_val==99997
			 replace var_val = -8 if var_val==9998
			 replace var_val = -8 if var_val==99998
			 replace var_val = -9 if var_val==9999
			 replace var_val = -9 if var_val==99999
			
			 cap gen var_vals = string(var_val)
			 cap replace var_vals = ("000" + var_vals) if var_val >= 0 & var_val < 10 & (item_num >= 10 & item_num < .) 
			 cap replace var_vals = ("00" + var_vals) if var_val >= 10 & var_val < 100 & (item_num >= 10 & item_num < .) 
			 cap replace var_vals = ("0" + var_vals) if var_val >= 100 & var_val < 1000 & (item_num >= 10 & item_num < .) 
		 }
		
		 cap order var_vals, before(var_lab)
		 cap order var_mlens, after(var_lab)
		
		 cap gen var_labs = var_vals + " " + var_lab
		
		 * 產生Stata指令的文字字串
		 cap gen syntax = "lab define "+ variable + " " + string(var_val) + " "+ "`"+`"""'+var_labs + `"""'+"'" + ", modify"
		
		 *cap drop novar - var_labs
		 save ".\label\rawdata\\`var'.dta", replace
		
		 * export the value labels
		 local t = _N
		 foreach n of numlist 1/`t' {
			 global sya = syntax[`n']
			 $sya
		 }
		 
		 cd ..    //退回上一層資料夾
		 ! if not exist ".\label\do\" mkdir ".\label\do\"    //使用Windows batch建立一個存放do檔的資料夾
		 label save `var' using `".\\label\\do\\`var'"', replace
		
	 restore
	
	 }
	
 local ++i

   }
 }
 
end
