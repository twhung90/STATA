
cd "C:\Users\user\Dropbox\Exchange_files\LIAO"

set more off
cd "C:\Users\user\Dropbox\Exchange_files\LIAO"
use "網調合併樣本.dta", clear

*/////////////////////////////// data processing ///////////////////////////////*

* co-variates
recode vs6(1=1 "male")(2=0 "female"), gen(gender)    // 1=male; 0=female

lab define satis 1"非常不滿意" 2"不滿意" 3"還算滿意" 4"滿意" 5"非常滿意"

gen life_sat = .
foreach v of varlist va3 vb3 vc3 {
	replace life_sat = `v' if (`v' !=9 & `v' !=.)
}
replace life_sat = (6 - life_sat)
lab value life_sat satis
lab var life_sat "生活品質滿意度(1-5)"

gen health = .
foreach v of varlist va4 vb4 vc4 {
	replace health = `v' if (`v' !=9 & `v' !=.)
}
replace health = (6-health)
lab value health satis
lab var health "健康滿意度(1-5)"

gen finance_sat = .
foreach v of varlist va7 vb7 vc7 {
	replace finance_sat = `v' if (`v' !=9 & `v' !=.)
}
replace finance_sat = (6-finance_sat)
lab var finance_sat "財務狀況滿意度(1-5)"

recode v16 (96/99=.), gen(dinner)
recode v17 (96/99=.), gen(nightout)
recode v19 (1/4=1 "有戴眼鏡")(5/6=0 "沒有戴眼鏡"), gen(glasses)
lab var glasses "是否戴眼鏡(Yes=1; No=0)"

recode v20 (1=0 "None insurance")(2=1 "NHI only")(3=2 "NHI and private"), gen(insured)
lab var insured "社會保險"

lab define job 1"有全職工作" 2"兼職/不固定工作/受訓無薪假或其他" 3"沒有工作/退休"
lab value job job
lab var job "工作狀態"

recode vs1 (1 4 5 13 14=1)(2 3 6 7 8 9 10/12 15 16=2), gen(job2)
recode job2 (1=1)(*=0), gen(fulltime)

lab define edugp 1"小學及以下" 2"國初中" 3"高中職/士官學校" 4"五專/二專/軍警專修班/空專" ///
				 5"三專/軍警專科班/大學" 6"碩/博士"
lab value edugp edugp
lab var edugp "教育程度分組"

recode edugp (1/3=5 "Senior high or less")(4=2 "Associate")(5=3 "College")(6=4 "Graduate"), gen(nedugp)
recode edugp (4=1)(*=0), gen(associate)
recode edugp (5=1)(*=0), gen(college)
recode edugp (6=1)(*=0), gen(graduate)

lab define marriage3 1"未婚" 2"已婚/同居" 3"離婚/分居/喪偶"
lab value marriage3 marriage3
lab var marriage3 "三分類之婚姻狀況"

recode marriage3 (1=1)(*=0), gen(single)
recode marriage3 (2=1)(*=0), gen(married)

lab define incomegp 1"2萬元以下" 2"2-4萬元以下" 3"4-6萬元以下" 4"6-8萬元以下" 5"8萬元以上"
lab value incomegp incomegp
lab var incomegp "收入分組"

gen income = vs5
recode income (1=0)(2=5)(3=15)(4=25)(5=35)(6=45)(7=55)(8=65)(9=75)(10=85)(11=95) ///
			  (12=105)(13=115)(14=125)(15=135)(16=145)(17=155)(18=165)(19=175) ///
			  (20=185)(21=195)(22=25)(23=30)
lab var income "平均每月所有收入(取組中點)"

gen workhr = vs2
lab var workhr "平均每週「所有工作」的時數"

gen status = v21
lab var status "自覺社會分層"

alpha v13 v14 v15, i c s
gen sodmore = (v13 + v14 + v15)    // Cronbach's alpha is 0.58


* District
gen dist = . 
replace dist = 100 if vz1==1
replace dist = 103 if vz1==2
replace dist = 104 if vz1==3
replace dist = 105 if vz1==4
replace dist = 106 if vz1==5
replace dist = 108 if vz1==6
replace dist = 110 if vz1==7
replace dist = 111 if vz1==8
replace dist = 112 if vz1==9
replace dist = 114 if vz1==10
replace dist = 115 if vz1==11
replace dist = 116 if vz1==12

replace dist = 207 if vz2==1
replace dist = 208 if vz2==2
replace dist = 220 if vz2==3
replace dist = 221 if vz2==4
replace dist = 222 if vz2==5
replace dist = 223 if vz2==6
replace dist = 224 if vz2==7
replace dist = 226 if vz2==8
replace dist = 227 if vz2==9
replace dist = 228 if vz2==10
replace dist = 231 if vz2==11
replace dist = 232 if vz2==12
replace dist = 233 if vz2==13
replace dist = 234 if vz2==14
replace dist = 235 if vz2==15
replace dist = 236 if vz2==16
replace dist = 237 if vz2==17
replace dist = 238 if vz2==18
replace dist = 239 if vz2==19
replace dist = 241 if vz2==20
replace dist = 242 if vz2==21
replace dist = 243 if vz2==22
replace dist = 244 if vz2==23
replace dist = 247 if vz2==24
replace dist = 248 if vz2==25
replace dist = 249 if vz2==26
replace dist = 251 if vz2==27
replace dist = 252 if vz2==28
replace dist = 253 if vz2==29

replace dist = 200 if vz3==1
replace dist = 201 if vz3==2
replace dist = 202 if vz3==3
replace dist = 203 if vz3==4
replace dist = 204 if vz3==5
replace dist = 205 if vz3==6
replace dist = 206 if vz3==7

replace dist = 320 if vz4==1
replace dist = 324 if vz4==2
replace dist = 325 if vz4==3
replace dist = 326 if vz4==4
replace dist = 327 if vz4==5
replace dist = 328 if vz4==6
replace dist = 330 if vz4==7
replace dist = 333 if vz4==8
replace dist = 334 if vz4==9
replace dist = 335 if vz4==10
replace dist = 336 if vz4==11
replace dist = 337 if vz4==12
replace dist = 338 if vz4==13

replace dist = 302 if vz5==1
replace dist = 303 if vz5==2
replace dist = 304 if vz5==3
replace dist = 305 if vz5==4
replace dist = 306 if vz5==5
replace dist = 307 if vz5==6
replace dist = 308 if vz5==7
replace dist = 310 if vz5==8
replace dist = 311 if vz5==9
replace dist = 312 if vz5==10
replace dist = 313 if vz5==11
replace dist = 314 if vz5==12
replace dist = 315 if vz5==13

replace dist = 300 if (vz6>=1 & vz6<=3)

replace dist = 350 if vz7==1
replace dist = 351 if vz7==2
replace dist = 352 if vz7==3
replace dist = 353 if vz7==4
replace dist = 354 if vz7==5
replace dist = 356 if vz7==6
replace dist = 357 if vz7==7
replace dist = 358 if vz7==8
replace dist = 360 if vz7==9
replace dist = 361 if vz7==10
replace dist = 362 if vz7==11
replace dist = 363 if vz7==12
replace dist = 364 if vz7==13
replace dist = 365 if vz7==14
replace dist = 366 if vz7==15
replace dist = 367 if vz7==16
replace dist = 368 if vz7==17
replace dist = 369 if vz7==18

