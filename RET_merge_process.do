* Title: The retirement and the wellbing (new samplings in 1999 and 2000 only)
* Editot: Tamao
* Date: 2020.10.22

clear
set more off
cd "D:\PSFD\RET"

*RI1999(new sampling)：A panel
use ri1999, clear
gen period = x02    //survey period
order period, after(x01)

recode x06 (996/999=.), gen(district)

recode a01 (2=0), gen(male)
gen birth_y = (1911 + a02) if a02 < 96
gen Sbirth_y = (1911 + d11) if d11 < 96

recode a04a (0 7/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode d15a (0 7/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode a04b (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap1)

recode b01 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(edu)

recode d13 (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學") ///
(4/5=2 "2 國中/初職")(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院") ///
(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上")(97=97 "97 other")(96 98/99=.), gen(Sedu)

gen gradu_yr = (b02z01 + 1911) if (b02z01 > 0 & b02z01 < 96)    //畢業年分

recode c01 (0=990 "不適用")(6/9=.)(1=1 "有")(2=0 "無"), gen(work)
recode d16 (0=990 "不適用")(6/9=.)(1=1 "有")(2=0 "無"), gen(Swork)

recode c05 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)
recode d20 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(Semp)

recode c04a01 (0 = 990 "990 不適用")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)    //no work or unemployment are recoded as 990

recode c04a02 0 9996/9999=., gen(PSFDcode)
replace PSFDcode=. if (c01==2 & c02==2)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if c04a02==0
drop isco??

recode d19a01 (0 = 990 "990 不適用")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)    //no work or unemployment are recoded as 990

recode d19a02 0 9996/9999=., gen(PSFDcode)
replace PSFDcode=. if (d16==2 & d17==2)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if d19a02==0
drop isco??

gen retire = (c03==1)
gen Sretire = (d18==3)

recode c04b (0=990)(96 98/99=.), gen(workfor)
recode d19b (0=990)(96 98/99=.), gen(Sworkfor)

recode c06z02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
recode d21z02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(Sworkplace)

label define workfor 1"自己一人工作，沒有雇用其他人" 2"自己當老闆，而且有雇用別人" ///
					 3"為私人雇主或私人機構工作" 4"為公營企業工作" 5"幫家裡工作，支領固定薪水" ///
					 6"為政府機構工作" 7"為非營利機構工作" 8"幫家裡工作，沒有拿薪水" ///
					 9"和他人合夥，沒有雇人" 97"其他" 990"不適用"
label value workfor Sworkfor workfor

recode c07 (0 996/999=.), gen(workhr)
recode d22 (0 996/999=.), gen(Sworkhr)

recode c08 (0 9999996/9999999=.), gen(wage)
recode d23 (0 9999996/9999999=.), gen(Swage)

recode c09 (0 97/99=.)(80=0), gen(seniority)    //未滿一年則編碼為0
gen Sseniority = (period - 1911) - d24 if d24 < 96

recode d01z01 (2/3=2)(4/5=3)(6=4)(97/99=.), gen(mar4)    //婚姻四分類
lab define mar4 1"未婚" 2"已婚/同居" 3"分居/離婚" 4"喪偶"
lab value mar4 mar4

gen ohouse = (g03a==1)    //自有房屋

recode g03e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)

recode h06z01 (9999991/9999999=.), gen(exp_hmortage)
recode h05a02p1 (0 9999991/9999999=.), gen(exp_parent)
recode h05a02p2 (0 9999991/9999999=.), gen(exp_Sparent)

forvalue a = 1/4 {
recode j02z01c`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-j02z02c`a') if j02z02c`a'>0 & j02z02c`a'<96

recode j02z03c`a' (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4=2 "2 國中/初職")(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child`a'_edu)
}

gen live_parent = (f06f1==1 | f06m1==1)
gen live_sparent = (f06f2==1 | f06m2==1)

recode j01 (96/99=.), gen(offspring)

keep x01 period x01b district - offspring
save A_1999, replace


*RII2000
use rii2000, clear
gen period = x02    //survey period
order period, after(x01)

recode x06 (996/999=.), gen(district)

recode a01 (2=0), gen(male)
gen birth_y = (1911 + a02) if a02 < 96
gen Sbirth_y = (1911 + a06) if a06 < 96

