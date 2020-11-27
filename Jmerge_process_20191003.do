* Project: Panel dada merging process of PSFD 4 waves main samples (1999、2000、2003 and 2009)
* Editor: Tamao
* Date: 2019.10.03

clear
set more off
cd "D:\PSFD\Jmerge"

*RI1999(new sampling)：A panel
use ri1999, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01 
gen age = period - (a02+1911) if a02<96
gen hage = period - (d11+1911) if d11<96

recode b01 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(edu)

recode d13 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學") ///
(4/5=2 "2 國中/初職")(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院") ///
(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上")(97=97 "97 other")(96 98/99=.), gen(hedu)
		   
recode c04b (0=990 "990 Not available")(96 98/99=.), gen(work)
recode d19b (0=990 "990 Not available")(96 98/99=.), gen(hwork)

gen place = c06z02 
recode place (0=990)(993/999=.)
gen hplace = d21z02 
recode hplace (0=990)(993/999=.)

recode c05 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)
recode d20 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(hemp)

recode c08 (0 9999996/9999999=.), gen(wage)
recode d23 (0 9999996/9999999=.), gen(hwage)
recode c07 (0 996/999=.), gen(whour)
recode d22 (0 996/999=.), gen(hwhour)

recode c04a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)    //no work or unemployment are recoded as 990

recode c04a02 0 9996/9999=., gen(PSFDcode)
replace PSFDcode=. if (c01==2 & c02==2)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if c04a02==0
drop isco??

recode d19a01 (0 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)    //no work or unemployment are recoded as 990

recode d19a02 0 9996/9999=., gen(PSFDcode)
replace PSFDcode=. if (d16==2 & d17==2)
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu=int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if d19a02==0
drop isco??

recode d01z01 (97/99=.), gen(marital)
lab define marital 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
lab value marital marital
recode j01 (96/99=.), gen(children)

recode j02z01c1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-j02z02c1) if j02z02c1>0 & j02z02c1<96
recode j02z03c1 (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4=2 "2 國中/初職")(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)

recode j02z01c2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)
gen child2sage = (period-1911-j02z02c2) if j02z02c2>0 & j02z02c2<96
recode j02z03c2 (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4=2 "2 國中/初職")(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)

recode j02z01c3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)
gen child3sage = (period-1911-j02z02c3) if j02z02c3>0 & j02z02c3<96
recode j02z03c3 (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4=2 "2 國中/初職")(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)

gen rjobless = c03 
recode rjobless (0=990)(1=5)(2=6)(3=7)(4=8)(7=97)(6 8/9=.)
gen hrjobless = d18 
recode hrjobless (0=990)(1=5)(2=6)(3=7)(4=8)(7=97)(6 8/9=.)

recode c09 (0 97/99=.)(80=0), gen(years)    //未滿一年則編碼為0
gen hyears = period-1911-d24 if d24<96 & d24 !=0 

recode d02 (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(mquitm)
recode d05 (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(hmquitm)

recode a04a (0 7/9=.), gen(health)
replace health = (6-health)    //inversed coding

recode e01* e02* (6/9=.)

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace wage ///
	 hwage whour hwhour indus occu hindus hoccu marital children child1ssex ///
	 child1sage child1sedu child2ssex child2sage child2sedu child3ssex ///
	 child3sage child3sedu rjobless hrjobless years hyears mquitm hmquitm ///
	 health e01* e02*
	 
save A_1999, replace


*RII2000
use rii2000,clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01     //1=male; 2=female
gen age = period - (a02+1911) if a02<96
gen hage = period - (a06+1911) if a06<96
recode a03 (1/2=0 "0 無/自修") (3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
		   (9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
		   (97=97 "97 other")(96 98/99=.), gen(edu)

recode a08 (0=990 "990 Not available")(1/2=0 "0 無/自修") (3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
		   (9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
		   (97=97 "97 other")(96 98/99=.), gen(hedu)
		   
recode c03b (0=990 "990 Not available")(96 98/99=.), gen(work)
recode c21b (0=990 "990 Not available")(96 98/99=.), gen(hwork)

recode c04 (0=990 "990 Not available")(1=1 "3 and less")(2=2 "4-9")(3=3 "10-29")(4=4 "30-49") ///
(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)

recode c05z02 (0=990 "990 Not available")(993/999=.), gen(place)

recode c06a02 (0 9999996/9999999=.), gen(pay1_)   //hourly or monthly pay
lab var pay1_ "hourly or monthly pay"
recode c06a04 (0 9999996/9999999=.), gen(pay2_)   //bonus and dividend
lab var pay2_ "bonus and dividend"
recode c06a06 (0 9999996/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
gen hpay1_=.
gen hpay2_=.
gen hpay3_=.

recode c06b (0 9999991/9999999=.), gen(wage)
recode c22 (0 9999991/9999999=.), gen(hwage)
recode c07 (0 995/999=.), gen(whour)
recode c23 (0 995/999=.), gen(hwhour)

recode c03a01 0=990    //無工作/失業者編碼為990
replace c03a01=990 if c01==2 & c02>=3 & c02<=97
recode c03a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode c03a02 0 9996/9999=., gen(job)
replace job=. if c01==2 & c02>=3 & c02<=97     //目前沒有工作者表示為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu=int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if c03a02==0
drop isco??

recode c21a01 0=990    //無工作/失業者編碼為990
replace c21a01=990 if c19==2 & c20>=3 & c20<=97
recode c21a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode c21a02 (0 9996/9999=.), gen(job)
replace job=. if c19==2 & c20>=3 & c20<=97     //目前沒有工作者表示為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu=int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if c21a02==0
drop isco??

recode a05z01 (97/99=.), gen(marital)
lab define marital 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
lab value marital marital
recode f01 (96/99=.), gen(children)
recode f02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(newborn)    // 1=Yes; 0=No
recode f04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode f05 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode f06 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)
recode d04z* (96/99=.)
egen family = rowtotal(d04z*)    //the number of people living together

gen rjobless = c02
recode rjobless (0=990)(97=97)
gen hrjobless = c20
recode hrjobless (0=990)(97=97)

gen years=.
	gen y = c08z02 if c08z02 <96
	gen m = (c08z03/12) if c08z03 <96
	replace years = m if c08z01==2
	replace years = y+m if c08z01==3
gen hyears=.
	
recode c12z01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit1_)
recode c12z02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit2_)
recode c12z03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit3_)
recode c12z04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit4_)
recode c12z05 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit5_)
recode c12z06 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit6_)

recode c13z01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(femalew1_)
recode c13z02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(femalew2_)
recode c13z03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(femalew3_)

recode c14z01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(burdenw1_)
recode c14z02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(burdenw2_)
recode c14z03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(burdenw3_)

recode a04 (7/99=.), gen (health)
replace health = (6-health)

keep period x01 x01b sex age hage edu hedu work hwork emp place pay1_ pay2_ pay3_ ///
	 hpay1_ hpay2_ hpay3_ wage hwage whour hwhour indus occu hindus hoccu marital ///
	 children newborn bplan hchild pboy family rjobless hrjobless years hyears ///
	 benefit1_ benefit2_ benefit3_ benefit4_ benefit5_ benefit6_ femalew1_ femalew2_ ///
	 femalew3_ burdenw1_ burdenw2_ burdenw3_ health

save A_2000, replace


*RI2000(new sampling)：B panel
use ri2000, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01 
gen age = period - (a02+1911) if a02 <96
gen hage = period - (d11+1911) if d11 <96

recode b01 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(edu)
recode d13 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(hedu)
		   
recode c04b (0=990 "990 Not available")(96 98/99=.), gen(work)
recode d19b (0=990 "990 Not available")(96 98/99=.), gen(hwork)

recode c05 (0=990 "990 Not available")(96/99=.), gen(emp)
recode d20 (0=990 "990 Not available")(96/99=.), gen(hemp)

recode c06z02 (0=990 "990 Not available")(993/999=.), gen(place)
recode d21z02 (0=990 "990 Not available")(993/999=.), gen(hplace)

recode c08 (0 9999991/9999999=.), gen(wage)
recode d23 (0 9999991/9999999=.), gen(hwage)
recode c07 (0 995/999=.), gen(whour)
recode d22 (0 995/999=.), gen(hwhour)

recode d01z01 (97/99=.), gen(marital)
label define mar 1"01 未婚" 2"02 同居" 3"03 已婚" 4"04 分居" 5"05 離婚" 6"06 喪偶"
label value marital mar

recode i01 (96/99=.), gen(children)

recode i02a03 (0 96/99=.), gen(child1sorder)
recode i02a01 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-i02a02) if i02a02<96 & i02a02>0
recode i02a05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)

recode i02b03 (0 96/99=.), gen(child2sorder)
recode i02b01 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-i02b02) if i02b02<96 & i02b02>0
recode i02b05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)

recode i02c03 (0 96/99=.), gen(child3sorder)			
recode i02c01 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-i02c02) if i02c02<96 & i02c02>0
recode i02c05 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)

recode c04a01 0=990    //無工作/失業者編碼為990
replace c04a01=990 if c01==2 & c02==2
recode c04a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode c04a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode=. if c01==2 & c02==2 | c01==0
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990 "Not available"
label value occu isco9
replace occu=990 if c04a02==0
drop isco??

recode d19a01 0=990    //無工作/失業者編碼為990
replace d19a01=990 if d16==2 & d17==2
recode d19a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode d19a02 (0 9996/9999=.), gen(PSFDcode)
replace PSFDcode=. if d16==2 & d17==2
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if d19a02==0
drop isco??

gen rjobless = c03 
recode rjobless (0=990)(1=5)(2=6)(3=7)(4=8)(7=97)(8/9=.)
gen hrjobless = d18 
recode hrjobless (0=990)(1=5)(2=6)(3=7)(4=8)(7=97)(8/9=.)

recode c09 (0 96/99=.), gen(years)    //工作年資未滿1年以0計
gen hyears = (period-1911-d24) if d24>0 & d24<96

recode d02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(mquitm)
recode d05 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(hmquitm)

recode a04a 0 7/9=., gen(health)
replace health = (6-health)    //inversed coding

recode e01* e02* (6/9=.)

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace wage hwage ///
	 whour hwhour marital children child1sorder child2sorder child3sorder child1ssex ///
	 child1sage child1sedu child2ssex child2sage child2sedu child3ssex child3sage ///
	 child3sedu indus occu hindus hoccu rjobless hrjobless years hyears mquitm ///
	 hmquitm health e01* e02*
	 
save B_2000, replace


*RIII2001
use riii2001,clear
gen period=x02    //survey period
order period, after(x01)

gen sex= -999    //RIII2001缺乏樣本性別資訊，需帶入前一波資訊(隨後以-999表示)
gen age=.
gen hage=(period-1911-a12) if a12>0 & a12<96

gen edu= -999     //需帶入前一波資訊(-999)
recode a14a (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(hedu)
replace hedu = -999 if a10==1

recode a05b (0=990 "990 Not available")(96 98/99=.), gen(work)
replace work=-999 if a03b==1
recode a18b (0=990 "990 Not available")(96 98/99=.), gen(hwork)

gen emp=.
replace emp= -999 if a03a==1    //the number of employees
gen hemp=.
gen place=.
gen hplace=.
recode a07a02 (0 9999991/9999999=.), gen(pay1_)   //hourly or monthly pay
lab var pay1_ "hourly or monthly pay"
recode a07a04 (0 9999991/9999999=.), gen(pay2_)   //bonus or dividend
lab var pay2_ "bonus or dividend"
recode a07a06 (0 9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
gen hpay1_=.
gen hpay2_=.
gen hpay3_=.

recode a07b (0 9999991/9999999=.), gen(wage)
recode a20 (0 9999991/9999999=.), gen(hwage)
recode a08 (0 991/999=.), gen(whour)
recode a21 (0 991/999=.), gen(hwhour)

recode a05a01 0=990    //無工作/失業者編碼為990
replace a05a01=-999 if a03a==1 & a03b==1
replace a05a01=990 if a03a>=4 & a03a<=6 | a03a==0
recode a05a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode a05a02 (0 9996/9999=.), gen(job)
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990 "Not available"
label value occu isco9
replace occu=990 if a05a02==0
replace occu=-999 if a03a==1 & a03b==1
drop isco??

recode a18a01 0=990    //無工作/失業者編碼為990
replace a18a01=-999 if a16a==1 & a16b==1
replace a18a01=990 if a16a>=4 & a16a<=6 | a16a==0
recode a18a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode a18a02 (0 9996/9999=.), gen(job)
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if a18a02==0
replace hoccu=-999 if a16a==1 & a16b==1    //-999 means taht datum would be replaced by last years
drop isco??

gen marital=.
replace marital=-999 if a11a==1
replace marital=1 if a11a==2
replace marital=3 if a11b==1
replace marital=4 if a11b==2
replace marital=5 if a11b==3
replace marital=6 if a11b==4

recode b12ac1 (0 96/99=.), gen(child1sorder)
gen child1sdistance = b12cc1 
recode child1sdistance (0=990)(96 98/99=.)

recode b12ac2 (0 96/99=.), gen(child2sorder)
gen child2sdistance = b12cc2 
recode child2sdistance (0=990)(96 98/99=.)

recode b12ac3 (0 96/99=.), gen(child3sorder)
gen child3sdistance = b12cc3 
recode child3sdistance (0=990)(96 98/99=.)

recode d01 (96/99=.), gen(children)

recode d02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(newborn)    // 1=Yes; 0=No
recode d04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode d05 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode d06 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

gen cmarital = a10 
recode cmarital (1=0)(2=1)(6/9=.)
recode a11b (0=990 "Not available")(1=1 "Got married recently")(2=2 "Got separated recently") ///
(3=3 "Got divorced recently")(4=4 "Got widowed recently")(6/9=.), gen(ccmarital)
recode b04z* (96/99=.)

recode a01 (0 6/9=.), gen(lsat4)
replace lsat4 = (5 - lsat4)    //inversed coding

egen family = rowtotal(b04z*)    //the number of people living together

gen cjob = a03a 
replace cjob=990 if cjob==0
replace cjob=. if cjob>=98 & cjob<=99
gen hcjob = a16a
replace hcjob=990 if hcjob==0
replace hcjob=. if hcjob>=98 & hcjob<=99

/*
rename a04 rjob
replace rjob=990 if rjob==0
replace rjob=. if rjob>=98 & rjob<=99
rename a17 hrjob
replace hrjob=990 if hrjob==0
replace hrjob=. if hrjob>=98 & hrjob<=99
*/

gen rjobless = a09 
replace rjobless=990 if rjobless==0
replace rjobless=. if rjobless>=98 & rjobless<=99
recode rjobless (10/11=10)(12=11)(13=12)
gen hrjobless = a22 
replace hrjobless=990 if hrjobless==0
replace hrjobless=. if hrjobless>=98 & hrjobless<=99
recode hrjobless (10/11=10)(12=11)(13=12)
			
gen years=.
gen hyears=.

recode a02 (0 7/9=.), gen(health)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace pay1_ pay2_ ///
pay3_ hpay1_ hpay2_ hpay3_ wage hwage whour hwhour indus occu hindus hoccu marital ///
child1sorder child2sorder child3sorder child1sdistance child2sdistance child3sdistance ///
children newborn bplan hchild pboy cmarital ccmarital lsat4 family cjob hcjob rjobless ///
hrjobless health

save A_2001, replace


*RII2001
use rii2001,clear
gen period=x02    //survey period
order period, after(x01)

gen sex= a01 
gen age= (period-1911)-a02 if a02 <96
gen hage= (period-1911-c22) if c21b==1    //just got married in past one year
replace hage= -999 if c20==1 | c21b==2
replace hage=. if (c21b>=3 & c21b !=.)

recode a03 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(edu)

recode c24a (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 other")(96 98/99=.), gen(hedu)
replace hedu=-999 if c20==1 | c21b==2
replace hedu=990 if c21b>=3 & c21b<=4

gen work = c03b 
recode work(0=990)(96 98/99=.)
replace work=-999 if c01b==1
gen hwork = c28b 
recode hwork (0=990)(96 98/99=.)
replace hwork=-999 if c26b==1

recode c04 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)
replace emp=-999 if c01b==1
gen hemp=.

gen place = c06z02 
recode place (0=990)(993/999=.)
gen hplace=.
replace hplace = -999 if c26a==1 & c26b==1

recode c07a02 (0 9999991/9999999=.), gen(pay1_)   //hourly or monthly pay
lab var pay1_ "hourly or monthly pay"
recode c07a04 (0 9999991/9999999=.), gen(pay2_)   //bonus or dividend
lab var pay2_ "bonus or dividend"
recode c07a06 (0 9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
gen hpay1_=.
gen hpay2_=.
gen hpay3_=.

recode c07b (9999991/9999999=.), gen(wage)
recode c30 (9999991/9999999=.), gen(hwage)
recode c08 (0 991/999=.), gen(whour)
recode c31 (0 991/999=.), gen(hwhour)

recode c03a01 0=990    //無工作/失業者編碼為990
replace c03a01=-999 if c01a==1 & c01b==1
replace c03a01=990 if c01a>=4 & c01a<=6
recode c03a01 (990 = 990 "990 Not available ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode c03a02 (0 9996/9999=.), gen(job)
replace job=. if c01a>=4 & c01a<=6
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if c03a02==0
replace occu=-999 if c01a==1 & c01b==1
drop isco??

recode c28a01 0=990    //無工作/失業者編碼為990
replace c28a01=-999 if c26a==1 & c26b==1
replace c28a01=990 if c26a>=4 & c26a<=6
recode c28a01 (990 = 990 "990 Not available ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode c28a02 (0 9996/9999=.), gen(job)
replace job=. if c26a>=4 & c26a<=6
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if c28a02==0
replace hoccu=-999 if c26a==1 & c26b==1
drop isco??

gen marital=.
replace marital=-999 if (c21a==1 | c21a==2)
replace marital=3 if c21b==1
replace marital=4 if c21b==2
replace marital=5 if c21b==3
replace marital=6 if c21b==4

recode f01 (96/99=.), gen(children)

recode d11ac1 (0 96/99=.), gen(child1sorder)
gen child1sdistance = d11cc1 
recode child1sdistance (0=990)(96 98/99=.)

recode d11ac2 (0 96/99=.), gen(child2sorder)
gen child2sdistance = d11cc2
recode child2sdistance (0=990)(96 98/99=.)

recode d11ac3 (0 96/99=.), gen(child3sorder)
gen child3sdistance = d11cc3 
recode child3sdistance (0=990)(96 98/99=.)


recode f02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(newborn)    // 1=Yes; 0=No
recode f04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode f05 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode f06 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

gen cmarital = c20 
recode cmarital (1=0)(2=1)(6/9=.)    //No change=0
recode c21b (0=990 "Not available")(1=1 "Got married recently")(2=2 "Got separated recently") ///
(3=3 "Got divorced recently")(4=4 "Got widowed recently")(6/9=.), gen(ccmarital)
recode d04z* (96/99=.)
egen family =rowtotal(d04z*)    //the number of people living together

gen cjob = c01a 
replace cjob=990 if cjob==0
replace cjob=. if cjob>=98 & cjob<=99
gen hcjob = c26a 
replace hcjob=990 if hcjob==0
replace hcjob=. if hcjob>=98 & hcjob<=99

/*
rename c02 rjob
recode rjob (0=990)(98/99=.)
rename c27 hrjob
recode hrjob (0=990)(98/99=.)
*/

gen rjobless = c19 
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)
gen hrjobless = c32 
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)

gen years=.
	gen y = c09z02 if c09z02 <96
	gen m = (c09z03/12) if c09z03 <96
	replace years = m if c09z01==2
	replace years = y+m if c09z01==3
	drop y m
replace years = -999 if years==. & c01a==1
	
gen hyears=.
	replace hyears = -999 if c26a==1 & c26b==1
	replace hyears = 1 if c26a>=2 & c26a<=3    //job-changing regards the seniority as 1

recode c13z01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit1_)    //yes=1; No=0
recode c13z02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit2_)
recode c13z03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit3_)
recode c13z04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit4_)
recode c13z05 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit5_)
recode c13z06 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(benefit6_)