replace dist = 411 if vz8==1
replace dist = 412 if vz8==2
replace dist = 413 if vz8==3
replace dist = 414 if vz8==4
replace dist = 420 if vz8==5
replace dist = 421 if vz8==6
replace dist = 422 if vz8==7
replace dist = 423 if vz8==8
replace dist = 424 if vz8==9
replace dist = 426 if vz8==10
replace dist = 427 if vz8==11
replace dist = 428 if vz8==12
replace dist = 429 if vz8==13
replace dist = 432 if vz8==14
replace dist = 433 if vz8==15
replace dist = 434 if vz8==16
replace dist = 435 if vz8==17
replace dist = 436 if vz8==18
replace dist = 437 if vz8==19
replace dist = 438 if vz8==20
replace dist = 439 if vz8==21
replace dist = 400 if vz8==22
replace dist = 401 if vz8==23
replace dist = 402 if vz8==24
replace dist = 403 if vz8==25
replace dist = 404 if vz8==26
replace dist = 406 if vz8==27
replace dist = 407 if vz8==28
replace dist = 408 if vz8==29

replace dist = 500 if vz9==1
replace dist = 502 if vz9==2
replace dist = 503 if vz9==3
replace dist = 504 if vz9==4
replace dist = 505 if vz9==5
replace dist = 506 if vz9==6
replace dist = 507 if vz9==7
replace dist = 508 if vz9==8
replace dist = 509 if vz9==9
replace dist = 510 if vz9==10
replace dist = 511 if vz9==11
replace dist = 512 if vz9==12
replace dist = 513 if vz9==13
replace dist = 514 if vz9==14
replace dist = 515 if vz9==15
replace dist = 516 if vz9==16
replace dist = 520 if vz9==17
replace dist = 521 if vz9==18
replace dist = 522 if vz9==19
replace dist = 523 if vz9==20
replace dist = 524 if vz9==21
replace dist = 525 if vz9==22
replace dist = 526 if vz9==23
replace dist = 527 if vz9==24
replace dist = 528 if vz9==25
replace dist = 530 if vz9==26

replace dist = 540 if vz10==1
replace dist = 545 if vz10==2
replace dist = 542 if vz10==3
replace dist = 557 if vz10==4
replace dist = 552 if vz10==5
replace dist = 551 if vz10==6
replace dist = 558 if vz10==7
replace dist = 541 if vz10==8
replace dist = 555 if vz10==9
replace dist = 544 if vz10==10
replace dist = 553 if vz10==11
replace dist = 556 if vz10==12
replace dist = 546 if vz10==13

replace dist = 640 if vz11==1
replace dist = 630 if vz11==2
replace dist = 632 if vz11==3
replace dist = 648 if vz11==4
replace dist = 633 if vz11==5
replace dist = 651 if vz11==6
replace dist = 646 if vz11==7
replace dist = 631 if vz11==8
replace dist = 647 if vz11==9
replace dist = 643 if vz11==10
replace dist = 649 if vz11==11
replace dist = 637 if vz11==12
replace dist = 638 if vz11==13
replace dist = 635 if vz11==14
replace dist = 634 if vz11==15
replace dist = 636 if vz11==16
replace dist = 655 if vz11==17
replace dist = 654 if vz11==18
replace dist = 653 if vz11==19
replace dist = 652 if vz11==20

replace dist = 602 if vz12==1
replace dist = 603 if vz12==2
replace dist = 604 if vz12==3
replace dist = 605 if vz12==4
replace dist = 606 if vz12==5
replace dist = 607 if vz12==6
replace dist = 608 if vz12==7
replace dist = 611 if vz12==8
replace dist = 612 if vz12==9
replace dist = 613 if vz12==10
replace dist = 614 if vz12==11
replace dist = 615 if vz12==12
replace dist = 616 if vz12==13
replace dist = 621 if vz12==14
replace dist = 622 if vz12==15
replace dist = 623 if vz12==16
replace dist = 624 if vz12==17
replace dist = 625 if vz12==18

replace dist = 600 if (vz13>=1 & vz13<=2)

replace dist = 712 if vz14==1
replace dist = 710 if vz14==2
replace dist = 711 if vz14==3
replace dist = 713 if vz14==4
replace dist = 714 if vz14==5
replace dist = 715 if vz14==6
replace dist = 716 if vz14==7
replace dist = 717 if vz14==8
replace dist = 718 if vz14==9
replace dist = 719 if vz14==10
replace dist = 720 if vz14==11
replace dist = 721 if vz14==12
replace dist = 722 if vz14==13
replace dist = 723 if vz14==14
replace dist = 724 if vz14==15
replace dist = 725 if vz14==16
replace dist = 726 if vz14==17
replace dist = 727 if vz14==18
replace dist = 730 if vz14==19
replace dist = 731 if vz14==20
replace dist = 732 if vz14==21
replace dist = 733 if vz14==22
replace dist = 734 if vz14==23
replace dist = 735 if vz14==24
replace dist = 736 if vz14==25
replace dist = 737 if vz14==26
replace dist = 741 if vz14==27
replace dist = 742 if vz14==28
replace dist = 743 if vz14==29
replace dist = 744 if vz14==30
replace dist = 745 if vz14==31
replace dist = 700 if vz14==32
replace dist = 701 if vz14==33
replace dist = 704 if vz14==34
replace dist = 702 if vz14==35
replace dist = 708 if vz14==36
replace dist = 709 if vz14==37

replace dist = 847 if vz15==1
replace dist = 814 if vz15==2
replace dist = 815 if vz15==3
replace dist = 820 if vz15==4
replace dist = 821 if vz15==5
replace dist = 822 if vz15==6
replace dist = 823 if vz15==7
replace dist = 824 if vz15==8
replace dist = 825 if vz15==9
replace dist = 826 if vz15==10
replace dist = 827 if vz15==11
replace dist = 828 if vz15==12
replace dist = 829 if vz15==13
replace dist = 830 if vz15==14
replace dist = 831 if vz15==15
replace dist = 832 if vz15==16
replace dist = 833 if vz15==17
replace dist = 840 if vz15==18
replace dist = 842 if vz15==19
replace dist = 843 if vz15==20
replace dist = 844 if vz15==21
replace dist = 845 if vz15==22
replace dist = 846 if vz15==23
replace dist = 848 if vz15==24
replace dist = 849 if vz15==25
replace dist = 851 if vz15==26
replace dist = 852 if vz15==27
replace dist = 800 if vz15==28
replace dist = 801 if vz15==29
replace dist = 802 if vz15==30
replace dist = 803 if vz15==31
replace dist = 804 if vz15==32
replace dist = 805 if vz15==33
replace dist = 806 if vz15==34
replace dist = 807 if vz15==35
replace dist = 811 if vz15==36
replace dist = 812 if vz15==37
replace dist = 813 if vz15==38

replace dist = 928 if vz16==1
replace dist = 900 if vz16==2
replace dist = 901 if vz16==3
replace dist = 902 if vz16==4
replace dist = 903 if vz16==5
replace dist = 904 if vz16==6
replace dist = 905 if vz16==7
replace dist = 906 if vz16==8
replace dist = 907 if vz16==9
replace dist = 908 if vz16==10
replace dist = 909 if vz16==11
replace dist = 911 if vz16==12
replace dist = 912 if vz16==13
replace dist = 913 if vz16==14
replace dist = 920 if vz16==15
replace dist = 921 if vz16==16
replace dist = 922 if vz16==17
replace dist = 923 if vz16==18
replace dist = 924 if vz16==19
replace dist = 925 if vz16==20
replace dist = 926 if vz16==21
replace dist = 927 if vz16==22
replace dist = 929 if vz16==23
replace dist = 931 if vz16==24
replace dist = 932 if vz16==25
replace dist = 940 if vz16==26
replace dist = 941 if vz16==27
replace dist = 942 if vz16==28
replace dist = 943 if vz16==29
replace dist = 944 if vz16==30
replace dist = 945 if vz16==31
replace dist = 946 if vz16==32
replace dist = 947 if vz16==33

