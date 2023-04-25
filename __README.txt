# Attractiveness Rank Effects README:

**********************************************************
****** "_MAIN"
**********************************************************

Main Stata script that sets file paths/globals and executes all following Stata scripts.

data in:

data out:
table out:
figure out:

**********************************************************
****** "A_fake"
**********************************************************

Generate four 'fake' continental ancestry percentage variables for running test code off of the server (the data on the server contains the real genetic variables).

data in: analysis_unsupervised.dta

data out: ah_continental_admixture.dta
table out:
figure out:

**********************************************************
****** "B_clean"
**********************************************************

Merges and clean raw AH data, generate IPW weights, and saves out a .dta.

data in: ah_continental_admixture.dta, wave1.dta, wave3.dta, wave4.dta

data out: ah_clean.dta
table out: 
figure out:

**********************************************************
****** "C_race_table"
**********************************************************

Produces table of average continental ancestry by race to compare with David Reich's results.

data in: ah_clean.dta

data out:
table out: race_table_${date}.dta
figure out:

**********************************************************
****** "D_analysis"
**********************************************************

Produces table of racial mismatch/fluidity.

data in: ah_clean.dta

data out:
table out: mismatch_table_${date}.dta
figure out:


**********************************************************
****** "E_binscatter"
**********************************************************

Produces binned scatterplots with fractional polynomials (no confidence intervals) of identity as a function of the four continental ancestry variables.

data in: ah_clean.dta

data out:
table out:
figure out: binscatter_${date}.dta


**********************************************************
****** "F_polynimial"
**********************************************************

Produces polynomial scatterplots with fractional polynomials and confidence intervals across SES, gender, immigrant, and language use.

data in: ah_clean.dta

data out:
table out:
figure out: binscatter_hetero_${date}.dta