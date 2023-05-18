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

import sas using "$data/dataverse_files_IV/w4weight.sas7bdat",clear

use "$data/w1_inhome.dta",clear
merge 1:1 AID using "$data/w3_inhome.dta"
keep if _merge==3
drop _merge
merge 1:1 AID using "$data/w4_inhome.dta"
keep if _merge==3
drop _merge

rename *,lower
gen race_w3 = . 
replace race_w3 = 1 if h3od4a == 1 & h3od4b == 0 & h3od4c == 0 & h3od4d == 0 & h3od2 == 0 //non-hispanic whites
replace race_w3 = 2 if h3od4a == 0 & h3od4b == 1 & h3od4c == 0 & h3od4d == 0 & h3od2 == 0 //non-hispanic blacks
replace race_w3 = 3 if h3od2 == 1 																		 //hispanic
replace race_w3 = 4 if h3od4a == 0 & h3od4b == 0 & h3od4c == 0 & h3od4d == 1 & h3od2 == 0 //non-hispanic asians
replace race_w3 = 5 if h3od4a == 0 & h3od4b == 0 & h3od4c == 1 & h3od4d == 0 & h3od2 == 0 //non-hispanic native americans
replace race_w3 = 6 if h3od4a == 0 & h3od4b == 0 & h3od4c == 0 & h3od4d == 0 & h3od2 == 0 //non-hispanic other or two more races
replace race_w3 = 6 if race_w3 == .

gen race_w3_nh = . 
replace race_w3_nh = 1 if h3od4a == 1 & h3od4b == 0 & h3od4c == 0 & h3od4d == 0  // whites
replace race_w3_nh = 2 if h3od4a == 0 & h3od4b == 1 & h3od4c == 0 & h3od4d == 0  //non-hispanic blacks

replace race_w3_nh = 4 if h3od4a == 0 & h3od4b == 0 & h3od4c == 0 & h3od4d == 1  //non-hispanic asians
replace race_w3_nh = 5 if h3od4a == 0 & h3od4b == 0 & h3od4c == 1 & h3od4d == 0  //non-hispanic native americans
replace race_w3_nh = 6 if h3od4a == 0 & h3od4b == 0 & h3od4c == 0 & h3od4d == 0  //non-hispanic other or two more races
replace race_w3_nh = 6 if race_w3_nh == .

recode h3od4* h3od2 (6/9=.)
rename h3od4a race_w3_wh
rename h3od4b race_w3_bl
rename h3od2  race_w3_hs
rename h3od4d race_w3_as
rename h3od4c race_w3_na

foreach v in eur afr asa amr { 
	gen `v' = runiform()
	}
	gen total = eur + afr + asa +amr
	foreach v in eur afr asa amr { 
		replace `v' = `v' / total 
		}

/*----------------------------------------------------*/
   /* [>   Other demographic variables  <] */ 
/*----------------------------------------------------*/
destring aid,force replace
* Fake Family SES
gen sespc_al = runiform()

* Fake IPW
gen ipw = runiform()

* Fake School ID
gen scid = runiformint(1,100)

* Female dummy
gen age = iyear - h1gi1y
drop if age < 0
recode bio_sex 1=0 2=1 else=.,gen(female)

* Language use 
recode h1gi10 1=0 2=1 3=0,gen(spanish)
recode h1gi10 1=0 2=0 3=1,gen(otherlg)
recode h1gi10 1=0 2/3=1,gen(noneng)

* Generational status
gen gene = 0
replace gene = 2 if h1rm2 == 0 | h1rf2 == 0
replace gene = 1 if h3od13 == 0
tabulate gene,gen(gene)

lab var gene2 "1st generation"
lab var gene3 "2nd generation"
lab var female "Famle"
lab var noneng "Non-English language use"
lab var sespc_al "Family SES"

lab var asa "Asian ancestry"
lab var amr "American ancestry"
lab var eur "European ancestry"
lab var afr "African ancestry"

lab var race_w3_hs "Hispanic"
lab var race_w3_wh "White"
lab var race_w3_bl "Black"
lab var race_w3_na "Native American"
lab var race_w3_as "Asian"

keep aid female age gene* asa amr eur afr race_* spanish otherlg noneng sespc_al ipw scid

save "$data/ah_clean.dta",replace
}
