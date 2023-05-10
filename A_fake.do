if "`c(username)'"=="uchikoshi" & "`c(machine_type)'" == "Macintosh (Intel 64-bit)" {
 global dir "/Users/uchikoshi/Dropbox (Princeton)/~~GeneticAncestry/~ancestry_identity"
***set files path globals
	global data "${dir}/Data"
	global syntax "`c(pwd)'"
	global table "${dir}/Results/Tables"
	global figure "${dir}/Results/Figures"
	

*import sas using "$data/dataverse_files_I/w1inhome.sas7bdat", clear
*save "$data/w1_inhome.dta", replace
*import sas using "$data/dataverse_files_III/w3inhome.sas7bdat", clear
*save "$data/w3_inhome.dta", replace
*import sas using "$data/dataverse_files_IV/w4inhome.sas7bdat", clear
*save "$data/w4_inhome.dta", replace

use "$data/w1_inhome.dta",clear
merge 1:1 AID using "$data/w3_inhome.dta"
keep if _merge==3
drop _merge
merge 1:1 AID using "$data/w4_inhome.dta"
keep if _merge==3
drop _merge

save "$data/ah_merge.dta",replace
}