replace dist = 267 if vz17==1
replace dist = 260 if vz17==2
replace dist = 261 if vz17==3
replace dist = 262 if vz17==4
replace dist = 263 if vz17==5
replace dist = 264 if vz17==6
replace dist = 265 if vz17==7
replace dist = 266 if vz17==8
replace dist = 268 if vz17==9
replace dist = 269 if vz17==10
replace dist = 270 if vz17==11
replace dist = 272 if vz17==12

replace dist = 970 if vz18==1
replace dist = 971 if vz18==2
replace dist = 972 if vz18==3
replace dist = 973 if vz18==4
replace dist = 974 if vz18==5
replace dist = 975 if vz18==6
replace dist = 976 if vz18==7
replace dist = 977 if vz18==8
replace dist = 978 if vz18==9
replace dist = 979 if vz18==10
replace dist = 981 if vz18==11
replace dist = 982 if vz18==12
replace dist = 983 if vz18==13

replace dist = 961 if vz19==1
replace dist = 950 if vz19==2
replace dist = 951 if vz19==3
replace dist = 952 if vz19==4
replace dist = 953 if vz19==5
replace dist = 954 if vz19==6
replace dist = 955 if vz19==7
replace dist = 956 if vz19==8
replace dist = 957 if vz19==9
replace dist = 958 if vz19==10
replace dist = 959 if vz19==11
replace dist = 962 if vz19==12
replace dist = 963 if vz19==13
replace dist = 964 if vz19==14
replace dist = 965 if vz19==15
replace dist = 966 if vz19==16

replace dist = 882 if vz20==1
replace dist = 880 if vz20==2
replace dist = 881 if vz20==3
replace dist = 883 if vz20==4
replace dist = 884 if vz20==5
replace dist = 885 if vz20==6

merge m:1 dist using city_layer_2014, keepus(layer_2014 layern_2014)
drop if _merge==2
drop _merge

* geographic areas

recode dist (100/116 200/206 207/208 220/253 260/272=1 "北北基宜") ///
			(300/315 320/338 350/369=2 "桃竹苗")(400/439 500/530 540/558=3 "中彰投") ///
			(600/625 630/655 700/745=4 "雲嘉南")(800/852 900/947 880/885=5 "高屏澎") ///
			(950/966 970/983=6 "花東"), gen(geo_index)
label variable geo_index "地理區分層"


* outcome variable
recode v18 (1/4=2 "Current smoker")(5=0 "Never smoke")(6=1 "Used to smoke"), gen(smoke)
lab var smoke "抽菸頻率"


* treatment
gen treat = (source==1)    // Select the first data source as the comparison group

order id_new, before(id)

save used_data, replace


*///////////////////////// raking weigthing (sample A) /////////////////////////*


** 加權前網調樣本原始資料檔案
use used_data,clear
sort id_new
keep if source==2    // only for A sample
save main_2014_A.dta, replace


*2014年年底的全國總人口數 (19-88)
gen total_pop = 18716991


*該年度的完訪的樣本總數
gen total_sample = (_N)

* 計算基本權值
gen weight_basic = 1    //由於沒有分層抽樣的不等機率，每個樣本的中選機率假設為 1


* 1.性別

*Step1_1. 由不等機率抽樣加權權值得出的男女人口數
sort gender
by gender : egen pop_sex_hat = sum(weight_basic)

*Step1_2. 實際資料得出的(19-88歲)男女人口數_2014
gen pop_sex_2014=.
replace pop_sex_2014 = 9249958 if gender==1    //男性
replace pop_sex_2014 = 9467033 if gender==0    //女性

gen sample_sex=.
replace sample_sex = 67 if gender==1
replace sample_sex = 224 if gender==0

*Step1_3. 計算出用 "男女人口數" 的邊際資訊所得的 ??比例??
gen weight_sex = pop_sex_2014/pop_sex_hat

*Step1_4. 將原始權值按 weight_sex 做調整
gen w_raking_sex = weight_sex


* 2.年齡
*Step2_1. 將原始權值按 weight_sex 做調整的權值得出 各年齡的人口數

gen birth_year = (1911 + v1)
replace birth_year = floor(year - age) if birth_year==.
gen age_index = (2014 - birth_year)

gen agep=.
replace agep = 1 if age_index>=19 & age_index<=28 & agep==.
replace agep = 2 if age_index>=29 & age_index<=38 & agep==.
replace agep = 3 if age_index>=39 & age_index<=48 & agep==.
replace agep = 4 if age_index>=49 & age_index<=58 & agep==.
replace agep = 5 if age_index>=59 & age_index<=68 & agep==.
replace agep = 6 if age_index>=69 & age_index<=78 & agep==.
replace agep = 7 if age_index>=79 & age_index<=88 & agep==.

bysort agep : egen pop_age_hat = sum(w_raking_sex)

*Step2_2. 實際資料得出的各年齡口數_2014
gen pop_age_2014=.
replace pop_age_2014 = 3168236 if agep==1
replace pop_age_2014 = 3905207 if agep==2
replace pop_age_2014 = 3606477 if agep==3
replace pop_age_2014 = 3601768 if agep==4
replace pop_age_2014 = 2505188 if agep==5
replace pop_age_2014 = 1262079 if agep==6
replace pop_age_2014 = 667036  if agep==7

*Step2_3. 計算出用 "男女人口數" 的邊際資訊所得的 ??比例??
gen weight_age = (pop_age_2014 / pop_age_hat)

*Step2_4. 將原始權值按 weight_sex * weight_age  做調整
gen w_raking_sex_age = (weight_sex*weight_age)


* 3.地區層別
*Step3_1. 將原始權值按 w_raking_sex_age_edu 做調整的權值得出 各地區層別的人口數
sort geo_index
by geo_index : egen pop_area_hat = sum(w_raking_sex_age)

*Step3_2. 實際資料得出的 各地區層別人口數
gen pop_area_2014=.
replace pop_area_2014 = 6076258 if geo_index==1
replace pop_area_2014 = 2798628 if geo_index==2
replace pop_area_2014 = 3587845 if geo_index==3
replace pop_area_2014 = 2754802 if geo_index==4
replace pop_area_2014 = 3047960 if geo_index==5
replace pop_area_2014 = 451498  if geo_index==6

*Step3_3. 計算出用 "各地區層別" 的邊際資訊所得的 ??比例??
gen weight_area = (pop_area_2014/pop_area_hat)

*Step3_4. 將原始權值按 weight_sex * weight_age * weight_area 做調整
gen w_raking_sex_age_area = (weight_basic*weight_sex*weight_age*weight_area)
gen iter_sex_age_area = w_raking_sex_age_area    //此變數僅為之後作「代迭」用途


global t = 20    // 預計raking的代迭次數

* raking weighting by loops (2-20)
forvalue a = 2/$t {

//gender
sort gender
by gender : egen pop_sex_hat_`a' = sum(iter_sex_age_area)
gen weight_sex_`a' = (pop_sex_2014/pop_sex_hat_`a')
gen w_raking_sex_`a' = (iter_sex_age_area * weight_sex_`a')

