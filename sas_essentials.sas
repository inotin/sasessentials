*=======================================;
*HonE - p.45;
*---------------------------------------;

title "SAS Essentials - HoE - p.45";

data example;
	input age @@;
	datalines;
10 10 10 .
;
run;

proc means data=example;
	var age;
run;
*---------------------------------------;


*=======================================;
*Ex. 1.1;
*---------------------------------------;
title "SAS Essentials - Exercise 1.1";

data temp;
	input id sex $ age wt;
	datalines;
1 m 25 75
2 f 24 65
3 m 23 45
;
run;

proc print data=temp;
run;

proc means;
run;
*---------------------------------------;


*=======================================;
*Ex. 1.2;
*---------------------------------------;
title "SAS Essentials - Exercise 1.2";

data recovery;
	input ilname $ rectime;
	datalines;
alice 3.1
bob 4.1
charlie 5.5
;
run;

proc print data=recovery;
run;

proc means;
run;

*=======================================;
*Informats and formats practice;
*---------------------------------------;

data mydata;
	input @1 col1 4. @5 col2 $1.;
	format col1 4.2;
	datalines;
0.1 df
23.1fsdg
2.34r 
;

proc print data=mydata;
	format col1 3.2 col2;
run;
*---------------------------------------;


*=======================================;
*Infile practice;
*---------------------------------------;
data mydata;
	length Nazione $ 24;
	infile "/home/u59542976/pil.txt" dlm='	' truncover;
	input Nazione $ y2004 y2005 y2006 y2007 y2008 y2009 y2010 y2011 y2012 y2013 
		y2014 y2015 y2016 y2017;
	;

DATA CHILDREN;
	* WT is in column 1-2, HEIGHT is in 4-5 and AGE is in 7-8;
	* Create an INPUT statement that will read in this data set;
	INPUT WT 1-3 HT 4-6 AGE 7-9;
	DATALINES;
 64 57 8
 71 59 10
 53 49 6
 67 62 11
 55 51 8 
 58 50 8
 77 55 10
 57 48 9
 56 42 10
 51 42 6
 76 61 12
 68 57 9
   ;
	Title “Exercise 2.1 - Ilia Notin”;

PROC PRINT DATA=CHILDREN;
RUN;

*=======================================;
*p.127;
*---------------------------------------;
proc import out=pil(rename=VAR1=Country VAR2-VAR15=y2004-y2017) 
		datafile="/home/u59542976/pil.txt" dbms=TAB replace;
	getnames=no;
	label Country='Paese';
run;

proc print data=work.pil label;
run;

proc means data=work.pil;
	var y2004;
run;
*---------------------------------------;


*=======================================;
*p.129;
*---------------------------------------;
ods pdf file="&outpath/proc_datasets_contents.pdf";

proc datasets;
	contents data=pil;
	run;
	ods pdf close;
	ods pdf file="&outpath/proc_contents.pdf";

proc contents data=pil;
run;

ods pdf close;


*=======================================;
*---------------------------------------;
proc means data=pil;
	output out=work.pil_means;
run;

proc print data=work.pil_means label;
run;

*---------------------------------------;


*=======================================;
*4.8 Using Proc Format - p.179;
*---------------------------------------;

proc format library=mformats;
	value fmt_pil_high_low low-3='Low' 3-high='High';
run;

options fmtsearch=(mformats.formats);

proc print data=work.pil;
	format y: fmt_pil_high_low.;
run;

proc catalog catalog=mformats.formats;
	contents;
	run;
quit;

*---------------------------------------;


*=======================================;
*4.8 Using Proc Format - p.179;
*---------------------------------------;

proc sort data=pg1.storm_summary out=storms_sorted;
	by Basin MaxWindMPH;
run;

data storm_grouped;
	putlog _N_=;
	set storms_sorted;
	by Basin;
	length isFirst $ 5;

	if first.Basin then
		isFirst='True';
	else
		isFirst='False';
	putlog _all_;
run;

*---------------------------------------;


*=======================================;
*Ex. 4.2a - p.189;
*---------------------------------------;

data small;
	set sashelp.cars;

	if EngineSize<2;
run;

proc means data=small;
	var MPG_City MPG_Highway;
run;

*---------------------------------------;
*Exploring the data;

proc contents data=sashelp.cars;
run;

proc print data=sashelp.cars;
run;
*---------------------------------------;


*=======================================;
*Ex. 4.2b - p.189;
*---------------------------------------;
*Non ho trovato le macchine hybrid;

proc print data=sashelp.cars;
	where model like "%hybrid%";
run;

*---------------------------------------;


