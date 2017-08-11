/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _single_dir.sas

   \version    \$Revision: 486 $
   \author     \$Author: klandwich $
   \date       \$Date: 2016-12-05 12:08:40 +0100 (Mo, 05 Dez 2016) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_dir_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/*-- Prepare file to check for correct results -------------------------------*/
data dircheck; 
   length membername filename $255; 
   format changed datetime20.; 
   informat changed datetime.;
   label change="Date Modified";
   stop; 
run; 

/*-- macro to add one entry to check file ------------------------------------*/
%macro addentry(file);
   %local theTime;
   data _null_; file "&file"; put 'X'; run; 
   %let thetime=%sysfunc(datetime());
   data dircheck0; 
      length membername filename $255; 
      format changed datetime20.; 
      informat changed datetime.;
      changed = &thetime; 
      filename = translate("&file", '/', '\');
      membername = substr(filename,length(filename) - length(scan(filename,-1,'/')) + 1);      
      output; 
   run;
   data dircheck; 
      set dircheck dircheck0; 
   run; 
%mend addentry; 

/*-- 001 Empty directory ---------------------------------------------------------*/
%let path = %sysfunc(pathname(work))/testdir;
%_xcmd(mkdir "&path");
data work.directory;
   Directory = translate ("&path.", "/", "\");
run;
%initTestcase(i_object=_single_dir.sas, i_desc=empty directory)
%_single_dir(i_dsPath=work.directory, o_members=_empty_dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
%assertLogMsg(i_logmsg=^NOTE.SASUNIT.: Given directory is empty:);
%assertColumns(i_expected=dircheck, i_actual=_empty_dir, i_desc=check for empty dir file, i_fuzz=0.5)
%endTestcase;

/*-- 002 Simple directory with three files -----------------------------------------*/
%addentry(&path/file with blank.dat)
%addentry(&path/file1.txt)
%addentry(&path/filemitü.dat)

%initTestcase(i_object=_single_dir.sas, i_desc=directory with three files)
%_single_dir(i_dsPath=work.directory, o_members=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

data dircheck1; set dircheck; run; 

/*-- 003 nonrecursive call with subdirectories -----------------------------------*/
%let path = %sysfunc(pathname(work))/testdir/one;
%_xcmd(mkdir "&path")
%addentry(&path/file_one_1.dat)
%addentry(&path/file_one_2.dat)
%let path = %sysfunc(pathname(work))/testdir/one/one;
%_xcmd(mkdir "&path")
%addentry(&path/file_one_one_1.dat)
%addentry(&path/file_one_one_2.dat)
%let path = %sysfunc(pathname(work))/testdir/two;
%_xcmd(mkdir "&path")
%addentry(&path/file_two_1.dat)
%addentry(&path/file_two_2.dat)

%initTestcase(i_object=_single_dir.sas, i_desc=nonrecursive call with subdirectories)
%_single_dir(i_dsPath=work.directory, o_members=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck1, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 004 nonrecursive call with wildcards -----------------------------------*/
%initTestcase(i_object=_single_dir.sas, i_desc=nonrecursive call with wildcards)
%_single_dir(i_dsPath=work.directory, i_pattern=%str(%%).dat, o_members=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 005 nonrecursive call with specific file -----------------------------------*/
%initTestcase(i_object=_single_dir.sas, i_desc=nonrecursive call with specific file)
%_single_dir(i_dsPath=work.directory, i_pattern=file1.txt, o_members=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains "file1.txt";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 006 nonrecursive call with specific file in subdirectory -----------------------------------*/
data work.directory;
   Directory = translate ("%sysfunc(pathname(work))/testdir/one", "/", "\");
run;
%initTestcase(i_object=_single_dir.sas, i_desc=nonrecursive call with specific file in subdirectory)
%_single_dir(i_dsPath=work.directory, i_pattern=file_one_1.dat, o_members=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains "file_one_1.dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;
/** \endcond */