//age
sort agep
by agep : egen pop_age_hat_`a' = sum(w_raking_sex_`a')
gen weight_age_`a' = (pop_age_2014/pop_age_hat_`a')
gen w_raking_sex_age_`a' = (iter_sex_age_area * weight_sex_`a' * weight_age_`a')


//area
sort geo_index
by geo_index : egen pop_area_hat_`a' = sum(w_raking_sex_age_`a')
gen weight_area_`a' = (pop_area_2014/pop_area_hat_`a')
gen w_raking_sex_age_area_`a' = (iter_sex_age_area * weight_sex_`a' * weight_age_`a' * weight_area_`a')


display "the `a' times transfer the raking weight"
replace iter_sex_age_area = w_raking_sex_age_area_`a'    //此變數僅為之後作「代迭」用途

                           
}

*檢查原來的權值，以及目前的權值
sort id_new
gen w_raking     = weight_basic * (total_pop/total_sample)     //(原本為 weight)
gen weight_adj_0 = weight_basic * (total_sample/total_pop)
gen weight_adj_1 = w_raking_sex_age_area * (total_sample/total_pop)

forvalue a = 2/$t {

gen weight_adj_`a' = w_raking_sex_age_area_`a' * (total_sample/total_pop)

}

gen n=1
sort geo_index id_new
by geo_index: gen order_index = sum(n)
browse id_new geo_index gender agep weight_basic if (order_index==1)
browse id_new weight_basic weight_adj_0 weight_adj_1 weight_adj_*     //(原本為 weight)
browse id_new w_raking weight_basic w_raking_sex_age_area w_raking_sex_age_area_*


** 檢測加櫂後的 "樣本人口結構" 與 "母體人口結構" 的差異
scalar s_sample = (_N)
scalar s_pop = 18716991

*Step1_1. 檢測 gender
sort gender
by gender : egen pop_sex_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_sex_raking = pop_sex_raking*(total_sample/total_pop)

*Step2_1. 檢測 age
sort agep
by agep : egen pop_age_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_age_raking = pop_age_raking*(total_sample/total_pop)

*Step3_1. 檢測 geo_index
sort geo_index
by geo_index : egen pop_geo_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_geo_raking = pop_geo_raking*(total_sample/total_pop)


*Step1_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_sex_raking if gender==1
scalar s_sample_s1_raking=round(r(mean))

sum sample_pop_sex_raking if gender==0
scalar s_sample_s2_raking=round(r(mean))

*Step1_3. 由母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_s1 = 9249958    // male
scalar s_pop_s2 = 9467033    // female

scalar s_percent_exp_s1 = (s_pop_s1 / s_pop)    // male
scalar s_percent_exp_s2 = (s_pop_s2 / s_pop)    // female

scalar s_exp_sample_s1 = (s_percent_exp_s1 * s_sample)
scalar s_exp_sample_s2 = (s_percent_exp_s2 * s_sample)

*Step1_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
scalar sex_chi_sq=((s_sample_s1_raking-s_exp_sample_s1)^2/s_exp_sample_s1)+((s_sample_s2_raking-s_exp_sample_s2)^2/s_exp_sample_s2)
scalar list sex_chi_sq
scalar sex_p_value = chi2tail(1, sex_chi_sq)
scalar list sex_p_value


*Step2_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_age_raking if agep==1
scalar s_sample_a1_raking=round(r(mean))

sum sample_pop_age_raking if agep==2
scalar s_sample_a2_raking=round(r(mean))

sum sample_pop_age_raking if agep==3
scalar s_sample_a3_raking=round(r(mean))

sum sample_pop_age_raking if agep==4
scalar s_sample_a4_raking=round(r(mean))

sum sample_pop_age_raking if agep==5
scalar s_sample_a5_raking=round(r(mean))

sum sample_pop_age_raking if agep==6
scalar s_sample_a6_raking=round(r(mean))

sum sample_pop_age_raking if agep==7
scalar s_sample_a7_raking=round(r(mean))

*Step2_3. 由(2014年底)母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_a1 = 3168236
scalar s_pop_a2 = 3905207
scalar s_pop_a3 = 3606477
scalar s_pop_a4 = 3601768
scalar s_pop_a5 = 2505188
scalar s_pop_a6 = 1262079
scalar s_pop_a7 = 667036

scalar s_percent_exp_a1 = (s_pop_a1 / s_pop)
scalar s_percent_exp_a2 = (s_pop_a2 / s_pop)
scalar s_percent_exp_a3 = (s_pop_a3 / s_pop)
scalar s_percent_exp_a4 = (s_pop_a4 / s_pop)
scalar s_percent_exp_a5 = (s_pop_a5 / s_pop)
scalar s_percent_exp_a6 = (s_pop_a6 / s_pop)
scalar s_percent_exp_a7 = (s_pop_a7 / s_pop)

scalar s_exp_sample_a1 = (s_percent_exp_a1 * s_sample)
scalar s_exp_sample_a2 = (s_percent_exp_a2 * s_sample)
scalar s_exp_sample_a3 = (s_percent_exp_a3 * s_sample)
scalar s_exp_sample_a4 = (s_percent_exp_a4 * s_sample)
scalar s_exp_sample_a5 = (s_percent_exp_a5 * s_sample)
scalar s_exp_sample_a6 = (s_percent_exp_a6 * s_sample)
scalar s_exp_sample_a7 = (s_percent_exp_a7 * s_sample)

*Step2_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
#delimit;
scalar age_chi_sq=((s_sample_a1_raking-s_exp_sample_a1)^2/s_exp_sample_a1)+((s_sample_a2_raking-s_exp_sample_a2)^2/s_exp_sample_a2)
                 +((s_sample_a3_raking-s_exp_sample_a3)^2/s_exp_sample_a3)+((s_sample_a4_raking-s_exp_sample_a4)^2/s_exp_sample_a4) 
				 +((s_sample_a5_raking-s_exp_sample_a5)^2/s_exp_sample_a5)+((s_sample_a6_raking-s_exp_sample_a6)^2/s_exp_sample_a6)
				 +((s_sample_a7_raking-s_exp_sample_a7)^2/s_exp_sample_a7)
;
#delimit cr
scalar list age_chi_sq
scalar age_p_value = chi2tail(6, age_chi_sq)
scalar list age_p_value


*Step3_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_geo_raking if geo_index==1
scalar s_sample_geo1_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==2
scalar s_sample_geo2_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==3
scalar s_sample_geo3_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==4
scalar s_sample_geo4_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==5
scalar s_sample_geo5_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==6
scalar s_sample_geo6_raking = round(r(mean))

*Step3_3. 由母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_geo1 = 6076258
scalar s_pop_geo2 = 2798628
scalar s_pop_geo3 = 3587845
scalar s_pop_geo4 = 2754802
scalar s_pop_geo5 = 3047960
scalar s_pop_geo6 = 451498

scalar s_percent_exp_geo1 = (s_pop_geo1 / s_pop)
scalar s_percent_exp_geo2 = (s_pop_geo2 / s_pop)
scalar s_percent_exp_geo3 = (s_pop_geo3 / s_pop)
scalar s_percent_exp_geo4 = (s_pop_geo4 / s_pop)
scalar s_percent_exp_geo5 = (s_pop_geo5 / s_pop)
scalar s_percent_exp_geo6 = (s_pop_geo6 / s_pop)

