/*----------------------------------------------------*/
   /* [>   Main analysis files  <] */ 
/*----------------------------------------------------*/

use "$data/wave1all.dta",clear
destring aid, replace
destring scid,replace

merge 1:1 aid using "$data/wave3.dta" 
keep if _merge==3
drop _merge 

merge m:1 scid using "$data/~Admixture/w1inschool.dta" 
keep if _merge !=2 // omit cases only in using
drop _merge 

merge m:1 scid using "$data/~Admixture/w1schinfo.dta"
keep if _merge !=2 // omit cases only in using
drop _merge 

merge 1:1 aid using "$data/~Admixture/w3region.dta" 
keep if _merge !=2 // omit cases only in using
drop _merge 

merge 1:1 aid using "$data/wave4.dta"
keep if _merge==3
drop _merge 

merge 1:1 aid using "$data/~Admixture/w4homewc.dta"
keep if _merge==3
drop _merge 

merge 1:1 aid using "$data/edupostx.dta"
drop if _merge==2
drop _merge 

merge 1:1 aid using "$data/conses.dta"
drop if _merge==2
drop _merge 

merge 1:1 aid using "$data/~Admixture/ah_plink_subset_unsupervised.dta"
drop if _merge==2
*drop _merge 

save "$data/~Admixture/ah_merge.dta",replace
/*----------------------------------------------------*/
   /* [>   Race  <] */ 
/*----------------------------------------------------*/
use "$data/~Admixture/ah_merge.dta",clear
* non-hispanic black, non-hispanic white, hispanic, non-hispanic asian, non-hispanic native american, and two or more races
*keep aid h1gi6a h1gi6b h1gi6c h1gi6d h1gi6e h1gi4
gen race_w1 = . 
replace race_w1 = 1 if h1gi6a == 1 & h1gi6b == 0 & h1gi6c == 0 & h1gi6d == 0 & h1gi6e == 0 & h1gi4 == 0 //non-hispanic whites
replace race_w1 = 2 if h1gi6a == 0 & h1gi6b == 1 & h1gi6c == 0 & h1gi6d == 0 & h1gi6e == 0 & h1gi4 == 0 //non-hispanic blacks
replace race_w1 = 3 if h1gi4 == 1 																		 //hispanic
replace race_w1 = 4 if h1gi6a == 0 & h1gi6b == 0 & h1gi6c == 0 & h1gi6d == 1 & h1gi6e == 0 & h1gi4 == 0 //non-hispanic asians
replace race_w1 = 5 if h1gi6a == 0 & h1gi6b == 0 & h1gi6c == 1 & h1gi6d == 0 & h1gi6e == 0 & h1gi4 == 0 //non-hispanic native americans
replace race_w1 = 6 if h1gi6a == 0 & h1gi6b == 0 & h1gi6c == 0 & h1gi6d == 0 & h1gi6e == 1 & h1gi4 == 0 //non-hispanic other or two more races
replace race_w1 = 6 if race_w1 == .
tabulate race_w1,gen(race_w1)

gen race_w1_nh = . 
replace race_w1_nh = 1 if h1gi6a == 1 & h1gi6b == 0 & h1gi6c == 0 & h1gi6d == 0 & h1gi6e == 0  // whites
replace race_w1_nh = 2 if h1gi6a == 0 & h1gi6b == 1 & h1gi6c == 0 & h1gi6d == 0 & h1gi6e == 0  // blacks

replace race_w1_nh = 4 if h1gi6a == 0 & h1gi6b == 0 & h1gi6c == 0 & h1gi6d == 1 & h1gi6e == 0 // asians
replace race_w1_nh = 5 if h1gi6a == 0 & h1gi6b == 0 & h1gi6c == 1 & h1gi6d == 0 & h1gi6e == 0 //non-hispanic native americans
replace race_w1_nh = 6 if h1gi6a == 0 & h1gi6b == 0 & h1gi6c == 0 & h1gi6d == 0 & h1gi6e == 1 //non-hispanic other or two more races
replace race_w1_nh = 6 if race_w1_nh == .

drop if race_w1 == 5

* Ethnicity
recode h1gi7a h1gi7b h1gi7c h1gi7d h1gi7e h1gi7f h1gi7g (0=0)(1=1)(7/8=.)
gen asian_ea = 0
replace asian_ea = 1 if h1gi7a == 1 | h1gi7c == 1 | h1gi7e == 1
replace asian_ea = . if race_w1 !=4

gen asian_sa = 0
replace asian_sa = 1 if h1gi7d == 1 
replace asian_sa = . if race_w1 !=4

