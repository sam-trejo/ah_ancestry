use "$data/admixture_race.dta",clear

append using "$data/GID_link.dta"

xtile ses = sespc_al, nq(2)

recode ses 1=0 2=1
label define sesl 0"Low SES" 1"High SES" ,replace
label values ses sesl 
label define nonengl 0"English use" 1"Non-English use" ,replace
label values noneng nonengl 
label define femalel 0"Male" 1"Female" ,replace
label values female femalel 
label define gene1l 0"1st/2nd generation" 1"3rd+ generation" ,replace
label values gene1 gene1l 

sum ses noneng female gene1 asa amr eur afr

**********************************************************************
* Black - African ancestry
**********************************************************************

twoway (fpfitci race_w3_bl afr if ses == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_bl afr if ses == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "Low SES" 4 "High SES")) saving("$figure/polynomial/ses.gph",replace)

twoway (fpfitci race_w3_bl afr if noneng == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_bl afr if noneng == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "English use" 4 "Non-English use")) saving("$figure/polynomial/noneng.gph",replace)

twoway (fpfitci race_w3_bl afr if female == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_bl afr if female == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "Male" 4 "Female")) saving("$figure/polynomial/female.gph",replace)

twoway (fpfitci race_w3_bl afr if gene1 == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_bl afr if gene1 == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "1st/2nd generation" 4 "3rd+ generation")) saving("$figure/polynomial/gene1.gph",replace)
 
graph combine $figure/polynomial/ses.gph $figure/polynomial/noneng.gph $figure/polynomial/female.gph $figure/polynomial/gene1.gph, ycommon saving("$figurepolynomial/polynomial_black_hetero.gph",replace)
graph export "$figure/polynomial/polynomial_black_hetero.pdf",replace

**********************************************************************
* Asian - Asian ancestry
**********************************************************************
twoway (fpfitci race_w3_as asa if ses == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_as asa if ses == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5)  estopts(degree(3))), legend(order(2 "Low SES" 4 "High SES")) saving("$figure/polynomial/ses.gph",replace)

twoway (fpfitci race_w3_as asa if noneng == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_as asa if noneng == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "English use" 4 "Non-English use")) saving("$figure/polynomial/noneng.gph",replace)

twoway (fpfitci race_w3_as asa if female == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_as asa if female == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "Male" 4 "Female")) saving("$figure/polynomial/female.gph",replace)

twoway (fpfitci race_w3_as asa if gene1 == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_as asa if gene1 == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "1st/2nd generation" 4 "3rd+ generation")) saving("$figure/polynomial/gene1.gph",replace)
 
graph combine $figure/polynomial/ses.gph $figure/polynomial/noneng.gph $figure/polynomial/female.gph $figure/polynomial/gene1.gph, ycommon saving("$figure/polynomial/polynomial_asian_hetero.gph",replace)
graph export "$figure/polynomial/polynomial_asian_hetero.pdf",replace

**********************************************************************
* Black - African ancestry
**********************************************************************
twoway (fpfitci race_w3_hs afr if ses == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs afr if ses == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "Low SES" 4 "High SES")) saving("$figure/polynomial/ses.gph",replace)

twoway (fpfitci race_w3_hs afr if noneng == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs afr if noneng == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "English use" 4 "Non-English use")) saving("$figure/polynomial/noneng.gph",replace)

twoway (fpfitci race_w3_hs afr if female == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs afr if female == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "Male" 4 "Female")) saving("$figure/polynomial/female.gph",replace)

twoway (fpfitci race_w3_hs afr if gene1 == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs afr if gene1 == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "1st/2nd generation" 4 "3rd+ generation")) saving("$figure/polynomial/gene1.gph",replace)
 
graph combine $figure/polynomial/ses.gph $figure/polynomial/noneng.gph $figure/polynomial/female.gph $figure/polynomial/gene1.gph, ycommon saving("$figure/polynomial/polynomial_hisp_hetero_african.gph",replace)
graph export "$figure/polynomial/polynomial_hisp_hetero_african.pdf",replace

**********************************************************************
* Hispanic - American ancestry
**********************************************************************
twoway (fpfitci race_w3_hs amr if ses == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs amr if ses == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "Low SES" 4 "High SES")) saving("$figure/polynomial/ses.gph",replace)

twoway (fpfitci race_w3_hs amr if noneng == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs amr if noneng == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "English use" 4 "Non-English use")) saving("$figure/polynomial/noneng.gph",replace)

twoway (fpfitci race_w3_hs amr if female == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs amr if female == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "Male" 4 "Female")) saving("$figure/polynomial/female.gph",replace)

twoway (fpfitci race_w3_hs amr if gene1 == 0 ,clcolor(cranberry) estopts(degree(3)))  ///  
   (fpfitci race_w3_hs amr if gene1 == 1, clcolor(ebblue) clpattern(dash) lwidth(0.5) estopts(degree(3))), legend(order(2 "1st/2nd generation" 4 "3rd+ generation")) saving("$figure/polynomial/gene1.gph",replace)
 
graph combine $figure/polynomial/ses.gph $figure/polynomial/noneng.gph $figure/polynomial/female.gph $figure/polynomial/gene1.gph, ycommon saving("$figure/polynomial/polynomial_hisp_hetero_american.gph",replace)
graph export "$figure/polynomial/polynomial_hisp_hetero_american.pdf",replace
