

proc import datafile="/folders/myshortcuts/SAS/testdata2.txt"
	out=mydata
	dbms=csv
	replace;
getnames=no;
run;

proc print data=mydata;
run;
   
   
   