scalar s_exp_sample_geo1 = (s_percent_exp_geo1 * s_sample)
scalar s_exp_sample_geo2 = (s_percent_exp_geo2 * s_sample)
scalar s_exp_sample_geo3 = (s_percent_exp_geo3 * s_sample)
scalar s_exp_sample_geo4 = (s_percent_exp_geo4 * s_sample)
scalar s_exp_sample_geo5 = (s_percent_exp_geo5 * s_sample)
scalar s_exp_sample_geo6 = (s_percent_exp_geo6 * s_sample)

*Step3_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
#delimit;
scalar geo_chi_sq=((s_sample_geo1_raking-s_exp_sample_geo1)^2 / s_exp_sample_geo1)
                 +((s_sample_geo2_raking-s_exp_sample_geo2)^2 / s_exp_sample_geo2)
				 +((s_sample_geo3_raking-s_exp_sample_geo3)^2 / s_exp_sample_geo3) 
                 +((s_sample_geo4_raking-s_exp_sample_geo4)^2 / s_exp_sample_geo4)
				 +((s_sample_geo5_raking-s_exp_sample_geo5)^2 / s_exp_sample_geo5) 
               /*+((s_sample_geo6_raking-s_exp_sample_geo6)^2 / s_exp_sample_geo6)*/
;
#delimit cr
scalar list geo_chi_sq
scalar geo_p_value = chi2tail(5, geo_chi_sq)
scalar list geo_p_value


scalar list sex_chi_sq
scalar list sex_p_value
scalar list age_chi_sq
scalar list age_p_value
scalar list geo_chi_sq
scalar list geo_p_value


***** 檢驗樣本百分比(加權前) *****
tab1 gender age geo_index

***** 檢驗樣本百分比(加權後) *****
ta gender [aw=weight_adj_3]
ta age [aw=weight_adj_3]
ta geo_index [aw=weight_adj_3]



keep id_new weight_adj_20

label variable weight_adj_20 "第20次反覆加權權值"

save weight_new_2014_A.dta, replace


*///////////////////////// raking weigthing (sample B) /////////////////////////*


** 加權前網調樣本原始資料檔案
use used_data,clear
sort id_new
keep if source==1    // only for B sample
save main_2014_B.dta, replace


*2014年年底的全國總人口數 (19-88)
gen total_pop = 18716991


*該年度的完訪的樣本總數
gen total_sample = (_N)

* 計算基本權值
gen weight_basic = 1    //由於沒有分層抽樣的不等機率，每個樣本的中選機率假設為 1


* 1.性別

*Step1_1. 由不等機率抽樣加權權值得出的男女人口數
sort gender
by gender : egen pop_sex_hat = sum(weight_basic)

*Step1_2. 實際資料得出的(19-88歲)男女人口數_2014
gen pop_sex_2014=.
replace pop_sex_2014 = 9249958 if gender==1    //男性
replace pop_sex_2014 = 9467033 if gender==0    //女性

gen sample_sex=.
replace sample_sex = 172 if gender==1
replace sample_sex = 155 if gender==0

*Step1_3. 計算出用 "男女人口數" 的邊際資訊所得的 ??比例??
gen weight_sex = pop_sex_2014/pop_sex_hat

*Step1_4. 將原始權值按 weight_sex 做調整
gen w_raking_sex = weight_sex


* 2.年齡
*Step2_1. 將原始權值按 weight_sex 做調整的權值得出 各年齡的人口數

gen birth_year = (1911 + v1)
replace birth_year = floor(year - age) if birth_year==.
gen age_index = (2014 - birth_year)

gen agep=.
replace agep = 1 if age_index>=19 & age_index<=28 & agep==.
replace agep = 2 if age_index>=29 & age_index<=38 & agep==.
replace agep = 3 if age_index>=39 & age_index<=48 & agep==.
replace agep = 4 if age_index>=49 & age_index<=58 & agep==.
replace agep = 5 if age_index>=59 & age_index<=68 & agep==.
replace agep = 6 if age_index>=69 & age_index<=78 & agep==.
replace agep = 7 if age_index>=79 & age_index<=88 & agep==.

bysort agep : egen pop_age_hat = sum(w_raking_sex)

*Step2_2. 實際資料得出的各年齡口數_2014
gen pop_age_2014=.
replace pop_age_2014 = 3168236 if agep==1
replace pop_age_2014 = 3905207 if agep==2
replace pop_age_2014 = 3606477 if agep==3
replace pop_age_2014 = 3601768 if agep==4
replace pop_age_2014 = 2505188 if agep==5
replace pop_age_2014 = 1262079 if agep==6
replace pop_age_2014 = 667036  if agep==7

*Step2_3. 計算出用 "男女人口數" 的邊際資訊所得的 ??比例??
gen weight_age = (pop_age_2014 / pop_age_hat)

*Step2_4. 將原始權值按 weight_sex * weight_age  做調整
gen w_raking_sex_age = (weight_sex*weight_age)


* 3.地區層別
*Step3_1. 將原始權值按 w_raking_sex_age_edu 做調整的權值得出 各地區層別的人口數
sort geo_index
by geo_index : egen pop_area_hat = sum(w_raking_sex_age)

*Step3_2. 實際資料得出的 各地區層別人口數
gen pop_area_2014=.
replace pop_area_2014 = 6076258 if geo_index==1
replace pop_area_2014 = 2798628 if geo_index==2
replace pop_area_2014 = 3587845 if geo_index==3
replace pop_area_2014 = 2754802 if geo_index==4
replace pop_area_2014 = 3047960 if geo_index==5
replace pop_area_2014 = 451498  if geo_index==6

*Step3_3. 計算出用 "各地區層別" 的邊際資訊所得的 ??比例??
gen weight_area = (pop_area_2014/pop_area_hat)

*Step3_4. 將原始權值按 weight_sex * weight_age * weight_area 做調整
gen w_raking_sex_age_area = (weight_basic*weight_sex*weight_age*weight_area)
gen iter_sex_age_area = w_raking_sex_age_area    //此變數僅為之後作「代迭」用途


global t = 20    // 預計raking的代迭次數

* raking weighting by loops (2-20)
forvalue a = 2/$t {

//gender
sort gender
by gender : egen pop_sex_hat_`a' = sum(iter_sex_age_area)
gen weight_sex_`a' = (pop_sex_2014/pop_sex_hat_`a')
gen w_raking_sex_`a' = (iter_sex_age_area * weight_sex_`a')

//age
sort agep
by agep : egen pop_age_hat_`a' = sum(w_raking_sex_`a')
gen weight_age_`a' = (pop_age_2014/pop_age_hat_`a')
gen w_raking_sex_age_`a' = (iter_sex_age_area * weight_sex_`a' * weight_age_`a')


//area
sort geo_index
by geo_index : egen pop_area_hat_`a' = sum(w_raking_sex_age_`a')
gen weight_area_`a' = (pop_area_2014/pop_area_hat_`a')
gen w_raking_sex_age_area_`a' = (iter_sex_age_area * weight_sex_`a' * weight_age_`a' * weight_area_`a')


display "the `a' times transfer the raking weight"
replace iter_sex_age_area = w_raking_sex_age_area_`a'    //此變數僅為之後作「代迭」用途

                           
}

*檢查原來的權值，以及目前的權值
sort id_new
gen w_raking     = weight_basic * (total_pop/total_sample)     //(原本為 weight)
gen weight_adj_0 = weight_basic * (total_sample/total_pop)
gen weight_adj_1 = w_raking_sex_age_area * (total_sample/total_pop)

forvalue a = 2/$t {

gen weight_adj_`a' = w_raking_sex_age_area_`a' * (total_sample/total_pop)

}

