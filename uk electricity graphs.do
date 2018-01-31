********************************************************************************
** Graphs for wednesday seminar on market power in electricity markets
********************************************************************************

	
	clear matrix
	clear
	set more off
	capture log close
	set type double

	
	** Set paths
	global root = 	"H:\Training\Wednesday seminar\Energy econ 2016\Graphs"

	local raw		"$root\raw"
 	local temp		"$root\temp"
	local graphs	"$root\graphs"
	local out		"$root\out"
	
	cd "$root"
	
	**********
	** Import
	**********
	
		import delimited gridwatch.csv, clear
	
	**********
	** Clean
	**********
	
	// Dates + time
		
		gen time = clock(timestamp, "YMD hms")
		format time %tc
		
		gen date = dofC(time)
		format date %td
		
		
		gen day = day(date)
		gen month = month(date)
		gen year = year(date)
		
		drop timestamp
	

	
	// Other
	
		drop id 
		
		gen trade = french_ict + dutch_ict + ew_ict
		
		drop french_ict dutch_ict ew_ict other
	
	// Vars for graph
	
		gen A = trade
		gen B = A + nuclear
		gen C = B + ccgt
		gen D = C + coal
		gen E = D + wind 
		gen F = E + pumped + hydro
		gen H = F + oil
		gen I = H + ocgt
		
		
	// Standardising number of periods per day for graphs
	
		gen minute = mm(time)

		replace minute = minute/5
		replace minute = floor(minute)
		replace minute = minute*5

		gen hour = hh(time)
	
		collapse (mean) A B C D E F H I, by(minute hour day month year)

		save "data", replace
		
		
	**********
	** Graphs - daily
	**********
	
/*	
	collapse (mean) A B C D E F H I, by(minute hour month year)
	
	gen time = hms(hour,minute,0)
	format time %tc_HH:MM
	
	sort year month hour minute
		
	#delimit ;

	forvalues year_lab = 2014/2015 {;

		forvalues month_lab = 1/12 {;
		
			twoway
				(area I time, color("105 109 113"))
				(area H time, color("175 178 181"))
				(area F time, color("0 112 186"))
				(area E time, color("127 183 220"))
				(area D time, color("218 57 18"))
				(area C time, color("236 156 136"))
				(area B time, color("97 138 24"))
				(area A time, color("176 196 139"))
	
				if  month == `month_lab' & year == `year_lab', 
				graphregion(color(white))
				title("Electricity Demand by Type - 15/`month_lab'/`year_lab'")
				legend(label(1 "OCGT") label(2 "Oil")
				label(3 "Hydro") label(4 "Wind")
				label(5 "Coal") label(6 "CCGT") label(7 "Nuclear")
				label(8 "Trade"))
				scale(0.7)
				ytitle("Demand / GW") 
				xtitle("Time")
				ylabel(0(5000)40000)
				
				;
				graph export "Generation `year_lab'-`month_lab'.png",  replace;
				
				};
			};	

			#delimit cr
*/
	
	**********
	** Graphs - weekly
	**********
	
	use "data", clear
	
	
	gen time = hms(hour,minute,0)
	format time %tc_HH:MM
	
	gen date = mdy(month,day,year)
	gen week = week(date)
	
	sort year month week day hour minute
	
	#delimit ;
	

		forvalues week = 1/10 {;
		
			twoway
				(area I day, color("105 109 113"))
				(area H day, color("175 178 181"))
				(area F day, color("0 112 186"))
				(area E day, color("127 183 220"))
				(area D day, color("218 57 18"))
				(area C day, color("236 156 136"))
				(area B day, color("97 138 24"))
				(area A day, color("176 196 139"))
	
				if  week == `week' & year == 2015, 
				graphregion(color(white))
				title("Electricity Demand by Type - week `week' 2015")
				legend(label(1 "OCGT") label(2 "Oil")
				label(3 "Hydro") label(4 "Wind")
				label(5 "Coal") label(6 "CCGT") label(7 "Nuclear")
				label(8 "Trade"))
				scale(0.7)
				ytitle("Demand / GW") 
				xtitle("Day")
				ylabel(0(5000)40000)
				
				;
				graph export "Generation week `week'.png",  replace;
				
				};
			

	#delimit cr