recode a03 (1/2=0 "0 無/自修") (3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
		   (9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
		   (97=97 "97 other")(96 98/99=.), gen(edu)

recode a08 (0=990 "990 不適用")(1/2=0 "0 無/自修") (3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
		   (9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
		   (97=97 "97 other")(96 98/99=.), gen(Sedu)

recode a04 (0 6/99=.), gen(health)
replace health = (6-health)    //inversed coding
recode a09 (0 6/99=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode a05z01 (2/3=2)(4/5=3)(6=4)(97/99=.), gen(mar4)
lab define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
lab value mar4 mar4

recode c01 (0=990 "不適用")(6/9=.)(1=1 "有")(2=0 "無"), gen(work)
recode c19 (0=990 "不適用")(6/9=.)(1=1 "有")(2=0 "無"), gen(Swork)

recode c04 (0=990 "990 Not available")(1=1 "3 and less")(2=2 "4-9")(3=3 "10-29")(4=4 "30-49") ///
(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)

recode c03a01 (0 = 990 "990 不適用")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = 990 if c01==2 & c02>=3 & c02<=97    //無工作/失業者編碼為990

recode c03a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode = . if c01==2 & c02>=3 & c02<=97     //目前沒有工作者表示為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if c03a02==0
drop isco??

recode c21a01 (0 = 990 "990 不適用")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = 990 if c19==2 & c20>=3 & c20<=97    //無工作/失業者編碼為990

recode c21a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode = . if c19==2 & c20>=3 & c20<=97     //目前沒有工作者表示為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if c21a02==0
drop isco??

gen retire = (c02==7)
gen Sretire = (c20==7)

recode c03b (0=990 "不適用")(96 98/99=.), gen(workfor)
recode c21b (0=990 "不適用")(96 98/99=.), gen(Sworkfor)

recode c05z02 (0=990 "990 不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
gen Sworkplace = .

recode c06b (0 9999991/9999999=.), gen(wage)
recode c22 (0 9999991/9999999=.), gen(Swage)
recode c07 (0 995/999=.), gen(workhr)
recode c23 (0 995/999=.), gen(Sworkhr)

gen seniority=.
	gen y = c08z02 if c08z02 <96
	gen m = (c08z03/12) if c08z03 <96
	replace seniority = m if c08z01==2
	replace seniority = y+m if c08z01==3
	drop y m

gen Sseniority=.

recode f01 (96/99=.), gen(offspring)

recode e02a (9999991/9999999=.), gen(exp_hmortage)    //家庭每月支出的房貸金額

egen family = rowtotal(d04z*)    //the number of people living together

gen live_spouse = (d04z01 >= 1 & d04z01 < 96)
gen live_marson = (d04z02 >= 1 & d04z02 < 96)
gen live_mardau = (d04z03 >= 1 & d04z03 < 96)
gen live_sinson = (d04z04 >= 1 & d04z04 < 96)
gen live_sindau = (d04z05 >= 1 & d04z05 < 96)
gen live_parent = (d04z08 >= 1 & d04z08 < 96)
gen live_sparent = (d04z09 >= 1 & d04z09 < 96)
gen live_grachild = (d04z06 >=1 & d04z06 < 96)    //與孫子女同住

keep x01 period x01b district - live_grachild
save A_2000, replace


*RI2000(new sampling)：B panel
use ri2000, clear
gen period = x02    //survey period
order period, after(x01)

recode x06 (996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (a02+1911) if a02 < 96 & a02 != .
gen Sbirth_y = (d11+1911) if d11 < 96 & d11 != .

recode b01 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(edu)

recode d13 (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(Sedu)

gen gradu_yr = (b02z01 + 1911) if (b02z01 > 0 & b02z01 < 96)    //畢業年分

recode a04a (0 6/99=.), gen(health)
replace health = (6-health)    //inversed coding
recode d15a (0 6/99=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode a04b (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap1)

recode c01 (0=990 "不適用")(6/9=.)(1=1 "有")(2=0 "無"), gen(work)
recode d16 (0=990 "不適用")(6/9=.)(1=1 "有")(2=0 "無"), gen(Swork)

recode c05 (0=990 "990 Not available")(96/99=.), gen(emp)
recode d20 (0=990 "990 Not available")(96/99=.), gen(Semp)

recode c04a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = 990 if c01==2 & c02==2    //無工作/失業者編碼為990

recode c04a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode = . if c01==2 & c02==2 | c01==0
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990 "Not available"
label value occu isco
replace occu = 990 if c04a02==0
drop isco??

recode d19a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = 990 if d16==2 & d17==2    //無工作/失業者編碼為990

recode d19a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode = . if d16==2 & d17==2
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if d19a02==0
drop isco??

recode c04b (0=990 "不適用")(96 98/99=.), gen(workfor)
recode d19b (0=990 "不適用")(96 98/99=.), gen(Sworkfor)

recode c06z02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
recode d21z02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(Sworkplace)

recode c08 (0 9999991/9999999=.), gen(wage)
recode d23 (0 9999991/9999999=.), gen(Swage)

recode c07 (0 995/999=.), gen(workhr)
recode d22 (0 995/999=.), gen(Sworkhr)

recode c09 (0 96/99=.), gen(seniority)    //工作年資未滿1年以0計
gen Sseniority = (period - 1911)-d24 if (d24 > 0 & d24 < 96)
replace Sseniority = d24 if (d24 > 0 & d24 < 30)    //將不合理值視為「年資」？

recode c21a01 (0 = 990 "不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (r_indust)

recode c21a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen r_occu = int(isco88/1000)
recode r_occu (0 = 10)
label value r_occu isco
replace r_occu = 990 if c21a02==0
drop isco??

recode d32a01 (0 = 990 "不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sr_indust)

recode d32a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Sr_occu = int(isco88/1000)
recode Sr_occu (0 = 10)
label value Sr_occu isco
replace Sr_occu = 990 if d32a02==0
drop isco??

gen retire = (c23!=0 & c23 < 7)
replace retire = 1 if (c03==3)
gen Sretire = (d34 > 0 & d34 <= 7)
replace Sretire = 1 if (d18==3)

recode c21b (0=990 "990 Not available")(96 98/99=.), gen(r_workfor)
recode d32b (0=990 "990 Not available")(96 98/99=.), gen(Sr_workfor)

gen retire_y = (c22z02+1911) if (c22z02 > 0 & c22z02 < 96)
gen Sretire_y = (d33z02+1911) if (d33z02 > 0 & d33z02 < 96)

recode c22z01 (0 9999991/9999999=.), gen(r_wage)
recode d33z01 (0 9999991/9999999=.), gen(Sr_wage)

gen pensions = (c23 >= 2 & c23 <= 4)
gen Spensions = (d34 >= 2 & d34 <= 4)

recode d01z01 (2/3=2)(4/5=3)(6=4)(97/99=.), gen(mar4)
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen live_parent = (f06f1==1 | f06m1==1)
gen live_sparent = (f06f2==1 | f06m2==1)

gen ohouse = (g03a==1)

recode g03e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)

recode h06a (9999991/9999999=.), gen(exp_hmortage)    //

recode i01 (96/99=.), gen(offspring)

recode i02a03 (0 96/99=.), gen(child1_order)
recode i02a01 (0=990 "990 Not available")(6/9=.), gen(child1_sex)    //1=male; 2=female
gen child1_age = (period-1911-i02a02) if i02a02<96 & i02a02>0
recode i02a05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1_edu)
recode i02a08 (1=1)(2=0)(0=990)(6/9=.), gen(child1_cores)

recode i02b03 (0 96/99=.), gen(child2_order)
recode i02b01 (0=990 "990 Not available")(6/9=.), gen(child2_sex)    //1=male; 2=female
gen child2_age = (period-1911-i02b02) if i02b02<96 & i02b02>0
recode i02b05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2_edu)
recode i02b08 (1=1)(2=0)(0=990)(6/9=.), gen(child2_cores)

recode i02c03 (0 96/99=.), gen(child3_order)			
recode i02c01 (0=990 "990 Not available")(6/9=.), gen(child3_sex)    //1=male; 2=female
gen child3_age = (period-1911-i02c02) if i02c02<96 & i02c02>0
recode i02c05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3_edu)
recode i02c08 (1=1)(2=0)(0=990)(6/9=.), gen(child3_cores)

recode i02d03 (0 96/99=.), gen(child4_order)			
recode i02d01 (0=990 "990 Not available")(6/9=.), gen(child4_sex)    //1=male; 2=female
gen child4_age = (period-1911-i02d02) if i02d02<96 & i02d02>0
recode i02d05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child4_edu)
recode i02d08 (1=1)(2=0)(0=990)(6/9=.), gen(child4_cores)

recode i02e03 (0 96/99=.), gen(child5_order)			
recode i02e01 (0=990 "990 Not available")(6/9=.), gen(child5_sex)    //1=male; 2=female
gen child5_age = (period-1911-i02e02) if i02e02<96 & i02e02>0
recode i02e05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child5_edu)
recode i02e08 (1=1)(2=0)(0=990)(6/9=.), gen(child5_cores)

recode i02f03 (0 96/99=.), gen(child6_order)			
recode i02f01 (0=990 "990 Not available")(6/9=.), gen(child6_sex)    //1=male; 2=female
gen child6_age = (period-1911-i02f02) if i02f02<96 & i02f02>0
recode i02f05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child6_edu)
recode i02f08 (1=1)(2=0)(0=990)(6/9=.), gen(child6_cores)

recode h05a02p1 (0 9999991/9999999=.), gen(exp_parent)
recode h05a02p2 (0 9999991/9999999=.), gen(exp_Sparent)

keep x01 period x01b district - exp_Sparent
save B_2000, replace


*RIII2001
use riii2001, clear
gen period = x02    //survey period
order period, after(x01)

recode x05 (996/999=.), gen(district)

gen birth_y = -999
gen Sbirth_y = (a12+1911) if (a12 > 0 & a12 < 96)

gen male = -999

recode a02 (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a15 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b11a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b11b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b11c (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b11d (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a03a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(96/99=.), gen(work)
recode a16a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(96/99=.), gen(Swork)

gen emp=.
replace emp= -999 if a03a==1    //the number of employees
gen Semp=.

gen cwork = 0
replace cwork =1 if (a03a >= 2 & a03a <= 4)
gen Scwork = 0
replace Scwork =1 if (a16a >= 2 & a16a <= 4)

recode a05b (0=990 "990 Not available")(96 98/99=.), gen(workfor)
replace workfor = -999 if a03b==1
recode a18b (0=990 "990 Not available")(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if a16b==1

recode a05a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = 990 if (a03a >= 4 & a03a<=6 | a03a==0)    //無工作/失業者編碼為990
replace indust = -999 if a03a==1 & a03b==1

recode a05a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990 "Not available"
label value occu isco
replace occu = 990 if a05a02==0
replace occu = -999 if a03a==1 & a03b==1
drop isco??

recode a18a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = 990 if (a16a >= 4 & a16a <= 6 | a16a==0)    //無工作/失業者編碼為990
replace Sindust = -999 if a16a==1 & a16b==1

recode a18a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a18a02==0
replace Soccu = -999 if a16a==1 & a16b==1    //-999 means taht datum would be replaced by last years
drop isco??

gen workplace = .
replace workplace = -999 if (a03a==1 & a03b==1)
gen Sworkplace = .
replace Sworkplace = -999 if (a16a==1 & a16b==1)

recode a07b (0 9999991/9999999=.), gen(wage)
recode a20 (0 9999991/9999999=.), gen(Swage)
recode a08 (0 991/999=.), gen(workhr)
recode a21 (0 991/999=.), gen(Sworkhr)

gen seniority = .
	replace seniority = -999 if (a03a==1 & a03b==1)
	replace seniority = 0 if (a03a >= 2 & a03a <= 3)    //若去年與今年工作不一致，年資為0
gen Sseniority = .
	replace Sseniority = -999 if (a16a==1 & a16b==1)
	replace Sseniority = 0 if (a16a >= 2 & a16a <= 3)    //若去年與今年工作不一致，年資為0

gen retire = (a09==7)
gen Sretire = (a22==7)

gen mar4=.
replace mar4 = 2 if a11a==1
replace mar4 = -999 if a11a==2    //沒有變化；仍然單身（包含未婚、分居、離婚、喪偶）
replace mar4 = 2 if a11b==1
replace mar4 = 3 if a11b==2
replace mar4 = 3 if a11b==3
replace mar4 = 4 if a11b==4

gen edu = -999
recode a14a (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(Sedu)
replace Sedu = -999 if a10==1 | a11b==2

gen ohouse = (b07a==1)
replace ohouse = -999 if (b05==2)

recode b07e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b05==2)

recode c02a (9999991/9999999=.), gen(exp_hmortage)    //家庭平均每月支出的房屋貸款

forvalue a = 1/4 {
recode b12ac`a' (0 96/99=.), gen(child`a'_order)

gen child`a'_cores = b12cc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode d01 (96/99=.), gen(offspring)

egen family = rowtotal(b04z*)    //the number of people living together

gen live_spouse = (b04z01 >= 1 & b04z01 < 96)
gen live_marson = (b04z02 >= 1 & b04z02 < 96)
gen live_mardau = (b04z03 >= 1 & b04z03 < 96)
gen live_sinson = (b04z04 >= 1 & b04z04 < 96)
gen live_sindau = (b04z05 >= 1 & b04z05 < 96)
gen live_parent = (b04z08 >= 1 & b04z08 < 96)
gen live_sparent = (b04z09 >= 1 & b04z09 < 96)
gen live_grachild = (b04z06 >=1 & b04z06 < 96)    //與孫子女同住

keep x01 period x01b district - live_grachild
save A_2001, replace


*RII2001
use rii2001, clear
gen period = x02    //survey period
order period, after(x01)

recode x05 (996/999=.), gen(district)

recode a01 (2=0), gen(male) 

gen birth_y = (1911+a02) if a02 <96
gen Sbirth_y = (1911+c22) if c21b==1    //just got married in past one year
replace Sbirth_y = -999 if c20==1 | c21b==2
replace Sbirth_y = . if (c21b>=3 & c21b !=.)

recode a03 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(edu)

recode c24a (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(Sedu)
replace Sedu = -999 if c20==1 | c21b==2
replace Sedu = 990 if c21b>=3 & c21b<=4

gen gradu_yr = .
foreach a of varlist b07c b06e b05e b04e {
	replace gradu_yr = (`a' + 1911) if gradu_yr==. & (`a' > 0 & `a' < 96)
}
replace gradu_yr = (b01 + 6 + 1911) if gradu_yr==. & (b01 > 0 & b01 < 96)

recode a04 (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode c25 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode d10a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode d10b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode d10c (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode d10d (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

gen mar4=.
replace mar4 = -999 if (c21a==1 | c21a==2)
replace mar4 = 2 if c21b==1
replace mar4 = 3 if c21b==2
replace mar4 = 3 if c21b==3
replace mar4 = 4 if c21b==4

recode c01a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(97/99=.), gen(work)
recode c26a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(97/99=.), gen(Swork)

gen cwork = 0
replace cwork =1 if (c01a >= 2 & c01a <= 4)
gen Scwork = 0
replace Scwork =1 if (c26a >= 2 & c26a <= 4)

recode c04 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)
replace emp=-999 if c01b==1
gen Semp=.

recode c03a01 (0 = 990 "990 Not available ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = 990 if c01a>=4 & c01a<=6    //無工作/失業者編碼為990
replace indust = -999 if c01a==1 & c01b==1

recode c03a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode = . if c01a>=4 & c01a<=6
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if c03a02==0
replace occu = -999 if c01a==1 & c01b==1
drop isco??

recode c28a01 (0 = 990 "990 Not available ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = 990 if c26a>=4 & c26a<=6    //無工作/失業者編碼為990
replace Sindust = -999 if c26a==1 & c26b==1

recode c28a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode = . if c26a>=4 & c26a<=6
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if c28a02==0
replace Soccu = -999 if c26a==1 & c26b==1
drop isco??
 
recode c03b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if c01b==1
recode c28b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if c26b==1

recode c06z02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
gen Sworkplace = .
replace Sworkplace = -999 if c26a==1 & c26b==1

recode c07b (9999991/9999999=.), gen(wage)
recode c30 (9999991/9999999=.), gen(Swage)
recode c08 (0 991/999=.), gen(workhr)
recode c31 (0 991/999=.), gen(Sworkhr)

gen seniority=.
	gen y = c09z02 if c09z02 <96
	gen m = (c09z03/12) if c09z03 <96
	replace seniority = m if c09z01==2
	replace seniority = y+m if c09z01==3
	drop y m
gen Sseniority=.
	replace Sseniority = -999 if c26a==1 & c26b==1
	replace Sseniority = 0 if c26a>=2 & c26a<=3    //若去年與今年工作不一致，年資為0 

gen retire = (c19==7)
gen Sretire = (c32==7)

gen ohouse = (d07a==1)
replace ohouse = -999 if (d05==2)

recode d07e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (d05==2)

recode d12b02 (0 9999991/9999999=.), gen(exp_parent)
recode d13b02 (0 9999991/9999999=.), gen(exp_Sparent)
recode e02a (9999991/9999999=.), gen(exp_hmortage)

egen family = rowtotal(d04z*)    //the number of people living together

gen live_spouse = (d04z01 >= 1 & d04z01 < 96)
gen live_marson = (d04z02 >= 1 & d04z02 < 96)
gen live_mardau = (d04z03 >= 1 & d04z03 < 96)
gen live_sinson = (d04z04 >= 1 & d04z04 < 96)
gen live_sindau = (d04z05 >= 1 & d04z05 < 96)
gen live_parent = (d04z08 >= 1 & d04z08 < 96)
gen live_sparent = (d04z09 >= 1 & d04z09 < 96)
gen live_grachild = (d04z06 >= 1 & d04z06 < 96)    //與孫子女同住

forvalue a =1/4 {
recode d11ac`a' (0 96/99=.), gen(child`a'_order)

gen child1`a'_cores = d11cc`a' 
recode child1`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode f01 (96/99=.), gen(offspring)

keep x01 period x01b district - offspring
save B_2001, replace

		   
*RR2002
use rr2002, clear
gen period = x02    //survey period
order period, after(x01)

recode x05 (996/999=.), gen(district)

gen male = -999

gen birth_y = -999
gen Sbirth_y = (1911+a15) if a14==3
replace Sbirth_y = -999 if a14==1 | a14==4
replace Sbirth_y = . if a14==2 | a14==5 | a14==6

gen edu = -999     //data witout education, and using the datum in the last year

recode a17a (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "other")(96 98/99=.), gen(Sedu)
replace Sedu = -999 if a14==1 | a14==4
replace Sedu = 990 if (a14==2) | (a14>=5 & a14<=6)

recode a02 (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a18 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode c12a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode c12b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode c12c (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode c12d (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

gen mar4 = .
replace mar4 = -999 if a14 ==1    //帶入前期
replace mar4 = 1 if a14 == 2      //單身
replace mar4 = 2 if a14 == 3      //新結婚 
replace mar4 = 3 if a14 == 4
replace mar4 = 3 if a14 == 5
replace mar4 = 4 if a14 == 6

recode a03a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(97/99=.), gen(work)
recode a19a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(97/99=.), gen(Swork)

gen cwork = 0
replace cwork =1 if (a03a >= 2 & a03a <= 4)
gen Scwork = 0
replace Scwork =1 if (a19a >= 2 & a19a <= 4)

recode a05c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)
replace emp = -999 if a03b04==1    //公司內的工作人數

recode a21c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(Semp)
replace Semp = -999 if (a19b04==1)

gen retire = 0
replace retire = 1 if (a04b==3 | a04c==3) | (a12==7)
gen Sretire = 0
replace Sretire = 1 if (a20b==3 | a20c==3) | (a26==7)

recode  a05a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = 990 if a03a>=4 & a03a<=6    //無工作/失業者編碼為990
replace indust = -999 if a03a == 1    //使用前期資料

recode a05a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if (a05a02==0) | (a03a>=4 & a03a<=6)
replace occu = -999 if a03a == 1      //using the datum in the last year
drop isco*

recode a21a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = 990 if a19a>=4 & a19a<=6    //無工作/失業者編碼為990
replace Sindust = -999 if a19a == 1    //using the datum in the last year

recode a21a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu =int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if (a21a02==0) | (a19a>=4 & a19a<=6)
replace Soccu = -999 if a19a == 1      //using the datum in the last year
drop isco*

recode a06a02 (0=990)(993/999=.), gen(workplace)
replace workplace = -999 if a03b04==1

recode a22a02 (0=990)(993/999=.), gen(Sworkplace)
replace Sworkplace = -999 if a19b04==1

recode a05b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if a03a == 1    //using the datum in the last year
replace workfor = 990 if a03a>=4 & a03a<=6

recode a21b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if a19a==1    //using the datum in the last year
replace Sworkfor = 990 if a19a>=4 & a19a<=6

recode a08b (9999991/9999999=.), gen(wage)
replace wage = . if a03a>=4 & a03a<=6 | a03a==0
recode a24 (9999991/9999999=.), gen(Swage)
replace Swage = . if a19a>=4 & a19a<=6 | a19a==0

recode a09 (0 991/999=.), gen(workhr)
recode a25 (0 991/999=.), gen(Sworkhr)

gen seniority = .
replace seniority = -999 if a03a == 1     //使用前期資料
replace seniority = 0 if a03a == 2 | a03a == 3    //若去年與今年工作不一致，年資為0 
replace seniority = . if a03a >= 4 & a03a <= 6    //失業或沒工作者為.
gen Sseniority = .
replace Sseniority = -999 if a19a == 1     //使用前期資料
replace Sseniority = 0 if a19a == 2 | a19a == 3    //若去年與今年工作不一致，年資為0 
replace Sseniority = . if a19a >= 4 & a19a <= 6    //失業或沒工作者為.

recode c14b02 (0 9999991/9999999=.), gen(exp_parent)
recode c16b02 (0 9999991/9999999=.), gen(exp_Sparent)

recode c04z* (96/99=.)
egen family = rowtotal(c04z*)    //the number of people living together

gen live_spouse = (c04z01 >= 1 & c04z01 < 96)
gen live_marson = (c04z02 >= 1 & c04z02 < 96)
gen live_mardau = (c04z03 >= 1 & c04z03 < 96)
gen live_sinson = (c04z04 >= 1 & c04z04 < 96)
gen live_sindau = (c04z05 >= 1 & c04z05 < 96)
gen live_parent = (c04z08 >= 1 & c04z08 < 96)
gen live_sparent = (c04z09 >= 1 & c04z09 < 96)
gen live_grachild = (c04z06 >= 1 & c04z06 < 96)    //與孫子女同住

gen ohouse = (c08a==1)
replace ohouse = -999 if (c05==2)

recode c08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (c05==2)

recode d08a (9999991/9999999=.), gen(exp_hmortage)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (d02z02 * -1) if (d02z02 < 99999991 & d02z01==2)
replace invest = (d02z02 * 1) if (d02z02 < 99999991 & d02z01==1)

recode d04a01 (0=990 "不適用")(1=1 "有")(2=0 "無")(6/9=.), gen(pensions)
recode d04a02 (0 9999991/9999999=.), gen(pension_1)
recode d04a03 (0 9999991/9999999=.), gen(pension_2)
recode d04a04 (0 9999991/9999999=.), gen(pension_3)
recode d04a05 (0 9999991/9999999=.), gen(pension_4)

recode d04b01 (0=990 "不適用")(1=1 "有")(2=0 "無")(6/9=.), gen(Spensions)
recode d04b02 (0 9999991/9999999=.), gen(Spension_1)
recode d04b03 (0 9999991/9999999=.), gen(Spension_2)
recode d04b04 (0 9999991/9999999=.), gen(Spension_3)
recode d04b05 (0 9999991/9999999=.), gen(Spension_4)

recode d05z02 (0 9999991/9999999=.), gen(oincome_1)
recode d05z04 (0 9999991/9999999=.), gen(oincome_2)
recode d05z06 (0 9999991/9999999=.), gen(oincome_3)
recode d05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode d09a (9999991/9999999=.), gen(exp_insurance)
recode d09d (9999991/9999999=.), gen(exp_edu)
recode d09e (9999991/9999999=.), gen(exp_medical)

forvalue a = 1/4 {
recode c13ac`a' (0 96/99=.), gen(child`a'_order)

gen child`a'_cores = c13cc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode e01 (96/99=.), gen(offspring)

keep x01 period x01b district - offspring
save R_2002, replace


*RR2003
use rr2003, clear
gen period = 2003    //survey period
order period, after(x01)

recode x05 (996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+b01) if (b01 < 96)

recode a03 (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding

recode a02z* (96/99=.)
egen family = rowtotal(a02z*)    //the number of people living together

gen hmortage = (d12z01==1)    //您或配偶現在還有尚未繳清的房屋貸款(Yes=1; Others=0)

keep x01 period district - hmortage
save R_2003, replace


*RR2004
use rr2004, clear
gen period = x02    //survey period
order period, after(x01)

recode x06 (996/999=.), gen(district)

gen male = -999

gen birth_y = -999
gen Sbirth_y = (1911+a25) if a25>0 & a25<96
replace Sbirth_y = -999 if a24b==1 | a24b==4
replace Sbirth_y = -999 if a24a==1 | a24a==4

recode a02 (0 6/99=.), gen(health)
replace health = (6-health)    //inversed coding
recode a28 (0 6/99=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode c12a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode c12b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode c12c (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode c12d (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a03 (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/99=.), gen(work)
recode a29 (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/99=.), gen(Swork)

recode a14 (0=990 "不適用")(1=0 "沒有")(2=1 "有")(6/99=.), gen(cwork)
recode a38 (0=990 "不適用")(1=0 "沒有")(2=1 "有")(6/99=.), gen(Scwork)

recode a05c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(91/99=.), gen(emp)
recode a31c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(91/99=.), gen(Semp)

gen retire = 0 
replace retire = 1 if (a04a==7) | (a15b==3 | a15c==3)
gen Sretire = 0
replace Sretire = 1 if (a30a==7) | (a39b==3 | a39c==3)

recode a05a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)

recode a05a02 (0 9996/9999=.), gen(PSFDcode)     //失業或沒工作者編碼為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a05a02==0
drop isco*

recode a31a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)

recode a31a02 (0 9996/9999=.), gen(PSFDcode)     //失業或沒工作者編碼為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a31a02==0
drop isco*

recode a05b (0=990)(96 98/99=.), gen(workfor)
recode a31b (0=990)(96 98/99=.), gen(Sworkfor)

recode a06a02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
recode a32a02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(Sworkplace)

recode a08b (9999991/9999999=.), gen(wage)
replace wage = . if a03==2
recode a34b (9999991/9999999=.), gen(Swage)
replace Swage = . if a29==2

recode a09 (0 991/999=.), gen(workhr)
recode a35 (0 991/999=.), gen(Sworkhr)

gen seniority = .
replace seniority = -999 if a14==1    //沒有工作轉變，需帶入前一波資訊(-999)
replace seniority = 0 if a03==1 & a14==2    //若去年與今年工作不一致，年資為0
replace seniority = . if a03 !=1

gen Sseniority = .
replace Sseniority = -999 if a38==1   //沒有工作轉變，需帶入前一波資訊(-999)
replace Sseniority = 0 if a36==1 & a38==2    //若去年與今年工作不一致，年資為0
replace Sseniority = . if a36 !=1 | (a24a>=5 & a24a<=6) | (a24b>=5 & a24b<=6)

gen mar4=.
replace mar4 = 2 if a24a == 1 | a24b == 1    //已婚或同居
replace mar4 = 1 if a24a == 2 | a24b == 2    //單身
replace mar4 = 2 if a24a == 3 | a24b == 3    //新結婚 
replace mar4 = 3 if a24a == 4 | a24b == 4 
replace mar4 = 3 if a24a == 5 | a24b == 5
replace mar4 = 4 if a24a == 6 | a24b == 6
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen edu = -999    //無資料，需帶入前一波資訊(-999)

recode a27a (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)
replace Sedu = -999 if a24a==1 | a24a==4
replace Sedu = -999 if a24b==1 | a24b==4

gen ohouse = (c08a==1)
replace ohouse = -999 if c06a==2

recode c08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (c06a==2)
/*replace loan_house = 1 if d08a01==2    //擁有個人房屋貸款者*/

recode d08a02 (9999991/9999999=.), gen(exp_hmortage)    //家中房屋貸款每月平均支出

recode c04z?? (96/99=.)
egen family = rowtotal(c04z*)    //the number of people living together

gen live_spouse = (c04z03 >= 1 & c04z03 < 96)
gen live_marson = (c04z06 >= 1 & c04z06 < 96)
gen live_mardau = (c04z07 >= 1 & c04z07 < 96)
gen live_sinson = (c04z08 >= 1 & c04z08 < 96)
gen live_sindau = (c04z09 >= 1 & c04z09 < 96)
gen live_parent = ((c04z01 >= 1 & c04z01 < 96) | (c04z02>=1 & c04z02 < 96))    // 與父親或母親同住
gen live_sparent = ((c04z04 >= 1 & c04z04 < 96) | (c04z05>=1 & c04z05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((c04z30 >= 1 & c04z30 < 96) | (c04z31 >= 1 & c04z31 < 96))    //與(外)孫子女同住

recode c14b02 (0 9999991/9999999=.), gen(exp_parent)
recode c16b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (d02z02 * -1) if (d02z02 < 99999991 & d02z01==2)
replace invest = (d02z02 * 1) if (d02z02 < 99999991 & d02z01==1)

recode d03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if d03a01==2

recode d03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if d03b01==2

recode d04a01 (0=990 "不適用")(1=1 "有")(2=0 "無")(6/9=.), gen(pensions)
recode d04a02 (0 9999991/9999999=.), gen(pension_1)
recode d04a03 (0 9999991/9999999=.), gen(pension_2)
recode d04a04 (0 9999991/9999999=.), gen(pension_3)
recode d04a05 (0 9999991/9999999=.), gen(pension_4)

recode d04b01 (0=990 "不適用")(1=1 "有")(2=0 "無")(6/9=.), gen(Spensions)
recode d04b02 (0 9999991/9999999=.), gen(Spension_1)
recode d04b03 (0 9999991/9999999=.), gen(Spension_2)
recode d04b04 (0 9999991/9999999=.), gen(Spension_3)
recode d04b05 (0 9999991/9999999=.), gen(Spension_4)

recode d05z02 (0 9999991/9999999=.), gen(oincome_1)
recode d05z04 (0 9999991/9999999=.), gen(oincome_2)
recode d05z06 (0 9999991/9999999=.), gen(oincome_3)
recode d05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode d09a (9999991/9999999=.), gen(exp_insurance)
recode d09d (9999991/9999999=.), gen(exp_edu)
recode d09e (9999991/9999999=.), gen(exp_medical)

forvalue a = 1/4 {
recode c13ac`a' (0 6/9=.), gen(child`a'_order)

recode c13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-c13c01c`a') if c13c01c`a'>0 & c13c01c`a'<96

gen child`a'_cores = c13ec`a'
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode e01 (96/99=.), gen(offspring)

keep x01 period x01b district - offspring
save R_2004, replace


*RR2005
use rr2005,clear
gen period = x02    //survey period
order period, after(x01)
replace x01b = 6 if x01b==4

recode x06 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

gen male = -999    //無資料，需帶入前期資料(-999)

gen birth_y = .    // 無資料
gen Sbirth_y = (1911+a23) if a23>0 & a23<96
replace Sbirth_y = -999 if a22==1 | a22==5

gen edu = -999    //無資料

recode a25a (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)
replace Sedu = -999 if a22==1 | a22==5

recode a02a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a26 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b12a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b12b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b12c (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b12d (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a02c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a11a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(6/99=.), gen(work)
recode a27a (0=990 "不適用")(1/3=1 "有")(4/6=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork =1 if (a11a >= 2 & a11a <= 4)
gen Scwork = 0
replace Scwork =1 if (a27a >= 2 & a27a <= 4)

recode a13c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(96/99=.), gen(emp)
replace emp = -999 if a11a==1
recode a29c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(96/99=.), gen(Semp)
replace Semp = -999 if a27a== 1

gen retire = 0
replace retire = 1 if (a12b==3 | a12c==3) | (a20==7)
gen Sretire = 0
replace Sretire = 1 if (a28b==3 | a28c==3) | (a34==7)

recode a14a02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
recode a30a02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(Sworkplace)

recode a13a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = 990 if  a11a >= 4 & a11a <= 6    //無工作/失業者編碼為990
replace indust = -999 if a11a == 1   //使用前期資料


recode a13a02 (0 9996/9999=.), gen(PSFDcode)     //失業或沒工作者編碼為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a11a>= 4 & a11a <=6
replace occu = -999 if a11a==1   //使用前期資料
drop isco*

recode a29a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = 990 if  a27a >= 4 & a27a <= 6    //無工作/失業者編碼為990
replace Sindust = -999 if a27a == 1    //使用前期資料

recode a29a02 (0 9996/9999=.), gen(job)     //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a27a>= 4 & a27a <=6
replace Soccu = -999 if a27a==1    //使用前期資料
drop isco*

recode a13b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if a11a == 1   //使用前期資料

recode a29b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if a27a == 1

recode a16b (9999991/9999999=.), gen(wage)
replace wage = . if a11a >= 4 & a11a <= 6
recode a32b (9999991/9999999=.), gen(Swage)
replace Swage = . if a27a >= 4 & a27a <= 6

recode a17 (0 991/999=.), gen(workhr)
recode a33 (0 991/999=.), gen(Sworkhr)

gen seniority = .
replace seniority = -999 if a11a== 1   //使用前期資料
replace seniority = 0 if a11a>= 2 & a11a<= 3      //今年有工作，但與去年工作不一樣，年資為0 
replace seniority = . if a11a>= 4 & a11a<= 6     //失業或沒有工作為.
gen Sseniority = .
replace Sseniority = -999 if a27a==1
replace Sseniority = 0 if a27a>= 2 & a27a<= 3      //今年有工作，但與去年工作不一樣，年資為0 
replace Sseniority = . if a27a>= 4 & a27a<= 6     //失業或沒有工作為.

gen mar4 = .
replace mar4 = -999 if a22 == 3
replace mar4 = 1 if a22 == 2
replace mar4 = 2 if a22 == 1 | a22 == 4
replace mar4 = 3 if a22 == 5 | a22 == 6
replace mar4 = 4 if a22 == 7
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

recode b04z?? (96/99=.)
egen family = rowtotal(b04z*)    //the number of people living together

gen live_spouse = (b04z03 >= 1 & b04z03 < 96)
gen live_marson = (b04z06 >= 1 & b04z06 < 96)
gen live_mardau = (b04z07 >= 1 & b04z07 < 96)
gen live_sinson = (b04z08 >= 1 & b04z08 < 96)
gen live_sindau = (b04z09 >= 1 & b04z09 < 96)
gen live_parent = ((b04z01 >= 1 & b04z01 < 96) | (b04z02>=1 & b04z02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04z04 >= 1 & b04z04 < 96) | (b04z05>=1 & b04z05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04z30 >= 1 & b04z30 < 96) | (b04z31 >= 1 & b04z31 < 96))    //與(外)孫子女同住

gen ohouse = (b08a==1)
replace ohouse = -999 if b06==2

recode b08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)
/*replace loan_house = 1 if c08a01==1    //擁有個人的房屋貸款者*/

recode c08a02 (9999991/9999999=.), gen(exp_hmortage)    //家中房屋貸款每月平均支出

recode b12e (96/99=.), gen(offspring)

forvalue a = 1/4 {
recode b13ac`a' (0 6/9=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'<96 & b13c01c`a'>0

gen child`a'_cores = b13ec`a' 
recode child`a'_cores (8=1)(0=990)(96/99=.)(*=0)
}

recode b14b02 (0 9999991/9999999=.), gen(exp_parent)
recode b16b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c02z02 * -1) if (c02z02 < 99999991 & c02z01==2)
replace invest = (c02z02 * 1) if (c02z02 < 99999991 & c02z01==1)

recode c03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c03a01==2
recode c03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c03b01==2

recode c04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c04a02 (0 9999991/9999999=.), gen(pension_1)
recode c04a03 (0 9999991/9999999=.), gen(pension_2)
recode c04a04 (0 9999991/9999999=.), gen(pension_3)
recode c04a05 (0 9999991/9999999=.), gen(pension_4)

recode c04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c04b02 (0 9999991/9999999=.), gen(Spension_1)
recode c04b03 (0 9999991/9999999=.), gen(Spension_2)
recode c04b04 (0 9999991/9999999=.), gen(Spension_3)
recode c04b05 (0 9999991/9999999=.), gen(Spension_4)

recode c05z02 (0 9999991/9999999=.), gen(oincome_1)
recode c05z04 (0 9999991/9999999=.), gen(oincome_2)
recode c05z06 (0 9999991/9999999=.), gen(oincome_3)
recode c05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c09a (9999991/9999999=.), gen(exp_insurance)
recode c09d (9999991/9999999=.), gen(exp_edu)
recode c09e (9999991/9999999=.), gen(exp_medical)

keep x01 period x01b district - exp_medical
save R_2005, replace


*RR2006
use rr2006, clear
gen period = z02    //survey period
rename z01b x01b
order period, after(x01)
replace x01b = 6 if x01b==4

recode z04b (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02) if a02 < 96
gen Sbirth_y = (1911+a23) if (a23 > 0 & a23 < 96)

recode a04a (0 7/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a26 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b12a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b12b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b12c (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b12d (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a07 (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/99=.), gen(work)
recode a27a (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork = 1 if (a08a01 == 1)
gen Scwork = 0
replace Scwork = 1 if (a27b01 == 1)

recode a11c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode a29c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)

gen seniority = a08a02 if (a08a01 >= 0 & a08a02 < 96)
gen Sseniority = a27b02 if (a27b01 >= 0 & a27b02 < 96)

recode a11a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)

recode a11a02 (0 9996/9999=.), gen(PSFDcode)    //失業或沒工作者編碼為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a11a02==0
drop isco*

recode a29a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)

recode a29a02 (0 9996/9999=.), gen(PSFDcode)    //失業或沒工作者編碼為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a29a02==0
drop isco*

recode a11b (0=990)(96 98/99=.), gen(workfor)
recode a29b (0=990)(96 98/99=.), gen(Sworkfor)

recode a12a02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
recode a30a02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(Sworkplace)

recode a13b (0 9999991/9999999=.), gen(wage)
recode a31b (0 9999991/9999999=.), gen(Swage)

recode a14 (0 991/999=.), gen(workhr)
recode a32 (0 991/999=.), gen(Sworkhr)

gen retire = 0
replace retire = 1 if (a20==7) | (a10b==3 | a10c==3) | (c04a01>=1 & c04a01<=2)
gen Sretire = 0
replace Sretire = 1 if (a33==7) | (a28b==3 | a28c==3) | (c04b01>=1 & c04b01<=2)

gen mar4 = .
replace mar4 = 1 if a22 == 1
replace mar4 = 2 if a22 == 2 | a22 == 3
replace mar4 = 3 if a22 == 4 | a22 == 5
replace mar4 = 4 if a22 == 6
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen edu = -999    //缺乏教育程度資訊，需帶入前一波資訊(-999)

recode a25a (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

gen ohouse = (b08a==1)
replace ohouse = -999 if b06==2

recode b08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)
/*replace loan_house = 1 if c08a01==1*/

recode c08a02 (9999991/9999999=.), gen(exp_hmortage)    //家中房屋貸款每月平均支出

gen family = b04a if (b04a < 96)    //the number of people living together

gen live_spouse = (b04b03 >= 1 & b04b03 < 96)
gen live_marson = (b04b06 >= 1 & b04b06 < 96)
gen live_mardau = (b04b07 >= 1 & b04b07 < 96)
gen live_sinson = (b04b08 >= 1 & b04b08 < 96)
gen live_sindau = (b04b09 >= 1 & b04b09 < 96)
gen live_parent = ((b04b01 >= 1 & b04b01 < 96) | (b04b02>=1 & b04b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04b04 >= 1 & b04b04 < 96) | (b04b05>=1 & b04b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04b30 >= 1 & b04b30 < 96) | (b04b31 >= 1 & b04b31 < 96))    //與(外)孫子女同住

recode b12e (96/99=.), gen(offspring)

forvalue a = 1/4 {
recode b13ac`a' (0 6/9=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'<96 & b13c01c`a'>0

gen child`a'_cores = b13hc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b14b02 (0 9999991/9999999=.), gen(exp_parent)
recode b15b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c02z02 * -1) if (c02z02 < 99999991 & c02z01==2)
replace invest = (c02z02 * 1) if (c02z02 < 99999991 & c02z01==1)

recode c03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c03a01==2
recode c03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c03b01==2

recode c04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c04a02 (0 9999991/9999999=.), gen(pension_1)
recode c04a03 (0 9999991/9999999=.), gen(pension_2)
recode c04a04 (0 9999991/9999999=.), gen(pension_3)
recode c04a05 (0 9999991/9999999=.), gen(pension_4)

recode c04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c04b02 (0 9999991/9999999=.), gen(Spension_1)
recode c04b03 (0 9999991/9999999=.), gen(Spension_2)
recode c04b04 (0 9999991/9999999=.), gen(Spension_3)
recode c04b05 (0 9999991/9999999=.), gen(Spension_4)

recode c05z02 (0 9999991/9999999=.), gen(oincome_1)
recode c05z04 (0 9999991/9999999=.), gen(oincome_2)
recode c05z06 (0 9999991/9999999=.), gen(oincome_3)
recode c05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c09a (9999991/9999999=.), gen(exp_insurance)
recode c09d (9999991/9999999=.), gen(exp_edu)
recode c09e (9999991/9999999=.), gen(exp_medical)

keep x01 period x01b district - exp_medical
save R_2006, replace


*RR2007
use rr2007, clear
gen period = x02    //survey period
order period, after(x01)
replace x01b = 6 if x01b>=4

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02a) if a02a <96
gen Sbirth_y = (1911+a17) if a17 > 0 & a17 < 96

recode a04a (0 7/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a20 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b14a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b14b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b14d (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b14e (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

gen edu = -999    //data without education level

recode a19 (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

recode a05 (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/99=.), gen(work)
recode a21a (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork = 1 if a06z01==1 | a06z02==1 | a06z03==1 | a06z04==1 | a06z05==1 | a06z07==1
gen Scwork = 0
replace Scwork = 1 if a21b01==1 | a21b02==1 | a21b03==1 | a21b04==1 | a21b05==1 | a21b07==1

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990

recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)
replace Semp= -999 if (a21b01==2 & a06z02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & Semp==990

recode a08b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & workfor==990

recode a23b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if (a21b01==2 & a06z02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & Sworkfor==990

recode a09b02 (0=990)(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(workplace)
recode a24b02 (0=990)(1/99=99 "國外地區（含中國及港澳地區）")(991/999=.), gen(Sworkplace)
 
recode a10b (9999991/9999999=.), gen(wage)
replace wage = . if a05==2

recode a25b (9999991/9999999=.), gen(Swage)
replace Swage = . if a21a==2 | a21a==0

recode a11a (991/999=.), gen(workhr)
replace workhr = . if a05==2

recode a26a (991/999=.), gen(Sworkhr)
replace Sworkhr = . if a21a==2 | a21a==0

gen seniority = .
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace seniority = y+m
	replace seniority = . if a11b01>=96
	replace seniority = y if a11b02>=96
	drop y m

gen Sseniority = .
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace Sseniority = y+m
	replace Sseniority = . if a26b01>=96
	replace Sseniority = y if a26b02>=96
	drop y m
	
gen retire = 0
replace retire = 1 if (a07b==3 | a07c==3) | (a14==7) | (d04a01==1 | d04a01==2)
gen Sretire = 0
replace Sretire = 1 if (a22b==3 | a22c==3) | (a27==7)| (d04b01==1 | d04b01==2)

recode a09a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)

recode a09a02 (0 9996/9999=.), gen(PSFDcode)     //失業或沒工作者為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a09a02==0
replace occu = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)
drop isco*

recode a24a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = -999 if (a21b05==1 | a21b06==1) & (a21b01==2 & a21b02==2 & a21b03==2 & a21b04==2)

recode a24a02 (0 9996/9999=.), gen(PSFDcode)     //失業或沒工作者為.
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a24a02==0
replace Soccu = -999 if (a21b05==1 | a21b06==1) & (a21b01==2 & a21b02==2 & a21b03==2 & a21b04==2)
drop isco*

recode a16 (1=1)(2/5=2)(6/7=3)(8=4)(96/99=.), gen(mar4)
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen family = b04a if (b04a < 96)    //the number of people living together

gen live_spouse = (b04b03 >= 1 & b04b03 < 96)
gen live_marson = (b04b06 >= 1 & b04b06 < 96)
gen live_mardau = (b04b07 >= 1 & b04b07 < 96)
gen live_sinson = (b04b08 >= 1 & b04b08 < 96)
gen live_sindau = (b04b09 >= 1 & b04b09 < 96)
gen live_parent = ((b04b01 >= 1 & b04b01 < 96) | (b04b02>=1 & b04b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04b04 >= 1 & b04b04 < 96) | (b04b05>=1 & b04b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04b30 >= 1 & b04b30 < 96) | (b04b31 >= 1 & b04b31 < 96))    //與(外)孫子女同住

gen ohouse = (b08a==1)
replace ohouse = -999 if b06==2

recode b08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)

recode d08a (9999991/9999999=.), gen(exp_hmortage)

recode b12 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b13ac`a' (0 6/9=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'<996 & b13c01c`a'>0

recode b13dc`a' (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4/5=2 "2 國中/初職")(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院(科技大學)") ///
(13/15=5 "5 大學(或)以上")(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b13gc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b13j02 (0 9999991/9999999=.), gen(callowance)

recode b15b02 (0 9999991/9999999=.), gen(exp_parent)
recode b16b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (d02z02 * -1) if (d02z02 < 99999991 & d02z01==2)
replace invest = (d02z02 * 1) if (d02z02 < 99999991 & d02z01==1)

recode d03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if d03a01==2
recode d03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if d03b01==2

recode d04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode d04a02 (0 9999991/9999999=.), gen(pension_1)
recode d04a03 (0 9999991/9999999=.), gen(pension_2)
recode d04a04 (0 9999991/9999999=.), gen(pension_3)
recode d04a05 (0 9999991/9999999=.), gen(pension_4)
recode d04a06 (0 9999991/9999999=.), gen(pension_5)

recode d04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode d04b02 (0 9999991/9999999=.), gen(Spension_1)
recode d04b03 (0 9999991/9999999=.), gen(Spension_2)
recode d04b04 (0 9999991/9999999=.), gen(Spension_3)
recode d04b05 (0 9999991/9999999=.), gen(Spension_4)
recode d04b06 (0 9999991/9999999=.), gen(Spension_5)

recode d05z02 (0 9999991/9999999=.), gen(oincome_1)
recode d05z04 (0 9999991/9999999=.), gen(oincome_2)
recode d05z06 (0 9999991/9999999=.), gen(oincome_3)
recode d05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode d09a (9999991/9999999=.), gen(exp_insurance)
recode d09d (9999991/9999999=.), gen(exp_edu)
recode d09e (9999991/9999999=.), gen(exp_medical)

keep x01 period x01b district - exp_medical
save R_2007, replace


*RR2008
use rr2008, clear
gen period = x02    //survey period
order period, after(x01)
replace x01b = 6 if x01b==4

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)
 
gen birth_y = (1911+a02a) if a02a < 96
gen Sbirth_y = (1911+a17) if a17 > 0 & a17 < 96

gen edu = -999    //缺乏教育程度資訊，需帶入前一波資訊(-999)

recode a19 (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a20 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b14a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b14b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b18b (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b18c (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a05 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a21a (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

gen retire = 0
replace retire = 1 if (a07b==3 | a07c==3) | (a14==7) | (c04a01==1 | c04a01==2)
gen Sretire = 0
replace Sretire = 1 if (a22b==3 | a22c==3) | (a27==7) | (c04b01==1 | c04b01==2)

gen cwork = 0
replace cwork = 1 if (a06z01==1 | a06z02==1 | a06z03==1 | a06z04==1 | a06z05==1 | a06z07==1)
gen Scwork = 0
replace Scwork = 1 if (a21b01==1 | a21b02==1 | a21b03==1 | a21b04==1 | a21b05==1 | a21b07==1)

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990

recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)
replace Semp= -999 if (a21b01==2 & a06z02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & Semp==990

recode a09a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (indust)
replace indust = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)    //使用前期資料(-999)
replace indust = 97 if a05==2     //無酬勞動者(其他類)

recode a09a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu = int(isco88/1000)
recode occu (0 = 10)
label define isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a09a02==0
replace occu = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)   //使用前期資料(-999)
drop isco*

recode a24a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = 97 "其他")(996/999 =.), gen (Sindust)
replace Sindust = -999 if (a21b05==1 | a21b06==1) & (a21b01==2 & a21b02==2 & a21b03==2 & a21b04==2)    //使用前期資料(-999)
replace Sindust = 97 if a05==2     //無酬勞動者(其他類)

recode a24a02 (0 9996/9999=.), gen(PSFDcode)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a24a02==0
replace Soccu = -999 if (a21b05==1 | a21b06==1) & (a21b01==2 & a21b02==2 & a21b03==2 & a21b04==2)    //使用前期資料(-999)
drop isco*

recode a08b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & workfor==990    //使用前期資料

recode a23b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if (a21b01==2 & a21b02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & Sworkfor==990    //使用前期資料

recode a09b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(workplace)
recode a24b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(Sworkplace)

recode a10b (9999991/9999999=.), gen(wage)
replace wage = . if a05==3

recode a25b (9999991/9999999=.), gen(Swage)
replace Swage = . if a21a==3

recode a11a (0 991/999=.), gen(workhr)
replace workhr = 0 if a11a==0 & (a05==1 | a05==2)
recode a26a (0 991/999=.), gen(Sworkhr)
replace Sworkhr = 0 if a26a==0 & (a21a==1 | a21a==2)

gen seniority = .
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02<96
	replace seniority = y+m
	replace seniority = . if a11b01>=96
	replace seniority = y if a11b02>=96
	drop y m

gen Sseniority = .
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace Sseniority = y+m
	replace Sseniority = . if a26b01>=96
	replace Sseniority = y if a26b02>=96
	drop y m
	
recode a16z01 (1=1)(2/5=2)(6/7=3)(8=4)(0 96/99=.), gen(mar4)
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen family = b04a if (b04a < 96)    //the number of people living together

gen live_spouse = (b04b03 >= 1 & b04b03 < 96)
gen live_marson = (b04b06 >= 1 & b04b06 < 96)
gen live_mardau = (b04b07 >= 1 & b04b07 < 96)
gen live_sinson = (b04b08 >= 1 & b04b08 < 96)
gen live_sindau = (b04b09 >= 1 & b04b09 < 96)
gen live_parent = ((b04b01 >= 1 & b04b01 < 96) | (b04b02>=1 & b04b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04b04 >= 1 & b04b04 < 96) | (b04b05>=1 & b04b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04b30 >= 1 & b04b30 < 96) | (b04b31 >= 1 & b04b31 < 96))    //與(外)孫子女同住

gen ohouse = (b08a==1)
replace ohouse = -999 if b06==2

recode b08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)

recode c08a (9999991/9999999=.), gen(exp_hmortage)

recode b12 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b13ac`a' (0 6/9=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'<996 & b13c01c`a'>0

recode b13dc`a' (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4/5=2 "2 國中/初職")(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院(科技大學)") ///
(13/15=5 "5 大學(或)以上")(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b13gc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b13j02 (0 9999991/9999999=.), gen(callowance)

recode b15b02 (0 9999991/9999999=.), gen(exp_parent)
recode b19b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c02z02 * -1) if (c02z02 < 99999991 & c02z01==2)
replace invest = (c02z02 * 1) if (c02z02 < 99999991 & c02z01==1)

recode c03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c03a01==2
recode c03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c03b01==2

recode c04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c04a02 (0 9999991/9999999=.), gen(pension_1)
recode c04a03 (0 9999991/9999999=.), gen(pension_2)
recode c04a04 (0 9999991/9999999=.), gen(pension_3)
recode c04a05 (0 9999991/9999999=.), gen(pension_4)
recode c04a06 (0 9999991/9999999=.), gen(pension_5)

recode c04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c04b02 (0 9999991/9999999=.), gen(Spension_1)
recode c04b03 (0 9999991/9999999=.), gen(Spension_2)
recode c04b04 (0 9999991/9999999=.), gen(Spension_3)
recode c04b05 (0 9999991/9999999=.), gen(Spension_4)
recode c04b06 (0 9999991/9999999=.), gen(Spension_5)

recode c05z02 (0 9999991/9999999=.), gen(oincome_1)
recode c05z04 (0 9999991/9999999=.), gen(oincome_2)
recode c05z06 (0 9999991/9999999=.), gen(oincome_3)
recode c05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c09a (9999991/9999999=.), gen(exp_insurance)
recode c09c (9999991/9999999=.), gen(exp_edu)

keep x01 period x01b district - exp_edu
save R_2008, replace


*RR2009
use rr2009, clear
gen period = x02    //survey period
order period, after(x01)
replace x01b = 6 if x01b==4

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)
 
gen birth_y = (1911+a02a) if a02a < 96
gen Sbirth_y = (1911+a17z01) if a17z01 > 0 & a17z01 < 96

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(98/99=.), gen(edu)

recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a19 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b14a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b14b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b18d (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b18e (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a05 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a20 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork = 1 if a06z01==1 | a06z02==1 | a06z03==1 | a06z04==1 | a06z05==1 | a06z07==1
gen Scwork = 0
replace Scwork = 1 if a21z01==1 | a21z02==1 | a21z03==1 | a21z04==1 | a21z05==1 | a21z07==1

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)
replace Semp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & Semp==990

gen retire = 0
replace retire = 1 if (a07b==3 | a07c==3) | (a14==7) | (c04a01==1 | c04a01==2)
gen Sretire = 0
replace Sretire = 1 if (a22b==3 | a22c==3) | (a27==7) | (c04b01==1 | c04b01==2)

recode a08b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & workfor==990
recode a23b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & Sworkfor==990

recode a09a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (indust)
replace indust = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)

recode a09a02 (0 9996/9999=.), gen(ver5)     //失業或沒有工作為.
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco
replace occu = 990 if a09a02==0
replace occu = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)
drop isco*

recode a24a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社(a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (Sindust)
replace Sindust = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)

recode a24a02 (0 9996/9999=.), gen(ver5)     //失業或沒有工作為.
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
lab val Soccu isco
replace Soccu = 990 if a24a02==0
replace Soccu = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)
drop isco*

recode a09f02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(workplace)
recode a24b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(Sworkplace)

recode a10a (0 9999991/9999999=.), gen(wage)
recode a10b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(income)
replace wage = income if wage==.

recode a25a (0 9999991/9999999=.), gen(Swage)
recode a25b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(Sincome)
replace Swage = Sincome if Swage==.

recode a11a (0 991/999=.), gen(workhr)
recode a26a (0 991/999=.), gen(Sworkhr)

gen seniority = .
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace seniority = y+m
	replace seniority = . if a11b01>=96
	replace seniority = y if a11b02>=96
	drop y m

gen Sseniority = .
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace Sseniority = y+m
	replace Sseniority = . if a26b01>=96
	replace Sseniority = y if a26b02>=96
	drop y m

recode a16z01 (1=1)(2/5=2)(6/7=3)(8=4)(0 96/99=.), gen(mar4)
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen family = b04a if (b04a < 96)    //the number of people living together

gen live_spouse = (b04b03 >= 1 & b04b03 < 96)
gen live_marson = (b04b06 >= 1 & b04b06 < 96)
gen live_mardau = (b04b07 >= 1 & b04b07 < 96)
gen live_sinson = (b04b08 >= 1 & b04b08 < 96)
gen live_sindau = (b04b09 >= 1 & b04b09 < 96)
gen live_parent = ((b04b01 >= 1 & b04b01 < 96) | (b04b02>=1 & b04b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04b04 >= 1 & b04b04 < 96) | (b04b05>=1 & b04b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04b30 >= 1 & b04b30 < 96) | (b04b31 >= 1 & b04b31 < 96))    //與(外)孫子女同住

gen ohouse = (b08a==1)
replace ohouse = -999 if (b06==2)

recode b08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)

recode c08a (9999991/9999999=.), gen(exp_hmortage)

recode b12 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b13ac`a' (0 96/99=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'<996 & b13c01c`a'>0

recode b13dc`a' (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b13gc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b13k02 (0 9999991/9999999=.), gen(callowance)

recode b15b02 (0 9999991/9999999=.), gen(exp_parent)
recode b19b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c02z02 * -1) if (c02z02 < 99999991 & c02z01==2)
replace invest = (c02z02 * 1) if (c02z02 < 99999991 & c02z01==1)

recode c03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c03a01==2
recode c03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c03b01==2

recode c04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c04a02 (0 9999991/9999999=.), gen(pension_1)
recode c04a03 (0 9999991/9999999=.), gen(pension_2)
recode c04a04 (0 9999991/9999999=.), gen(pension_3)
recode c04a05 (0 9999991/9999999=.), gen(pension_4)
recode c04a06 (0 9999991/9999999=.), gen(pension_5)

recode c04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c04b02 (0 9999991/9999999=.), gen(Spension_1)
recode c04b03 (0 9999991/9999999=.), gen(Spension_2)
recode c04b04 (0 9999991/9999999=.), gen(Spension_3)
recode c04b05 (0 9999991/9999999=.), gen(Spension_4)
recode c04b06 (0 9999991/9999999=.), gen(Spension_5)

recode c05z02 (0 9999991/9999999=.), gen(oincome_1)
recode c05z04 (0 9999991/9999999=.), gen(oincome_2)
recode c05z06 (0 9999991/9999999=.), gen(oincome_3)
recode c05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c09a (9999991/9999999=.), gen(exp_insurance)
recode c09c (9999991/9999999=.), gen(exp_edu)

keep x01 period x01b district - exp_edu
save R_2009, replace


*RR2010
use rr2010, clear
gen period = x02    //survey period
order period, after(x01)
replace x01b = 6 if x01b==5

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02a) if a02a < 96
gen Sbirth_y = (1911+a17z01) if (a17z01 > 0 & a17z01 < 96)

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(98/99=.), gen(edu)

recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a19 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b14a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b14b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b18d (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b18e (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a05 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a20 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork = 1 if a06z01==1 | a06z02==1 | a06z03==1 | a06z04==1 | a06z05==1 | a06z07==1
gen Scwork = 0
replace Scwork = 1 if a21z01==1 | a21z02==1 | a21z03==1 | a21z04==1 | a21z05==1 | a21z07==1

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)
replace Semp = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & Semp==990

recode a08b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & workfor==990
recode a23b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & Sworkfor==990

recode a09a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (indust)
replace indust = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)

recode a09a02 (0 9996/9999=.), gen(ver5)
merge m:1 ver5 using "2009-2010_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco
replace occu = 990 if a09a02==0
replace occu = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)    //失業為990
drop isco*

recode a24a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (Sindust)
replace Sindust = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)

recode a24a02 (0 9996/9999=.), gen(ver5)
merge m:1 ver5 using "2009-2010_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
lab val Soccu isco
replace Soccu = 990 if a24a02==0
replace Soccu = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)    //失業為990
drop isco*

recode a09b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(workplace)
recode a24b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(Sworkplace)

recode a10a (0 9999991/9999999=.), gen(wage)
recode a10b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(income)
replace wage = income if wage==.

recode a25a (0 9999991/9999999=.), gen(Swage)
recode a25b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(Sincome)
replace Swage = Sincome if Swage==.

recode a11a (0 991/999=.), gen(workhr)
recode a26a (0 991/999=.), gen(Sworkhr)

gen seniority = .
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace seniority = y+m
	replace seniority = . if a11b01>=96
	replace seniority = y if a11b02>=96
	drop y m

gen Sseniority = .
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace Sseniority = y+m
	replace Sseniority = . if a26b01>=96
	replace Sseniority = y if a26b02>=96
	drop y m
	
gen retire = 0
replace retire = 1 if (a07b==3 | a07c==3) | (a14==7) | (c04a01==1 | c04a01==2)
gen Sretire = 0
replace Sretire = 1 if (a22b==3 | a22c==3) | (a27==7) | (c04b01==1 | c04b01==2)

recode a16z01 (1=1)(2/5=2)(6/7=3)(8=4)(0 96/99=.), gen(mar4)
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen family = b04a if (b04a < 96)    //the number of people living together

gen live_spouse = (b04b03 >= 1 & b04b03 < 96)
gen live_marson = (b04b06 >= 1 & b04b06 < 96)
gen live_mardau = (b04b07 >= 1 & b04b07 < 96)
gen live_sinson = (b04b08 >= 1 & b04b08 < 96)
gen live_sindau = (b04b09 >= 1 & b04b09 < 96)
gen live_parent = ((b04b01 >= 1 & b04b01 < 96) | (b04b02>=1 & b04b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04b04 >= 1 & b04b04 < 96) | (b04b05>=1 & b04b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04b30 >= 1 & b04b30 < 96) | (b04b31 >= 1 & b04b31 < 96))    //與(外)孫子女同住

gen ohouse = (b08a==1)    //自己或配偶所有
replace ohouse = -999 if (b06==2)

recode b08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)

recode c08a (9999991/9999999=.), gen(exp_hmortage)

recode b12 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b13ac`a' (0 6/9=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'>0 & b13c01c`a'<996

recode b13dc`a' (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b13gc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b13k02 (0 9999991/9999999=.), gen(callowance)

recode b15b02 (0 9999991/9999999=.), gen(exp_parent)
recode b19b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c02z02 * -1) if (c02z02 < 99999991 & c02z01==2)
replace invest = (c02z02 * 1) if (c02z02 < 99999991 & c02z01==1)

recode c03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c03a01==2
recode c03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c03b01==2

recode c04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c04a02 (0 9999991/9999999=.), gen(pension_1)
recode c04a03 (0 9999991/9999999=.), gen(pension_2)
recode c04a04 (0 9999991/9999999=.), gen(pension_3)
recode c04a05 (0 9999991/9999999=.), gen(pension_4)
recode c04a06 (0 9999991/9999999=.), gen(pension_5)

recode c04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c04b02 (0 9999991/9999999=.), gen(Spension_1)
recode c04b03 (0 9999991/9999999=.), gen(Spension_2)
recode c04b04 (0 9999991/9999999=.), gen(Spension_3)
recode c04b05 (0 9999991/9999999=.), gen(Spension_4)
recode c04b06 (0 9999991/9999999=.), gen(Spension_5)

recode c05z02 (0 9999991/9999999=.), gen(oincome_1)
recode c05z04 (0 9999991/9999999=.), gen(oincome_2)
recode c05z06 (0 9999991/9999999=.), gen(oincome_3)
recode c05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c09a (9999991/9999999=.), gen(exp_insurance)
recode c09c (9999991/9999999=.), gen(exp_edu)

keep x01 period x01b district - exp_edu
save R_2010, replace


*RR2011
use rr2011, clear
gen period = x02    //survey period
order period, after(x01)
replace x01b = 6 if x01b==5

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02a) if a02a < 96
gen Sbirth_y = (1911+a17z01) if a17z01>0 & a17z01<996

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(98/99=.), gen(edu)

recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a19 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b14a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b14b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b18d (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b18e (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a05 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a20 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork = 1 if a06z01==1 | a06z02==1 | a06z03==1 | a06z04==1 | a06z05==1 | a06z07==1
gen Scwork = 0
replace Scwork = 1 if a21z01==1 | a21z02==1 | a21z03==1 | a21z04==1 | a21z05==1 | a21z07==1

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)
replace Semp = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & Semp==990

recode a08b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & workfor==990
recode a23b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & Sworkfor==990

recode a09a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (indust)
replace indust = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)

recode a09a02 (0 9996/9999=.), gen(ver6)    //失業或沒工作者為.
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco
replace occu = 990 if a09a02==0
replace occu = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)
drop isco*

recode a24a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (Sindust)
replace Sindust = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)

recode a24a02 (0 9996/9999=.), gen(ver6)    //失業或沒工作者為.
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
lab val Soccu isco
replace Soccu = 990 if a24a02==0
replace Soccu = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)
drop isco*

recode a09b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(workplace)
recode a24b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(Sworkplace)

recode a10a (0 9999991/9999999=.), gen(wage)
recode a10b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(income)
replace wage = income if wage==.

recode a25a (0 9999991/9999999=.), gen(Swage)
recode a25b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(Sincome)
replace Swage = Sincome if Swage==.

recode a11a (0 991/999=.), gen(workhr)
recode a26a (0 991/999=.), gen(Sworkhr)

gen seniority = .
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace seniority = y+m
	replace seniority = . if a11b01>=96
	replace seniority = y if a11b02>=96
	drop y m

gen Sseniority = .
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace Sseniority = y+m
	replace Sseniority = . if a26b01>=96
	replace Sseniority = y if a26b02>=96
	drop y m

gen retire = 0
replace retire = 1 if (a07b==3 | a07c==3) | (a14b==8) | (c04a01==1 | c04a01==2)
gen Sretire = 0
replace Sretire = 1 if (a22b==3 | a22c==3) | (a27b==8) | (c04b01==1 | c04b01==2)

gen mar4 = .
replace mar4 = 1 if a16a==3
replace mar4 = 2 if a16a==1 | a16a==2 | a16a==7
replace mar4 = 3 if a16a==4 | a16a==5 | a16a==8 | a16a==9
replace mar4 = 4 if a16a==6 | a16a==10
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen family = b04a if (b04a < 96)    //the number of people living together

gen live_spouse = (b04b03 >= 1 & b04b03 < 96)
gen live_marson = (b04b06 >= 1 & b04b06 < 96)
gen live_mardau = (b04b07 >= 1 & b04b07 < 96)
gen live_sinson = (b04b08 >= 1 & b04b08 < 96)
gen live_sindau = (b04b09 >= 1 & b04b09 < 96)
gen live_parent = ((b04b01 >= 1 & b04b01 < 96) | (b04b02>=1 & b04b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04b04 >= 1 & b04b04 < 96) | (b04b05>=1 & b04b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04b30 >= 1 & b04b30 < 96) | (b04b31 >= 1 & b04b31 < 96))    //與(外)孫子女同住

gen ohouse = (b08a==1)    //自己或配偶所有
replace ohouse = -999 if (b06==2)

recode b08e (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)

recode c08a (9999991/9999999=.), gen(exp_hmortage)

recode b12 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b13ac`a' (0 6/9=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'>0 & b13c01c`a'<996

recode b13dc`a' (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b13gc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b13k02 (0 9999991/9999999=.), gen(callowance)

recode b15b02 (0 9999991/9999999=.), gen(exp_parent)
recode b19b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c02z02 * -1) if (c02z02 < 99999991 & c02z01==2)
replace invest = (c02z02 * 1) if (c02z02 < 99999991 & c02z01==1)

recode c03a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c03a01==2
recode c03b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c03b01==2

recode c04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c04a02 (0 9999991/9999999=.), gen(pension_1)
recode c04a03 (0 9999991/9999999=.), gen(pension_2)
recode c04a04 (0 9999991/9999999=.), gen(pension_3)
recode c04a05 (0 9999991/9999999=.), gen(pension_4)
recode c04a06 (0 9999991/9999999=.), gen(pension_5)

recode c04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c04b02 (0 9999991/9999999=.), gen(Spension_1)
recode c04b03 (0 9999991/9999999=.), gen(Spension_2)
recode c04b04 (0 9999991/9999999=.), gen(Spension_3)
recode c04b05 (0 9999991/9999999=.), gen(Spension_4)
recode c04b06 (0 9999991/9999999=.), gen(Spension_5)

recode c05z02 (0 9999991/9999999=.), gen(oincome_1)
recode c05z04 (0 9999991/9999999=.), gen(oincome_2)
recode c05z06 (0 9999991/9999999=.), gen(oincome_3)
recode c05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c09a (9999991/9999999=.), gen(exp_insurance)
recode c09c (9999991/9999999=.), gen(exp_edu)

keep x01 period x01b district - exp_edu
save R_2011, replace


*RR2012
use rr2012, clear
gen period = 2012    //survey period
order period, after(x01)
replace x01b = 6 if x01b==5

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(0 996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02a01) if a02a01>0 & a02a01<96
gen Sbirth_y = (1911+a17z01) if a17z01>0 & a17z01<96

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學") (4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)

recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a19 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b14a (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b14b (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b18d (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b18e (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a05 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a20 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork = 1 if a06z01==1 | a06z02==1 | a06z03==1 | a06z04==1 | a06z05==1 | a06z07==1
gen Scwork = 0
replace Scwork = 1 if a21z01==1 | a21z02==1 | a21z03==1 | a21z04==1 | a21z05==1 | a21z07==1

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)
replace Semp = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & Semp==990


recode a08b (0=990)(96 98/99=.), gen(workfor)
replace workfor = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & workfor==990

recode a23b (0=990)(96 98/99=.), gen(Sworkfor)
replace Sworkfor = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & Sworkfor==990

recode a09a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (indust)
replace indust = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)

recode a09a02 (0 9996/9999=.), gen(ver6)         //失業或沒工作者為.
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco
replace occu = 990 if a09a02==0
replace occu = -999 if (a06z05==1 | a06z06==1) & (a06z01==2 & a06z02==2 & a06z03==2 & a06z04==2)
drop isco*

recode a24a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (Sindust)
replace Sindust = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)

recode a24a02 (0 9996/9999=.), gen(ver6)         //失業或沒工作者為.
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
lab val Soccu isco
replace Soccu = 990 if a24a02==0
replace Soccu = -999 if (a21z05==1 | a21z06==1) & (a21z01==2 & a21z02==2 & a21z03==2 & a21z04==2)
drop isco*

recode a09b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(workplace)
recode a24b02 (0=990 "不適用")(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(Sworkplace)

recode a10a (0 9999991/9999999=.), gen(wage)
recode a10b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(income)
replace wage = income if wage==.

recode a25a (0 9999991/9999999=.), gen(Swage)
recode a25b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(Sincome)
replace Swage = Sincome if Swage==.

recode a11a (0 991/999=.), gen(workhr)
recode a26a (0 991/999=.), gen(Sworkhr)

gen retire = 0
replace retire = 1 if (a07b==3 | a07c==3) | (a14b==8) | (d04a01==1 | d04a01==2)
gen Sretire = 0
replace Sretire = 1 if (a22b==3 | a22c==3) | (a27b==8) | (d04b01==1 | d04b01==2)

gen seniority = .
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace seniority = y+m
	replace seniority = . if a11b01>=96
	replace seniority = y if a11b02>=96
	drop y m
replace seniority = -999 if seniority == . & a06z06==1

gen Sseniority = .
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace Sseniority = y+m
	replace Sseniority = . if a26b01>=96
	replace Sseniority = y if a26b02>=96
	drop y m
replace Sseniority = -999 if Sseniority == . & a21z05==1
	
gen mar4=.
replace mar4 = 1 if a16a==3
replace mar4 = 2 if a16a==1 | a16a==2 | a16a==7
replace mar4 = 3 if a16a==4 | a16a==5 | a16a==8 | a16a==9
replace mar4 = 4 if a16a==6 | a16a==10
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen family = b04a if (b04a < 96)    //the number of people living together

gen live_spouse = (b04b03 >= 1 & b04b03 < 96)
gen live_marson = (b04b06 >= 1 & b04b06 < 96)
gen live_mardau = (b04b07 >= 1 & b04b07 < 96)
gen live_sinson = (b04b08 >= 1 & b04b08 < 96)
gen live_sindau = (b04b09 >= 1 & b04b09 < 96)
gen live_parent = ((b04b01 >= 1 & b04b01 < 96) | (b04b02>=1 & b04b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b04b04 >= 1 & b04b04 < 96) | (b04b05>=1 & b04b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b04b30 >= 1 & b04b30 < 96) | (b04b31 >= 1 & b04b31 < 96))    //與(外)孫子女同住

gen ohouse = (b08a==1)    //自己或配偶所有
replace ohouse = -999 if (b06==2)

recode b08c (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b06==2)

recode d08a (9999991/9999999=.), gen(exp_hmortage)

recode b12 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b13ac`a' (0 6/9=.), gen(child`a'_order)

recode b13bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b13c01c`a') if b13c01c`a'>0 & b13c01c`a'<996

recode b13dc`a' (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b13gc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b13k02 (0 9999991/9999999=.), gen(callowance)

recode b15b02 (0 9999991/9999999=.), gen(exp_parent)
recode b19b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (d02z02 * -1) if (d02z02 < 99999991 & d02z01==2)
replace invest = (d02z02 * 1) if (d02z02 < 99999991 & d02z01==1)

recode d03a02 (99999991/99999999=.), gen(ann_wage)
replace ann_wage = . if d03a01==2
recode d03b02 (99999991/99999999=.), gen(Sann_wage)
replace Sann_wage = . if d03b01==2

recode d04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode d04a02 (0 9999991/9999999=.), gen(pension_1)
recode d04a03 (0 9999991/9999999=.), gen(pension_2)
recode d04a04 (0 9999991/9999999=.), gen(pension_3)
recode d04a05 (0 9999991/9999999=.), gen(pension_4)
recode d04a06 (0 9999991/9999999=.), gen(pension_5)

recode d04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode d04b02 (0 9999991/9999999=.), gen(Spension_1)
recode d04b03 (0 9999991/9999999=.), gen(Spension_2)
recode d04b04 (0 9999991/9999999=.), gen(Spension_3)
recode d04b05 (0 9999991/9999999=.), gen(Spension_4)
recode d04b06 (0 9999991/9999999=.), gen(Spension_5)

recode d05z02 (0 9999991/9999999=.), gen(oincome_1)
recode d05z04 (0 9999991/9999999=.), gen(oincome_2)
recode d05z06 (0 9999991/9999999=.), gen(oincome_3)
recode d05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode d09a (9999991/9999999=.), gen(exp_insurance)
recode d09c (9999991/9999999=.), gen(exp_edu)

keep x01 period x01b district - exp_edu
save R_2012, replace


*RR2014
use rr2014, clear
gen period = x02    //survey period
order period, after(x01)
replace x01b = 6 if x01b==5

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02a) if a02a < 96
gen Sbirth_y = (1911+a26z01) if a26z01 > 0 & a26z01 < 96
replace Sbirth_y = -999 if a16a==1 | a16a==2 | a16a==5

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)

recode a27 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)
replace Sedu = -999 if a16a==1 | a16a==2

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a28 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b20af1 (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b20am1 (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b23bf2 (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b23bm2 (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a05 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a29 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

recode a07b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode a31b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)

recode a07a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (indust)    //無工作/失業者編碼為990

recode a07a02 (0 9996/9999=.), gen(ver6)
merge m:1 ver6 using "2011_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a07a02==0
drop isco*

recode a31a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (Sindust)    //無工作/失業者編碼為990

recode a31a02 (0 9996/9999=.), gen(job)
rename job ver6
merge m:1 ver6 using "2011_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a31a02==0
drop isco*

recode a06 (0=990)(96 98/99=.), gen(workfor)
recode a30 (0=990)(96 98/99=.), gen(Sworkfor)

recode a07c02 (0=990)(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(workplace)
recode a31c02 (0=990)(1/99=99 "國外地區（含中國及港澳地區）")(993/999=.), gen(Sworkplace)

recode a08a (0 9999991/9999999=.), gen(wage)
recode a08b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(income)
replace wage = income if wage==.

recode a32a (0 9999991/9999999=.), gen(Swage)
recode a32b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000)(8=65000) ///
			(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000)(15=135000) ///
			(16=145000)(17=155000)(18=165000)(19=175000)(20=185000)(21=195000) ///
			(22=250000)(23=300000), gen(Sincome)
replace Swage = Sincome if Swage==.

recode a09b (0 991/999=.), gen(workhr)
recode a33b (0 991/999=.), gen(Sworkhr)

gen seniority = (2014-1911)-a10a01 if (a10a01 > 0 & a10a01 < 996)
gen Sseniority = (2014-1911)-a33c01 if (a33c01 > 0 & a33c01 < 996)

gen cwork = 0
replace cwork = 1 if a11a01==1 | a11a02==1 | a11a03==1 | a11a04==1 | a11a05==1 | a11a07==1 | a11a08==1

gen retire = 0
replace retire = 1 if (a11d==3 | a11e==3) | (a14b==8) | (c04a01==1 | c04a01==2)
gen Sretire = 0
replace Sretire = 1 if (a34b==8) | (c04b01==1 | c04b01==2)

gen mar4 = .
replace mar4 = 1 if a16a==3
replace mar4 = 2 if a16a==1 | a16a==2 | a16a==7 | a16a==11
replace mar4 = 3 if a16a==4 | a16a==5 | a16a==8 | a16a==9
replace mar4 = 4 if a16a==6 | a16a==10
label define mar4 1"未婚" 2"同居/已婚" 3"分居/離婚" 4"喪偶"
label value mar4 mar4

gen ohouse = (b06a==1)    //自己或配偶所有
replace ohouse = -999 if (b04a>=2)

recode b06c (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b04a>=2)

recode c08a (9999991/9999999=.), gen(exp_hmortage)

gen family = b11a if (b11a < 96)    //the number of people living together

gen live_spouse = (b11b03 >= 1 & b11b03 < 96)
gen live_marson = (b11b06 >= 1 & b11b06 < 96)
gen live_mardau = (b11b07 >= 1 & b11b07 < 96)
gen live_sinson = (b11b08 >= 1 & b11b08 < 96)
gen live_sindau = (b11b09 >= 1 & b11b09 < 96)
gen live_parent = ((b11b01 >= 1 & b11b01 < 96) | (b11b02>=1 & b11b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b11b04 >= 1 & b11b04 < 96) | (b11b05>=1 & b11b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b11b30 >= 1 & b11b30 < 96) | (b11b31 >= 1 & b11b31 < 96))    //與(外)孫子女同住

recode b13 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b14ac`a' (0 96/99=.), gen(child`a'_order)