gen n=1
sort geo_index id_new
by geo_index: gen order_index = sum(n)
browse id_new geo_index gender agep weight_basic if (order_index==1)
browse id_new weight_basic weight_adj_0 weight_adj_1 weight_adj_*     //(原本為 weight)
browse id_new w_raking weight_basic w_raking_sex_age_area w_raking_sex_age_area_*


** 檢測加櫂後的 "樣本人口結構" 與 "母體人口結構" 的差異
scalar s_sample = (_N)
scalar s_pop = 18716991

*Step1_1. 檢測 gender
sort gender
by gender : egen pop_sex_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_sex_raking = pop_sex_raking*(total_sample/total_pop)

*Step2_1. 檢測 age
sort agep
by agep : egen pop_age_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_age_raking = pop_age_raking*(total_sample/total_pop)

*Step3_1. 檢測 geo_index
sort geo_index
by geo_index : egen pop_geo_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_geo_raking = pop_geo_raking*(total_sample/total_pop)


*Step1_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_sex_raking if gender==1
scalar s_sample_s1_raking=round(r(mean))

sum sample_pop_sex_raking if gender==0
scalar s_sample_s2_raking=round(r(mean))

*Step1_3. 由母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_s1 = 9249958    // male
scalar s_pop_s2 = 9467033    // female

scalar s_percent_exp_s1 = (s_pop_s1 / s_pop)    // male
scalar s_percent_exp_s2 = (s_pop_s2 / s_pop)    // female

scalar s_exp_sample_s1 = (s_percent_exp_s1 * s_sample)
scalar s_exp_sample_s2 = (s_percent_exp_s2 * s_sample)

*Step1_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
scalar sex_chi_sq=((s_sample_s1_raking-s_exp_sample_s1)^2/s_exp_sample_s1)+((s_sample_s2_raking-s_exp_sample_s2)^2/s_exp_sample_s2)
scalar list sex_chi_sq
scalar sex_p_value = chi2tail(1, sex_chi_sq)
scalar list sex_p_value


*Step2_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_age_raking if agep==1
scalar s_sample_a1_raking=round(r(mean))

sum sample_pop_age_raking if agep==2
scalar s_sample_a2_raking=round(r(mean))

sum sample_pop_age_raking if agep==3
scalar s_sample_a3_raking=round(r(mean))

sum sample_pop_age_raking if agep==4
scalar s_sample_a4_raking=round(r(mean))

sum sample_pop_age_raking if agep==5
scalar s_sample_a5_raking=round(r(mean))

sum sample_pop_age_raking if agep==6
scalar s_sample_a6_raking=round(r(mean))

sum sample_pop_age_raking if agep==7
scalar s_sample_a7_raking=round(r(mean))

*Step2_3. 由(2014年底)母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_a1 = 3168236
scalar s_pop_a2 = 3905207
scalar s_pop_a3 = 3606477
scalar s_pop_a4 = 3601768
scalar s_pop_a5 = 2505188
scalar s_pop_a6 = 1262079
scalar s_pop_a7 = 667036

scalar s_percent_exp_a1 = (s_pop_a1 / s_pop)
scalar s_percent_exp_a2 = (s_pop_a2 / s_pop)
scalar s_percent_exp_a3 = (s_pop_a3 / s_pop)
scalar s_percent_exp_a4 = (s_pop_a4 / s_pop)
scalar s_percent_exp_a5 = (s_pop_a5 / s_pop)
scalar s_percent_exp_a6 = (s_pop_a6 / s_pop)
scalar s_percent_exp_a7 = (s_pop_a7 / s_pop)

scalar s_exp_sample_a1 = (s_percent_exp_a1 * s_sample)
scalar s_exp_sample_a2 = (s_percent_exp_a2 * s_sample)
scalar s_exp_sample_a3 = (s_percent_exp_a3 * s_sample)
scalar s_exp_sample_a4 = (s_percent_exp_a4 * s_sample)
scalar s_exp_sample_a5 = (s_percent_exp_a5 * s_sample)
scalar s_exp_sample_a6 = (s_percent_exp_a6 * s_sample)
scalar s_exp_sample_a7 = (s_percent_exp_a7 * s_sample)

*Step2_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
#delimit;
scalar age_chi_sq=((s_sample_a1_raking-s_exp_sample_a1)^2/s_exp_sample_a1)+((s_sample_a2_raking-s_exp_sample_a2)^2/s_exp_sample_a2)
                 +((s_sample_a3_raking-s_exp_sample_a3)^2/s_exp_sample_a3)+((s_sample_a4_raking-s_exp_sample_a4)^2/s_exp_sample_a4) 
				 +((s_sample_a5_raking-s_exp_sample_a5)^2/s_exp_sample_a5)+((s_sample_a6_raking-s_exp_sample_a6)^2/s_exp_sample_a6)
			   /*+((s_sample_a7_raking-s_exp_sample_a7)^2/s_exp_sample_a7)*/
;
#delimit cr
scalar list age_chi_sq
scalar age_p_value = chi2tail(6, age_chi_sq)
scalar list age_p_value


*Step3_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_geo_raking if geo_index==1
scalar s_sample_geo1_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==2
scalar s_sample_geo2_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==3
scalar s_sample_geo3_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==4
scalar s_sample_geo4_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==5
scalar s_sample_geo5_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==6
scalar s_sample_geo6_raking = round(r(mean))

*Step3_3. 由母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_geo1 = 6076258
scalar s_pop_geo2 = 2798628
scalar s_pop_geo3 = 3587845
scalar s_pop_geo4 = 2754802
scalar s_pop_geo5 = 3047960
scalar s_pop_geo6 = 451498

scalar s_percent_exp_geo1 = (s_pop_geo1 / s_pop)
scalar s_percent_exp_geo2 = (s_pop_geo2 / s_pop)
scalar s_percent_exp_geo3 = (s_pop_geo3 / s_pop)
scalar s_percent_exp_geo4 = (s_pop_geo4 / s_pop)
scalar s_percent_exp_geo5 = (s_pop_geo5 / s_pop)
scalar s_percent_exp_geo6 = (s_pop_geo6 / s_pop)

scalar s_exp_sample_geo1 = (s_percent_exp_geo1 * s_sample)
scalar s_exp_sample_geo2 = (s_percent_exp_geo2 * s_sample)
scalar s_exp_sample_geo3 = (s_percent_exp_geo3 * s_sample)
scalar s_exp_sample_geo4 = (s_percent_exp_geo4 * s_sample)
scalar s_exp_sample_geo5 = (s_percent_exp_geo5 * s_sample)
scalar s_exp_sample_geo6 = (s_percent_exp_geo6 * s_sample)

*Step3_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
#delimit;
scalar geo_chi_sq=((s_sample_geo1_raking-s_exp_sample_geo1)^2 / s_exp_sample_geo1)
                 +((s_sample_geo2_raking-s_exp_sample_geo2)^2 / s_exp_sample_geo2)
				 +((s_sample_geo3_raking-s_exp_sample_geo3)^2 / s_exp_sample_geo3) 
                 +((s_sample_geo4_raking-s_exp_sample_geo4)^2 / s_exp_sample_geo4)
				 +((s_sample_geo5_raking-s_exp_sample_geo5)^2 / s_exp_sample_geo5) 
                 +((s_sample_geo6_raking-s_exp_sample_geo6)^2 / s_exp_sample_geo6)
