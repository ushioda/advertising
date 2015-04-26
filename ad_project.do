// start from uscreditcard1.dta

duplicates drop mediaid panelisttrackingnumber, force

// delete one weird observation

list if month == "Personalized Mail"
drop if month == "Personalized Mail"

// year was not specified in June 2007. Fix this.

replace year = 2007 if month == "Jun 2007"
drop if year == .

// generate time variable

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

gen time = ym(year, month1) // time in stata internal form

// convert into panel data

sort panelisttrackingnumber mediaid
egen id = group(panelisttrackingnumber mediaid), label

tsset id time

gen statement = 0
replace statement = 1 if mailingtype == "Statement Mailing"

sort panelisttrackingnumber time mediaid

// save to 2

drop if statement == 0

gen ones = 1
egen num_statement_per_hh = sum(ones), by(panelisttrackingnumber)

duplicates drop panelisttrackingnumber, force

summarize num_statement_per_hh