recode b14bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b14c01c`a') if b14c01c`a'>0 & b14c01c`a'<996

recode b14dc`a' (0=990 "990 Not available")(1/3=0 "0 無/自修")(4=1 "1 小學")(5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b14nc`a' 
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

recode b15a02 (0 9999991/9999999=.), gen(callowance)

recode b21b02 (0 9999991/9999999=.), gen(exp_parent)
recode b24b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c02z02 * -1) if (c02z02 < 99999991 & c02z01==2)
replace invest = (c02z02 * 1) if (c02z02 < 99999991 & c02z01==1)

recode c03a02 (99999991/99999999=.), gen(ann_wage)
replace ann_wage = . if c03a01==2
recode c03b02 (99999991/99999999=.), gen(Sann_wage)
replace Sann_wage = . if c03b01==2

recode c04a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c04a02 (0 9999991/9999999=.), gen(pension_1)
recode c04a03 (0 9999991/9999999=.), gen(pension_2)
recode c04a04 (0 9999991/9999999=.), gen(pension_3)
recode c04a05 (0 9999991/9999999=.), gen(pension_4)
recode c04a06 (0 9999991/9999999=.), gen(pension_5)

recode c04b01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c04b02 (0 9999991/9999999=.), gen(Spension_1)
recode c04b03 (0 9999991/9999999=.), gen(Spension_2)
recode c04b04 (0 9999991/9999999=.), gen(Spension_3)
recode c04b05 (0 9999991/9999999=.), gen(Spension_4)
recode c04b06 (0 9999991/9999999=.), gen(Spension_5)

