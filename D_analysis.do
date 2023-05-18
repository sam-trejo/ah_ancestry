mark nomiss
markout nomiss race_w3_hs race_w3_wh race_w3_bl race_w3_na race_w3_as
keep if nomiss == 1
local dvs "asa amr eur afr"
foreach dv in `dvs'{
recode eur 0/1=0 else=.,gen(cat_`dv')
replace cat_`dv' = 1 if `dv' >= 0.01 & `dv' < 0.02 & cat_`dv' == 0
replace cat_`dv' = 2 if `dv' >= 0.02 & `dv' < 0.05 & cat_`dv' == 0
replace cat_`dv' = 3 if `dv' >= 0.05 & `dv' < 0.10 & cat_`dv' == 0
replace cat_`dv' = 4 if `dv' >= 0.10 & `dv' < 0.20 & cat_`dv' == 0
replace cat_`dv' = 5 if `dv' >= 0.20 & `dv' < 0.30 & cat_`dv' == 0
replace cat_`dv' = 6 if `dv' >= 0.30 & `dv' < 0.40 & cat_`dv' == 0
replace cat_`dv' = 7 if `dv' >= 0.40  & cat_`dv' == 0
}

forvalues i=2/4{
recode eur 0/1=0 else=.,gen(cat`i')
}
forvalues i=1/7{
replace cat4 = `i' if cat_asa >= `i' & cat_amr >= `i' & cat_eur >= `i' & cat_afr >= `i' & cat4 != .
}
forvalues i=1/7{
replace cat3 = `i' if cat_asa >= `i' & cat_amr >= `i' & cat_eur >= `i' & cat3 != .
replace cat3 = `i' if cat_asa >= `i' & cat_amr >= `i' & cat_afr >= `i' & cat3 != .
replace cat3 = `i' if cat_asa >= `i' & cat_eur >= `i' & cat_afr >= `i' & cat3 != .
replace cat3 = `i' if cat_amr >= `i' & cat_eur >= `i' & cat_afr >= `i' & cat3 != .
}
forvalues i=1/7{
replace cat2 = `i' if cat_eur >= `i' & cat_afr >= `i' & cat2 != .
replace cat2 = `i' if cat_asa >= `i' & cat_afr >= `i' & cat2 != .
replace cat2 = `i' if cat_amr >= `i' & cat_eur >= `i' & cat2 != .
replace cat2 = `i' if cat_asa >= `i' & cat_amr >= `i' & cat2 != .
replace cat2 = `i' if cat_amr >= `i' & cat_afr >= `i' & cat2 != .
replace cat2 = `i' if cat_asa >= `i' & cat_eur >= `i' & cat2 != .
}

ta cat2 [aweight=ipw]
 ta cat3 [aweight=ipw]
  ta cat4 [aweight=ipw]

* Omit single ancestry > 95% or 90?
local dvs "asa amr eur afr"
*foreach dv in `dvs'{
*gen `dv'95 = 0
*replace `dv'95 = 1 if `dv' > 0.95
*replace `dv'95 = . if `dv' == .
*drop if `dv'95 == 1

*gen `dv'01 = 0
*replace `dv'01 = 1 if `dv' < 0.01
*replace `dv'01 = . if `dv' == .
*drop if `dv'01 == 1
*}

local dvs "hs wh bl as"
foreach dv in `dvs'{
reg race_w3_`dv' afr amr asa
est sto model1_`dv'
mixed race_w3_`dv' afr amr asa || scid: afr amr asa
est sto model2_`dv'
mixed race_w3_`dv' (c.afr c.amr c.asa)##(c.female c.age c.noneng c.gene2 c.gene3 c.sespc_al)
est sto model3_`dv'
}
esttab model1_wh model2_wh model3_wh model1_bl model2_bl model3_bl model1_hs model2_hs model3_hs model1_as model2_as model3_as using `"$table/LPM_full`=subinstr("`c(current_date)'"," ","",.)'.csv"', scalar(N r2) wide se star(# 0.1 * 0.05 ** 0.01 *** 0.001) b(2) label  replace  title("Bivariate Linear Probability Model (Model 1)")


* analysis mismatch .do