gen asian_se = 0
replace asian_se = 1 if h1gi7b == 1 | h1gi7f == 1
replace asian_se = . if race_w1 !=4

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

recode h1gi9 6/9=.,gen(race_int_w1)
rename h3ir4 race_int_w3 
rename h4ir4 race_int_w4
* 1 whites
* 2 blacks
* 3 native americans
* 4 asians

* Add racial mismatch codes if needed

recode h3od4* h3od2 (6/9=.)
rename h3od4a race_w3_wh
rename h3od4b race_w3_bl
rename h3od2  race_w3_hs
rename h3od4d race_w3_as
rename h3od4c race_w3_na

gen hisp_rated = .
replace hisp_rated = 1 if race_w1 == 3 & race_int_w1 == 1 //hisp rated as white
replace hisp_rated = 2 if race_w1 == 3 & race_int_w1 == 5 //hisp rated as other
replace hisp_rated = 3 if race_w1 == 3 & (race_int_w1 == 2 | race_int_w1 == 3 | race_int_w1 == 4) //hisp rated as black/asian/native

rename v3 eur
rename v4 afr
rename v1 asa
rename v2 amr

* drop _merge
* merge 1:1 aid using "0.Data\~Admixture\ah_plink_subset_supervised.dta"
* drop if _merge==2

* bysort race_w1: sum v1 v2 v3 v4

* rename v3 eur_sp
* rename v1 afr_sp
* rename v4 asian_sp
* rename v2 native_sp

/*----------------------------------------------------*/
   /* [>   Parent race  <] */ 
/*----------------------------------------------------*/
gen prace_w1 = . 
replace prace_w1 = 1 if pa6_1 == 1 & pa6_2 == 0 & pa6_3 == 0 & pa6_4 == 0 & pa6_5 == 0 & h1gi4 == 0 //non-hispanic whites
replace prace_w1 = 2 if pa6_1 == 0 & pa6_2 == 1 & pa6_3 == 0 & pa6_4 == 0 & pa6_5 == 0 & h1gi4 == 0 //non-hispanic blacks
replace prace_w1 = 3 if pa4 == 1 																		 //hispanic
replace prace_w1 = 4 if pa6_1 == 0 & pa6_2 == 0 & pa6_3 == 0 & pa6_4 == 1 & pa6_5 == 0 & h1gi4 == 0 //non-hispanic asians
replace prace_w1 = 5 if pa6_1 == 0 & pa6_2 == 0 & pa6_3 == 1 & pa6_4 == 0 & pa6_5 == 0 & h1gi4 == 0 //non-hispanic native americans
replace prace_w1 = 6 if pa6_1 == 0 & pa6_2 == 0 & pa6_3 == 0 & pa6_4 == 0 & pa6_5 == 1 & h1gi4 == 0 //non-hispanic other or two more races
replace prace_w1 = 6 if prace_w1 == . & pa4 !=.

gen sprace_w1 = . 
replace sprace_w1 = 1 if pb5_1 == 1 & pb5_2 == 0 & pb5_3 == 0 & pb5_4 == 0 & pb5_5 == 0 & h1gi4 == 0 //non-hispanic whites
replace sprace_w1 = 2 if pb5_1 == 0 & pb5_2 == 1 & pb5_3 == 0 & pb5_4 == 0 & pb5_5 == 0 & h1gi4 == 0 //non-hispanic blacks
replace sprace_w1 = 3 if pb3 == 1 																		 //hispanic
replace sprace_w1 = 4 if pb5_1 == 0 & pb5_2 == 0 & pb5_3 == 0 & pb5_4 == 1 & pb5_5 == 0 & h1gi4 == 0 //non-hispanic asians
replace sprace_w1 = 5 if pb5_1 == 0 & pb5_2 == 0 & pb5_3 == 1 & pb5_4 == 0 & pb5_5 == 0 & h1gi4 == 0 //non-hispanic native americans
replace sprace_w1 = 6 if pb5_1 == 0 & pb5_2 == 0 & pb5_3 == 0 & pb5_4 == 0 & pb5_5 == 1 & h1gi4 == 0 //non-hispanic other or two more races
replace sprace_w1 = 6 if sprace_w1 == . & pb3 !=7 & pb3 !=.

gen birace = . 
replace birace = 1 if prace_w1==1 & sprace_w1 == 2 // white-black
replace birace = 1 if prace_w1==2 & sprace_w1 == 1 // white-black
replace birace = 2 if prace_w1==1 & sprace_w1 == 3 // white-hispanic
replace birace = 2 if prace_w1==3 & sprace_w1 == 1 // white-hispanic
replace birace = 3 if prace_w1==1 & sprace_w1 == 4 // white-asian
replace birace = 3 if prace_w1==4 & sprace_w1 == 1 // white-asian