*=======================================;
*Ex. 4.2c - p.189;
*---------------------------------------;

data awdsuv;
	set sashelp.cars;

	if lowcase(Type)="suv";
	label make=Brand;
run;

proc print data=awdsuv label;
	var make model;
run;

proc means data=awdsuv;
	var MPG_City MPG_Highway;
run;

proc sort data=awdsuv out=awdsuv_sorted(keep=make model MPG_Highway);
	by MPG_Highway;
run;

*---------------------------------------;


*=======================================;
*Ex. 4.3a - p.190;
*---------------------------------------;

data somedata_calc;
	set sasess.somedata;
	change6=time2-time1;
	change12=time3-time1;
	change24=time4-time1;
run;

proc means data=somedata_calc;
run;
*---------------------------------------;


*=======================================;
*---------------------------------------;
*Ex. 4.3b - p.190;
*---------------------------------------;

proc print data=sasess.somedata;
run;

data somedata_b(keep=id gp gender);
	set sasess.somedata;

	if gp='A' and gender="Female";
run;

*---------------------------------------;


*=======================================;
*Ex. 4.4 - p.190;
*---------------------------------------;

proc format;
	value fmtYN 0='No' 1='Yes';

data questions;
	INPUT Q1 Q2 Q3 Q4 Q5;
	DATALINES;
1 0 1 1 0
0 1 1 1 0
0 0 0 1 1
1 1 1 1 1 
1 1 1 0 1
;

proc print;
	format Q: fmtYN.;
run;

*---------------------------------------;


*=======================================;
*Ex. 4.5 - p.191;
*---------------------------------------;

PROC FORMAT LIBRARY=mformats.formats;
	VALUE FMTAGE LOW-12='Child' 13, 14, 15, 16, 17, 18, 19='Teen' 20-59='Adult' 
		60-HIGH='Senior';
	VALUE FMTSTAT 1='Lower Class' 2='Lower-Middle' 3='Middle Class' 
		4='Upper-Middle' 5='Upper';
RUN;

*listing the format catalogue;

proc catalog catalog=mformats.formats;
	contents;
	run;
quit;

options fmtsearch=(mformats.formats);

proc print data=sasess.somedata;
	var age status gp;
	format age fmtage. status fmtstat.;
	title "Formatting Example";
run;

*---------------------------------------;


*=======================================;
*HonE - p.207;
*---------------------------------------;

data mydata;
	infile "/home/u59542976/SASEssentialsData/EXAMPLE.DAT";
	input id 1-3 gp $ 5 age 6-9 time1 10-14 time2 15-19 time3 20-24 status 31;
run;

title "Means without BY";

proc means data=mydata;
	var time1 time2;
run;

proc sort data=mydata;
	by gp;
run;

title "Means with BY";

proc means data=mydata;
	var time1 time2;
	by gp;
run;

title;
*---------------------------------------;


*=======================================;
*HonE - p.210;
*---------------------------------------;

data weight;
	informat mdate mmddyy10.;
	format mdate date9.;
	input mdate rat_id $ wt_grams trt$ pinkeye $;
	datalines;
02/03/2009 001 093 A Y
02/04/2009 002 087 B N
02/04/2009 003 103 A Y
02/07/2009 005 099 A Y
02/08/2009 006 096 B N
02/11/2009 008 091 B Y
;
run;

proc print data=weight;
	id rat_id;
run;
*---------------------------------------;


*=======================================;
*HonE - p.213;
*---------------------------------------;

proc print data=weight label;
	id rat_id;
	label trt='Treatment';
run;

proc means data=weight;
	label wt_grams="Weight in grams" mdate="MEDOBS date";
run;
*---------------------------------------;


*=======================================;
*HonE - p.215;
*---------------------------------------;

proc print data=weight label;
	id rat_id;
	label trt='Treatment';
	where trt="A";
run;

*---------------------------------------;


*=======================================;
*HonE - p.219;
*---------------------------------------;

proc print data=sasess.somedata N="Number of Subjects:" obs="Subjectz";
	sum time1 time2 time4;
	title "Proc print options demostration";
	by gp;
run;
*---------------------------------------;


*=======================================;
*Ex.5.1-5.2 - p.228;
*---------------------------------------;
title "Title 1";
title2 "Title 2";
title3 "Title 3";
title4 "Title 4";
title5 "Title 5";
footnote "footnote 1";
footnote2 "footnote 2";

proc print data=sashelp.cars;
	id model;
run;

title;
footnote;
*---------------------------------------;


*=======================================;
*Ex.5.3 - p.228;
*---------------------------------------;

