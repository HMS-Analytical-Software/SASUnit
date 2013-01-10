/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_dir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/* Change log 
   xx.xx.xxxx YY  <reason>
*/

/*-- Prepare file to check for correct results -------------------------------*/
data dircheck; 
   length filename $255; 
   format changed datetime20.; 
   stop; 
run; 

/*-- macro to add one entry to check file ------------------------------------*/
%macro addentry(file);
%local theTime;
data _null_; file "&file"; put 'X'; run; 
%let thetime=%sysfunc(datetime());
data dircheck0; 
   length filename $255; 
   format changed datetime20.; 
   changed = dhms(datepart(&thetime), hour(timepart(&thetime)), minute(timepart(&thetime)), 0); 
   filename = translate("&file", '/', '\'); 
   output; 
run;
data dircheck; 
   set dircheck dircheck0; 
run; 
%mend; 

/*-- Empty directory ---------------------------------------------------------*/
%let path = %sysfunc(pathname(work))/testdir;
%_sasunit_xcmd(mkdir "&path")

%initTestcase(i_object=_sasunit_dir.sas, i_desc=empty directory)
%_sasunit_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for empty dir file)
%endTestcase;

/*-- Simple directory with two files -----------------------------------------*/
%addentry(&path/file with blank.dat)
%addentry(&path/file1.txt)
%macro lx;
%if &sysscp NE LINUX %then %do;
%addentry(&path/filemitü.dat)
%end;
%mend lx;
%lx;

%initTestcase(i_object=_sasunit_dir.sas, i_desc=directory with two files)
%_sasunit_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file)
%endTestcase;

data dircheck1; set dircheck; run; 

/*-- recursive call with subdirectories --------------------------------------*/
%let path = %sysfunc(pathname(work))/testdir/one;
%_sasunit_xcmd(mkdir "&path")
%addentry(&path/file_one_1.dat)
%addentry(&path/file_one_2.dat)
%let path = %sysfunc(pathname(work))/testdir/one/one;
%_sasunit_xcmd(mkdir "&path")
%addentry(&path/file_one_one_1.dat)
%addentry(&path/file_one_one_2.dat)
%let path = %sysfunc(pathname(work))/testdir/two;
%_sasunit_xcmd(mkdir "&path")
%addentry(&path/file_two_1.dat)
%addentry(&path/file_two_2.dat)

%initTestcase(i_object=_sasunit_dir.sas, i_desc=recursive call with subdirectories)
%_sasunit_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=1, o_out=dir);
%endTestcall;

proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file)
%endTestcase;

/*-- nonrecursive call with subdirectories -----------------------------------*/
%initTestcase(i_object=_sasunit_dir.sas, i_desc=nonrecursive call with subdirectories)
%_sasunit_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck1, i_actual=dir, i_desc=check for contents of dir file)
%endTestcase;

/*-- nonrecursive call with wildcards -----------------------------------*/
%initTestcase(i_object=_sasunit_dir.sas, i_desc=nonrecursive call with wildcards)
%_sasunit_dir(i_path=%sysfunc(pathname(work))/testdir/%str(*).txt, i_recursive=0, o_out=dir);
%endTestcall;

proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".txt";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file)
%endTestcase;

/** \endcond */
