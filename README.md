# STATA

### 這裡將儲存Stata處理資料的語法。

●更新日期：2020/10/23  
●更新內容：納入兩個PSFD資料集(dataset)的 dofile 語法檔─ "Jmerge_process_20191003.do" 與 "RET_merge_process.do"

●更新日期：2020/11/27  
●更新內容：上傳 PSFD 資料的職業 ISCO 編碼對照表(.dta)

●更新日期：2021/05/26  
●更新內容：上傳事後加權 raking method 的 dofile 語法檔

●更新日期：2023/04/25  
●更新內容：透過Stata stata programming，將 PSFD 資料檔中的特殊碼轉換為指定的「特殊缺漏值」。設定的轉換規則與編碼意義如下：

|PSFD資料特殊碼|特殊意義|指定特殊缺漏值|
|:--------|:-------|:------:|
|91、991、9991、9999991|不固定。對於該題項詢問的時間或收入等數額，受訪者的答案為「不固定」。|**.u**|
|91、991、9991、9999991|虧損或打平。對於該題項詢問的收入金額，受訪者的答案為「虧損或打平」。|**.b**|
|92、992、9992、9999992|對於金額原本設計有「無法估計」（999992）特殊碼。於2022年決議取消此編碼，併入「不知道」類別中。|**.d**|
|93、993、9993|保留碼，由各單期資料定義。|─|
|94、994、9994|保留碼，由各單期資料定義。|─|
|95、995、9995、9999995|數值超過欄位上限，但仍屬於合理值的情形。|**.o**|
|96、996、9996、9999996|受訪者回答「不知道」或「不清楚」，或無法估算實際數額等情形。|**.d**|
|98、998、9998、9999998|受訪者回答「拒答」，或受訪者拒絕回答等情形。|**.r**|
|99、999、9999、9999999|遺漏值。因訪員或訪問系統設定因素，造成應詢問但沒有紀錄的情形。|**.m**|
|0|「跳答」或「不適用」等情形。|**.j**|
|(資料檔目前尚無此特殊碼)|不合理值。受訪者答案前後矛盾，且無法應用現有資料修正的情形。|**.a**|
 
●更新日期：2023/05/30  
●更新內容：上傳CAI_special_code_convert.do，可將CAI系統的特殊碼轉換為Stata版本的「指定特殊缺漏值」

●更新日期：2023/06/09  
●更新內容：上傳Modify_birth_order_RR2022.do，利用Bubble sorting演算法來排序PSFD調查問卷中，RR2022資料檔的子女題組資訊

●更新日期：2023/07/21  
●更新內容：上傳Stata軟體中，在ado資料夾裡頭自定義的PSFD處理CAI系統資料時，常用的小工具

●更新日期：2023/08/04  
●更新內容：上傳PSFD資料編碼簿的產生器try_label_information_RR2022_3_1.do（仍開發改進中，但已有雛型），可透過抓取dta資料檔中的值標籤(value labels)輸出成MS Word格式的 Codebook

●**最後更新日期：2023/08/18**  
●更新內容：上傳PSFD資料編碼簿的產生器try_label_information_RR2022_3_2_1.do（可在資料檔預設路經中，新增documents資料夾，將codebook存放於其中）