DATA MYDATA;
	INFILE '/home/u59542976/SASEssentialsData/BPDATA.DAT';
	* READ DATA FROM FILE;
	INPUT ID $ 1 SBP 2-4 DBP 5-7 SEX $ 8 AGE 9-10 WT 11-13;
	LABEL ID='Identification Number' SBP='Systolic Blood Pressure' 
		DBP='Diastolic Blood Pressure' AGE='Age on Jan 1, 2000' WT='Weight';

PROC MEANS;
	VAR SBP DBP AGE WT;
	LABEL ID='Identification Number' SBP='Systolic Blood Pressure' 
		DBP='Diastolic Blood Pressure' AGE='Age on Jan 1, 2000' WT='Weight';
RUN;

proc print label;
run;

TITLE;
FOOTNOTE;
*---------------------------------------;


*=======================================;
*HonE - p.237;
*---------------------------------------;

data dates;
	input @1 bdate mmddyy8.;
	*target=mdy(08,25,2001);
	target=today();
	age=intck('year', bdate, target);
	datalines;
07101952
07041776
01011900
;

proc print data=dates;
	format bdate weekdate. target mmddyy8.;
run;

*---------------------------------------;


*=======================================;
*HonE - p.240;
*---------------------------------------;

data subjects;
	input sub1 $ sub2 $ sub3 $ sub4 $;
	datalines;
12 21 13 14
13 21 13 46
21 42 67 89
12 56 88 22
m f f m
;
title "Original data";
proc print data=subjects;
run;

proc transpose data=subjects out=transposed prefix=info;
	var sub1 sub2 sub3 sub4;
run;

title "Transposed";
proc print data=transposed;
run;

data transposed_renamed;
	set transposed;
	rename _name_=subject info1=t1 info2=t2 info3=t3 info4=t4 info5=gender;
run;

title "Transposed and renamed";
proc print data=transposed_renamed;
run;

data transposed_renamed_type_changed;
	set transposed;
	subject = _name_;
	t1 = input(info1, 5.); 
	t2 = input(info2, 5.); 
	t3 = input(info3, 5.); 
	t4 = input(info4, 5.); 
	gender = input(info5, $1.); 
	drop _name_ info1 info2 info3 info4 info5;
run;

title "Transposed, renamed and changed type";
proc print data=transposed_renamed_type_changed;
var subject t1 t2 t3 t4 gender;
run;
title;

*---------------------------------------;


*=======================================;
*HonE - p.244;
*---------------------------------------;
proc print data=sasess.complications(obs=10);
run;

proc transpose data=sasess.complications out=comp_out prefix=comp;
by subject;
var complication;
run;

data multiple;
set comp_out;
drop _name_;
if comp3 ne ' ';
run;

proc print data=multiple;
var subject comp1-comp4;
run;
*---------------------------------------;


*=======================================;
*HonE - p.247;
*---------------------------------------;
data mydata;
set sasess.somedata;
format economic $7.;
select(status);
	when (1,2) economic="low";
	when (3) economic="middle";
	when (4,5) economic="high";
	otherwise economic ="missing";
end;
select;
	when (age<12) agegroup="child";
	when (age>=12 and age<=19) agegroup="teen";
	when (age>20) agegroup="adult";
	otherwise agegroup ="na";
end;

proc print data=mydata;
run;
*---------------------------------------;


*=======================================;
*HonE - p.252;
*---------------------------------------;

data sasess.cleaned; 
set sasess.messydata;
label
	education="Years of schooling" 
	how_arrived="How Arrived at Clinic"
	top_reason="Top Reason for Coming"
	satisfatcion="Satisfaction Score";
temp=arrival;
drop arrival;
label temp="Arrival Temperature";
run;

proc print data=sasess.cleaned(firstobs=1 obs=10) label;
var subject education temp top_reason satisfaction;
format subject z5.;
run;
*---------------------------------------;


*=======================================;
*HonE - p.254;
*---------------------------------------;
data sasess.cleaned2;
set sasess.cleaned;
gender = upcase(gender);
race = upcase(race);
if how_arrived not in ('CAR','BUS','WALK') then how_arrived="";
if subject="" then delete;
if gender not in ('M','F') then gender="";
if race in ("MEX","M") then race="H";
if race in ("X","NA") then race="";
run;

*---------------------------------------;


*=======================================;
*HonE - p.256;
*---------------------------------------;
proc freq data=sasess.cleaned2;
tables married single top_reason race gender how_arrived;
run;