;
#delimit cr
scalar list geo_chi_sq
scalar geo_p_value = chi2tail(5, geo_chi_sq)
scalar list geo_p_value


scalar list sex_chi_sq
scalar list sex_p_value
scalar list age_chi_sq
scalar list age_p_value
scalar list geo_chi_sq
scalar list geo_p_value


***** 檢驗樣本百分比(加權前) *****
tab1 gender age geo_index

***** 檢驗樣本百分比(加權後) *****
ta gender [aw=weight_adj_3]
ta age [aw=weight_adj_3]
ta geo_index [aw=weight_adj_3]



keep id_new weight_adj_20

label variable weight_adj_20 "第20次反覆加權權值"

save weight_new_2014_B.dta, replace


*///////////////////////// raking weigthing (sample C) /////////////////////////*


** 加權前網調樣本原始資料檔案
use used_data,clear
sort id_new
keep if source==3    // only for C sample
save main_2014_C.dta, replace


*2014年年底的全國總人口數 (19-88)
gen total_pop = 18716991


*該年度的完訪的樣本總數
gen total_sample = (_N)

* 計算基本權值
gen weight_basic = 1    //由於沒有分層抽樣的不等機率，每個樣本的中選機率假設為 1


* 1.性別

*Step1_1. 由不等機率抽樣加權權值得出的男女人口數
sort gender
by gender : egen pop_sex_hat = sum(weight_basic)

*Step1_2. 實際資料得出的(19-88歲)男女人口數_2014
gen pop_sex_2014=.
replace pop_sex_2014 = 9249958 if gender==1    //男性
replace pop_sex_2014 = 9467033 if gender==0    //女性

gen sample_sex=.
replace sample_sex = 239 if gender==1
replace sample_sex = 224 if gender==0

*Step1_3. 計算出用 "男女人口數" 的邊際資訊所得的 ??比例??
gen weight_sex = pop_sex_2014/pop_sex_hat

*Step1_4. 將原始權值按 weight_sex 做調整
gen w_raking_sex = weight_sex


* 2.年齡
*Step2_1. 將原始權值按 weight_sex 做調整的權值得出 各年齡的人口數

gen birth_year = (1911 + v1)
replace birth_year = floor(year - age) if birth_year==.
gen age_index = (2014 - birth_year)

gen agep=.
replace agep = 1 if age_index>=19 & age_index<=28 & agep==.
replace agep = 2 if age_index>=29 & age_index<=38 & agep==.
replace agep = 3 if age_index>=39 & age_index<=48 & agep==.
replace agep = 4 if age_index>=49 & age_index<=58 & agep==.
replace agep = 5 if age_index>=59 & age_index<=68 & agep==.
replace agep = 6 if age_index>=69 & age_index<=78 & agep==.
replace agep = 7 if age_index>=79 & age_index<=88 & agep==.

bysort agep : egen pop_age_hat = sum(w_raking_sex)

*Step2_2. 實際資料得出的各年齡口數_2014
gen pop_age_2014=.
replace pop_age_2014 = 3168236 if agep==1
replace pop_age_2014 = 3905207 if agep==2
replace pop_age_2014 = 3606477 if agep==3
replace pop_age_2014 = 3601768 if agep==4
replace pop_age_2014 = 2505188 if agep==5
replace pop_age_2014 = 1262079 if agep==6
replace pop_age_2014 = 667036  if agep==7

*Step2_3. 計算出用 "男女人口數" 的邊際資訊所得的 ??比例??
gen weight_age = (pop_age_2014 / pop_age_hat)

*Step2_4. 將原始權值按 weight_sex * weight_age  做調整
gen w_raking_sex_age = (weight_sex*weight_age)


* 3.地區層別
*Step3_1. 將原始權值按 w_raking_sex_age_edu 做調整的權值得出 各地區層別的人口數
sort geo_index
by geo_index : egen pop_area_hat = sum(w_raking_sex_age)

*Step3_2. 實際資料得出的 各地區層別人口數
gen pop_area_2014=.
replace pop_area_2014 = 6076258 if geo_index==1
replace pop_area_2014 = 2798628 if geo_index==2
replace pop_area_2014 = 3587845 if geo_index==3
replace pop_area_2014 = 2754802 if geo_index==4
replace pop_area_2014 = 3047960 if geo_index==5
replace pop_area_2014 = 451498  if geo_index==6

*Step3_3. 計算出用 "各地區層別" 的邊際資訊所得的 ??比例??
gen weight_area = (pop_area_2014/pop_area_hat)

*Step3_4. 將原始權值按 weight_sex * weight_age * weight_area 做調整
gen w_raking_sex_age_area = (weight_basic*weight_sex*weight_age*weight_area)
gen iter_sex_age_area = w_raking_sex_age_area    //此變數僅為之後作「代迭」用途


global t = 20    // 預計raking的代迭次數

* raking weighting by loops (2-20)
forvalue a = 2/$t {

//gender
sort gender
by gender : egen pop_sex_hat_`a' = sum(iter_sex_age_area)
gen weight_sex_`a' = (pop_sex_2014/pop_sex_hat_`a')
gen w_raking_sex_`a' = (iter_sex_age_area * weight_sex_`a')

//age
sort agep
by agep : egen pop_age_hat_`a' = sum(w_raking_sex_`a')
gen weight_age_`a' = (pop_age_2014/pop_age_hat_`a')
gen w_raking_sex_age_`a' = (iter_sex_age_area * weight_sex_`a' * weight_age_`a')


//area
sort geo_index
by geo_index : egen pop_area_hat_`a' = sum(w_raking_sex_age_`a')
gen weight_area_`a' = (pop_area_2014/pop_area_hat_`a')
gen w_raking_sex_age_area_`a' = (iter_sex_age_area * weight_sex_`a' * weight_age_`a' * weight_area_`a')


display "the `a' times transfer the raking weight"
replace iter_sex_age_area = w_raking_sex_age_area_`a'    //此變數僅為之後作「代迭」用途

                           
}

*檢查原來的權值，以及目前的權值
sort id_new
gen w_raking     = weight_basic * (total_pop/total_sample)     //(原本為 weight)
gen weight_adj_0 = weight_basic * (total_sample/total_pop)
gen weight_adj_1 = w_raking_sex_age_area * (total_sample/total_pop)

forvalue a = 2/$t {

gen weight_adj_`a' = w_raking_sex_age_area_`a' * (total_sample/total_pop)

}

gen n=1
sort geo_index id_new
by geo_index: gen order_index = sum(n)
browse id_new geo_index gender agep weight_basic if (order_index==1)
browse id_new weight_basic weight_adj_0 weight_adj_1 weight_adj_*     //(原本為 weight)
browse id_new w_raking weight_basic w_raking_sex_age_area w_raking_sex_age_area_*


** 檢測加櫂後的 "樣本人口結構" 與 "母體人口結構" 的差異
scalar s_sample = (_N)
scalar s_pop = 18716991

*Step1_1. 檢測 gender
sort gender
by gender : egen pop_sex_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_sex_raking = pop_sex_raking*(total_sample/total_pop)

*Step2_1. 檢測 age
sort agep
by agep : egen pop_age_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_age_raking = pop_age_raking*(total_sample/total_pop)

*Step3_1. 檢測 geo_index
sort geo_index
by geo_index : egen pop_geo_raking = sum(w_raking_sex_age_area_$t)
gen sample_pop_geo_raking = pop_geo_raking*(total_sample/total_pop)


