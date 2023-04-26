clear all
set maxvar 10000
cd "X:\uchikoshi"
use "0.Data\~Admixture\ah_clean.dta",clear

/*----------------------------------------------------*/
   /* [>   Distribution of genetic ancestry  <] */ 
/*----------------------------------------------------*/
sum eur afr amr asa if race_w1 == 1 [aweight=ipw]
sum eur afr amr asa if race_w1 == 2 [aweight=ipw]
sum eur afr amr asa if race_w1 == 3 [aweight=ipw]
sum eur afr amr asa if race_w1 == 4 [aweight=ipw]

*sum eur_sp afr_sp native_sp asian_sp if race_w1 == 1 [aweight=ipw]
*sum eur_sp afr_sp native_sp asian_sp if race_w1 == 2 [aweight=ipw]
*sum eur_sp afr_sp native_sp asian_sp if race_w1 == 3 [aweight=ipw]
*sum eur_sp afr_sp native_sp asian_sp if race_w1 == 4 [aweight=ipw]

quietly estpost tabstat eur afr amr asa if race_w1 == 1 [aweight=ipw], statistics(n mean sd min max) columns(statistics) 
quietly esttab . using "2.Results/Admixture/Tables/race_table_wh.csv", replace cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") wide nostar unstack noobs nonote label
quietly estpost tabstat eur afr amr asa if race_w1 == 2 [aweight=ipw], statistics(n mean sd min max) columns(statistics) 
quietly esttab . using "2.Results/Admixture/Tables/race_table_bl.csv", replace cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") wide nostar unstack noobs nonote label
quietly estpost tabstat eur afr amr asa if race_w1 == 3 [aweight=ipw], statistics(n mean sd min max) columns(statistics) 
quietly esttab . using "2.Results/Admixture/Tables/race_table_hs.csv", replace cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") wide nostar unstack noobs nonote label
quietly estpost tabstat eur afr amr asa if race_w1 == 4 [aweight=ipw], statistics(n mean sd min max) columns(statistics) 
quietly esttab . using "2.Results/Admixture/Tables/race_table_as.csv", replace cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") wide nostar unstack noobs nonote label