recode c14z01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(femalew1_)    //yes=1; No=0
recode c14z02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(femalew2_)
recode c14z03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(femalew3_)

recode c15z01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(burdenw1_)    //yes=1; No=0
recode c15z02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(burdenw2_)
recode c15z03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/99=.), gen(burdenw3_)

gen mquitm=.
gen hmquitm=.

gen health = a04 
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace pay1_ ///
pay2_ pay3_ hpay1_ hpay2_ hpay3_ wage hwage whour hwhour indus occu hindus hoccu ///
marital children child1sorder child2sorder child3sorder child1sdistance ///
child2sdistance child3sdistance newborn bplan hchild pboy cmarital ccmarital ///
family cjob hcjob rjobless hrjobless years hyears benefit1_ benefit2_ benefit3_ ///
benefit4_ benefit5_ benefit6_ femalew1_ femalew2_ femalew3_ burdenw1_ burdenw2_ ///
burdenw3_ mquitm hmquitm health

save B_2001, replace


*RR2002
use rr2002,clear
gen period=x02    //survey period
order period, after(x01)

gen sex = -999   //data without gender
gen age = .      //data without birth year
gen hage = (period-1911-a15) if a14==3
replace hage= -999 if a14==1 | a14==4

gen edu = -999     //data witout education, and using the datum in the last year
recode a17a (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "other")(96 98/99=.), gen(hedu)
replace hedu = -999 if a14==1 | a14==4
replace hedu = 990 if (a14==2) | (a14>=5 & a14<=6)

gen work = .
replace work = a05b if a03b04!= 1
recode work (0=990)(96 98/99=.)
replace work = -999 if a03b04== 1    //using the datum in the last year
gen hwork = .
replace hwork = a21b if a19b04!=1
recode hwork (0=990)(96 98/99=.)
replace hwork = -999 if a19b04==1    //using the datum in the last year

recode a05c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(emp)
replace emp = -999 if a03b04==1    //公司內的工作人數

recode a21c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6=6 "100-499")(7=7 "500 or more")(96/99=.), gen(hemp)
replace hemp = -999 if (a19b04==1)

gen place = a06a02 
recode place (0=990)(993/999=.)
replace place = -999 if a03b04==1     //using the datum in the last year

gen hplace = a22a02 
recode hplace (0=990)(993/999=.)
replace hplace = -999 if a19b04==1     //using the datum in the last year

recode a08a02 (0 9999991/9999999=.), gen(pay1_)   //hourly or monthly pay
lab var pay1_ "hourly or monthly pay"
recode a08a04 (0 9999991/9999999=.), gen(pay2_)   //bonus or dividend
lab var pay2_ "bonus or dividend"
recode a08a06 (0 9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
gen hpay1_ = .
gen hpay2_ = .
gen hpay3_ = .

recode a08b (9999991/9999999=.), gen(wage)
recode a24 (9999991/9999999=.), gen(hwage)

recode a09 (0 991/999=.), gen(whour)
recode a25 (0 991/999=.), gen(hwhour)

recode a05a01 0=990    //無工作/失業者編碼為990
replace a05a01 = -999 if a03a == 1 & a03b04 == 1    //使用前期資料
recode  a05a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode a05a02 (0 9996/9999=.), gen(job)
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu = 990 if (a05a02==0) | (a03a>=4 & a03a<=6)
replace occu = -999 if a03a == 1 & a03b04 == 1      //using the datum in the last year
drop isco*

recode a21a01 0=990    //無工作/失業者編碼為990
replace a21a01 = -999 if a19a == 1 & a19b04 == 1    //using the datum in the last year
recode a21a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode a21a02 (0 9996/9999=.), gen(job)
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu = 990 if (a21a02==0) | (a19a>=4 & a19a<=6)
replace hoccu = -999 if (a19a == 1 & a19b04 == 1)      //using the datum in the last year
drop isco*

gen marital=.
replace marital = -999 if a14 ==1    //帶入前期
replace marital = 1 if a14 == 2      //單身
replace marital = 3 if a14 == 3      //新結婚 
replace marital = 4 if a14 == 4
replace marital = 5 if a14 == 5
replace marital = 6 if a14 == 6

recode e01 (96/99=.), gen(children)

recode c13ac1 (0 96/99=.), gen(child1sorder)
gen child1sdistance = c13cc1 
recode child1sdistance (0=990)(96 98/99=.)

recode c13ac2 (0 96/99=.), gen(child2sorder)
gen child2sdistance = c13cc2 
recode child2sdistance (0=990)(96 98/99=.)

recode c13ac3 (0 96/99=.), gen(child3sorder)
gen child3sdistance = c13cc3
recode child3sdistance (0=990)(96 98/99=.)


recode e02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(newborn)    // 1=Yes; 0=No
recode e04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e05 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e06 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

gen cmarital = .
replace cmarital = 0 if a14>=1 & a14<=2    //No change=0
replace cmarital = 1 if a14>=3 & a14<=6
recode a14 (0=990 "Not available")(1/2=0 "No change")(3=1 "Got married recently") ///
(4=2 "Got separated recently")(5=3 "Got divorced recently")(6=4 "Got widowed recently") ///
(7/9=.)(96 98/99=.), gen(ccmarital)

recode a01 (0 6/9=.), gen(lsat4)
replace lsat4 = (5 - lsat4)    //inversed coding

recode c04z* (96/99=.)
egen family = rowtotal(c04z*)    //the number of people living together

gen cjob = a03a 
replace cjob = 990 if a03a==0
replace cjob = . if a03a>=98 & a03a<=99
gen hcjob = a19a 
replace hcjob = 990 if hcjob==0
replace hcjob = . if a03a>=98 & a03a<=99

gen rjobvo = a04b 
replace rjobvo = 990 if a04b==0
replace rjobvo = . if a04b>=98
gen rjobre = a04c 
replace rjobre = 990 if a04c==0
replace rjobre = . if a04c>=8
replace rjobre = 97 if a04c==7

gen hrjobvo = a20b 
replace hrjobvo = 990 if hrjobvo==0
replace hrjobvo = . if hrjobvo>=98
gen hrjobre = a20c 
replace hrjobre = 990 if a20c==0
replace hrjobre = . if a20c>=8
replace hrjobre = 97 if a20c==7

gen rjobless = a12 
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)
gen hrjobless = a26 
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)

gen years = .
replace years = -999 if a03b04 == 1     //使用前期資料
replace years = 1 if a03a == 2 | a03a == 3
replace years = . if a03a>= 4 & a03a<= 6    //失業或沒工作者為.
gen hyears = .
replace hyears = -999 if a19b04 == 1     //使用前期資料
replace hyears = 1 if a19a == 2 | a19a == 3
replace hyears = . if a19a>= 4 & a19a<= 6    //失業或沒工作者為.

gen health = a02 
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace pay1_ ///
pay2_ pay3_ hpay1_ hpay2_ hpay3_ wage hwage whour hwhour indus occu hindus hoccu ///
marital children child1sorder child2sorder child3sorder child1sdistance ///
child2sdistance child3sdistance newborn bplan hchild pboy cmarital ccmarital lsat4 ///
family cjob hcjob rjobvo rjobre hrjobvo hrjobre rjobless hrjobless years hyears health

save R_2002, replace


*RI2003(新抽樣)：C panel
use ri2003, clear
gen period=2003    //survey period
order period, after(x01)

gen x01b = 3    //the third panel

gen sex = a01
gen age= (period-1911)-a02 if a02<96
gen hage= (period-1911)-d11 if d11<96

recode b01 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)

recode d13 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = c04b
recode work (0=990)(96 98/99=.)
gen hwork = d19b
recode hwork (0=990)(96 98/99=.)

recode c05 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(96/99=.), gen(emp)
recode d20 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(96/99=.), gen(hemp)

gen place = c06z2
recode place (0=990)(993/999=.)
gen hplace = d21z2
recode hplace (0=990)(993/999=.)

gen pay1_ = .
gen pay2_ = .
gen pay3_ = .
gen hpay1_ = .
gen hpay2_ = .
gen hpay3_ = .

gen wage = c08
recode wage (9999991/9999999=.)
gen hwage = d28
recode hwage (9999991/9999999=.)

gen whour = c07
recode whour (0 991/999=.)
gen hwhour = d22
recode hwhour (0 991/999=.)

recode c04a1 0=990    //無工作/失業者編碼為990
recode c04a1 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode c04a2 0 9996/9999=., gen(job)     //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
drop isco*
replace occu = 990 if c04a2==0

recode d19a1 0=990    //無工作/失業者編碼為990
recode d19a1 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode d19a2 0 9996/9999=., gen(job)     //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
drop isco*
replace hoccu=990 if d19a2==0

gen marital = d01z1
recode marital (0 94 97/99 =.) 
label define mar 1"01 未婚" 2"02 同居" 3"03 已婚" 4"04 分居" 5"05 離婚" 6"06 喪偶"
label value marital mar

recode i01 (0 96/99=.), gen(children)

recode i02a3 (0 96/99=.), gen(child1sorder)
recode i02a1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-i02a2) if i02a2<96 & i02a2>0
recode i02a4 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)

recode i02b3 (0 96/99=.), gen(child2sorder)
recode i02b1 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-i02b2) if i02b2<96 & i02b2>0
recode i02b4 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)

recode i02c3 (0 96/99=.), gen(child3sorder)			
recode i02c1 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-i02c2) if i02c2<96 & i02c2>0
recode i02c4 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)

gen newborn = .
gen bplan = .
gen hchild = . 
gen pboy = .

recode g06z* (96/99=.)
egen family = rowtotal(g06z*)

gen rjobless = c03 
recode rjobless (0=990)(1=5)(2=6)(3=7)(4=8)(7=97)(6 8/9=.)
gen hrjobless = d18 
recode hrjobless (0=990)(1=5)(2=6)(3=7)(4=8)(7=97)(6 8/9=.)

gen years = c09
recode years (0 97/99=.)
gen hyears = (period-1911-d24) if d24<96

recode d02 (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(mquitm)
recode d05 (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(hmquitm)

gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

recode e01* e02* (6/9=.)

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace pay1_ pay2_ ///
pay3_ hpay1_ hpay2_ hpay3_ wage hwage whour hwhour indus occu hindus hoccu marital ///
children child1sorder child2sorder child3sorder child1ssex child1sage child1sedu ///
child2ssex child2sage child2sedu child3ssex child3sage child3sedu newborn bplan ///
hchild pboy family rjobless hrjobless years hyears mquitm hmquitm health e01* e02*

save C_2003, replace


*RR2003
use rr2003,clear
gen period=2003    //survey period
order period, after(x01)

gen sex = a01
gen age= (period-1911)-b01

recode a02z* (96/99=.)
egen family = rowtotal(a02z*)

gen health = a03
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 sex age family health

save R_2003, replace


*RR2004
use rr2004,clear
gen period=x02    //survey period
order period, after(x01)

gen sex = -999    //無資料
gen age = .    //無資料
gen hage = (period-1911-a25) if a25>0 & a25<96
replace hage = -999 if a24a==1 | a24a==4
replace hage = -999 if a24b==1 | a24b==4

gen edu = -999    //無資料，需帶入前一波資訊(-999)
recode a27a (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)
replace hedu = -999 if a24a==1 | a24a==4
replace hedu = -999 if a24b==1 | a24b==4

gen work = a05b
recode work (0=990)(96 98/99=.)
gen hwork = a31b
recode hwork (0=990)(96 98/99=.)

recode a05c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(91/99=.), gen(emp)
recode a31c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(91/99=.), gen(hemp)

gen place = a06a02
recode place (0=990)(993/999=.)
gen hplace = a32a02
recode hplace (0=990)(993/999=.)

recode a19a02 (0 9999991/9999999=.), gen(pay1_)   //hourly or monthly pay
lab var pay1_ "hourly or monthly pay"
recode a19a04 (0 9999991/9999999=.), gen(pay2_)   //bonus and dividend
lab var pay2_ "bonus and dividend"
recode a19a06 (0 9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"

recode a34a02 (0 9999991/9999999=.), gen(hpay1_)   //hourly or monthly pay
lab var hpay1_ "hourly or monthly pay"
recode a34a04 (0 9999991/9999999=.), gen(hpay2_)   //bonus and dividend
lab var hpay2_ "bonus and dividend"
recode a34a06 (0 9999991/9999999=.), gen(hpay3_)   //other pay
lab var hpay3_ "other pay"

gen wage = a08b
recode wage (9999991/9999999=.)
gen hwage = a34b
recode hwage (9999991/9999999=.)

gen whour = a09
recode whour (0 991/999=.)
gen hwhour = a35
recode hwhour (0 991/999=.)

recode a05a01 0=990    //無工作/失業者編碼為990
recode a05a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode a05a02 (0 9996/9999=.), gen(job)     //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if a05a02==0
drop isco*

recode a31a01 0=990    //無工作/失業者編碼為990
recode a31a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode a31a02 (0 9996/9999=.), gen(job)     //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if a31a02==0
drop isco*

gen marital=.
replace marital = -999 if a24a == 1 | a24b == 1    //需帶入前期資料(-999)
replace marital = 1 if a24a == 2 | a24b == 2    //單身
replace marital = 3 if a24a == 3 | a24b == 3    //新結婚 
replace marital = 4 if a24a == 4 | a24b == 4 
replace marital = 5 if a24a == 5 | a24b == 5
replace marital  = 6 if a24a == 6 | a24b == 6
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode e01 (96/99=.), gen(children)

recode c13ac1 (0 6/9=.), gen(child1sorder)
recode c13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-c13c01c1) if c13c01c1<96 & c13c01c1>0

recode c13ac2 (0 6/9=.), gen(child2sorder)
recode c13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-c13c01c2) if c13c01c2<96 & c13c01c2>0

recode c13ac3 (0 6/9=.), gen(child3sorder)
recode c13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-c13c01c3) if c13c01c3<96 & c13c01c3>0

gen child1sdistance = c13ec1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = c13ec2 
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = c13ec3
recode child3sdistance (0=990)(96 98/99=.)

recode e02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(newborn)    // 1=Yes; 0=No
recode e04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e05 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e06 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

gen cmarital = .
replace cmarital = 0 if a24b>=1 & a24b<=2    //No change=0
replace cmarital = 1 if a24b>=3 & a24b<=6
replace cmarital = 0 if a24a>=1 & a24a<=2    //No change=0
replace cmarital = 1 if a24a>=3 & a24a<=6

recode a24a (0=990 "Not available")(1/2=0 "No change")(3=1 "Got married recently") ///
(4=2 "Got separated recently")(5=3 "Got divorced recently")(6=4 "Got widowed recently") ///
(7/9=.), gen(ccmarital)
recode a24b (0=990 "Not available")(1/2=0 "No change")(3=1 "Got married recently") ///
(4=2 "Got separated recently")(5=3 "Got divorced recently")(6=4 "Got widowed recently") ///
(7/9=.), gen(ccmarital2)