recode c05z02 (0 9999991/9999999=.), gen(oincome_1)
recode c05z04 (0 9999991/9999999=.), gen(oincome_2)
recode c05z06 (0 9999991/9999999=.), gen(oincome_3)
recode c05z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c09a (9999991/9999999=.), gen(exp_insurance)

keep x01 period x01b district - exp_insurance
save R_2014, replace


*RR2016
use rr2016, clear
gen period = x02    //產生一個測量period年份
order period, after(x01)
replace x01b = 6 if x01b==5

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02a) if a02a < 96
gen Sbirth_y = (1911+a27z01) if a27z01 > 0 & a27z01 < 96

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職")(5/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)

recode a28 (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職") ///
(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a29 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b18af1 (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b18am1 (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b23af2 (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b23am2 (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a06a01 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a30z01 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

gen cwork = 0
replace cwork = 1 if a11b01==1 | a11b02==1 | a11b03==1 | a11b04==1 | a11b05==1 | a11b07==1 | a11b08==1

recode a08b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode a32b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)

recode a08a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (indust)    //無工作/失業者編碼為990

recode a08a02 (0 9996/9999=.), gen(ver6)
merge m:1 ver6 using "2011_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a08a02==0
drop isco*

recode a32a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (Sindust)    //無工作/失業者編碼為990

recode a32a02 (0 9996/9999=.), gen(ver6)
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a32a02==0
drop isco*

recode a07 (0=990)(96 98/99=.), gen(workfor)
recode a31 (0=990)(96 98/99=.), gen(Sworkfor)

recode a08c02 (0=990)(1/99=99)(993/999=.), gen(workplace)
recode a32c02 (0=990)(1/99=99)(993/999=.), gen(Sworkplace)

recode a09a01 (0 9999991/9999999=.), gen(wage)
recode a09a02 (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000) ///
			  (8=65000)(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000) ///
			  (15=135000)(16=145000)(17=155000)(18=165000)(19=175000)(20=185000) ///
			  (21=195000)(22=250000)(23=300000), gen(income)
replace wage = income if wage==.

recode a33a01 (0 9999991/9999999=.), gen(Swage)
recode a33a02 (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000) ///
			  (8=65000)(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000) ///
			  (15=135000)(16=145000)(17=155000)(18=165000)(19=175000)(20=185000) ///
			  (21=195000)(22=250000)(23=300000), gen(Sincome)
replace Swage = Sincome if Swage==.

recode a10b01 (0 991/999=.), gen(workhr)
recode a34b01 (0 991/999=.), gen(Sworkhr)

gen seniority = (2016-1911)-a12a01 if (a12a01 > 0 & a12a01 < 996)
replace seniority = -999 if (seniority == . & a11b02==1 | a11b03==1 | a11b04==4 | a11b05==1 | a11b06==1 | a11b07==1)
gen Sseniority = (2016-1911)-a34c01 if (a34c01 > 0 & a34c01 < 996)

gen retire = 0
replace retire = 1 if (a12g==3 | a12h==3) | (a15b==8) | (c05a01==1 | c05a01==2)
gen Sretire = 0
replace Sretire = 1 if (a35b==8) | (c06a01==1 | c06a01==2)

recode a17a (1=1 "未婚")(2=2 "同居/已婚")(3/4=3 "分居/離婚")(5=4 "喪偶")(6/9=.), gen(mar4)
replace mar4 = 2 if a17d==1 & (a17a==1 | a17a==4 | a17a==5)

gen ohouse = (b06a==1)    //自己或配偶所有
replace ohouse = -999 if (b04a==2)

recode b06c (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b04a==2)

recode c09a (9999991/9999999=.), gen(exp_hmortage)

gen family = b11a if (b11a < 96)    //the number of people living together
replace family = 90 if b11a==95    //超過90人以90作為計算

gen live_spouse = (b11b03 >= 1 & b11b03 < 96)
gen live_marson = (b11b06 >= 1 & b11b06 < 96)
gen live_mardau = (b11b07 >= 1 & b11b07 < 96)
gen live_sinson = (b11b08 >= 1 & b11b08 < 96)
gen live_sindau = (b11b09 >= 1 & b11b09 < 96)
gen live_parent = ((b11b01 >= 1 & b11b01 < 96) | (b11b02>=1 & b11b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b11b04 >= 1 & b11b04 < 96) | (b11b05>=1 & b11b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b11b30 >= 1 & b11b30 < 96) | (b11b31 >= 1 & b11b31 < 96))    //與(外)孫子女同住

recode b15 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b16ac`a' (0 96/99=.), gen(child`a'_order)

recode b16bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b16c01c`a') if b16c01c`a'>0 & b16c01c`a'<996

recode b16gc`a' (0=990 "990 Not available")(1/2 16=0 "0 無/自修")(3=1 "1 小學") ///
(4=2 "2 國中/初職")(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院") ///
(13/15=5 "5 大學(或)以上")(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b16p01c`a'
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}


foreach x of varlist b16n02c? {
	recode `x' (0 9999991/9999999=.), gen(`x'n)
}
egen callowance = rowtotal(b16n02c?n)    //至多6位子女之金額加總
drop b16n02c?n

recode b21b02 (0 9999991/9999999=.), gen(exp_parent)
recode b26b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c03z02 * -1) if (c03z02 < 99999991 & c03z01==2)
replace invest = (c03z02 * 1) if (c03z02 < 99999991 & c03z01==1)

recode c04a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c04a01==2
recode c04b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c04b01==2

gen retire_y = (1911+c05b01) if c05b01 > 0 & c05b01 < 996
gen Sretire_y = (1911+c06b01) if c06b01 > 0 & c06b01 < 996

recode c05a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c05a02 (0 9999991/9999999=.), gen(pension_1)
recode c05a03 (0 9999991/9999999=.), gen(pension_2)
recode c05a04 (0 9999991/9999999=.), gen(pension_3)
recode c05a05 (0 9999991/9999999=.), gen(pension_4)
recode c05a06 (0 9999991/9999999=.), gen(pension_5)

recode c06a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c06a02 (0 9999991/9999999=.), gen(Spension_1)
recode c06a03 (0 9999991/9999999=.), gen(Spension_2)
recode c06a04 (0 9999991/9999999=.), gen(Spension_3)
recode c06a05 (0 9999991/9999999=.), gen(Spension_4)
recode c06a06 (0 9999991/9999999=.), gen(Spension_5)

recode c07z02 (0 9999991/9999999=.), gen(oincome_1)
recode c07z04 (0 9999991/9999999=.), gen(oincome_2)
recode c07z06 (0 9999991/9999999=.), gen(oincome_3)
recode c07z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c10a (9999991/9999999=.), gen(exp_insurance)

keep x01 period x01b district - exp_insurance
save R_2016, replace


*RR2018
use rr2018, clear
gen period = x02    //產生一個測量period年份
order period, after(x01)
replace x01b = 6 if x01b==6

recode x05 (1/99=99 "國外地區（含中國及港澳地區）")(996/999=.), gen(district)

recode a01 (2=0), gen(male)

gen birth_y = (1911+a02a) if a02a < 96
gen Sbirth_y = (1911+a28a01) if a28a01 > 0 & a28a01 < 96

recode a03a (1/2=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職")(5/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)

recode a27 (0=990 "990 不適用")(1/2=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職")(5/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(Sedu)
replace Sedu = -999 if Sedu==990 & (a17a==2 & a17b==2)

recode a04a (0 6/9=.), gen(health)
replace health = (6-health)    //inversed coding
recode a29 (0 6/9=.), gen(Shealth)
replace Shealth = (6-Shealth)    //inversed coding

recode b14af1 (0 7/99=.)(6=50), gen(health_f)
replace health_f = (6-health_f)    //inversed coding
recode b14am1 (0 7/99=.)(6=50), gen(health_m)
replace health_m = (6-health_m)    //inversed coding

recode b19af2 (0 7/99=.)(6=50), gen(health_sf)
replace health_sf = (6-health_sf)    //inversed coding
recode b19am2 (0 7/99=.)(6=50), gen(health_sm)
replace health_sm = (6-health_sm)    //inversed coding

recode a04c (1=1 "Yes")(2=0 "No")(6/9=.), gen(handicap2)

recode a06a (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(work)
recode a30 (0=990 "不適用")(1/2=1 "有")(3=0 "沒有")(6/99=.), gen(Swork)

recode a08b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode a32b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(Semp)

recode a08a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (indust)    //無工作/失業者編碼為990

recode a08a02 (0 9996/9999=.), gen(ver6)
merge m:1 ver6 using "2011_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco
replace occu = 990 if a08a02==0
drop isco*

recode a32a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(996/999 =.), gen (Sindust)    //無工作/失業者編碼為990

recode a32a02 (0 9996/9999=.), gen(ver6) 
merge m:1 ver6 using "2011_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen Soccu = int(isco88/1000)
recode Soccu (0 = 10)
label value Soccu isco
replace Soccu = 990 if a32a02==0
drop isco*

recode a07a (0=990)(96 98/99=.), gen(workfor)
recode a31a (0=990)(96 98/99=.), gen(Sworkfor)

recode a08c02 (0=990)(1/99=99)(993/999=.), gen(workplace)
recode a32c02 (0=990)(1/99=99)(993/999=.), gen(Sworkplace)

recode a09a01 (0 9999991/9999999=.), gen(wage)
recode a09a02 (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000) ///
			  (8=65000)(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000) ///
			  (15=135000)(16=145000)(17=155000)(18=165000)(19=175000)(20=185000) ///
			  (21=195000)(22=250000)(23=300000)(24=400000), gen(income)
replace wage = income if wage==.

recode a33a01 (0 9999991/9999999=.), gen(Swage)
recode a33a02 (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000) ///
			  (8=65000)(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000) ///
			  (15=135000)(16=145000)(17=155000)(18=165000)(19=175000)(20=185000) ///
			  (21=195000)(22=250000)(23=350000)(24=400000), gen(Sincome)
replace Swage = Sincome if Swage==.

recode a10b (0 991/999=.), gen(workhr)
recode a34b (0 991/999=.), gen(Sworkhr)

gen cwork = 0
replace cwork = 1 if a11z06==2

gen seniority = (2018-1911)-a12a01 if (a12a01 > 0 & a12a01 < 996)
replace seniority = -999 if (seniority==. & a11z02==1 | a11z03==1 | a11z04==1 | a11z05==1 | a11z06==1 | a11z08==1)
replace seniority = 1 if a11z07==1
gen Sseniority = (2018-1911)-a34c01 if (a34c01 > 0 & a34c01 < 996)

gen retire = 0
replace retire = 1 if (a12g==3 | a12h==3) | (a15b==8) | (c05==1 | c05==2) | (c09d01==1 | c09d01==2)
gen Sretire = 0
replace Sretire = 1 if (a35b==8) | (c11a01==1 | c11a01==2) | (c11a01==1 | c11a01==2)

recode a17a (1=1 "未婚")(2=2 "同居/已婚")(3/4=3 "分居/離婚")(5=4 "喪偶")(6/9=.), gen(mar4)
replace mar4 = 2 if a17d==1 & (a17a==1 | a17a==4 | a17a==5)

gen ohouse = (b03a==1)    //自己或配偶所有
replace ohouse = -999 if (b01a==2)

recode b03c (0=990 "不適用")(1=1 "有")(2=0 "沒有")(6/9=.), gen(loan_house)
replace loan_house = -999 if (b01a==2)

recode c16a (9999991/9999999=.), gen(exp_hmortage)

gen family = b07a if (b07a < 96)    //the number of people living together
replace family = 90 if b07a==95    //超過90人以90作為計算

gen live_spouse = (b07b03 >= 1 & b07b03 < 96)
gen live_marson = (b07b06 >= 1 & b07b06 < 96)
gen live_mardau = (b07b07 >= 1 & b07b07 < 96)
gen live_sinson = (b07b08 >= 1 & b07b08 < 96)
gen live_sindau = (b07b09 >= 1 & b07b09 < 96)
gen live_parent = ((b07b01 >= 1 & b07b01 < 96) | (b07b02>=1 & b07b02 < 96))    // 與父親或母親同住
gen live_sparent = ((b07b04 >= 1 & b07b04 < 96) | (b07b05>=1 & b07b05 < 96))    // 與配偶的父親或母親同住
gen live_grachild = ((b07b30 >= 1 & b07b30 < 96) | (b07b31 >= 1 & b07b31 < 96))    //與(外)孫子女同住

recode b11 (96/99=.), gen(offspring)

forvalue a = 1/6 {
recode b12ac`a' (0 96/99=.), gen(child`a'_order)

recode b12bc`a' (0=990 "990 Not available")(6/9=.), gen(child`a'_sex)    //1=male; 2=female

gen child`a'_age = (period-1911-b12c01z01c`a') if b12c01z01c`a'>0 & b12c01z01c`a'<996

recode b12gc`a' (0=990 "990 Not available")(1/2 16=0 "0 無/自修")(3=1 "1 小學") ///
(4=2 "2 國中/初職")(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院") ///
(13/15=5 "5 大學(或)以上")(96 98/99=.), gen(child`a'_edu)

gen child`a'_cores = b12p01c`a'
recode child`a'_cores (8=1)(0=990)(96 98/99=.)(*=0)
}

foreach x of varlist b12n01z02c? {
	recode `x' (0 9999991/9999999=.), gen(`x'n)
}

egen callowance = rowtotal(b12n01z02c?n)    //至多6位子女之金額加總
drop b12n01z02c?n

recode b17b02 (0 9999991/9999999=.), gen(exp_parent)
recode b22b02 (0 9999991/9999999=.), gen(exp_Sparent)

gen invest = 0    //包含不適用、拒答或不知道，編碼為0
replace invest = (c03z02 * -1) if (c03z02 < 99999991 & c03z01==2)
replace invest = (c03z02 * 1) if (c03z02 < 99999991 & c03z01==1)

recode c04a02 (9999991/9999999=.), gen(ann_wage)
replace ann_wage = . if c04a01==2
recode c04b02 (9999991/9999999=.), gen(Sann_wage)
replace Sann_wage = . if c04b01==2

gen retire_y = (1911+c06a01) if c06a01 > 0 & c06a01 < 996
replace retire_y = (2018-c06b) if retire_y==. & (c06b > 0 & c06b < 96)
gen Sretire_y = (1911+c11b01) if c11b01 > 0 & c11b01 < 996
replace Sretire_y = (2018-c11c) if Sretire_y==. & (c11c > 0 & c11c < 96)

recode c07a01 (0 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/39 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(995 = 97 "其它")(996/999 =.), gen (r_indust)    //無工作/失業者編碼為990

recode c07a02 (0 9996/9999=.), gen(ver6)
merge m:1 ver6 using "2011_ISCO", keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen r_occu = int(isco88/1000)
recode r_occu (0 = 10)
label value r_occu isco
replace r_occu = 990 if c07a02==0
drop isco*

recode c07b (0=990)(96 98/99=.), gen(r_workfor)

recode c08a (0 9999991/9999999=.), gen(r_wage)
recode c08b (0 96/99=.)(1=0)(2=5000)(3=15000)(4=25000)(5=35000)(6=45000)(7=55000) ///
			(8=65000)(9=75000)(10=85000)(11=95000)(12=105000)(13=115000)(14=125000) ///
			(15=135000)(16=145000)(17=155000)(18=165000)(19=175000)(20=185000) ///
			(21=195000)(22=250000)(23=300000)(24=400000), gen(r_income)
replace r_wage = r_income if r_wage==.

recode c09a (0=990)(6=0)(96/99=.), gen(r_socinsur)
recode c11d (0=990)(6=0)(96/99=.), gen(Sr_socinsur)
lab define r_socinsur 1"勞工保險(勞保)" 2"農民保險(農保)" 3"公教保(公務,公職人員)" ///
					  4"公教保(私校教職)" 5"軍人保險(軍保)" 0"沒有職業保險" 990 "不適用"
lab value r_socinsur Sr_socinsur r_socinsur
			
recode c09b (0=990)(96/99=.), gen(r_reason)
lab define r_reason 1"屆齡退休" 2"因身體因素申請退休" 3"因生涯規劃申請退休" 4"提前優退" ///
					5"公營事業移轉民營化" 6"因工作或雇主更換結清年資" 7"家人因素" ///
					8"擔心以後領不到或退休金會減少" 990 "不適用"
lab value r_reason r_reason

gen r_pensions1 = c09c04 if (c09c04 < 9999991 & c09c01==1)    //一次領退休金的金額
gen r_pensionsm = c09c05 if (c09c05 < 9999991 & c09c02==1)    //按月領退休金的金額

recode c10z01 (0=990)(6 8/9=.)(7=97), gen(r_hopeage1)
lab define r_hopeage1 990 "不適用" 1"希望自己____歲退休" 2"做到屆齡退休" 3"做到不能做為止" ///
					  4"沒有想過" 97"其他"
lab value r_hopeage1 r_hopeage1
recode c10z02 (0 96/99=.), gen(r_hopeage2)

recode c12z01 (0=990)(6 8/9=.)(7=97), gen(Sr_hopeage1)
lab define Sr_hopeage1 990 "不適用" 1"希望配偶____歲退休" 2"做到屆齡退休" 3"做到不能做為止" ///
					   4"沒有想過" 97"其他"
lab value Sr_hopeage1 Sr_hopeage1
recode c12z02 (0 96/99=.), gen(Sr_hopeage2)

recode c09d01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(pensions)
recode c09d02 (0 9999991/9999999=.), gen(pension_1)
recode c09d03 (0 9999991/9999999=.), gen(pension_2)
recode c09d04 (0 9999991/9999999=.), gen(pension_3)
recode c09d05 (0 9999991/9999999=.), gen(pension_4)
recode c09d06 (0 9999991/9999999=.), gen(pension_5)

recode c11a01 (0=990 "不適用")(1=1 "有")(2/3=0 "無")(6/9=.), gen(Spensions)
recode c11a02 (0 9999991/9999999=.), gen(Spension_1)
recode c11a03 (0 9999991/9999999=.), gen(Spension_2)
recode c11a04 (0 9999991/9999999=.), gen(Spension_3)
recode c11a05 (0 9999991/9999999=.), gen(Spension_4)
recode c11a06 (0 9999991/9999999=.), gen(Spension_5)

recode c14z02 (0 9999991/9999999=.), gen(oincome_1)
recode c14z04 (0 9999991/9999999=.), gen(oincome_2)
recode c14z06 (0 9999991/9999999=.), gen(oincome_3)
recode c14z08 (0 9999991/9999999=.), gen(oincome_4)
egen oincomes = rowtotal(oincome_?)

recode c17a (9999991/9999999=.), gen(exp_insurance)

keep x01 period x01b district - exp_insurance
save R_2018, replace


*****************************  Append data  *****************************


clear
set more off
cd "D:\PSFD\RET"

*A panel append
use A_1999, clear
save A_panel_append, replace 

forvalue A= 2000/2001 {
	append using A_`A'.dta
	save, replace
}
save A_panel_append, replace

forvalue A= 2002/2012 {
use A_panel_append, clear
	append using R_`A'
	save, replace
}
save A_panel_append, replace

foreach A of numlist 2014(2)2018 {
use A_panel_append, clear
	append using R_`A'
	save, replace
}

sort x01 period
by x01 : replace x01b = x01b[_n+1] if x01b==. & x01b[_n+1] !=.
by x01 : replace x01b = x01b[_n-1] if x01b==. & x01b[_n-1] !=.

save A_panel_append, replace


*B panel append
use B_2000, clear
save B_panel_append, replace

append using B_2001
save B_panel_append, replace

forvalue B= 2002/2012 {
use B_panel_append, clear
	append using R_`B'
	save, replace
}
save B_panel_append, replace

foreach B of numlist 2014(2)2018 {
use B_panel_append, clear
	append using R_`B'
	save, replace
}

sort x01 period
by x01 : replace x01b = x01b[_n+1] if x01b==. & x01b[_n+1] !=.
by x01 : replace x01b = x01b[_n-1] if x01b==. & x01b[_n-1] !=.

save B_panel_append, replace

* Choosing the main samples (1999 & 2000)
local i=1
foreach v in A B {
use `v'_panel_append, clear
	order x01b, after(period) 
	tostring x01, replace
	gen select = substr(x01,-1,1)
	destring select, replace
	
	keep if (x01b==`i' & select==0) & (x01b <= 2 & x01b !=.)     // keep the 1999 and 2000 main samples
	
	drop select
	
save `v'_panel_append, replace
local ++i
}


*Merge to one file
use A_panel_append, clear
append using B_panel_append

sort x01 period
destring x01, replace

drop if period==.
save RET_TOTAL_ONE, replace


* replace -999 by using former value
cd "D:\PSFD\RET"
use RET_TOTAL_ONE, clear

sort x01 period
order S*, after(exp_medical)

/*replace loan_house = 990 if ohouse==0     //如果沒有擁有房子，則不適用房貸題項*/

forvalue a = 1/18 { 

by x01: replace male = male[_n-`a'] if male==-999 & male[_n-`a'] !=. & male[_n-`a'] !=-999

by x01: replace mar4 = mar4[_n-`a'] if mar4==-999 & mar4[_n-`a'] !=. & mar4[_n-`a'] !=-999

}

//處理離婚或喪偶者，混充「單身未婚」者
gen mar_4 = mar4
label value mar_4 mar4
label variable mar_4 "婚姻狀態 4 分類" 

forvalue a = 1/18 {

by x01: replace mar_4 = mar4[_n-`a'] if (mar4[_n-`a']==mar4[_n+`a']) & mar4[_n-`a'] !=. & mar4[_n-`a'] !=-999
by x01: replace mar_4 = mar4[_n-`a'] if mar4==1 & mar4[_n-`a']==3
by x01: replace mar_4 = mar4[_n-`a'] if mar4==1 & mar4[_n-`a']==4

}

forvalue a = 1/18 { 
by x01: replace birth_y = birth_y[_n-`a'] if (birth_y==-999 | birth_y==.) & birth_y[_n-`a'] !=. & birth_y[_n-`a'] !=-999

by x01: replace Sbirth_y = Sbirth_y[_n-`a'] if (Sbirth_y==-999 | Sbirth_y==.) & Sbirth_y[_n-`a'] !=. & Sbirth_y[_n-`a'] !=-999  & mar4[_n-`a']==2

by x01: replace edu = edu[_n-`a'] if edu==-999 & edu[_n-`a'] !=. & edu[_n-`a'] !=-999

by x01: replace Sedu = Sedu[_n-`a'] if Sedu==-999 & Sedu[_n-`a'] !=. & Sedu[_n-`a'] !=-999 & Sedu[_n-`a'] !=990  & mar4[_n-`a']==2

by x01: replace workfor = workfor[_n-`a'] if workfor==-999 & workfor[_n-`a'] !=. & workfor[_n-`a'] !=-999 & workfor[_n-`a'] !=990

by x01: replace Sworkfor = Sworkfor[_n-`a'] if Sworkfor==-999 & Sworkfor[_n-`a'] !=. & Sworkfor[_n-`a'] !=-999 & Sworkfor[_n-`a'] !=990 & mar4[_n-`a']==2

by x01: replace emp = emp[_n-`a'] if emp==-999 & emp[_n-`a'] !=. & emp[_n-`a'] != -999 & emp[_n-`a'] != 990

by x01: replace Semp = Semp[_n-`a'] if Semp==-999 & Semp[_n-`a'] !=. & Semp[_n-`a'] != -999 & Semp[_n-`a'] != 990 & mar4[_n-`a']==2

by x01: replace workplace = workplace[_n-`a'] if workplace==-999 & workplace[_n-`a'] !=. & workplace[_n-`a'] !=-999 & workplace[_n-`a'] !=990

by x01: replace Sworkplace = Sworkplace[_n-`a'] if Sworkplace==-999 & Sworkplace[_n-`a'] !=. & Sworkplace[_n-`a'] !=-999 & Sworkplace[_n-`a'] !=990  & mar4[_n-`a']==2

by x01: replace indust = indust[_n-`a'] if indust==-999 & indust[_n-`a'] !=. & indust[_n-`a'] !=-999 & indust[_n-`a'] !=990

by x01: replace occu = occu[_n-`a'] if occu==-999 & occu[_n-`a'] !=. & occu[_n-`a'] !=-999 & occu[_n-`a'] !=990

by x01: replace Sindust = Sindust[_n-`a'] if Sindust==-999 & Sindust[_n-`a'] !=. & Sindust[_n-`a'] !=-999 & Sindust[_n-`a'] !=990  & mar4[_n-`a']==2

by x01: replace Soccu = Soccu[_n-`a'] if Soccu==-999 & Soccu[_n-`a'] !=. & Soccu[_n-`a'] !=-999 & Soccu[_n-`a'] !=990  & mar4[_n-`a']==2

by x01: replace seniority = seniority[_n-`a']+`a' if seniority==-999 & cwork[_n-`a'+1]==0 & seniority[_n-`a'] !=. & seniority[_n-`a'] !=-999 & period<=2012
by x01: replace seniority = seniority[_n-`a']+(`a'*2) if seniority==-999 &  cwork[_n-`a'+1]==0 & seniority[_n-`a'] !=. & seniority[_n-`a'] !=-999 & period[_n-`a']>=2012

by x01: replace Sseniority = Sseniority[_n-`a']+`a' if Sseniority==-999 & Scwork[_n-`a'+1]==0 & Sseniority[_n-`a'] !=. & Sseniority[_n-`a'] !=-999 & period<=2012  & mar4[_n-`a']==2
by x01: replace Sseniority = Sseniority[_n-`a']+(`a'*2) if Sseniority==-999 & Scwork[_n-`a'+1]==0 & Sseniority[_n-`a'] !=. & Sseniority[_n-`a'] !=-999 & period[_n-`a']>=2012  & mar4[_n-`a']==2

by x01: replace ohouse = ohouse[_n-`a'] if ohouse==-999 & ohouse[_n-`a'] !=. & ohouse[_n-`a'] !=-999 

by x01: replace loan_house = loan_house[_n-`a'] if loan_house==-999 & loan_house[_n-`a'] !=. & loan_house[_n-`a'] !=-999 /*& loan_house[_n-`a'] != 990*/

forvalue n = 1/6 {
	by x01: replace child`n'_age = child`n'_age[_n-`a']+`a' if child`n'_age==. & child`n'_age[_n-`a'] !=. & period<=2012    //填補子女年齡資訊
	by x01: replace child`n'_age = child`n'_age[_n-`a']+(`a'*2) if child`n'_age==. & child`n'_age[_n-`a'] !=. & period[_n-`a']>=2012
	}

}

// 處理2000年新抽樣本之「畢業年分」不一致的問題，採用最早(2000年)的那一波次的資訊
preserve
keep x01 x01b period gradu_yr
reshape wide gradu_yr x01b, i(x01) j(period)

replace gradu_yr2001 = gradu_yr2000 if x01b2000==2 & gradu_yr2000 != gradu_yr2001 & gradu_yr2000 != .
reshape long gradu_yr x01b, i(x01) j(period)
save graduate_year, replace
restore

merge 1:1 x01 period using graduate_year, keepus(gradu_yr) update replace
drop if _merge==2
drop _merge
sort x01 period

forvalue a = 1/18 {

by x01: replace birth_y = birth_y[_n-`a'] if birth_y==. & birth_y[_n-`a'] !=.    //填補出生年份中的空隙

by x01: replace gradu_yr = gradu_yr[_n-`a'] if gradu_yr==. & gradu_yr[_n-`a'] != .

by x01: replace retire_y = retire_y[_n-`a'] if retire_y==. & retire_y[_n-`a'] !=.
by x01: replace retire_y = retire_y[_n+`a'] if retire_y==. & retire_y[_n+`a'] !=.

by x01: replace Sretire_y = Sretire_y[_n-`a'] if Sretire_y==. & Sretire_y[_n-`a'] !=. & mar4[_n-`a']==2
by x01: replace Sretire_y = Sretire_y[_n+`a'] if Sretire_y==. & Sretire_y[_n+`a'] !=. & mar4[_n+`a']==2

by x01: replace r_indust = r_indust[_n+`a'] if r_indust== . & r_indust[_n+`a'] != . & period >= retire_y 

by x01: replace r_occu = r_occu[_n+`a'] if r_occu== . & r_occu[_n+`a'] != . & period >= retire_y

by x01: replace Sr_indust = Sr_indust[_n+`a'] if Sr_indust== . & Sr_indust[_n+`a'] != . & period >= Sretire_y 

by x01: replace Sr_occu = Sr_occu[_n+`a'] if Sr_occu== . & Sr_occu[_n+`a'] != . & period >= Sretire_y

by x01: replace health = health[_n-`a'] if health==. & health[_n-`a'] !=.
by x01: replace health = health[_n+`a'] if health==. & health[_n+`a'] !=.

by x01: replace Shealth = Shealth[_n-`a'] if Shealth==. & Shealth[_n-`a'] !=. & mar4[_n-`a']==2
by x01: replace Shealth = Shealth[_n+`a'] if Shealth==. & Shealth[_n+`a'] !=. & mar4[_n+`a']==2

by x01: replace health_f = health_f[_n-`a'] if health_f==. & health_f[_n-`a'] !=. & health_f[_n-`a'] !=-44
by x01: replace health_f = health_f[_n+`a'] if health_f==. & health_f[_n+`a'] !=. & health_f[_n+`a'] !=-44
by x01: replace health_f = health_f[_n+1] if health_f==. & health_f[_n+1] ==-44

by x01: replace health_m = health_m[_n-`a'] if health_m==. & health_m[_n-`a'] !=. & health_m[_n-`a'] !=-44
by x01: replace health_m = health_m[_n+`a'] if health_m==. & health_m[_n+`a'] !=. & health_m[_n+`a'] !=-44
by x01: replace health_m = health_m[_n+1] if health_m==. & health_m[_n+1] ==-44

by x01: replace health_sf = health_sf[_n-`a'] if health_sf==. & health_sf[_n-`a'] !=. & health_sf[_n-`a'] !=-44 & mar4[_n-`a']==2
by x01: replace health_sf = health_sf[_n+`a'] if health_sf==. & health_sf[_n+`a'] !=. & health_sf[_n+`a'] !=-44 & mar4[_n+`a']==2
by x01: replace health_sf = health_sf[_n+1] if health_sf==. & health_sf[_n+1] ==-44 & mar4[_n+1]==2

by x01: replace health_sm = health_sm[_n-`a'] if health_sm==. & health_sm[_n-`a'] !=. & health_sm[_n-`a'] !=-44 & mar4[_n-`a']==2
by x01: replace health_sm = health_sm[_n+`a'] if health_sm==. & health_sm[_n+`a'] !=. & health_sm[_n+`a'] !=-44 & mar4[_n+`a']==2
by x01: replace health_sm = health_sm[_n+1] if health_sm==. & health_sm[_n+1] ==-44 & mar4[_n+1]==2

replace retire = 1 if pensions==1    //如果曾經領取退休金，則視為退休
by x01: replace retire = retire[_n-`a'] if (retire[_n-`a']==1 & retire !=.)    //曾經回報過退休者，往後則視為退休

replace Sretire = 1 if Spensions==1    //如果配偶曾經領取退休金，則視為退休
by x01: replace Sretire = Sretire[_n-`a'] if (Sretire[_n-`a']==1 & Sretire !=.) & Sbirth_y==Sbirth_y[_n-`a']    //曾經回報過退休者，往後則視為退休

} 

save RET_ALL_long, replace