*Step1_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_sex_raking if gender==1
scalar s_sample_s1_raking=round(r(mean))

sum sample_pop_sex_raking if gender==0
scalar s_sample_s2_raking=round(r(mean))

*Step1_3. 由母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_s1 = 9249958    // male
scalar s_pop_s2 = 9467033    // female

scalar s_percent_exp_s1 = (s_pop_s1 / s_pop)    // male
scalar s_percent_exp_s2 = (s_pop_s2 / s_pop)    // female

scalar s_exp_sample_s1 = (s_percent_exp_s1 * s_sample)
scalar s_exp_sample_s2 = (s_percent_exp_s2 * s_sample)

*Step1_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
scalar sex_chi_sq=((s_sample_s1_raking-s_exp_sample_s1)^2/s_exp_sample_s1)+((s_sample_s2_raking-s_exp_sample_s2)^2/s_exp_sample_s2)
scalar list sex_chi_sq
scalar sex_p_value = chi2tail(1, sex_chi_sq)
scalar list sex_p_value


*Step2_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_age_raking if agep==1
scalar s_sample_a1_raking=round(r(mean))

sum sample_pop_age_raking if agep==2
scalar s_sample_a2_raking=round(r(mean))

sum sample_pop_age_raking if agep==3
scalar s_sample_a3_raking=round(r(mean))

sum sample_pop_age_raking if agep==4
scalar s_sample_a4_raking=round(r(mean))

sum sample_pop_age_raking if agep==5
scalar s_sample_a5_raking=round(r(mean))

sum sample_pop_age_raking if agep==6
scalar s_sample_a6_raking=round(r(mean))

sum sample_pop_age_raking if agep==7
scalar s_sample_a7_raking=round(r(mean))

*Step2_3. 由(2014年底)母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_a1 = 3168236
scalar s_pop_a2 = 3905207
scalar s_pop_a3 = 3606477
scalar s_pop_a4 = 3601768
scalar s_pop_a5 = 2505188
scalar s_pop_a6 = 1262079
scalar s_pop_a7 = 667036

scalar s_percent_exp_a1 = (s_pop_a1 / s_pop)
scalar s_percent_exp_a2 = (s_pop_a2 / s_pop)
scalar s_percent_exp_a3 = (s_pop_a3 / s_pop)
scalar s_percent_exp_a4 = (s_pop_a4 / s_pop)
scalar s_percent_exp_a5 = (s_pop_a5 / s_pop)
scalar s_percent_exp_a6 = (s_pop_a6 / s_pop)
scalar s_percent_exp_a7 = (s_pop_a7 / s_pop)

scalar s_exp_sample_a1 = (s_percent_exp_a1 * s_sample)
scalar s_exp_sample_a2 = (s_percent_exp_a2 * s_sample)
scalar s_exp_sample_a3 = (s_percent_exp_a3 * s_sample)
scalar s_exp_sample_a4 = (s_percent_exp_a4 * s_sample)
scalar s_exp_sample_a5 = (s_percent_exp_a5 * s_sample)
scalar s_exp_sample_a6 = (s_percent_exp_a6 * s_sample)
scalar s_exp_sample_a7 = (s_percent_exp_a7 * s_sample)

*Step2_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
#delimit;
scalar age_chi_sq=((s_sample_a1_raking-s_exp_sample_a1)^2/s_exp_sample_a1)+((s_sample_a2_raking-s_exp_sample_a2)^2/s_exp_sample_a2)
                 +((s_sample_a3_raking-s_exp_sample_a3)^2/s_exp_sample_a3)+((s_sample_a4_raking-s_exp_sample_a4)^2/s_exp_sample_a4) 
				 +((s_sample_a5_raking-s_exp_sample_a5)^2/s_exp_sample_a5)+((s_sample_a6_raking-s_exp_sample_a6)^2/s_exp_sample_a6)
			   /*+((s_sample_a7_raking-s_exp_sample_a7)^2/s_exp_sample_a7)*/
;
#delimit cr
scalar list age_chi_sq
scalar age_p_value = chi2tail(6, age_chi_sq)
scalar list age_p_value


*Step3_2. 根據所計算出來的櫂值來計算 各分類 樣本總數的頻率
sum sample_pop_geo_raking if geo_index==1
scalar s_sample_geo1_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==2
scalar s_sample_geo2_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==3
scalar s_sample_geo3_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==4
scalar s_sample_geo4_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==5
scalar s_sample_geo5_raking = round(r(mean))

sum sample_pop_geo_raking if geo_index==6
scalar s_sample_geo6_raking = round(r(mean))

*Step3_3. 由母體的人口結構來計算 各分類 預期的樣本總數的頻率
scalar s_pop_geo1 = 6076258
scalar s_pop_geo2 = 2798628
scalar s_pop_geo3 = 3587845
scalar s_pop_geo4 = 2754802
scalar s_pop_geo5 = 3047960
scalar s_pop_geo6 = 451498

scalar s_percent_exp_geo1 = (s_pop_geo1 / s_pop)
scalar s_percent_exp_geo2 = (s_pop_geo2 / s_pop)
scalar s_percent_exp_geo3 = (s_pop_geo3 / s_pop)
scalar s_percent_exp_geo4 = (s_pop_geo4 / s_pop)
scalar s_percent_exp_geo5 = (s_pop_geo5 / s_pop)
scalar s_percent_exp_geo6 = (s_pop_geo6 / s_pop)

scalar s_exp_sample_geo1 = (s_percent_exp_geo1 * s_sample)
scalar s_exp_sample_geo2 = (s_percent_exp_geo2 * s_sample)
scalar s_exp_sample_geo3 = (s_percent_exp_geo3 * s_sample)
scalar s_exp_sample_geo4 = (s_percent_exp_geo4 * s_sample)
scalar s_exp_sample_geo5 = (s_percent_exp_geo5 * s_sample)
scalar s_exp_sample_geo6 = (s_percent_exp_geo6 * s_sample)

*Step3_4. 計算 "各分類 樣本總數的頻率" 與 "各分類 預期樣本總數的頻率"的卡方值
#delimit;
scalar geo_chi_sq=((s_sample_geo1_raking-s_exp_sample_geo1)^2 / s_exp_sample_geo1)
                 +((s_sample_geo2_raking-s_exp_sample_geo2)^2 / s_exp_sample_geo2)
				 +((s_sample_geo3_raking-s_exp_sample_geo3)^2 / s_exp_sample_geo3) 
                 +((s_sample_geo4_raking-s_exp_sample_geo4)^2 / s_exp_sample_geo4)
				 +((s_sample_geo5_raking-s_exp_sample_geo5)^2 / s_exp_sample_geo5) 
                 +((s_sample_geo6_raking-s_exp_sample_geo6)^2 / s_exp_sample_geo6)
;
#delimit cr
scalar list geo_chi_sq
scalar geo_p_value = chi2tail(5, geo_chi_sq)
scalar list geo_p_value


scalar list sex_chi_sq
scalar list sex_p_value
scalar list age_chi_sq
scalar list age_p_value
scalar list geo_chi_sq
scalar list geo_p_value


***** 檢驗樣本百分比(加權前) *****
tab1 gender age geo_index

***** 檢驗樣本百分比(加權後) *****
ta gender [aw=weight_adj_3]
ta age [aw=weight_adj_3]
ta geo_index [aw=weight_adj_3]



keep id_new weight_adj_20

label variable weight_adj_20 "第20次反覆加權權值"

save weight_new_2014_C.dta, replace