replace ccmarital = ccmarital2 if (a24a==0)

recode a01 (0 6/9=.), gen(lsat4)
replace lsat4 = (5 - lsat4)    //inversed coding

recode c04z* (96/99=.)
egen family = rowtotal(c04z*)    //the number of people living together

gen rjobvo = a15b
replace rjobvo = 990 if a15b==0
replace rjobvo = . if a15b>=98 | a15b==96
gen rjobre = a15c 
replace rjobre = 990 if a15c==0
replace rjobre = . if a15c>=98
replace rjobre = 97 if a15c==7

gen hrjobvo = a39b 
replace hrjobvo = 990 if a39b==0
replace hrjobvo = . if a39b>=98 | a39b==96
gen hrjobre = a39c 
replace hrjobre = 990 if a39c==0
replace hrjobre = . if a39c>=8
replace hrjobre = 97 if a39c==7

gen rjobless = a04a
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)
gen hrjobless = a30a
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)

gen years=.
replace years=-999 if a14==1   //沒有工作轉變，需帶入前一波資訊(-999)
replace years=1 if a03==1 & a14==2
replace years=. if a03 !=1
gen hyears=.
replace hyears=-999 if a38==1   //沒有工作轉變，需帶入前一波資訊(-999)
replace hyears=1 if a36==1 & a38==2
replace hyears=. if a36 !=1 | (a24a>=5 & a24a<=6) | (a24b>=5 & a24b<=6)

gen health = a02
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace pay1_ pay2_ ///
pay3_ hpay1_ hpay2_ hpay3_ wage hwage whour hwhour indus occu hindus hoccu marital ///
children child1sorder child2sorder child3sorder child1ssex child1sage child2ssex ///
child2sage child3ssex child3sage child1sdistance child2sdistance child3sdistance ///
newborn bplan hchild pboy cmarital ccmarital family lsat4 rjobvo rjobre hrjobvo ///
hrjobre rjobless hrjobless years hyears health

save R_2004, replace


*RR2005
use rr2005,clear
gen period=x02    //survey period
order period, after(x01)

gen sex = -999    //無資料，需帶入前期資料(-999)
gen age=.    // 無資料
gen hage =(period-1911-a23) if a23>0 & a23<96
replace hage = -999 if a22==1 | a22==5

gen edu = -999    //無資料
recode a25a (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)
replace hedu = -999 if a22==1 | a22==5

gen work = a13b
recode work (0=990)(96 98/99=.)
replace work = -999 if a11b04 ==1   //使用前期資料

gen hwork = a29b
recode hwork (0=990)(96 98/99=.)
replace hwork = -999 if a27b04==1

recode a13c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(96/99=.), gen(emp)
recode a29c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(96/99=.), gen(hemp)

gen place = a14a02
recode place (0 993/999=.)
replace place = -999 if a11b04== 1  //使用前期資料
gen hplace = a30a02
recode hplace (0 993/999=.)
replace hplace = -999 if a27b04==1