/*----------------------------------------------------*/
   /* [>   Other demographic variables  <] */ 
/*----------------------------------------------------*/

* Female dummy
gen age = iyear - h1gi1y
drop if age < 0
recode bio_sex 1=0 2=1 else=.,gen(female)

* Skin tone
rename h3ir17 skin
replace skin = 6-skin

* Discrimination
recode h4mh28 6/9=.,gen(disc)

* Language use 
recode h1gi10 1=0 2=1 3=0,gen(spanish)
recode h1gi10 1=0 2=0 3=1,gen(otherlg)
recode h1gi10 1=0 2/3=1,gen(noneng)

* Born as a US citizen
recode h1gi14 0=1 else=0,gen(immc_w1)
recode h3od16 0=1 else=0,gen(immc_w3)
recode h4od4 0=1 else=0,gen(immc_w4)
recode pa3 0=1 else=0,gen(immp_w1)
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

** School suspension **
* wave 1: h1ed7 Have you ever received an out-of-school suspension?
* wave 1: h1ed8 What grade were you in the last time you received an out-of-school suspension?
* wave 2: During this school year/{If SUMMER:] During the 1995-1996 school year {HAVE YOU RECEIVED/DID YOU RECEIVE} an out-of-school suspension from school?

/*----------------------------------------------------*/
   /* [>   Education  <] */ 
/*----------------------------------------------------*/
replace eprank = . if eprank==9992 // 9992: college rank missing
replace eprank = 21 - eprank
gen eprankx = eprank * 5
recode eprank 1/5=4 6/10=3 11/15=2 16/20=1,gen(quan_rank)

recode epblack epasian ephisp (0/2=1) (3/4=2) (5/6=3) (7/8=4) (9/10=5) (9992=.)
recode eploan epanyai (0/2=1) (3/4=2) (5/6=3) (7/8=4) (9/10=5) (9992=.)

bysort eploan:  sum eur afr if race_w1 == 2
bysort epanyai: sum eur afr if race_w1 == 2

bysort eploan:  sum eur afr if race_w1 == 3
bysort epanyai: sum eur afr if race_w1 == 3

recode w1region 1=4 4=1

recode h4ed2 1=8 2=10 3=12 4=13 5=14 6=14 7=16 8=17 9=18 10=19 11=21 12=17 13=18 else=0,gen(redu)

*Parents education
*conversion referred to NIHMS808914-supplement-Online_supplement.pdf
*recode h1rm1 1/2=1 3/6=2 6/7=3 8/9=4 10=1 97=6 else=5,gen(medu)
*recode h1rf1 1/2=1 3/6=2 6/7=3 8/9=4 10=1 97=6 else=5,gen(fedu)
recode h1rf1 1=8 2=10 3=10 4=12 5=12 6=13 7=14 8=16 9=18 10/12=. 96=. 97=. 98=. 99=.,gen(fedyr)
recode h1rm1 1=8 2=10 3=10 4=12 5=12 6=13 7=14 8=16 9=18 10/12=. 96=. 97=. 98=. 99=.,gen(medyr)
gen pedyr = medyr
replace pedyr = fedyr if pedyr ==. | (fedyr>medyr & fedyr !=. & medyr!=.)
replace pedyr = 0 if pedyr == .
recode pedyr 0=1 else=0,gen(pedyrx)

/*----------------------------------------------------*/
   /* [>   Create inverse probability weights  <] */ 
/*----------------------------------------------------*/
recode eur (.=0)(else=1),gen(missing)

qui: logit missing race_w11 race_w12 race_w13 race_w14 redu female pedyr pedyrx
predict p
sum missing if race_w1 == 1
sum missing if race_w1 == 2

gen ipw = w4_wc/p

/*----------------------------------------------------*/
   /* [>   Save data  <] */ 
/*----------------------------------------------------*/
*keep aid scid female age race* comp* *region skin eur afr asa amr hisp_rated disc prace sprace birace ipw w4_wc 

save "$data/ah_clean.dta",replace

******************************************************************
*mark nomiss
*markout nomiss race_w3_hs race_w3_wh race_w3_bl race_w3_na race_w3_as
*keep if nomiss == 1
*keep aid race_w3_* asa amr eur afr
save "$data/~Admixture/admixture_race.dta",replace
******************************************************************
* mismt_w3*

* analysis mismatch .do
