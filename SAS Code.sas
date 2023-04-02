libname HW10 "/home/u60739998/BS 805/Class 10";
filename long "/home/u60739998/BS 805/Class 10/longdata_f22.dat";
/* Question 1 */
data HW10.long1;
	infile long;
	input id treatment visitn last_visitn stage;
run;

proc sort data=HW10.long1;
	by id;
run;

data temp1;
	set Hw10.long1;
	by id;
	retain studyduration;
	if first.id then studyduration=last_visitn;
	else studyduration=studyduration+last_visitn;
run;

proc print data=temp1 (obs=20); run;
/* Question 2 */
proc means data=temp1 noprint;
	by id;
	var visitn treatment;
	output out=one max=maxvisits treatment;
run;

proc means data=one noprint;
	by treatment;
	var maxvisits;
	output out=two n=ntotal sum=totvisits;
run;
/* Question 3 */
proc sort data=temp2;
	by id stage;
run;

data temp2;
	set temp1;
	by id stage;
	retain untilprog;

	*first.stage means every first observation that has a new number. so id 1 was 0 0 1 - first.stage wold pick the first 0 and then 1 and run the command. for 0 1 1 - first.stage would take 0 and the first 1 and run command. if would run the else command for the second 1 because it is not first not =0;
	if first.stage or stage=0 then untilprog=studyduration;
	else untilprog=untilprog;
	if last.id;
run;

proc print data=temp2 (obs=10); run;

data temp3;
	set temp2;
	keep id treatment untilprog stage;
run;
/*Question 4 */
proc sort data=temp3;
	by treatment;
run;

proc univariate data=temp3 normal;
	by treatment;
	var untilprog;
run;

proc gchart data=temp3;
	by treatment;
	vbar untilprog;
run;

proc npar1way wilcoxon data=temp3;
	class treatment;
	var untilprog;
run;