recode a16a02 (9999991/9999999=.), gen(pay1_)   //hourly or monthly pay
lab var pay1_ "hourly or monthly pay"
replace pay1_ = . if a11a>=4 & a11a<=6
recode a16a04 (9999991/9999999=.), gen(pay2_)   //bonus and dividend
lab var pay2_ "bonus and dividend"
replace pay2_ = . if  a11a>=4 & a11a<=6
recode a16a06 (9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
replace pay3_ = . if a11a>=4 & a11a<=6
recode a32a02 (9999991/9999999=.), gen(hpay1_)   //hourly or monthly pay
lab var hpay1_ "hourly or monthly pay"
replace hpay1_ = . if a27a>=4 & a27a<=6
recode a32a04 (9999991/9999999=.), gen(hpay2_)   //bonus and dividend
lab var hpay2_ "bonus and dividend"
replace hpay2_ = . if a27a>=4 & a27a<=6
recode a32a06 (9999991/9999999=.), gen(hpay3_)   //other pay
lab var hpay3_ "other pay"
replace hpay3_ = . if a27a>=4 & a27a<=6

gen wage = a16b
recode wage (9999991/9999999=.)
replace wage = . if a11a>=4 & a11a<=6
gen hwage = a32b
recode hwage (9999991/9999999=.)
replace hwage = . if a27a>=4 & a27a<=6

gen whour = a17
recode whour (0 991/999=.)
gen hwhour = a33
recode whour (0 991/999=.)

replace a13a01 = -999 if a11a == 1 & a11b04 == 1   //使用前期資料
replace a13a01 = 0 if  a11a>= 4 & a11a <=6
recode a13a01 0=990    //無工作/失業者編碼為990
recode a13a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

replace a13a02 = -999 if a11a == 1 & a11b04==1   //使用前期資料
replace a13a02 = 0 if a11a>= 4 & a11a <=6
recode a13a02 (0 9996/9999=.), gen(job)     //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if a13a02==0
drop isco*

replace a29a01 = -999 if a27a == 1 & a27b04 == 1   //使用前期資料
replace a29a01 = 0 if  a27a>= 4 & a27a <=6
recode a29a01 0=990    //無工作/失業者編碼為990
recode a29a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

replace a29a02 = -999 if a27a == 1 & a27b04==1   //使用前期資料
replace a29a02 = 0 if a27a>= 4 & a27a <=6
recode a29a02 (0 9996/9999=.), gen(job)     //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if a29a02==0
drop isco*

gen marital=.
replace marital = -999 if a22 == 1 | a22 == 3    //帶入前期
replace marital = 1 if a22 == 2    //單身
replace marital = 3 if a22 == 4     //新結婚 
replace marital = 4 if a22 == 5 
replace marital = 5 if a22 == 6 
replace marital = 6 if a22 == 7
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12e (96/99=.), gen(children)

recode b13ac1 (0 6/9=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1<96 & b13c01c1>0

recode b13ac2 (0 6/9=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2<96 & b13c01c2>0

recode b13ac3 (0 6/9=.), gen(child3sorder)
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3<96 & b13c01c3>0

gen child1sdistance = b13ec1 
recode child1sdistance (0=990)(96/99=.)

gen child2sdistance = b13ec2 
recode child2sdistance (0=990)(96/99=.)

gen child3sdistance = b13ec3
recode child3sdistance (0=990)(96/99=.)

recode e01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(newborn)    // 1=Yes; 0=No
recode e03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e04 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e05 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

gen cmarital = .
replace cmarital = 0 if a22>=1 & a22<=3    //no change=0
replace cmarital = 1 if a22>=4 & a22<=7    //change=1
recode a22 (0=990 "Not available")(1/3=0 "No change")(4=1 "Got married recently") ///
(5=2 "Got separated recently")(6=3 "Got divorced recently")(7=4 "Got widowed recently") ///
(97=97 "Other")(7/9=.), gen(ccmarital)

recode a01 (0 6/9=.), gen(lsat4)
replace lsat4 = (5 - lsat4)    //inversed coding

recode b04z* (96/99=.)
egen family = rowtotal(b04z*)    //the number of people living together

gen cjob = a11a 
replace cjob = 990 if a11a==0
replace cjob = . if a11a>=98 & a11a<=99 | a11a==96
gen hcjob = a27a 
replace hcjob = 990 if a27a==0
replace hcjob = . if a27a>=98 & a27a<=99 | a27a==96

gen rjobvo = a12b 
replace rjobvo = 990 if a12b==0
replace rjobvo = . if a12b>=98 | a12b==96
gen rjobre = a12c 
replace rjobre = 990 if a12c==0
replace rjobre = . if a12c>=98| a12c==96

gen hrjobvo = a28b 
replace hrjobvo = 990 if a28b==0
replace hrjobvo = . if a28b>=98 | a28b==96
gen hrjobre = a28c 
replace hrjobre = 990 if a28c==0
replace hrjobre = . if a28c>=98  | a28c==96

gen rjobless = a20
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)
gen hrjobless = a34 
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)

gen years = .
replace years = -999 if a11a== 1   //使用前期資料
replace years = 1 if a11a>= 2 & a11a<= 3      //今年有工作，但與去年工作不一樣
replace years = . if a11a>= 4 & a11a<= 6     //失業或沒有工作為.
gen hyears = .
replace hyears = -999 if a27a==1
replace hyears = 1 if a27a>= 2 & a27a<= 3      //今年有工作，但與去年工作不一樣
replace hyears = . if a27a>= 4 & a27a<= 6     //失業或沒有工作為.

gen health = a02a
recode health (0 6/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace pay1_ pay2_ ///
pay3_ hpay1_ hpay2_ hpay3_ wage hwage whour hwhour indus occu hindus hoccu marital ///
children child1sorder child2sorder child3sorder child1ssex child1sage child2ssex ///
child2sage child3ssex child3sage child1sdistance child2sdistance child3sdistance ///
newborn bplan hchild pboy cmarital ccmarital lsat4 family cjob hcjob rjobvo rjobre ///
hrjobvo hrjobre rjobless hrjobless years hyears health

save R_2005, replace


*RR2006
use rr2006, clear
gen period=z02    //survey period
rename z01b x01b
order period, after(x01)

gen sex = a01
gen age = (period-1911)-a02
gen hage = (period-1911)-a23 if a23>0 & a23<96

gen edu = .    //缺乏教育程度資訊，需帶入前一波資訊(-999)
recode a25a (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a11b
recode work (0=990)(96 98/99=.)
gen hwork = a29b
recode hwork (0=990)(96 98/99=.)

recode a11c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode a29c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)

gen place = a12a02
recode place (0=990)(993/999=.)
gen hplace = a30a02
recode hplace (0=990)(993/999=.)

recode a13a02 (9999991/9999999=.), gen(pay1_)   //hourly or monthly pay
lab var pay1_ "hourly or monthly pay"
replace pay1_ = . if a07==2
recode a13a04 (9999991/9999999=.), gen(pay2_)   //bonus and dividend
lab var pay2_ "bonus and dividend"
replace pay2_ = . if  a07==2
recode a13a08 (9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
replace pay3_ = . if a07==2
recode a13a06 (9999991/9999999=.), gen(pay4_)   //by the piece
lab var pay4_ "by the piece"
replace pay4_ = . if a07==2

recode a31a02 (9999991/9999999=.), gen(hpay1_)   //hourly or monthly pay
lab var hpay1_ "hourly or monthly pay"
replace hpay1_ = . if a27a==2
recode a31a04 (9999991/9999999=.), gen(hpay2_)   //bonus and dividend
lab var hpay2_ "bonus and dividend"
replace hpay2_ = . if a27a==2
recode a31a08 (9999991/9999999=.), gen(hpay3_)   //other pay
lab var hpay3_ "other pay"
replace hpay3_ = . if a27a==2
recode a31a06 (9999991/9999999=.), gen(hpay4_)   //by the piece
lab var hpay4_ "by the piece"
replace hpay4_ = . if a27a==2

gen wage = a13b
recode wage (0 9999991/9999999=.)
gen hwage = a31b
recode hwage (0 9999991/9999999=.)

gen whour = a14
recode whour (0 991/999=.)
gen hwhour = a32
recode hwhour (0 991/999=.)

recode a11a01 0=990    //無工作/失業者編碼為990
recode a11a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode a11a02 (0 9996/9999=.), gen(job)    //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if a11a02==0
drop isco*

recode a29a01 0=990    //無工作/失業者編碼為990
recode a29a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode a29a02 (0 9996/9999=.), gen(job)    //失業或沒工作者編碼為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if a29a02==0
drop isco*

gen marital = a22
recode marital 94 97/99=.
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12e (96/99=.), gen(children)

recode b13ac1 (0 6/9=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1<96 & b13c01c1>0

recode b13ac2 (0 6/9=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2<96 & b13c01c2>0

recode b13ac3 (0 6/9=.), gen(child3sorder)
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3<96 & b13c01c3>0

gen child1sdistance = b13hc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b13hc2 
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b13hc3
recode child3sdistance (0=990)(96 98/99=.)

recode e01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(newborn)    // 1=Yes; 0=No
recode e03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e04 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e05 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

recode a03 (0 6/9=.), gen(lsat4)
replace lsat4 = (5 - lsat4)    //inversed coding

recode b04b* (96/99=.)
egen family = rowtotal(b04b*)    //the number of people living together

recode a08b04 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "雇主改變"
recode a08b03 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a08b01 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ "職位改變"
recode a08b02 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"

recode a27c04 (0 6/9=.)(2=0), gen(hdjob1_)
label var djob1_ "(他/她)雇主改變"
recode a27c03 (0 6/9=.)(2=0), gen(hdjob3_)
label var djob3_ "(他/她)工作內容改變"
recode a27c01 (0 6/9=.)(2=0), gen(hdjob4_)
label var djob4_ "(他/她)職位改變"
recode a27c02 (0 6/9=.)(2=0), gen(hdjob5_)
label var djob5_ "(他/她)工作地點改變"

gen rjobvo = a10b 
replace rjobvo = 990 if a10b==0
replace rjobvo = . if a10b>=98 | a10b==96
gen rjobre = a10c 
replace rjobre = 990 if a10c==0
replace rjobre = . if a10c>=98| a10c==96

gen hrjobvo = a28b 
replace hrjobvo = 990 if a28b==0
replace hrjobvo = . if a28b>=98 | a28b==96
gen hrjobre = a28c 
replace hrjobre = 990 if a28c==0
replace hrjobre = . if a28c>=98  | a28c==96

gen rjobless = a20
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)
gen hrjobless = a33 
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(96 98/99=.)

recode a08a02 (0 96/99=.), gen(years)
replace years=0 if a08a01==1     //更換過工作者，將其工作年資編碼為0
recode a27b02 (0 96/99=.), gen(hyears)
replace hyears=0 if a27b01==1     //更換過工作者，將其工作年資編碼為0

gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace pay1_ pay2_ ///
pay3_ pay4_ hpay1_ hpay2_ hpay3_ hpay4_ wage hwage whour hwhour indus occu hindus ///
hoccu marital children child1sorder child2sorder child3sorder child1ssex child1sage ///
child2ssex child2sage child3ssex child3sage child1sdistance child2sdistance ///
child3sdistance newborn bplan hchild pboy lsat4 family djob1_ djob3_ djob4_ djob5_ ///
hdjob1_ hdjob3_ hdjob4_ hdjob5_ rjobvo rjobre hrjobvo hrjobre rjobless hrjobless ///
years hyears health

save R_2006, replace


*RR2007
use rr2007, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01
gen age= (period-1911)-a02a

gen edu = .    //data without education level
recode a19 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a08b
recode work (0=990)(96 98/99=.)
replace work= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & work==990
gen hwork = a23b
recode hwork (0=990)(96 98/99=.)
replace hwork= -999 if (a21b01==2 & a06z02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & hwork==990

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990

recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)
replace hemp= -999 if (a21b01==2 & a06z02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & hemp==990

gen place = a09b02
recode place (0=990)(991/999=.)
gen hplace = a24b02
recode hplace (0=990)(991/999=.)

recode a10a02 (9999991/9999999=.), gen(pa1)   //hourly or monthly pay
recode a10a03 (9999991/9999999=.), gen(pa2)
gen pay1_ = pa1 + pa2
lab var pay1_ "hourly or monthly pay"
replace pay1_ = . if a05==2
recode a10a06 (9999991/9999999=.), gen(pay2_)   //bonus and dividend
lab var pay2_ "bonus and dividend"
replace pay2_ = . if  a05==2
recode a10a10 (9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
replace pay3_ = . if a05==2
recode a10a08 (9999991/9999999=.), gen(pay4_)   //by the piece
lab var pay4_ "by the piece"
replace pay4_ = . if a05==2

recode a25a02 (9999991/9999999=.), gen(hpa1)   //hourly or monthly pay
recode a25a04 (9999991/9999999=.), gen(hpa2)
gen hpay1_ = hpa1 +hpa2
lab var hpay1_ "hourly or monthly pay"
replace hpay1_ = . if a21a==2
recode a25a06 (9999991/9999999=.), gen(hpay2_)   //bonus and dividend
lab var hpay2_ "bonus and dividend"
replace hpay2_ = . if a21a==2
recode a25a10 (9999991/9999999=.), gen(hpay3_)   //other pay
lab var hpay3_ "other pay"
replace hpay3_ = . if a21a==2
recode a25a08 (9999991/9999999=.), gen(hpay4_)   //by the piece
lab var hpay4_ "by the piece"
replace hpay4_ = . if a21a==2

gen wage = a10b
recode wage (9999991/9999999=.)
replace wage=. if a05==2
gen hwage = a25b
recode hwage (9999991/9999999=.)
replace hwage=. if a21a==2 | a21a==0

gen whour = a11a
recode whour (991/999=.)
replace whour=. if a05==2
gen hwhour = a26a
recode hwhour (991/999=.)
replace hwhour=. if a21a==2 | a21a==0

replace a09a01= -999 if a06z05==1 | a06z06==1     //失業或沒有工作者表示為0
recode a09a01 0=990    //無工作/失業者編碼為990
recode a09a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode a09a02 (0 9996/9999=.), gen(job)     //失業或沒工作者為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if a09a02==0
replace occu= -999 if a06z05==1 | a06z06==1
drop isco*

replace a24a01= -999 if a21b05==1 | a21b06==1     //失業或沒有工作者表示為0
recode a24a01 0=990    //無工作/失業者編碼為990
recode a24a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode a24a02 (0 9996/9999=.), gen(job)     //失業或沒工作者為.
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if a24a02==0
replace hoccu= -999 if a21b05==1 | a21b06==1
drop isco*

gen marital = a16
recode marital (3/5=3)(6=4)(7=5)(8=6)(96/99=.)
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12 (96/99=.), gen(children)

recode b13ac1 (0 6/9=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1<996 & b13c01c1>0

recode b13ac2 (0 6/9=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2<996 & b13c01c2>0

recode b13ac3 (0 6/9=.), gen(child3sorder)
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3<996 & b13c01c3>0

gen child1sdistance = b13gc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b13gc2 
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b13gc3
recode child3sdistance (0=990)(96 98/99=.)

forvalue a = 1/6 {
recode b13dc`a' (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4/5=2 "2 國中/初職")(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院(科技大學)") ///
(13/15=5 "5 大學(或)以上")(96 98/99=.), gen(child`a'_edu)
}

recode f01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode f02 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode f03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

recode d07d (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode d07e (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b04b* (96/99=.)
egen family = rowtotal(b04b*)    //the number of people living together

recode a06z01 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "雇主改變"
recode a06z02 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "2006年1月後才開始工作"
recode a06z03 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a06z04 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ "職位改變"
recode a06z05 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a06z06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a06z07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"

recode a21b01 (0 6/9=.)(2=0), gen(hdjob1_)
label var djob1_ "(他/她)雇主改變"
recode a21b02 (0 6/9=.)(2=0), gen(hdjob2_)
label var djob2_ "(他/她)2006年1月後才開始工作"
recode a21b03 (0 6/9=.)(2=0), gen(hdjob3_)
label var djob3_ "(他/她)工作內容改變"
recode a21b04 (0 6/9=.)(2=0), gen(hdjob4_)
label var djob4_ "(他/她)職位改變"
recode a21b05 (0 6/9=.)(2=0), gen(hdjob5_)
label var djob5_ "(他/她)工作地點改變"
recode a21b06 (0 6/9=.)(2=0), gen(hdjob6_)
label var djob6_ "沒有改變"
recode a21b07 (0 6/9=.)(2=0), gen(hdjob7_)
label var djob7_ "其他"

gen rjobvo = a07b 
replace rjobvo = 990 if a07b==0
replace rjobvo = . if a07b>=98 | a07b==96
gen rjobre = a07c 
replace rjobre = 990 if a07c==0
replace rjobre = . if a07c>=98| a07c==96

gen hrjobvo = a22b 
replace hrjobvo = 990 if a22b==0
replace hrjobvo = . if a22b>=98 | a22b==96
gen hrjobre = a22c 
replace hrjobre = 990 if a22c==0
replace hrjobre = . if a22c>=98  | a22c==96
	
gen rjobless = a14
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(14=13)(96 98/99=.)
gen hrjobless = a27 
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(14=13)(96 98/99=.)

gen years=.
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace years = y+m
	replace years =. if a11b01>=96
	replace years = y if a11b02>=96
	drop y m
replace years = -999 if years== . & a06z06==1

gen hyears=.
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace hyears = y+m
	replace hyears =. if a26b01>=96
	replace hyears = y if a26b02>=96
	drop y m
replace hyears = -999 if hyears== . & a21b06==1

gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age edu hedu work hwork emp hemp place hplace pay1_ pay2_ pay3_ ///
pay4_ hpay1_ hpay2_ hpay3_ hpay4_ wage hwage whour hwhour indus occu hindus hoccu ///
marital children child1sorder child2sorder child3sorder child1ssex child1sage ///
child2ssex child2sage child3ssex child3sage child1sdistance child2sdistance ///
child3sdistance bplan hchild pboy jsat fsat rhappy lsat7 family djob1_ djob2_ ///
djob3_ djob4_ djob5_ djob6_ djob7_ hdjob1_ hdjob2_ hdjob3_ hdjob4_ hdjob5_ hdjob6_ ///
hdjob7_ rjobvo rjobre hrjobvo hrjobre rjobless hrjobless years hyears health

save R_2007, replace


*RR2008
use rr2008, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01 
gen age = (period-1911)-a02a

gen edu = .    //缺乏教育程度資訊，需帶入前一波資訊(-999)
recode a19 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a08b
recode work (0=990)(96 98/99=.)
replace work = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & work==990    //使用前期資料
gen hwork = a23b
recode hwork (0=990)(96 98/99=.)
replace hwork = -999 if (a21b01==2 & a21b02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & hwork==990    //使用前期資料

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990

recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)
replace hemp= -999 if (a21b01==2 & a06z02==2) & (a21b03==1 | a21b04==1 | a21b05==1 | a21b06==1) & hemp==990

gen place = a09b02
recode place (0=990)(993/999=.)
gen hplace = a24b02
recode hplace (0=990)(993/999=.)

recode a10a02 (9999991/9999999=.), gen(pa1)   //hourly or monthly pay
recode a10a03 (9999991/9999999=.), gen(pa2)
gen pay1_ = pa1 + pa2
lab var pay1_ "hourly or monthly pay"
replace pay1_ = . if a05==3
recode a10a06 (9999991/9999999=.), gen(pay2_)   //bonus and dividend
lab var pay2_ "bonus and dividend"
replace pay2_ = . if  a05==3
recode a10a10 (9999991/9999999=.), gen(pay3_)   //other pay
lab var pay3_ "other pay"
replace pay3_ = . if a05==3
recode a10a08 (9999991/9999999=.), gen(pay4_)   //by the piece
lab var pay4_ "by the piece"
replace pay4_ = . if a05==3

recode a25a02 (9999991/9999999=.), gen(hpa1)   //hourly or monthly pay
recode a25a04 (9999991/9999999=.), gen(hpa2)
gen hpay1_ = hpa1 +hpa2
lab var hpay1_ "hourly or monthly pay"
replace hpay1_ = . if a21a==3
recode a25a06 (9999991/9999999=.), gen(hpay2_)   //bonus and dividend
lab var hpay2_ "bonus and dividend"
replace hpay2_ = . if a21a==3
recode a25a10 (9999991/9999999=.), gen(hpay3_)   //other pay
lab var hpay3_ "other pay"
replace hpay3_ = . if a21a==3
recode a25a08 (9999991/9999999=.), gen(hpay4_)   //by the piece
lab var hpay4_ "by the piece"
replace hpay4_ = . if a21a==3

gen wage = a10b
recode wage (9999991/9999999=.)
replace wage=. if a05>=2 & a05<=3
gen hwage = a25b
recode hwage (9999991/9999999=.)
replace hwage=. if a21a>=2 & a21a<=3

gen whour = a11a
recode whour (0 991/999=.)
replace whour = 0 if a11a==0 & (a05==1 | a05==2)
gen hwhour = a26a
recode hwhour (0 991/999=.)
replace hwhour = 0 if a26a==0 & (a21a==1 | a21a==2)

recode a09a01 0=990  //無工作/失業者編碼為990
replace a09a01 = -999 if a06z05==1 | a06z06 == 1   //使用前期資料(-999)
replace a09a01 = 100 if a05==2     //無酬勞動者
*replace a09a01 = 53 if x01==4041150     //個案處理各別代換
*replace a09a01 = 98 if x01==4120022     //個案處理各別代換
recode a09a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (indus)

recode a09a02 (0 9996/9999=.), gen(job)
replace job = 3 if a05==2     //無酬勞動者
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen occu =int(isco88/1000)
recode occu (0 = 10)
label define isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu = 990 if a09a02==0
replace occu = -999 if a06z05==1 | a06z06 == 1   //使用前期資料(-999)
drop isco*

recode a24a01 0=990  //無工作/失業者編碼為990
replace a24a01 = -999 if a21b05==1 | a21b06 == 1   //使用前期資料(-999)
replace a24a01 = 100 if a21a==2     //無酬勞動者
recode a24a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(11/18 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(20/39 = 2 " 製造業 ")(40/49 = 3 " 水電燃氣業 ") ///
(50/59 = 4 " 營造業 ")(60/69 = 5 " 商業 ")(70/79 = 6 " 運輸、倉儲、及通信業 ") ///
(80/89 = 7 " 金融、保險、不動產、及工商服務業 ")(90/99 = 8 " 公共行政、社會服務及個人服務業 ") ///
(100 = .)(996/999 =.), gen (hindus)

recode a24a02 (0 9996/9999=.), gen(job)
replace job = 3 if a05==2     //無酬勞動者
rename job PSFDcode
merge m:1 PSFDcode using "1999-2008_ISCO", keepus(isco*)    //與ISCO編碼進行合併
drop if _merge==2     //將未使用到的ISCO編碼刪除
drop _merge PSFDcode
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu = 990 if a24a02==0
replace hoccu = -999 if a21b05==1 | a21b06 == 1   //使用前期資料(-999)
drop isco*

gen marital = a16z01
recode mar (0=.)(3/5=3)(6=4)(7=5)(8=6)(94 97/99=.)
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12 (96/99=.), gen(children)

recode b13ac1 (0 6/9=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1<996 & b13c01c1>0

recode b13ac2 (0 6/9=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2<996 & b13c01c2>0

recode b13ac3 (0 6/9=.), gen(child3sorder)	
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3<996 & b13c01c3>0

gen child1sdistance = b13gc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b13gc2 
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b13gc3
recode child3sdistance (0=990)(96 98/99=.)

forvalue a = 1/6 {
recode b13dc`a' (0=990 "990 Not available")(1/2 16=0 "0 無/幼稚園")(3=1 "1 小學") ///
(4/5=2 "2 國中/初職")(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院(科技大學)") ///
(13/15=5 "5 大學(或)以上")(96 98/99=.), gen(child`a'_edu)
}

recode e01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e02 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

recode c07a (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode c07b (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b04b* (96/99=.)
egen family = rowtotal(b04b*)    //the number of people living together

recode a06z01 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "雇主改變"
recode a06z02 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "2007年1月後才開始工作"
recode a06z03 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a06z04 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ ")職位改變"
recode a06z05 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a06z06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a06z07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"

recode a21b01 (0 6/9=.)(2=0), gen(hdjob1_)
label var djob1_ "(他/她)雇主改變"
recode a21b02 (0 6/9=.)(2=0), gen(hdjob2_)
label var djob2_ "(他/她)2007年1月後才開始工作"
recode a21b03 (0 6/9=.)(2=0), gen(hdjob3_)
label var djob3_ "(他/她)工作內容改變"
recode a21b04 (0 6/9=.)(2=0), gen(hdjob4_)
label var djob4_ "(他/她)職位改變"
recode a21b05 (0 6/9=.)(2=0), gen(hdjob5_)
label var djob5_ "(他/她)工作地點改變"
recode a21b06 (0 6/9=.)(2=0), gen(hdjob6_)
label var djob6_ "沒有改變"
recode a21b07 (0 6/9=.)(2=0), gen(hdjob7_)
label var djob7_ "其他"

gen rjobvo = a07b 
replace rjobvo = 990 if a07b==0
replace rjobvo = . if a07b>=98 | a07b==96
gen rjobre = a07c 
replace rjobre = 990 if a07c==0
replace rjobre = . if a07c>=98| a07c==96

gen hrjobvo = a22b 
replace hrjobvo = 990 if a22b==0
replace hrjobvo = . if a22b>=98 | a22b==96
gen hrjobre = a22c 
replace hrjobre = 990 if a22c==0
replace hrjobre = . if a22c>=98  | a22c==96
	
gen rjobless = a14
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(14=13)(15=14)(96 98/99=.)
gen hrjobless = a27 
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(14=13)(15=14)(96 98/99=.)

gen years=.
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02<96
	replace years = y+m
	replace years =. if a11b01>=96
	replace years = y if a11b02>=96
	drop y m
replace years = -999 if years== . & a06z06==1

gen hyears=.
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace hyears = y+m
	replace hyears =. if a26b01>=96
	replace hyears = y if a26b02>=96
	drop y m
replace years = -999 if years== . & a21b06==1

gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age edu hedu work hwork emp hemp place hplace pay1_ pay2_ pay3_ ///
pay4_ hpay1_ hpay2_ hpay3_ hpay4_ wage hwage whour hwhour indus occu hindus hoccu ///
marital children child1sorder child2sorder child3sorder child1ssex child1sage ///
child2ssex child2sage child3ssex child3sage child1sdistance child2sdistance ///
child3sdistance bplan hchild pboy jsat fsat rhappy lsat7 family djob1_ djob2_ ///
djob3_ djob4_ djob5_ djob6_ djob7_ hdjob1_ hdjob2_ hdjob3_ hdjob4_ hdjob5_ hdjob6_ ///
hdjob7_ rjobvo rjobre hrjobvo hrjobre rjobless hrjobless years hyears health

save R_2008, replace


*RI2009(新抽樣)：D panel
use ri2009, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01
gen age = (period-1911)-a02z01
gen hage = (period-1911)-d11 if d11>0 & d11<96

recode b01 (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)
recode d13 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = c04b
recode work (0=990)(96 98/99=.)
gen hwork = d19b
recode hwork (0=990)(96 98/99=.)

recode c05 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode d20 (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)

gen place = c06z02
recode place (0=990)(993/999=.)
gen hplace = d21z02
recode hplace (0=990)(993/999=.)

recode c08c01 (0=990)(2=0)(6/9=.), gen(cpay1_)    //hourly or daily pay
lab var cpay1_ "hourly or daily pay"
recode c08c02 (0=990)(2=0)(6/9=.), gen(cpay2_)    //monthly pay
lab var cpay2_ "monthly pay"
recode c08c03 (0=990)(2=0)(6/9=.), gen(cpay3_)    //bonus and dividend
lab var cpay3_ "bonus and dividend"
recode c08c04 (0=990)(2=0)(6/9=.), gen(cpay4_)    //by the piece
lab var cpay4_ "by the piece"
recode c08c05 (0=990)(2=0)(6/9=.), gen(cpay5_)    //other pay
lab var cpay5_ "other pay"

recode d23c01 (0=990)(2=0)(6/9=.), gen(hcpay1_)    //hourly or daily pay
lab var hcpay1_ "(spouse) hourly or daily pay"
recode d23c02 (0=990)(2=0)(6/9=.), gen(hcpay2_)    //monthly pay
lab var hcpay2_ "(spouse) monthly pay"
recode d23c03 (0=990)(2=0)(6/9=.), gen(hcpay3_)    //bonus and dividend
lab var hcpay3_ "(spouse) bonus and dividend"
recode d23c04 (0=990)(2=0)(6/9=.), gen(hcpay4_)    //by the piece
lab var hcpay4_ "(spouse) by the piece"
recode d23c05 (0=990)(2=0)(6/9=.), gen(hcpay5_)    //other pay
lab var hcpay5_ "(spouse) other pay"

gen wage = c08a
recode wage (0 9999991/9999999=.)
gen income = c08b
recode income (0 96/99=.)

gen hwage = d23a
recode hwage (0 9999991/9999999=.)
gen hincome = d23b
recode hincome (0 96/99=.)

gen whour = c07
recode whour (0 991/999=.)
gen hwhour = d22
recode hwhour (0 991/999=.)

recode c04a01 0=990    //無工作/失業者編碼為990
recode c04a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (indus)

recode c04a02 (0 9996/9999=.), gen(job)
rename job ver5
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen occu =int(isco88/1000)
recode occu (0 = 10)
lab def isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco9
replace occu=990 if c04a02==0
drop isco*

recode d19a01 0=990    //無工作/失業者編碼為990
recode d19a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (hindus)

recode d19a02 (0 9996/9999=.), gen(job)
rename job ver5
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
lab val hoccu isco9
replace hoccu=990 if d19a02==0
drop isco*

gen marital = d01a01
recode marital (3/5=3)(6=4)(7=5)(8=6) 
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode i01 (96/99=.), gen(children)

recode i02a03 (0 6/9=.), gen(child1sorder)
recode i02a01 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-i02a02z1) if i02a02z1<996 & i02a02z1>0
recode i02a04 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)

recode i02b03 (0 6/9=.), gen(child2sorder)
recode i02b01 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-i02b02z1) if i02b02z1<996 & i02b02z1>0
recode i02b04 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)

recode i02c03 (0 6/9=.), gen(child3sorder)
recode i02c01 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-i02c02z1) if i02c02z1<996 & i02c02z1>0
recode i02c04 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)

recode i04 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode i05 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode i03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

recode g06b* (96/99=.)
egen family = rowtotal(b06b*)    //the number of people living together

gen rjobless = c03
recode rjobless (0=990)(10/11=10)(12=11)(13=12)(14=13)(96 98/99=.)
gen hrjobless = d18
recode hrjobless (0=990)(10/11=10)(12=11)(13=12)(14=13)(96 98/99=.)

recode c09 (0 96/99=.), gen(years)
replace years=0 if c10!=0     //工作年資未滿1年以0計
recode d24 (0 96/99=.), gen(hyears)
replace hyears=0 if d24!=0     //工作年資未滿1年以0計

recode d02b (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(mquitm)
recode d05b (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(hmquitm)

gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

recode e01* e02* (6/9=.)

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace cpay1_ ///
cpay2_ cpay3_ cpay4_ cpay5_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ wage income ///
hwage hincome whour hwhour indus occu hindus hoccu marital children child1sorder ///
child2sorder child3sorder child1ssex child1sage child1sedu child2ssex child2sage ///
child2sedu child3ssex child3sage child3sedu bplan hchild pboy family rjobless ///
hrjobless years hyears mquitm hmquitm health e01* e02*

save D_2009, replace


*RR2009
use rr2009, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01
gen age= (period-1911)-a02a
gen hage= (period-1911)-a17z01 if a17z01>0 & a17z01<96

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(98/99=.), gen(edu)
recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a08b
recode work (0=990)(96 98/99=.)
replace work=-999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & work==990
gen hwork = a23b
recode hwork (0=990)(96 98/99=.)
replace work=-999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & hwork==990

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)
replace hemp= -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & hemp==990

gen place = a09f02
recode place (0=990)(993/999=.)
gen hplace = a24b02
recode hplace (0=990)(993/999=.)

recode a10c01 (0=990)(2=0)(6/9=.), gen(cpay1_)    //hourly or daily pay
lab var cpay1_ "hourly or daily pay"
recode a10c02 (0=990)(2=0)(6/9=.), gen(cpay2_)    //monthly pay
lab var cpay2_ "monthly pay"
recode a10c03 (0=990)(2=0)(6/9=.), gen(cpay3_)    //bonus and dividend
lab var cpay3_ "bonus and dividend"
recode a10c04 (0=990)(2=0)(6/9=.), gen(cpay4_)    //by the piece
lab var cpay4_ "by the piece"
recode a10c05 (0=990)(2=0)(6/9=.), gen(cpay5_)    //other pay
lab var cpay5_ "other pay"

recode a25c01 (0=990)(2=0)(6/9=.), gen(hcpay1_)    //hourly or daily pay
lab var hcpay1_ "(spouse) hourly or daily pay"
recode a25c02 (0=990)(2=0)(6/9=.), gen(hcpay2_)    //monthly pay
lab var hcpay2_ "(spouse) monthly pay"
recode a25c03 (0=990)(2=0)(6/9=.), gen(hcpay3_)    //bonus and dividend
lab var hcpay3_ "(spouse) bonus and dividend"
recode a25c04 (0=990)(2=0)(6/9=.), gen(hcpay4_)    //by the piece
lab var hcpay4_ "(spouse) by the piece"
recode a25c05 (0=990)(2=0)(6/9=.), gen(hcpay5_)    //other pay
lab var hcpay5_ "(spouse) other pay"

gen wage = a10a
recode wage (0 9999991/9999999=.)
gen income = a10b
recode income (0 96/99=.)

gen hwage = a25a
recode hwage (0 9999991/9999999=.)
gen hincome = a25b
recode hincome (0 96/99=.)

gen whour = a11a
recode whour (0 991/999=.)
gen hwhour = a26a
recode hwhour (0 991/999=.)

recode a09a01 0=990    //無工作/失業者編碼為990
replace a09a01 = -999 if a06z05==1 | a06z06==1    //失業或沒有工作為0
recode a09a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (indus)

recode a09a02 (0 9996/9999=.), gen(job)     //失業或沒有工作為.
rename job ver5
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen occu = int(isco88/1000)
recode occu (0 = 10)
lab def isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco9
replace occu = 990 if a09a02==0
replace occu = -999 if a06z05==1 | a06z06==1
drop isco*

recode a24a01 0=990    //無工作/失業者編碼為990
replace a24a01 = -999 if a21z05==1 | a21z06==1    //失業或沒有工作為0
recode a24a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (hindus)

recode a24a02 (0 9996/9999=.), gen(job)     //失業或沒有工作為.
rename job ver5
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen hoccu = int(isco88/1000)
recode hoccu (0 = 10)
lab val hoccu isco9
replace hoccu = 990 if a24a02==0
replace hoccu = -999 if a21z05==1 | a21z06==1
drop isco*

gen marital = a16z01
recode mar (0=.)(3/5=3)(6=4)(7=5)(8=6)
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12 (96/99=.), gen(children)

recode b13ac1 (0 96/99=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1<996 & b13c01c1>0
recode b13dc1 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)
recode b13ec1 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child1swork)    //Yes=1; No=0

recode b13ac2 (0 96/99=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2<996 & b13c01c2>0
recode b13dc2 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)
recode b13ec2 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child2swork)    //Yes=1; No=0

recode b13ac3 (0 96/99=.), gen(child3sorder)
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3<996 & b13c01c3>0
recode b13dc3 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)
recode b13ec3 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child3swork)    //Yes=1; No=0

gen child1sdistance = b13gc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b13gc2 
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b13gc3
recode child3sdistance (0=990)(96 98/99=.)

recode e02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e03 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(pboy)

recode c07a (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode c07b (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b04b* (96/99=.)
egen family = rowtotal(b04b*)    //the number of people living together

recode a06z01 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "雇主改變"
recode a06z02 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "2008年1月後才開始工作"
recode a06z03 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a06z04 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ ")職位改變"
recode a06z05 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a06z06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a06z07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"

recode a21z01 (0 6/9=.)(2=0), gen(hdjob1_)
label var hdjob1_ "(他/她)雇主改變"
recode a21z02 (0 6/9=.)(2=0), gen(hdjob2_)
label var hdjob2_ "(他/她)2008年1月後才開始工作"
recode a21z03 (0 6/9=.)(2=0), gen(hdjob3_)
label var hdjob3_ "(他/她)工作內容改變"
recode a21z04 (0 6/9=.)(2=0), gen(hdjob4_)
label var hdjob4_ "(他/她)職位改變"
recode a21z05 (0 6/9=.)(2=0), gen(hdjob5_)
label var hdjob5_ "(他/她)工作地點改變"
recode a21z06 (0 6/9=.)(2=0), gen(hdjob6_)
label var hdjob6_ "沒有改變"
recode a21z07 (0 6/9=.)(2=0), gen(hdjob7_)
label var hdjob7_ "其他"

gen rjobvo = a07b
replace rjobvo = 990 if a07b==0
replace rjobvo = . if a07b>=98 | a07b==96
gen rjobre = a07c 
replace rjobre = 990 if a07c==0
replace rjobre = . if a07c>=98| a07c==96

gen hrjobvo = a22b 
replace hrjobvo = 990 if a22b==0
replace hrjobvo = . if a22b>=98 | a22b==96
gen hrjobre = a22c 
replace hrjobre = 990 if a22c==0
replace hrjobre = . if a22c>=98  | a22c==96

gen rjobless = a14
replace rjobless=990 if a14==0
replace rjobless=. if a14>=98 | a14==96
recode rjobless (10/11=10)(12=11)(13=12)(14=13)(15=14)
gen hrjobless = a27
replace hrjobless=990 if a27==0
replace hrjobless=. if a27>=98 | a27==96
recode hrjobless (10/11=10)(12=11)(13=12)(14=13)(15=14)

gen years=.
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace years = y+m
	replace years =. if a11b01>=96
	replace years = y if a11b02>=96
	drop y m
replace years = -999 if years== . & a06z06==1

gen hyears=.
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace hyears = y+m
	replace hyears =. if a26b01>=96
	replace hyears = y if a26b02>=96
	drop y m
replace hyears = -999 if hyears== . & a21z06==1

gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace cpay1_ ///
cpay2_ cpay3_ cpay4_ cpay5_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ wage income ///
hwage hincome whour hwhour indus occu hindus hoccu marital children child1sorder ///
child2sorder child3sorder child1ssex child1sage child1sedu child1swork child2ssex ///
child2sage child2sedu child2swork child3ssex child3sage child3sedu child3swork ///
child1sdistance child2sdistance child3sdistance bplan hchild pboy jsat fsat ///
rhappy lsat7 family djob1_ djob2_ djob3_ djob4_ djob5_ djob6_ djob7_ hdjob1_ ///
hdjob2_ hdjob3_ hdjob4_ hdjob5_ hdjob6_ hdjob7_ rjobvo rjobre hrjobvo hrjobre ///
rjobless hrjobless years hyears health

save R_2009, replace


*RR2010
use rr2010, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01
gen age= (period-1911)-a02a
gen hage = (period-1911)-a17z01 if a17z01>0 & a17z01<96

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(98/99=.), gen(edu)
recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a08b
recode work (0=990)(96 98/99=.)
replace work = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & work==990
gen hwork = a23b
recode hwork (0=990)(96 98/99=.)
replace hwork = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & hwork==990

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)
replace hemp = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & hemp==990

gen place = a09b02
recode place (0=990)(993/999=.)
gen  hplace = a24b02
recode hplace (0=990)(993/999=.)

recode a10c01 (0=990)(2=0)(6/9=.), gen(cpay1_)    //hourly or daily pay
lab var cpay1_ "hourly or daily pay"
recode a10c02 (0=990)(2=0)(6/9=.), gen(cpay2_)    //monthly pay
lab var cpay2_ "monthly pay"
recode a10c03 (0=990)(2=0)(6/9=.), gen(cpay3_)    //bonus and dividend
lab var cpay3_ "bonus and dividend"
recode a10c04 (0=990)(2=0)(6/9=.), gen(cpay4_)    //by the piece
lab var cpay4_ "by the piece"
recode a10c05 (0=990)(2=0)(6/9=.), gen(cpay5_)    //other pay
lab var cpay5_ "other pay"

recode a25c01 (0=990)(2=0)(6/9=.), gen(hcpay1_)    //hourly or daily pay
lab var hcpay1_ "(spouse) hourly or daily pay"
recode a25c02 (0=990)(2=0)(6/9=.), gen(hcpay2_)    //monthly pay
lab var hcpay2_ "(spouse) monthly pay"
recode a25c03 (0=990)(2=0)(6/9=.), gen(hcpay3_)    //bonus and dividend
lab var hcpay3_ "(spouse) bonus and dividend"
recode a25c04 (0=990)(2=0)(6/9=.), gen(hcpay4_)    //by the piece
lab var hcpay4_ "(spouse) by the piece"
recode a25c05 (0=990)(2=0)(6/9=.), gen(hcpay5_)    //other pay
lab var hcpay5_ "(spouse) other pay"

gen wage = a10a
recode wage (0 9999991/9999999=.)
replace wage =. if a05>=2 & a05<=3
gen income = a10b
recode income (0 96/99=.)

gen hwage = a25a
recode hwage (0 9999991/9999999=.)
replace hwage = . if a20>=2 & a20<=3
gen hincome = a25b
recode hincome (0 96/99=.)

gen whour = a11a
recode whour (0 991/999=.)
gen hwhour = a26a
recode hwhour (0 991/999=.)

replace a09a01= -999 if a06z05==1 | a06z06==1    //失業為990
recode a09a01 0=990    //無工作/失業者編碼為990
recode a09a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (indus)

recode a09a02 (0 9996/9999=.), gen(job)
rename job ver5
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen occu =int(isco88/1000)
recode occu (0 = 10)
lab def isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco9
replace occu = 990 if a09a02==0
replace occu = -999 if a06z05==1 | a06z06==1    //失業為990
drop isco*

replace a24a01= -999 if a21z05==1 | a21z06==1    //失業為990
recode a24a01 0=990    //無工作/失業者編碼為990
recode a24a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (hindus)

recode a24a02 (0 9996/9999=.), gen(job)
rename job ver5
merge m:1 ver5 using "2009-2010_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver5
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
lab val hoccu isco9
replace hoccu = 990 if a24a02==0
replace hoccu = -999 if a21z05==1 | a21z06==1    //失業為990
drop isco*

gen marital = a16z01
recode mar (0 96/99=.)(4/5=3)(6=4)(7=5)(8=6)
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12 (96/99=.), gen(children)

recode b13ac1 (0 6/9=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1>0 & b13c01c1<996
recode b13dc1 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)
recode b13ec1 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child1swork)    //Yes=1; No=0

recode b13ac2 (0 6/9=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2>0 & b13c01c2<996
recode b13dc2 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)
recode b13ec2 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child2swork)    //Yes=1; No=0

recode b13ac3 (0 6/9=.), gen(child3sorder)
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3>0 & b13c01c3<996
recode b13dc3 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)
recode b13ec3 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child3swork)    //Yes=1; No=0


gen child1sdistance = b13gc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b13gc2 
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b13gc3
recode child3sdistance (0=990)(96 98/99=.)

recode e03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e04 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyp)
recode e02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyhp)

recode c07a (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode c07b (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b04b* (96/99=.)
egen family = rowtotal(b04b*)    //the number of people living together

recode a06z01 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "雇主改變"
recode a06z02 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "2009年1月後才開始工作"
recode a06z03 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a06z04 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ ")職位改變"
recode a06z05 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a06z06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a06z07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"

recode a21z01 (0 6/9=.)(2=0), gen(hdjob1_)
label var hdjob1_ "(他/她)雇主改變"
recode a21z02 (0 6/9=.)(2=0), gen(hdjob2_)
label var hdjob2_ "(他/她)2009年1月後才開始工作"
recode a21z03 (0 6/9=.)(2=0), gen(hdjob3_)
label var hdjob3_ "(他/她)工作內容改變"
recode a21z04 (0 6/9=.)(2=0), gen(hdjob4_)
label var hdjob4_ "(他/她)職位改變"
recode a21z05 (0 6/9=.)(2=0), gen(hdjob5_)
label var hdjob5_ "(他/她)工作地點改變"
recode a21z06 (0 6/9=.)(2=0), gen(hdjob6_)
label var hdjob6_ "沒有改變"
recode a21z07 (0 6/9=.)(2=0), gen(hdjob7_)
label var hdjob7_ "其他"

gen rjobvo = a07b
replace rjobvo = 990 if a07b==0
replace rjobvo = . if a07b>=98 | a07b==96
gen rjobre = a07c 
replace rjobre = 990 if a07c==0
replace rjobre = . if a07c>=98| a07c==96

gen hrjobvo = a22b 
replace hrjobvo = 990 if a22b==0
replace hrjobvo = . if a22b>=98 | a22b==96
gen hrjobre = a22c 
replace hrjobre = 990 if a22c==0
replace hrjobre = . if a22c>=98  | a22c==96

gen rjobless = a14
replace rjobless=990 if a14==0
replace rjobless=. if a14>=98 | a14==96
recode rjobless (14=15)(15=14)
gen hrjobless = a27
replace hrjobless=990 if a27==0
replace hrjobless=. if a27>=98 | a27==96
recode hrjobless (14=15)(15=14)

gen years=.
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace years = y+m
	replace years =. if a11b01>=96
	replace years = y if a11b02>=96
	drop y m
replace years = -999 if years== . & a06z06==1


gen hyears=.
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace hyears = y+m
	replace hyears =. if a26b01>=96
	replace hyears = y if a26b02>=96
	drop y m
replace hyears = -999 if hyears== . & a21z06==1


gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace cpay1_ cpay2_ ///
cpay3_ cpay4_ cpay5_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ wage income hwage hincome ///
whour hwhour indus occu hindus hoccu marital children child1sorder child2sorder child3sorder ///
child1ssex child1sage child1sedu child1swork child2ssex child2sage child2sedu child2swork ///
child3ssex child3sage child3sedu child3swork child1sdistance child2sdistance child3sdistance ///
bplan hchild boyp boyhp jsat fsat rhappy lsat7 family djob1_ djob2_ djob3_ djob4_ djob5_ ///
djob6_ djob7_ hdjob1_ hdjob2_ hdjob3_ hdjob4_ hdjob5_ hdjob6_ hdjob7_ rjobvo rjobre hrjobvo ///
hrjobre rjobless hrjobless years hyears health

save R_2010, replace


*RR2011
use rr2011, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01
gen age = (period-1911)-a02a
gen hage = (period-1911)-a17z01 if a17z01>0 & a17z01<996

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(98/99=.), gen(edu)
recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a08b
recode work (0=990)(96 98/99=.)
replace work=-999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & work==990
gen hwork = a23b
recode hwork (0=990)(96 98/99=.)
replace hwork = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & hwork==990

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)
replace hemp = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & hemp==990

gen place = a09b02
recode place (0=990)(993/999=.)
gen hplace = a24b02
recode hplace (0=990)(993/999=.)

recode a10c01 (0=990)(2=0)(6/9=.), gen(cpay1_)    //hourly or daily pay
lab var cpay1_ "hourly or daily pay"
recode a10c02 (0=990)(2=0)(6/9=.), gen(cpay2_)    //monthly pay
lab var cpay2_ "monthly pay"
recode a10c03 (0=990)(2=0)(6/9=.), gen(cpay3_)    //bonus and dividend
lab var cpay3_ "bonus and dividend"
recode a10c04 (0=990)(2=0)(6/9=.), gen(cpay4_)    //by the piece
lab var cpay4_ "by the piece"
recode a10c05 (0=990)(2=0)(6/9=.), gen(cpay5_)    //other pay
lab var cpay5_ "other pay"

recode a25c01 (0=990)(2=0)(6/9=.), gen(hcpay1_)    //hourly or daily pay
lab var hcpay1_ "(spouse) hourly or daily pay"
recode a25c02 (0=990)(2=0)(6/9=.), gen(hcpay2_)    //monthly pay
lab var hcpay2_ "(spouse) monthly pay"
recode a25c03 (0=990)(2=0)(6/9=.), gen(hcpay3_)    //bonus and dividend
lab var hcpay3_ "(spouse) bonus and dividend"
recode a25c04 (0=990)(2=0)(6/9=.), gen(hcpay4_)    //by the piece
lab var hcpay4_ "(spouse) by the piece"
recode a25c05 (0=990)(2=0)(6/9=.), gen(hcpay5_)    //other pay
lab var hcpay5_ "(spouse) other pay"

gen wage = a10a
recode wage (0 9999991/9999999=.)
replace wage = . if a05>=2 & a05<=3
gen income = a10b
recode income (0 96/99=.)

gen hwage = a25a
recode hwage (0 9999991/9999999=.)
replace hwage = . if a20>=2 & a20<=3
gen hincome = a25b
recode hincome (0 96/99=.)

gen whour = a11a
recode whour (0 991/999=.)
gen hwhour = a26a
recode hwhour (0 991/999=.)

replace a09a01= -999 if a06z05==1 | a06z06==1    //失業為0
recode a09a01 0=990    //無工作/失業者編碼為990
recode a09a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (indus)

recode a09a02 (0 9996/9999=.), gen(job)    //失搾或沒工作者為.
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu =int(isco88/1000)
recode occu (0 = 10)
lab def isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco9
replace occu = 990 if a09a02==0
replace occu = -999 if a06z05==1 | a06z06==1
drop isco*

replace a24a01= -999 if a21z05==1 | a21z06==1    //失業為0
recode a24a01 0=990    //無工作/失業者編碼為990
recode a24a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (hindus)

recode a24a02 (0 9996/9999=.), gen(job)    //失搾或沒工作者為.
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
lab val hoccu isco9
replace hoccu = 990 if a24a02==0
replace hoccu = -999 if a21z05==1 | a21z06==1
drop isco*

gen marital=.
replace marital=3 if a16a==1 | a16a==7
replace marital=2 if a16a==2
replace marital=1 if a16a==3
replace marital=5 if a16a==4 | a16a==9
replace marital=4 if a16a==5 | a16a==8
replace marital=6 if a16a==6 | a16a==10
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12 (96/99=.), gen(children)

recode b13ac1 (0 6/9=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1>0 & b13c01c1<996
recode b13dc1 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)
recode b13ec1 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child1swork)    //Yes=1; No=0

recode b13ac2 (0 6/9=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2>0 & b13c01c2<996
recode b13dc2 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)
recode b13ec2 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child2swork)    //Yes=1; No=0

