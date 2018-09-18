/* proc printto print='/folders/myshortcuts/SAS/testout.log'; */
/* run; */

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
   
   