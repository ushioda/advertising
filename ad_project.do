// start from uscreditcard1.dta

// generate month variable

gen month1 = .
replace month1 = 1 if strpos(month, "Jan")
replace month1 = 2 if strpos(month, "Feb")
replace month1 = 3 if strpos(month, "Mar")
replace month1 = 4 if strpos(month, "Apr")
replace month1 = 5 if strpos(month, "May")
replace month1 = 6 if strpos(month, "Jun")
replace month1 = 7 if strpos(month, "Jul")
replace month1 = 8 if strpos(month, "Aug")
replace month1 = 9 if strpos(month, "Sep")
replace month1 = 10 if strpos(month, "Oct")
replace month1 = 11 if strpos(month, "Nov")
replace month1 = 12 if strpos(month, "Dec")

// delete weird observations

list if month == "Personalized Mail"
drop if month == "Personalized Mail"

// year was not specified in June 2007. Fix this.

replace year = 2007 if month == "Jun 2007"
drop if year == .

// generate time variable

gen time = ym(year, month1) // time in stata internal form

// drop duplicate samples

duplicates drop mediaid panelisttrackingnumber time, force

// drop observations without panel id

drop if panelisttrackingnumber == .

gen hhid = panelisttrackingnumber
sort hhid time mediaid

gen statement = 0
replace statement = 1 if mailingtype == "Statement Mailing"


// save to 2

// count number of statements per household

/*

drop if statement == 0

gen ones = 1
egen num_statement_per_hh = sum(ones), by(panelisttrackingnumber)

duplicates drop panelisttrackingnumber, force

summarize num_statement_per_hh

*/

// create id showing the same creditcard

// sort companyreportformat product
// egen cardid = group(companyreportformat product)

// check what kind of product there are for chase

tabulate product if strpos(companyreportformat, "Chase")
tabulate productreportformat if strpos(companyreportformat, "Chase")
tabulate productfamily if strpos(companyreportformat, "Chase")