recode b13ac3 (0 6/9=.), gen(child3sorder)
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3>0 & b13c01c3<996
recode b13dc3 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)
recode b13ec3 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child3swork)    //Yes=1; No=0

gen child1sdistance = b13gc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b13gc2 
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b13gc3
recode child3sdistance (0=990)(96 98/99=.)

recode e03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode e04 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode e01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyp)
recode e02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyhp)

recode c07a (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode c07b (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b04b* (96/99=.)
egen family = rowtotal(b04b*)    //the number of people living together

recode a06z01 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "雇主改變"
recode a06z02 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "2010年1月後才開始工作"
recode a06z03 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a06z04 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ ")職位改變"
recode a06z05 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a06z06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a06z07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"

recode a21z01 (0 6/9=.)(2=0), gen(hdjob1_)
label var hdjob1_ "(他/她)雇主改變"
recode a21z02 (0 6/9=.)(2=0), gen(hdjob2_)
label var hdjob2_ "(他/她)2010年1月後才開始工作"
recode a21z03 (0 6/9=.)(2=0), gen(hdjob3_)
label var hdjob3_ "(他/她)工作內容改變"
recode a21z04 (0 6/9=.)(2=0), gen(hdjob4_)
label var hdjob4_ "(他/她)職位改變"
recode a21z05 (0 6/9=.)(2=0), gen(hdjob5_)
label var hdjob5_ "(他/她)工作地點改變"
recode a21z06 (0 6/9=.)(2=0), gen(hdjob6_)
label var hdjob6_ "沒有改變"
recode a21z07 (0 6/9=.)(2=0), gen(hdjob7_)
label var hdjob7_ "其他"

gen rjobvo = a07b
replace rjobvo = 990 if a07b==0
replace rjobvo = . if a07b>=98 | a07b==96
gen rjobre = a07c 
replace rjobre = 990 if a07c==0
replace rjobre = . if a07c>=98| a07c==96

gen hrjobvo = a22b 
replace hrjobvo = 990 if a22b==0
replace hrjobvo = . if a22b>=98 | a22b==96
gen hrjobre = a22c 
replace hrjobre = 990 if a22c==0
replace hrjobre = . if a22c>=98  | a22c==96

gen rjobless = a14a
replace rjobless=990 if a14a==0
replace rjobless=. if a14a>=98 | a14a==96
recode rjobless (6=14)(3=16)(4=17)(5=18)(97=97)
gen hrjobless = a27a
replace hrjobless=990 if a27a==0
replace hrjobless=. if a27a>=98 | a27a==96
recode hrjobless (6=14)(3=16)(4=17)(5=18)(97=97)

gen years=.
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace years = y+m
	replace years =. if a11b01>=96
	replace years = y if a11b02>=96
	drop y m
replace years = -999 if years== . & a06z06==1

gen hyears=.
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace hyears = y+m
	replace hyears =. if a26b01>=96
	replace hyears = y if a26b02>=96
	drop y m
replace hyears = -999 if hyears==. & a21z06==1

gen health = a04a
recode health (0 7/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace cpay1_ ///
cpay2_ cpay3_ cpay4_ cpay5_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ wage income ///
hwage hincome whour hwhour indus occu hindus hoccu marital children child1sorder ///
child2sorder child3sorder child1ssex child1sage child1sedu child1swork child2ssex ///
child2sage child2sedu child2swork child3ssex child3sage child3sedu child3swork ///
child1sdistance child2sdistance child3sdistance bplan hchild boyp boyhp jsat fsat ///
rhappy lsat7 family djob1_ djob2_ djob3_ djob4_ djob5_ djob6_ djob7_ hdjob1_ hdjob2_ ///
hdjob3_ hdjob4_ hdjob5_ hdjob6_ hdjob7_ rjobvo rjobre hrjobvo hrjobre rjobless ///
hrjobless years hyears health

save R_2011, replace


*RR2012
use rr2012, clear
gen period=2012    //survey period
order period, after(x01)

gen sex = a01
gen age = (period-1911)-a02a01 if a02a01>0 & a02a01<96
gen hage = (period-1911)-a17z01 if a17z01>0 & a17z01<96

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學") (4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)
recode a18 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a08b
recode work (0=990)(96 98/99=.)
replace work=-999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & work==990
gen hwork = a23b
recode hwork (0=990)(96 98/99=.)
replace hwork = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & hwork==990

recode a08c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
replace emp = -999 if (a06z01==2 & a06z02==2) & (a06z03==1 | a06z04==1 | a06z05==1 | a06z06==1) & emp==990
recode a23c (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)
replace hemp = -999 if (a21z01==2 & a21z02==2) & (a21z03==1 | a21z04==1 | a21z05==1 | a21z06==1) & hemp==990

gen place = a09b02
recode place (0 993/999=.)
gen hplace = a24b02
recode hplace (0 993/999=.)

recode a10c01 (0=990)(2=0)(6/9=.), gen(cpay1_)    //hourly or daily pay
lab var cpay1_ "hourly or daily pay"
recode a10c02 (0=990)(2=0)(6/9=.), gen(cpay2_)    //monthly pay
lab var cpay2_ "monthly pay"
recode a10c03 (0=990)(2=0)(6/9=.), gen(cpay3_)    //bonus and dividend
lab var cpay3_ "bonus and dividend"
recode a10c04 (0=990)(2=0)(6/9=.), gen(cpay4_)    //by the piece
lab var cpay4_ "by the piece"
recode a10c05 (0=990)(2=0)(6/9=.), gen(cpay5_)    //other pay
lab var cpay5_ "other pay"

recode a25c01 (0=990)(2=0)(6/9=.), gen(hcpay1_)    //hourly or daily pay
lab var hcpay1_ "(spouse) hourly or daily pay"
recode a25c02 (0=990)(2=0)(6/9=.), gen(hcpay2_)    //monthly pay
lab var hcpay2_ "(spouse) monthly pay"
recode a25c03 (0=990)(2=0)(6/9=.), gen(hcpay3_)    //bonus and dividend
lab var hcpay3_ "(spouse) bonus and dividend"
recode a25c04 (0=990)(2=0)(6/9=.), gen(hcpay4_)    //by the piece
lab var hcpay4_ "(spouse) by the piece"
recode a25c05 (0=990)(2=0)(6/9=.), gen(hcpay5_)    //other pay
lab var hcpay5_ "(spouse) other pay"

gen wage = a10a
recode wage (0 9999991/9999999=.)
replace wage = . if a05>=2 & a05<=3
gen income = a10b
recode income (0 96/99=.)

gen hwage = a25a
recode hwage (0 9999991/9999999=.)
replace hwage = . if a20>=2 & a20<=3
gen hincome = a25b
recode hincome (0 96/99=.)

gen whour = a11a
recode whour (0 991/999=.)
gen hwhour = a26a
recode hwhour (0 996/999=.)

replace a09a01 = -999 if a06z05==1 | a06z06==1    //失業為0
recode a09a01 0=990    //無工作/失業者編碼為990
recode a09a01 (990 = 990 "990 Not available")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (indus)

recode a09a02 (0 9996/9999=.), gen(job)         //失業或沒工作者為.
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu =int(isco88/1000)
recode occu (0 = 10)
lab def isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
lab val occu isco9
replace occu = 990 if a09a02==0
replace occu = -999 if a06z05==1 | a06z06==1
drop isco*

replace a24a01 = -999 if a21z05==1 | a21z06==1    //失業為0
recode a24a01 0=990    //無工作/失業者編碼為990
recode a24a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (hindus)

recode a24a02 (0 9996/9999=.), gen(job)         //失業或沒工作者為.
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
lab val hoccu isco9
replace hoccu = 990 if a24a02==0
replace hoccu = -999 if a21z05==1 | a21z06==1
drop isco*

gen marital=.
replace marital=3 if a16a==1 | a16a==7
replace marital=2 if a16a==2
replace marital=1 if a16a==3
replace marital=5 if a16a==4 | a16a==9
replace marital=4 if a16a==5 | a16a==8
replace marital=6 if a16a==6 | a16a==10
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b12 (96/99=.), gen(children)

recode b13ac1 (0 6/9=.), gen(child1sorder)
recode b13bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b13c01c1) if b13c01c1>0 & b13c01c1<996
recode b13dc1 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)
recode b13ec1 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child1swork)    //Yes=1; No=0

