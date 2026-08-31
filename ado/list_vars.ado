* Title: 列出所有變項
* Author: Tamao
* Version: 1.0.0
* Date: 2026.08.31

program define list_vars, rclass
    version 13.0
    syntax varlist(min=1) [, sep(string)]

    if strtrim(`"`sep'"') == "" {
        local sepstr " "
    }
    else {
        local sepstr `"`sep' "'
    }

    local result ""
    foreach v of local varlist {
        if `"`result'"' == "" {
            local result `"`v'"'          // 第一個不加分隔符
        }
        else {
            local result `"`result'`sepstr'`v'"'
        }
    }

    display in yellow `"`result'"'

    return scalar k = `: word count `varlist''
	return local vars  `"`result'"'
    
end