data sasess.cleaned3;
set sasess.cleaned;
gender = upcase(gender);
race = upcase(race);
if how_arrived not in ('CAR','BUS','WALK') then how_arrived="";
if subject="" then delete;
if gender not in ('M','F') then gender="";
if race in ("MEX","M") then race="H";
if race in ("X","NA") or race not in ("AA","H", "C") then race="";
drop married;
if top_reason not in ("1", "2", "3") then top_reason="";
run;

proc freq data=sasess.cleaned3;
tables single top_reason race gender how_arrived;
run;
*---------------------------------------;


*=======================================;
*HonE - p.259;
*---------------------------------------;
proc means data=sasess.cleaned3;
run;

data sasess.cleaned4;
set sasess.cleaned3;
if education=99 then education=.;
if temp<45 then temp=32+temp*9/5;
if temp>1000 then temp=temp/10;
if satisfaction=-99 then satisfaction=.;
agen = input(age, 5.);
if agen<10 or agen>99 then agen=.;
drop age;
label agen="Age as for 01.01.2014";
run;

proc means data=sasess.cleaned4;
run;
*---------------------------------------;


*=======================================;
*HonE - p.262;
*---------------------------------------;

data sasess.cleaned5;
set sasess.cleaned4;
format arrivedt datetime18.;
datearrived2 = input(trim(datearrived), mmddyy10.);
i = find(timerarrive, " ");
p = find(timerarrive, "p");
timearrive1=substr(timearrive,1,i-1);
timearrivet=input(trim(timearrive1),time8.);
if p>0 and timearrivet<43200 then timearrivet=timearrivet+43200;
arrivedt = dhms(datearrived2,0,0,timearrivet);
label arrivedt="Date&Time Arrived";

*dateleft;
format leftdt datetime18.;
dateleft2 = input(trim(dateleft), mmddyy10.);
*timeleft;
il = find(timeleft, " ");
pl = find(timeleft, "p");
timeleft1=substr(timeleft,1,il-1);
timeleftt=input(trim(timeleft1),time8.);
if pl>0 and timeleftt<43200 then timeleftt=timeleftt+43200;

*combining;
leftdt = dhms(dateleft2,0,0,timeleftt);
label leftdt="Date&Time Left";

stayminutes = intck("min", arrivedt, leftdt);
stayhours = round(stayminutes/60, .1);
if stayhours<0 or stayhours>48 then stayhours=.;
run;
*---------------------------------------;


*=======================================;
*HonE - p.262;
*---------------------------------------;

proc freq data=sasess.cleaned5;
tables subject / out=frqcnt;
run;

proc print data=frqcnt;
where count>1;
run;

proc print data=sasess.cleaned5;
where subject>24 and subject<29;
run;

data sasess.cleaned6;
set sasess.cleaned5;
if _N_=27 then subject=27;
run;
*---------------------------------------;


*=======================================;
*Ex.6.1 - p.268;
*---------------------------------------;
DATA OWED;
INPUT ID $3. AMOUNTOWED DOLLAR9.;
DATALINES;
001 $3,209
002 $29
002 $34.95
003 2,012
003 312.45
003 34.23
004 2,312
004 $3.92
005 .98
;

proc transpose data=owed out=expanded prefix=amt;
by id;
var amountowed;
run;

data summarize;
set expanded;
total=sum(of amt:);
*total=amt1+amt2+amt3;
format total dollar9.2;
drop _name_;
run;
*---------------------------------------;


*=======================================;
*Ex.6.2 - p.269;
*---------------------------------------;
DATA wound2;
set sasess.wound;
select;
when (age le 4) agegp="Toddler";
when (age gt 4 and age le 12) agegp="Child";
when (age gt 12 and age le 18) agegp="Adult";
otherwise agegp="NA";
end;
run;
*---------------------------------------;


*=======================================;
*Ex.6.3 - p.269;
*---------------------------------------;
*fixing gender;
data fixmiss;
set sasess.somemiss;
run;
proc freq data=fixmiss;
tables gender;
run;

data fixmiss;
set sasess.somemiss;
if find(lowcase(gender), "f")>0 then gender="F";
else gender="M";
run;
proc freq data=fixmiss;
tables gender;
run;

*fixing age;
*step 1;
proc freq data=fixmiss;
tables age;
run;
proc means data=fixmiss;
var age;
run;

*step 2;
data fixmiss2;
set fixmiss;
agen = input(age, 4.);
run;
proc means data=fixmiss2;
var agen;
run;

*step 3;
data fixmiss2;
set fixmiss2;
if agen>105 then agen=.;
run;
proc means data=fixmiss2;
var agen;
run;
*---------------------------------------;





proc print data=sasess.cleaned5(obs=20);
format timearrive $16.;
run;












*---------------------------------------;