recode b13ac2 (0 6/9=.), gen(child2sorder)
recode b13bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b13c01c2) if b13c01c2>0 & b13c01c2<996
recode b13dc2 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)
recode b13ec2 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child2swork)    //Yes=1; No=0

recode b13ac3 (0 6/9=.), gen(child3sorder)
recode b13bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b13c01c3) if b13c01c3>0 & b13c01c3<996
recode b13dc3 (0=990 "990 Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)
recode b13ec3 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child3swork)    //Yes=1; No=0

gen child1sdistance = b13gc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b13gc2
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b13gc3
recode child3sdistance (0=990)(96 98/99=.)

recode f03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode f04 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode f01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyp)
recode f02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyhp)

recode e01a (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode e01b (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b04b* (96/99=.)
egen family = rowtotal(b04b*)    //the number of people living together

recode a06z01 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "雇主改變"
recode a06z02 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "2011年1月後才開始工作"
recode a06z03 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a06z04 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ ")職位改變"
recode a06z05 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a06z06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a06z07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"

recode a21z01 (0 6/9=.)(2=0), gen(hdjob1_)
label var hdjob1_ "(他/她)雇主改變"
recode a21z02 (0 6/9=.)(2=0), gen(hdjob2_)
label var hdjob2_ "(他/她)2011年1月後才開始工作"
recode a21z03 (0 6/9=.)(2=0), gen(hdjob3_)
label var hdjob3_ "(他/她)工作內容改變"
recode a21z04 (0 6/9=.)(2=0), gen(hdjob4_)
label var hdjob4_ "(他/她)職位改變"
recode a21z05 (0 6/9=.)(2=0), gen(hdjob5_)
label var hdjob5_ "(他/她)工作地點改變"
recode a21z06 (0 6/9=.)(2=0), gen(hdjob6_)
label var hdjob6_ "沒有改變"
recode a21z07 (0 6/9=.)(2=0), gen(hdjob7_)
label var hdjob7_ "其他"

gen rjobvo = a07b
replace rjobvo = 990 if a07b==0
replace rjobvo = . if a07b>=98 | a07b==96
gen rjobre = a07c 
replace rjobre = 990 if a07c==0
replace rjobre = . if a07c>=98| a07c==96

gen hrjobvo = a22b 
replace hrjobvo = 990 if a22b==0
replace hrjobvo = . if a22b>=98 | a22b==96
gen hrjobre = a22c 
replace hrjobre = 990 if a22c==0
replace hrjobre = . if a22c>=98  | a22c==96

gen rjobless = a14a
replace rjobless=990 if a14a==0
replace rjobless=. if a14a>=98 | a14a==96
recode rjobless (6=14)(3=16)(4=17)(5=18)(97=97)
gen hrjobless = a27a
replace hrjobless=990 if a27a==0
replace hrjobless=. if a27a>=98 | a27a==96
recode hrjobless (6=14)(3=16)(4=17)(5=18)(97=97)

gen years=.
	gen y = a11b01 if a11b01<96
	gen m = (a11b02/12) if a11b02 <96
	replace years = y+m
	replace years =. if a11b01>=96
	replace years = y if a11b02>=96
	drop y m
replace years = -999 if years == . & a06z06==1

gen hyears=.
	gen y = a26b01 if a26b01<96
	gen m = (a26b02/12) if a26b02<96
	replace hyears = y+m
	replace hyears =. if a26b01>=96
	replace hyears = y if a26b02>=96
	drop y m
replace hyears = -999 if hyears == . & a21z05==1

gen health = a04a 
recode health (0 6/9=.)
replace health = (6-health)    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace cpay1_ ///
cpay2_ cpay3_ cpay4_ cpay5_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ wage income ///
hwage hincome whour hwhour indus occu hindus hoccu marital children child1sorder ///
child2sorder child3sorder child1ssex child1sage child1sedu child1swork child2ssex ///
child2sage child2sedu child2swork child3ssex child3sage child3sedu child3swork ///
child1sdistance child2sdistance child3sdistance bplan hchild boyp boyhp jsat fsat ///
rhappy lsat7 family djob1_ djob2_ djob3_ djob4_ djob5_ djob6_ djob7_ hdjob1_ hdjob2_ ///
hdjob3_ hdjob4_ hdjob5_ hdjob6_ hdjob7_ rjobvo rjobre hrjobvo hrjobre rjobless ///
hrjobless years hyears health

save R_2012, replace


*RR2014
use rr2014, clear
gen period=x02    //survey period
order period, after(x01)

gen sex = a01
gen age = (period-1911)-a02a
gen hage = (period-1911)-a26z01 if a26z01>0 & a26z01<96
replace hage = -999 if a16a==1 | a16a==2

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職")(6/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)
recode a27 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4/5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)
replace hedu = -999 if a16a==1 | a16a==2

gen work = a06
recode work (0=990)(96 98/99=.)
gen hwork = a30
recode hwork (0=990)(96 98/99=.)

recode a07b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode a31b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)

gen place = a07c02
recode place (0=990)(993/999=.)
gen  hplace = a31c02
recode hplace (0=990)(993/999=.)

recode a08c01 (0=990)(2=0)(6/9=.), gen(cpay1_)    //hourly or daily pay
lab var cpay1_ "hourly or daily pay"
recode a08c02 (0=990)(2=0)(6/9=.), gen(cpay2_)    //monthly pay
lab var cpay2_ "monthly pay"
recode a08c03 (0=990)(2=0)(6/9=.), gen(cpay3_)    //bonus and dividend
lab var cpay3_ "bonus and dividend"
recode a08c04 (0=990)(2=0)(6/9=.), gen(cpay4_)    //by the piece
lab var cpay4_ "by the piece"
recode a08c05 (0=990)(2=0)(6/9=.), gen(cpay5_)    //other pay
lab var cpay5_ "other pay"

recode a32c01 (0=990)(2=0)(6/9=.), gen(hcpay1_)    //hourly or daily pay
lab var hcpay1_ "(spouse) hourly or daily pay"
recode a32c02 (0=990)(2=0)(6/9=.), gen(hcpay2_)    //monthly pay
lab var hcpay2_ "(spouse) monthly pay"
recode a32c03 (0=990)(2=0)(6/9=.), gen(hcpay3_)    //bonus and dividend
lab var hcpay3_ "(spouse) bonus and dividend"
recode a32c04 (0=990)(2=0)(6/9=.), gen(hcpay4_)    //by the piece
lab var hcpay4_ "(spouse) by the piece"
recode a32c05 (0=990)(2=0)(6/9=.), gen(hcpay5_)    //other pay
lab var hcpay5_ "(spouse) other pay"

gen wage = a08a
recode wage (0 9999991/9999999=.)
gen income = a08b
recode income (0 96/99=.)

gen hwage = a32a
recode hwage (0 9999991/9999999=.)
gen hincome = a32b
recode hincome (0 96/99=.)

gen whour = a09b
recode whour (0 991/999=.)
gen hwhour = a33b
recode hwhour (0 991/999=.)

recode a07a01 0=990    //無工作/失業者編碼為990
recode a07a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (indus)

recode a07a02 (0 9996/9999=.), gen(job)
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu =int(isco88/1000)
recode occu (0 = 10)
lab def isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if a07a02==0
drop isco*

recode a31a01 0=990    //無工作/失業者編碼為990
recode a31a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (hindus)

recode a31a02 (0 9996/9999=.), gen(job)
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if a31a02==0
drop isco*

gen marital=.
replace marital=3 if a16a==1 | a16a==7
replace marital=2 if a16a==2 | a16a==11
replace marital=1 if a16a==3
replace marital=5 if a16a==4 | a16a==9
replace marital=4 if a16a==5 | a16a==8
replace marital=6 if a16a==6 | a16a==10
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b13 (96/99=.), gen(children)

