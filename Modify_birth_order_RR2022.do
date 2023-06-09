
cap program drop _all

* RR2022問卷的子女題組相關題項
global cvar g04z01c g04z02c g05c g06c g07c g08z01c g08z02c g09c g10z01c g10z02c g10z03c ///
g10z04c g10z05c g10z06c	g10z07c	g10z08c	g10z09c	g10z10c	g10z94c	k_g10c g11c	k_g11c ///
g12z01c g12z02c g13z01c	g13z02c	g13z03c	g14z01c	g14z02c	g15z01c	g15z02c	g16c k_g16c	///
g17c k_g17c	g18c g19z01c g19z02c g19z03c g19z04c g19z05c g19z06c g19z07c g19z08c ///
g19z09c g19z10c g19z11c g20z01c	g20z02c	g20z03c	g20z95c	g21c g22z01c g22z02c g22z03c ///
g23z01c g23z02c g23z03c g24c g25c g26c g27c	g28c g29c k_g29c g30z01c g30z02c g31c ///
g32c g33c g34c g35c

program define 改子女生出序
syntax [if] [in]
marksample touse, novarlist strok
	amend_birth `touse'
end

program define amend_birth
args touse
local r = 1
	while `r' < 6 {
		foreach a of numlist 1/5 {
	
		gen birth`a' = .
		replace birth`a' = g04z01c`a' if g04z01c`a' > 0 & g04z01c`a' < 991 & birth`a' == . & `touse'
		replace birth`a' = g08z01c`a' if g08z01c`a' > 0 & g08z01c`a' < 991 & birth`a' == . & `touse'
		replace birth`a' = (111 - g09c`a') if g09c`a' > 0 & g09c`a' < 96   & birth`a' == . & `touse'

		local b = (`a' + 1)
		gen birth`b' = .
		replace birth`b' = g04z01c`b' if g04z01c`b' > 0 & g04z01c`b' < 991 & birth`b' == . & `touse'
		replace birth`b' = g08z01c`b' if g08z01c`b' > 0 & g08z01c`b' < 991 & birth`b' == . & `touse'
		replace birth`b' = (111 - g09c`b') if g09c`b' > 0 & g09c`b' < 96   & birth`b' == . & `touse'
	
			foreach v of global cvar {
			gen temp1 = `v'`a'
			gen temp2 = `v'`b'
			replace `v'`a' = temp2 if birth`a' > birth`b' & !inrange(birth`a',991,999) & birth`b' != . & `touse'
			replace `v'`b' = temp1 if birth`a' > birth`b' & !inrange(birth`a',991,999) & birth`b' != . & `touse'
			drop temp1 temp2
			}
		drop birth`a' birth`b'
		}
		local ++r
	}
end

