***********************************************************************************
*** SETUP
***********************************************************************************

clear all
set more off, perm
set maxvar 16000, perm
set matsize 5000
pause on
capture postutil close
*set scheme burd
*graph set window fontface "Calibri Light" 
*set trace on
*capture log close

***********************************************************************************
*** DIRECTORY GLOBALS
***********************************************************************************

***set home folder
if "`c(username)'"=="trejo" {
	glob dir "C:\Users\trejo\Dropbox (Princeton)\~ancestry_identity"
	
	***set files path globals
	global data "${dir}\data"
	global syntax "`c(pwd)'"
	global table "${dir}\tables"
	global figure "${dir}\figures"
}

if "`c(username)'"=="uchikoshi" & "`c(machine_type)'" == "Macintosh (Intel 64-bit)" {
 glob dir "/Users/uchikoshi/Dropbox (Princeton)/~~GeneticAncestry/~ancestry_identity/"
***set files path globals
	global data "${dir}/Data"
	global syntax "`c(pwd)'"
	global table "${dir}/Results/Tables"
	global figure "${dir}/Results/Figures"
}

if "`c(username)'"=="uchikoshi" & "`c(machine_type)'" == "PC (64-bit x86-64)" {
 glob dir "X:\uchikoshi\"
***set files path globals
	global data "${dir}\.Data"
	global syntax "`c(pwd)'"
	global table "${dir}\2.Results\Admixture\Tables"
	global figure "${dir}\2.Results\Admixture\Figures"
}

***********************************************************************************
*** STATA DATE
***********************************************************************************

***returns YYYY_MM_DD as global $date
quietly {
	global date=c(current_date)

	***day
	if substr("$date",1,1)==" " {
		local val=substr("$date",2,1)
		global day=string(`val',"%02.0f")
	}
	else {
		global day=substr("$date",1,2)
	}

	***month
	if substr("$date",4,3)=="Jan" {
		global month="01"
	}
	if substr("$date",4,3)=="Feb" {
		global month="02"
	}
	if substr("$date",4,3)=="Mar" {
		global month="03"
	}
	if substr("$date",4,3)=="Apr" {
		global month="04"
	}
	if substr("$date",4,3)=="May" {
		global month="05"
	}
	if substr("$date",4,3)=="Jun" {
		global month="06"
	}
	if substr("$date",4,3)=="Jul" {
		global month="07"
	}
	if substr("$date",4,3)=="Aug" {
		global month="08"
	}
	if substr("$date",4,3)=="Sep" {
		global month="09"
	}
	if substr("$date",4,3)=="Oct" {
		global month="10"
	}
	if substr("$date",4,3)=="Nov" {
		global month="11"
	}
	if substr("$date",4,3)=="Dec" {
		global month="12"
	}

	***year
	global year=substr("$date",8,4)

	global date="$year"+"_"+"$month"+"_"+"$day"
}
dis "$date"

***********************************************************************************
*** RUN CODE
***********************************************************************************

***import survey data
do "${syntax}/A_fake.do"

***clean survey data
do "${syntax}/B_clean.do"

***summary statistics table
do "${syntax}/C_sumstat.do"

***analysis
do "${syntax}/D_analysis.do"