recode b14ac1 (0 96/99=.), gen(child1sorder)
recode b14bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b14c01c1) if b14c01c1>0 & b14c01c1<996
recode b14dc1 (0=990 "990 Not available")(1/3=0 "0 無/自修")(4=1 "1 小學")(5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)
recode b14lc1 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child1swork)    //Yes=1; No=0

recode b14ac2 (0 96/99=.), gen(child2sorder)
recode b14bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b14c01c2) if b14c01c2>0 & b14c01c2<996
recode b14dc2 (0=990 "990 Not available")(1/3=0 "0 無/自修")(4=1 "1 小學")(5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)
recode b14lc2 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child2swork)    //Yes=1; No=0

recode b14ac3 (0 96/99=.), gen(child3sorder)
recode b14bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b14c01c3) if b14c01c3>0 & b14c01c3<996
recode b14dc3 (0=990 "990 Not available")(1/3=0 "0 無/自修")(4=1 "1 小學")(5=2 "2 國中/初職") ///
(6/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)
recode b14lc3 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(child3swork)    //Yes=1; No=0

gen child1sdistance = b14nc1 
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b14nc2
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b14nc3
recode child3sdistance (0=990)(96 98/99=.)

recode d03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode d04 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode d01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyp)
recode d02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyhp)

