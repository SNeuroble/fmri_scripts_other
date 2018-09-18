/* proc printto print='/folders/myshortcuts/SAS/testout.log'; */
/* run; */




/* Read all filenames and put them into macro variables. The &FNAME variables store */
/* the names of the files only and &PEXT variables store the names of the files and */
/* the extensions.                                                                  */
/*                                                                                  */
/* Note: For releases SAS 9.0 or above, CALL SYMPUTX can be used to save two        */
/* function calls while creating the macro variables.  For example,                 */
/*                                                                                  */
/*      call symputx('fname'||put(i,8.-L),scan(trim(fname),1,'.'));                 */

/* Edit the pipe information for your OS */
filename blah pipe 'ls -l /folders/myshortcuts/SAS/';


data _null_;
  infile blah truncover end=last;
  /* Edit length as needed */
  length fname $20;
  input fname;
  i+1;
  /* The parsing of FNAME may need to be changed depending on your OS. */
  call symput('fname'||trim(left(put(i,8.))),scan(trim(fname),1,'.'));
  call symput('pext'||trim(left(put(i,8.))),trim(fname));
  if last then call symput('total',trim(left(put(i,8.))));
run;



/* Within a macro, run the PROC IMPORT code so that each filename is placed into */
/* the code appropriately.  The PROC PRINT in the macro is just to show the      */
/* results for testing purposes, and can be removed later.                       */

%macro test;
  %do i=1 %to &total;
     proc import datafile="c:\Junk\&&pext&i" 
                 out=work.&&fname&i 
                 dbms=dlm replace;
     delimiter=' ';
     getnames=no ;
     run;

     proc print data=work.&&fname&i;;
     title &&fname&i;
     run;
  %end;
%mend;

/* Invoke the macro */

%test    








filename mydata '/folders/myshortcuts/SAS/testdata2.txt';
data connectivity;
	infile mydata delimiter=',';
	input subj scanner day roi @@;
	/*  if pcc_seed, roi=edge(pcc-roi); if icd, roi=degree(roi) */

run;
	
/*     datalines; */
/* 1 1 1 0.0633262000000000 */
/* 1 1 2 0.0527221000000000 */
/* 2 1 1 0.0741907000000000 */
/* ... */
/* 6 2 2 0.0799140000000000 */
/*    ; */
   

ods html body='/folders/myshortcuts/SAS/test.xls';
/* ods trace on; */
proc varcomp method=reml data=connectivity ;
      class subj scanner day;
      model roi=subj scanner day subj|scanner subj|day scanner|day; 
ods select Varcomp.roi.Estimates;
/* ods output Varcomp.roi.Estimates=myestimates; */
/* ods select work.myestimates; */
run;
/* ods trace off; */
ods html close;
   
   