recode c07a (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode c07b (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b11b* (96/99=.)
egen family = rowtotal(b11b*)    //the number of people living together

recode a11a05 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "老闆/負責人/雇主改變"
recode a11a07 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "(2012年)上次訪問時沒有工作"
recode a11a02 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a11a03 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ ")職位改變"
recode a11a04 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a11a06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a11a07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"
recode a11a01 (0 6/9=.)(2=0), gen(djob8_)
label var djob8_ "公司/機構換了"

gen rjobvo = a11d
replace rjobvo = 990 if a11d==0
replace rjobvo = . if a11d>=98 | a11d==96
gen rjobre = a11e 
replace rjobre = 990 if a11e==0
replace rjobre = . if a11e>=98 | a11e==96

gen rjobless = a14a
replace rjobless=990 if a14a==0
replace rjobless=. if a14a>=98 | a14a==96
recode rjobless (6=14)(3=16)(4=17)(5=18)(97=97)
gen hrjobless = a34a
replace hrjobless=990 if a34a==0
replace hrjobless=. if a34a>=98 | a34a==96
recode hrjobless (6=14)(3=16)(4=17)(5=18)(97=97)

gen years = (period-1911)-a10a01 if a10a01>0 & a10a01<996    //工作年資未滿1年以0年計
replace years = -999 if years = . & a11a06==1
gen hyears= (period-1911)-a33c01 if a33c01>0 & a33c01<996

gen health = a04a
recode health (0 6/9=.)
replace health = 6-health    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace cpay1_ cpay2_ ///
cpay3_ cpay4_ cpay5_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ wage income hwage ///
hincome whour hwhour indus occu hindus hoccu marital children child1sorder child2sorder ///
child3sorder child1ssex child1sage child1sedu child1swork child2ssex child2sage child2sedu ///
child2swork child3ssex child3sage child3sedu child3swork child1sdistance child2sdistance ///
child3sdistance bplan hchild boyp boyhp jsat fsat rhappy lsat7 family djob1_ djob2_ djob3_ ///
djob4_ djob5_ djob6_ djob7_ djob8_ rjobvo rjobre rjobless hrjobless years hyears health

save R_2014, replace


*RR2016
use rr2016, clear
gen period=x02    //產生一個測量period年份
order period, after(x01)

gen sex = a01
gen age = (period-1911)-a02a
gen hage = (period-1911)-a27z01 if a27z01>0 & a27z01<96

recode a03c (1/2=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職")(5/8=3 "3 高中職") ///
(9/12=4 "4 專科或技術學院") (13=5 "5 大學或獨立學院") (14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(edu)
recode a28 (0=990 "Not available")(1/2=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職") ///
(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13=5 "5 大學或獨立學院")(14/15=6 "6 研究所(或)以上") ///
(97=97 "97 其它")(96 98/99=.), gen(hedu)

gen work = a07
recode work (0=990)(96 98/99=.)
gen hwork = a31
recode hwork (0=990)(96 98/99=.)

recode a08b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(emp)
recode a32b (0=990 "990 Not available")(1=1 "3 or less")(2=2 "4-9")(3=3 "10-29") ///
(4=4 "30-49")(5=5 "50-99")(6/7=6 "100-499")(8=7 "500 or more")(97=97 "other")(96 98/99=.), gen(hemp)

gen place = a08c02
recode place (0=990)(993/999=.)
gen  hplace = a32c02
recode hplace (0=990)(993/999=.)

recode a09c01 (0=990)(2=0)(6/9=.), gen(cpay1_)    //hourly or daily pay
lab var cpay1_ "hourly or daily pay"
recode a09c02 (0=990)(2=0)(6/9=.), gen(cpay2_)    //monthly pay
lab var cpay2_ "monthly pay"
recode a09c03 (0=990)(2=0)(6/9=.), gen(cpay3_)    //bonus and dividend
lab var cpay3_ "bonus and dividend"
recode a09c04 (0=990)(2=0)(6/9=.), gen(cpay4_)    //by the piece
lab var cpay4_ "by the piece"
recode a09c06 (0=990)(2=0)(6/9=.), gen(cpay5_)    //other pay
lab var cpay5_ "other pay"
recode a09c05 (0=990)(2=0)(6/9=.), gen(cpay6_)    //with year-end bonuses
lab var cpay6_ "with year-end bonuses"

recode a33c01 (0=990)(2=0)(6/9=.), gen(hcpay1_)    //hourly or daily pay
lab var hcpay1_ "(spouse) hourly or daily pay"
recode a33c02 (0=990)(2=0)(6/9=.), gen(hcpay2_)    //monthly pay
lab var hcpay2_ "(spouse) monthly pay"
recode a33c03 (0=990)(2=0)(6/9=.), gen(hcpay3_)    //bonus and dividend
lab var hcpay3_ "(spouse) bonus and dividend"
recode a33c04 (0=990)(2=0)(6/9=.), gen(hcpay4_)    //by the piece
lab var hcpay4_ "(spouse) by the piece"
recode a33c06 (0=990)(2=0)(6/9=.), gen(hcpay5_)    //other pay
lab var hcpay5_ "(spouse) other pay"
recode a33c05 (0=990)(2=0)(6/9=.), gen(hcpay6_)    //with year-end bonuses
lab var hcpay6_ "(spouse) with year-end bonuses"

gen wage = a09a01
recode wage (0 9999991/9999999=.)
gen income = a09a02
recode income (0 96/99=.)

gen hwage = a33a01
recode hwage (0 9999991/9999999=.)
gen hincome = a33a02
recode hincome (0 96/99=.)

gen whour = a10b01
recode whour (0 991/999=.)
gen hwhour = a34b01
recode hwhour (0 991/999=.)

recode a08a01 0=990    //無工作/失業者編碼為990
recode a08a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (indus)

recode a08a02 (0 9996/9999=.), gen(job)
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen occu =int(isco88/1000)
recode occu (0 = 10)
lab def isco9 1"民意代表、主管及經理人員" 2"專業人員 " 3"技術員及助理專業人員" ///
4"事務支援人員" 5" 服務及銷售工作人員" 6"農、林、漁、牧業生產人員" 7"技藝有關工作人員" ///
8"機械設備操作及組裝人員" 9"基層技術工及勞力工" 10"軍人" 990"Not available"
label value occu isco9
replace occu=990 if a08a02==0
drop isco*

recode a32a01 0=990    //無工作/失業者編碼為990
recode a32a01 (990 = 990 "990 不適用/跳答 ")(1/3 = 1 "農、林、漁、牧、狩獵與採礦業 ") ///
(5/7 = 1 " 農、林、漁、牧、狩獵與採礦業 ")(8/34 = 2 " 製造業 ")(35/36 = 3 " 水電燃氣業 ") ///
(41/43 = 4 " 營造業 ")(45/48 = 5 " 商業 ")(49/54 = 6 " 運輸、倉儲、及通信業 ") ///
(55/56 = 5 " 商業 ")(58/63 = 8 " 公共行政、社會服務及個人服務業 ") ///
(64/82 = 7 " 金融、保險、不動產、及工商服務業 ")(83/96 = 8 " 公共行政、社會服務及個人服務業 ") ///
(37/39 = 3)(996/999 =.), gen (hindus)

recode a32a02 (0 9996/9999=.), gen(job)
rename job ver6
merge m:1 ver6 using "2011_ISCO" ,keepus(isco*) 
drop if _merge==2
drop _merge ver6
gen hoccu =int(isco88/1000)
recode hoccu (0 = 10)
label value hoccu isco9
replace hoccu=990 if a32a02==0
drop isco*

recode a17a (6/9=.), gen(marital)
recode marital (2=3)(3=4)(4=5)(5=6)
replace marital=2 if (a17d==1 & a17a==1)
replace marital=2 if a17d==1 & (a17a==4 | a17a==5)
label define mar 1"未婚" 2"同居" 3"已婚" 4"分居" 5"離婚" 6"喪偶"
label value marital mar

recode b15 (96/99=.), gen(children)

recode b16ac1 (0 96/99=.), gen(child1sorder)
recode b16bc1 (0=990 "990 Not available")(6/9=.), gen(child1ssex)    //1=male; 2=female
gen child1sage = (period-1911-b16c01c1) if b16c01c1>0 & b16c01c1<996
recode b16gc1 (0=990 "990 Not available")(1/2 16=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職") ///
(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child1sedu)
recode b16lc1 (0=990 "Not available")(1/2=1 "Yes")(3=0 "No")(6/9=.), gen(child1swork)    //Yes=1; No=0

recode b16ac2 (0 96/99=.), gen(child2sorder)
recode b16bc2 (0=990 "990 Not available")(6/9=.), gen(child2ssex)    //1=male; 2=female
gen child2sage = (period-1911-b16c01c2) if b16c01c2>0 & b16c01c2<996
recode b16gc2 (0=990 "990 Not available")(1/2 16=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職") ///
(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child2sedu)
recode b16lc2 (0=990 "Not available")(1/2=1 "Yes")(3=0 "No")(6/9=.), gen(child2swork)    //Yes=1; No=0

recode b16ac3 (0 96/99=.), gen(child3sorder)
recode b16bc3 (0=990 "990 Not available")(6/9=.), gen(child3ssex)    //1=male; 2=female
gen child3sage = (period-1911-b16c01c3) if b16c01c3>0 & b16c01c3<996
recode b16gc3 (0=990 "990 Not available")(1/2 16=0 "0 無/自修")(3=1 "1 小學")(4=2 "2 國中/初職") ///
(5/8=3 "3 高中職")(9/12=4 "4 專科或技術學院")(13/15=5 "5 大學(或)以上") ///
(96 98/99=.), gen(child3sedu)
recode b16lc3 (0=990 "Not available")(1/2=1 "Yes")(3=0 "No")(6/9=.), gen(child3swork)    //Yes=1; No=0

gen child1sdistance = b16p01c1
recode child1sdistance (0=990)(96 98/99=.)

gen child2sdistance = b16p01c2
recode child2sdistance (0=990)(96 98/99=.)

gen child3sdistance = b16p01c3
recode child3sdistance (0=990)(96 98/99=.)

recode d03 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(3=2 "Not sure")(6/9=.), gen(bplan)
recode d04 (0=990 "Not available")(1=1 "Boy")(2=2 "Girl")(3=3 "Both")(6/9=.), gen(hchild)
recode d01 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyp)
recode d02 (0=990 "Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(boyhp)

recode a06b (0 6/9=.), gen(jsat)
replace jsat = (5-jsat)    //inversed coding
recode b12 (0 6/9=.), gen(fsat)
replace fsat = (5-fsat)    //inversed coding
recode a03a (0 96/99=.), gen(rhappy)
recode a03b (0 96/99=.), gen(lsat7)

recode b11b* (96/99=.)
egen family = rowtotal(b11b*)    //the number of people living together

recode a11b05 (0 6/9=.)(2=0), gen(djob1_)
label var djob1_ "老闆/負責人/雇主改變"
recode a11b07 (0 6/9=.)(2=0), gen(djob2_)
label var djob2_ "(2012年)上次訪問時沒有工作"
recode a11b02 (0 6/9=.)(2=0), gen(djob3_)
label var djob3_ "工作內容改變"
recode a11b03 (0 6/9=.)(2=0), gen(djob4_)
label var djob4_ ")職位改變"
recode a11b04 (0 6/9=.)(2=0), gen(djob5_)
label var djob5_ "工作地點改變"
recode a11b06 (0 6/9=.)(2=0), gen(djob6_)
label var djob6_ "沒有改變"
recode a11b07 (0 6/9=.)(2=0), gen(djob7_)
label var djob7_ "其他"
recode a11b01 (0 6/9=.)(2=0), gen(djob8_)
label var djob8_ "公司/機構換了"

gen rjobvo = a12g
replace rjobvo = 990 if a12g==0
replace rjobvo = . if a12g>=98 | a12g==96
gen rjobre = a12h 
replace rjobre = 990 if a12h==0
replace rjobre = . if a12h>=98 | a12h==96

gen rjobless = a15a
replace rjobless=990 if a15a==0
replace rjobless=. if a15a>=98 | a15a==96
recode rjobless (6=14)(3=16)(4=17)(5=18)(97=97)
gen hrjobless = a35a
replace hrjobless=990 if a35a==0
replace hrjobless=. if a35a>=98 | a35a==96
recode hrjobless (6=14)(3=16)(4=17)(5=18)(97=97)

gen years = (period-1911)-a12a01 if a12a01>0 & a12a01<996    //工作年資未滿1年以0年計
replace years = -999 if years == . & a11b02==1 | a11b03==1 | a11b04==4 | a11b05==1 | a11b06==1 | a11b07==1
gen hyears= (period-1911)-a34c01 if a34c01>0 & a34c01<996

recode a18b (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(mquitm)
recode a21b (0=990 "990 Not available")(1=1 "Yes")(2=0 "No")(6/9=.), gen(hmquitm)

gen health = a04a
recode health (0 6/9=.)
replace health = 6-health    //inversed coding

keep period x01 x01b sex age hage edu hedu work hwork emp hemp place hplace cpay1_ cpay2_ ///
cpay3_ cpay4_ cpay5_ cpay6_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ hcpay6_ wage ///
income hwage hincome whour hwhour indus occu hindus hoccu marital children child1sorder ///
child2sorder child3sorder child1ssex child1sage child1sedu child1swork child2ssex child2sage ///
child2sedu child2swork child3ssex child3sage child3sedu child3swork child1sdistance ///
child2sdistance child3sdistance bplan hchild boyp boyhp jsat fsat rhappy lsat7 family ///
djob1_ djob2_ djob3_ djob4_ djob5_ djob6_ djob7_ djob8_ rjobvo rjobre rjobless hrjobless ///
years hyears mquitm hmquitm health

save R_2016, replace


**************************  Append data  **************************


clear
set more off
cd "D:\PSFD\Jmerge"

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

foreach A of numlist 2014 2016 {
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

foreach B of numlist 2014 2016 {
use B_panel_append, clear
	append using R_`B'
	save, replace
}

sort x01 period
by x01 : replace x01b = x01b[_n+1] if x01b==. & x01b[_n+1] !=.
by x01 : replace x01b = x01b[_n-1] if x01b==. & x01b[_n-1] !=.

save B_panel_append, replace

*C panel append
use C_2003, clear
save C_panel_append, replace

forvalue C= 2004/2012 {
use C_panel_append, clear
	append using R_`C'
	save, replace
}

foreach C of numlist 2014 2016 {
use C_panel_append, clear
	append using R_`C'
	save, replace
}

sort x01 period
by x01 : replace x01b = x01b[_n+1] if x01b==. & x01b[_n+1] !=.
by x01 : replace x01b = x01b[_n-1] if x01b==. & x01b[_n-1] !=.

save C_panel_append, replace


*D panel append
use D_2009, clear
save D_panel_append, replace

forvalue D= 2010/2012 {
use D_panel_append, clear
	append using R_`D'
	save, replace
}

foreach D of numlist 2014 2016 {
use D_panel_append, clear
	append using R_`D'
	save, replace
}

sort x01 period
by x01 : replace x01b = x01b[_n+1] if x01b==. & x01b[_n+1] !=.
by x01 : replace x01b = x01b[_n-1] if x01b==. & x01b[_n-1] !=.

save D_panel_append, replace

local i=1
foreach v in A B C D {
use `v'_panel_append, clear
	order x01b, after(period) 
	tostring x01, replace
	gen select = substr(x01,-1,1)
	destring select, replace
	
	keep if (x01b==`i' & select==0)     // keep the 4 waves main samples
	
	drop select
	
save `v'_panel_append, replace
local ++i
}


*Merge to one file

use D_panel_append, clear

append using C_panel_append
append using B_panel_append
append using A_panel_append

sort x01b x01 period
destring x01, replace

save TOTAL_ONE, replace

/*
tostring x01, replace
gen select = substr(x01,-1,1)
destring select, replace
drop if select>0     // keep the main samples
drop select

save TOTAL_ONE, replace
*/


************ English labels and Replacing "-999" by former information************

cd "D:\PSFD\Jmerge"
use TOTAL_ONE, clear


* Try to fill the nonresponse in (h)wage by using the group median of (h)income variable

recode income 0=. 1=0 2=5000 3=15000 4=25000 5=35000 6=45000 7=55000 8=65000 ///
			  9=75000 10=85000 11=95000 12=105000 13=115000 14=125000 15=135000 ///
			  16=145000 17=155000 18=165000 19=175000 20=185000 21=195000 ///
			  22=250000 23=300000, gen(income_n)

recode hincome 0=. 1=0 2=5000 3=15000 4=25000 5=35000 6=45000 7=55000 8=65000 ///
			   9=75000 10=85000 11=95000 12=105000 13=115000 14=125000 15=135000 ///
			   16=145000 17=155000 18=165000 19=175000 20=185000 21=195000 22=250000 ///
			   23=300000, gen(hincome_n)

replace wage = income_n if wage==.
replace hwage = hincome_n if hwage==.

drop income_n hincome_n

save TOTAL_ONE_long, replace


* variables label and items recoding

use TOTAL_ONE_long, clear
sort x01 period

label var x01 "Respondents ID"
label var period "Survey period"
label drop x01b
label var x01b "The age strata main samples"
label define samp 1"A. 1953-64 years born" 2"B. 1935-54 years born" 3"C. 1964-76 years born" 4"D. 1977-83 years born"
label value x01b samp

label define filial 5"Absolutely important" 1"Unimportant"
label define fvalue 5"Absolutely important" 1"Unimportant"

local i = 1
foreach v in a b c d e f g h i {
	rename e01`v' filial_`i'
		label drop e01`v'
		label value filial_`i' filial
	by x01: replace filial_`i' = filial_`i'[_n-1] if filial_`i'==. & filial_`i'[_n-1] !=.
		
	rename e02`v' fvalue_`i'
		label drop e02`v'
		label value fvalue_`i' fvalue
	by x01: replace fvalue_`i' = fvalue_`i'[_n-1] if fvalue_`i'==. & fvalue_`i'[_n-1] !=.
		
	local ++i
}
label var filial_1 "To havel gratitude to parents hardships in raising us"
label var filial_2 "No matter how parents treat us, we should still treat them well"
label var filial_3 "We should fulfill parents' dream rather than ours"
label var filial_4 "We should live with our parents after getting married"
label var filial_5 "We should take care of our parents so that they live a better live"
label var filial_6 "We should say something good of our parents to save their face"
label var filial_7 "We should have at least one son to carry on the family name"
label var filial_8 "We should do something good to honor the whole family"
label var filial_9 "Married daughters should go home from time to time to visit their parents"

label var fvalue_1 "To get married and to have a family"
label var fvalue_2 "To try one's best to maintain a marriage"
label var fvalue_3 "To discipline children"
label var fvalue_4 "Family members have a good relationship with one another"
label var fvalue_5 "Married couple should never get a divorce for the best interest of children"
label var fvalue_6 "The family helps us in our inner growth"
label var fvalue_7 "To make enough money for family expenditure"
label var fvalue_8 "Family members will come to help when you have difficulties"
label var fvalue_9 "Husband is obligated to earn money to support his family, while wife is obligat"

label define sex 1"Male" 2"Female"
label value sex sex
label var sex "Gender"
label var age "Age in sruvey period"
label var hage "Spouse's age in sruvey period"

label define place 2"Mainland China" 3"Hong Kong/Macau" 99"Other foreign country" 990"Not available"
label value place hplace place
label var place "Workplace (postcode are presented)"
label var hplace "Spouse's workplace (postcode are presented)"

label drop edu hedu
label define edu 990"Not available" 0"0 None/Self-taught" 1"1 Elementary" 2"2 Junior high" ///
3"3 Senior/Vocational high" 4"4 Junior college/Technical college" 5"5 University or college" ///
6"6 Graduate school and above" 97"97 Other"
label value edu hedu edu
label var edu "Education level"
label var hedu "Spouse's education level"

label define work 1"Self-employed without employees" 2"Self-employed with employees" ///
3"Employed by a private company" 4"Employed by a public enterprise" ///
5"Working for family business with regular payment" 6"Government employee(e.g. Public School or hospital)" ///
7"Employee of a non-profit organization (e.g. Private school)" 8"Working for family business without payment" ///
9"Partnership without employees" 97"Others" 990"Not available"
label value work hwork work
label variable work "For whom do you work?"
label variable hwork "For whom do your spouse work?"

label variable emp "How many employees are there in your company?"
label variable hemp "How many employees are there in your spouse's company?"

label variable indus "Industry"
label variable hindus "(Spouse) Industry"
label variable occu "Occupation"
label variable hoccu "(Spouse) occupation"

label drop indus hindus
label define indus 1"Agriculture, Forestry, Fishing, Animal Husbandry, and Mining and Quarrying" ///
2"Manufacturing" 3"Electricity, Gas and Water" 4"Construction" 5"Trade and Eating-Drinking places" ///
6"Transportation, Storage and Communication" 7"Finance, Insurance and Real Estate" ///
8"Public Administration, Business Services, Social, Personal, Related Community Services" ///
990"Not available"
label value indus hindus indus

label define isco88 1"Legislators, senior officials and managers" 2"Professionals" ///
3"Technicians and associate professinals" 4"Clerks" 5"Service workers and shop and market sales worker" ///
6"Skilled agricultural and fishery workers" 7"Craft and related trade workers" ///
8"Plant and machine operators and assemblers" 9"Elementary occupations" 10"Armed forces" ///
990"Not available"
label value occu hoccu isco88

label var wage "The average monthly income of current job"
label var hwage "The average monthly income of your spouse's current job"
label var income "The average monthly income of current job (category)"
label var hincome "The average monthly income of your spouse's current job (category)"

label variable whour "working hours"
label variable hwhour "Spouse's workinh hours"

label drop child1sedu child2sedu child3sedu
label define childsedu 990"990 Not available" 0"0 No/Self-taught/Kindergarten" ///
1 "1 Elementary" 2"2 Junior High" 3"3 Senior/Vocational high" ///
4"4 Specialist/Technological college or university" 5"5 University and above" 97"97 Other"
label value child1sedu child2sedu child3sedu childsedu

label define distance 1"Next door or within the same building" ///
2"Not in the same building, but less than 10 minutes' walking" 3"Less than 30 minutes' driving" ///
4"30~60 minutes' driving" 5"1~2 hours' driving" 6"More than 2 hours' driving" ///
7"Foreign country" 8"Live together" 9"Student in dormitory" 10"Serve in the mandatory military" ///
97"Other" 990"Not available"
label value child1sdistance child2sdistance child3sdistance distance

label drop mar
label define marital 1"Single" 2"Cohabitation" 3"Married" 4"Separation" 5"Divorce" 6"Widow"
label value marital marital
label variable marital "Current marital status"

label variable children "How many children you have?"
label variable newborn "Did you have a newborn baby last year?"
label variable bplan "Do you and your spouse plan to have a child in the future?"
label variable hchild "Do you and your spouse prefer this child a boy or a girl?"
label variable pboy "Do you feel pressure from your (or your spouse's) parents for you to have a son?"
label variable boyp "Do you feel pressure from your parents for you to have a son?"
label variable boyhp "Do you feel pressure from your spouse's parents for you to have a son?"

label var pay1_ "Hourly or monthly pay"
label var pay2_ "Bonus and dividend"
label var pay3_ "Other pay"
label var pay4_ "Pay by the piece"

label var hpay1_ "Hourly or monthly pay"
label var hpay2_ "Bonus and dividend"
label var hpay3_ "Other pay"
label var hpay4_ "Pay by the piece"

label define childsex 1"Male" 2"Female" 990"Not availabel"
label value child1ssex child2ssex child3ssex childsex

label var djob1_ "Employer change"
label var djob2_ "Get a job in last year/Without a job as last time interview"
label var djob3_ "Working content change"
label var djob4_ "Job change"
label var djob5_ "Place change"
label var djob6_ "None"
label var djob7_ "Others"
label var djob8_ "Company/Organization change"

label var hdjob1_ "(Spouse) Employer change"
label var hdjob2_ "(Spouse) Get a job in last year/Without a job as last time interview"
label var hdjob3_ "(Spouse) Working content change"
label var hdjob4_ "(Spouse) Job change"
label var hdjob5_ "(Spouse) Place change"
label var hdjob6_ "(Spouse) None"
label var hdjob7_ "(Spouse) Others"
*label var hdjob8_ "(Spouse) Company/Organization change"

label define djob 0"No" 1"Yes"
label value djob1_ djob2_ djob3_ djob4_ djob5_ djob6_ djob7_ djob8_ hdjob1_ hdjob2_ ///
hdjob3_ hdjob4_ hdjob5_ hdjob6_ hdjob7_ djob

label var mquitm "Did you quit your job because you got married?"
label var hmquitm " Did your spouse quit his/her job because he/ she got married?"
label var cjob "Has your work changed since last year"
label var hcjob "Has your spouse's work changed since last year?"
label var rjobvo "What is the reason that you quick your job volunatarily?"
label var rjobre "What is the reason that you quick your job reluctantly?"
label var hrjobvo "What is the reason that your spouse quick (his/her) job volunatarily?"
label var hrjobre "What is the reason that your spouse quick (his/her) job reluctantly?"

label define rjobless 1"Temporarily no job due to sick, leave" 2"Have found a job but not started yet" ///
3"Look for a job or wait for prospective" 4"Still in school or prepare for college" ///
5"house keeping" 6"Poor health condition" 7"Retired" 8"Attend vocational training" ///
9"Dissatisfied with the work" 10"Company out of business/Being laid off" ///
11"Family economy condition is good and do not to find jobs" ///
12"Take care of young children and not be out for work" 13"Be ready to mandatory military service" ///
14"Unpaid family members" 15"Taking care off the elders, disabled, and Long-term patients" ///
16"Searching a job/Starting a business, or waiting the result" ///
17"Do not search any jobs, but would try to find a job/starting a business" ///
18"Do not search any jobs, and would not try to find any jobs" 97"other" 990"Not available"
label value rjobless hrjobless rjobless

label var rjobless "The reason that you do not have a job"
label var hrjobless "The reason that your spouse does not have a job"

label define cjob 990"990 Not available" 1"No, same to the last year" 2"Yes, I had changed a new job" ///
3"Yes, I was jobless last year, but got a job this year" 4"Yes, I got a job in the last year, but jobless this year" ///
5"No, I still jobless, but had some parttimejob last year" 6"No, I still jobless"
label value cjob cjob

label define hcjob 990"990 Not available" 1"No, same to the last year" 2"Yes, he/she had changed a new job" ///
3"Yes, he/she was jobless last year, but got a job this year" 4"Yes, he/she got a job in the last year, but jobless this year" ///
5"No, he/she still jobless, but had some part-time job last year" 6"No, he/she still jobless"
label value hcjob hcjob

label define rjobvo 990"Not available" 1"Dissatisfied with the work" 2" Want to change workplace" ///
3"Retired voluntarily" 4"Poor health condition" 5"Marriage or give birth" 6"Starting a business of your own" 7"Refresher courses" ///
8"Contract has expired" 97"Others"

label define rjobre 990"Not available" 1"Layoff" 2"Shutdown of factory or company" ///
3"Forced Retirement" 4"Seasonal or temporary jobs" 5"Marriage or give birth" 6"Contract has expired" ///
97"Others"
label value rjobvo hrjobvo rjobvo
label value rjobre hrjobre rjobre

replace family = 95 if family >=95 & family !=.
label define family 95 "95 and more"
label value family family
label variable family "The number of people living together"

label define jsat 1"Very dissatisfied" 4"Very satisfied"
label value jsat jsat
label var jsat "Job Satisfaction (inversed)"

label define fsat 1"Very dissatisfied" 4"Very satisfied"
label value fsat fsat
label var fsat "Family life Satisfaction (inversed)"

label define happy 1"Very unhappy" 7"Very happy"
label value rhappy happy
label variable rhappy "The happiness"

label define lsat4 1"Very bad" 4"Very well"
label value lsat4 lsat4 
label variable lsat4 "The life well-being (2001-2006)"

label define lsat7 1"Very bad" 7"Very well"
label value lsat7 lsat7 
label variable lsat7 "The life well-being (2007-2016)"

label define cmarital 0"No" 1"Yes"
label value cmarital cmarital
label variable cmarital "Does the current marital status change or not since last year?"
label variable ccmarital "The change of current marital status"

label variable years "The seniority of job"
label variable hyears "The seniority of your spouse's job"

label var benefit1_ "Employer provides the Medical, accident or life insurance"
label var benefit2_ "Employer provides loans at low interest"
label var benefit3_ "Employer provides dormitory or Housing subsidy"
label var benefit4_ "Employer provides pension"
label var benefit5_ "Employer provides education Subsidies for children"
label var benefit6_ "Employer provides job training"

label var femalew1_ "Among employees of the same rank, female receive less pay"
label var femalew2_ "More difficult for female employees to get promoted"
label var femalew3_ "Female employees may be fired or transferred because of getting married or pregnancy"

label var burdenw1_ "Vulnerable to occupational Disease"
label var burdenw2_ "Dangerous or easy to get injured"
label var burdenw3_ "High working pressure"

label define health 1"Very bad" 5"Very well"
label value health health
label variable health "The current health condition (inversed)"

forvalue n = 1/3 {
	label variable child`n'sorder "The `n' child's birth order"
	label variable child`n'sage "The `n' child's age"
	label variable child`n'ssex "The `n' child's gender"
	label variable child`n'sedu "The `n' child's education level"
	label variable child`n'swork "Does the `n' child get a job?"
	label variable child`n'sdistance "The distance of The `n' child's residence"
}


order x01 period x01b sex age edu work indus occu years emp place djob1_ djob2_ djob3_ djob4_ djob5_ djob6_ djob7_ djob8_
order cjob rjobvo rjobre rjobless pay1_ pay2_ pay3_ pay4_ cpay1_ cpay2_ cpay3_ cpay4_ cpay5_ cpay6_ wage income whour, after(djob8_)
order benefit1_ - benefit6_ femalew1_ femalew2_ femalew3_ burdenw1_ burdenw2_ burdenw3_ marital, after(whour) 
order cmarital ccmarital mquitm hmquitm hage hedu hwork hindus hoccu hyears hemp hplace hrjobvo, after(marital)
order hcjob hrjobre hrjobless hpay1_ hpay2_ hpay3_ hpay4_ hcpay1_ hcpay2_ hcpay3_ hcpay4_ hcpay5_ hcpay6_, after(hrjobvo) 
order hwage hincome hwhour children child1sorder child2sorder child3sorder child1ssex child2ssex child3ssex child1sage child2sage child3sage, after(hcpay6_)
order child1sedu child2sedu child3sedu child1swork child2swork child3swork child1sdistance, after(child3sage)
order child2sdistance child3sdistance newborn bplan hchild pboy boyp boyhp filial_1 - filial_9, after(child1sdistance)
order fvalue_1 - fvalue_9 hdjob1_ - hdjob7_ family health jsat fsat rhappy lsat4 lsat7, after(filial_9)


* replace -999 by using former value

forvalue a = 1/18 { 

by x01: replace sex = sex[_n-`a'] if sex==-999 & sex[_n-`a'] !=. & sex[_n-`a'] !=-999

by x01: replace hage = hage[_n-`a']+`a' if hage==-999 & hage[_n-`a'] !=. & hage[_n-`a'] !=-999 & period<=2012
by x01: replace hage = hage[_n-`a']+(`a'*2) if hage==-999 & hage[_n-`a'] !=. & hage[_n-`a'] !=-999 & period[_n-`a']>=2012

by x01: replace edu = edu[_n-`a'] if edu==-999 & edu[_n-`a'] !=. & edu[_n-`a'] !=-999

by x01: replace work = work[_n-`a'] if work==-999 & work[_n-`a'] !=. & work[_n-`a'] !=-999

by x01: replace indus = indus[_n-`a'] if indus==-999 & indus[_n-`a'] !=. & indus[_n-`a'] !=-999 /*& occu[_n-`a'] !=-999*/

by x01: replace occu = occu[_n-`a'] if occu==-999 & occu[_n-`a'] !=. & occu[_n-`a'] !=-999

by x01: replace work = work[_n-`a'] if work==-999 & work[_n-`a'] !=. & work[_n-`a'] !=-999

by x01: replace emp = emp[_n-`a'] if emp==-999 & emp[_n-`a'] !=. & emp[_n-`a'] !=-999

by x01: replace place = place[_n-`a'] if place==-999 & place[_n-`a'] !=. & place[_n-`a'] !=-999

by x01: replace marital = marital[_n-`a'] if marital==-999 & marital[_n-`a'] !=. & marital[_n-`a'] !=-999

by x01: replace hedu = edu[_n-`a'] if hedu==-999 & hedu[_n-`a'] !=. & hedu[_n-`a'] !=-999

by x01: replace hwork = work[_n-`a'] if hwork==-999 & hwork[_n-`a'] !=. & hwork[_n-`a'] !=-999

by x01: replace hindus = indus[_n-`a'] if hindus==-999 & hindus[_n-`a'] !=. & hindus[_n-`a'] !=-999 /*& hoccu[_n-`a'] !=-999*/

by x01: replace hoccu = occu[_n-`a'] if hoccu==-999 & hoccu[_n-`a'] !=. & hoccu[_n-`a'] !=-999

by x01: replace hwork = work[_n-`a'] if hwork==-999 & hwork[_n-`a'] !=. & hwork[_n-`a'] !=-999

by x01: replace hemp = emp[_n-`a'] if hemp==-999 & hemp[_n-`a'] !=. & hemp[_n-`a'] !=-999

by x01: replace hplace = place[_n-`a'] if place==-999 & hplace[_n-`a'] !=. & hplace[_n-`a'] !=-999

}

save TOTAL_ONE_long, replace
