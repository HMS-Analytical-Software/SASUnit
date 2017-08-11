/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _new_dir.sas

   \version    \$Revision: 486 $
   \author     \$Author: klandwich $
   \date       \$Date: 2016-12-05 12:08:40 +0100 (Mo, 05 Dez 2016) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_new_dir_test.sas $
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
      changed = floor(&thetime);
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

%initTestcase(i_object=_new_dir.sas, i_desc=directory does not exist)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
%assertLogMsg(i_logmsg=^ERROR.SASUNIT.: Given directory does not exist:);
%endTestcase;

/*-- 002 Empty directory ---------------------------------------------------------*/
%let path = %sysfunc(pathname(work))/testdir;
%_xcmd(mkdir "&path")

%initTestcase(i_object=_new_dir.sas, i_desc=empty directory)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
%assertLogMsg(i_logmsg=^NOTE.SASUNIT.: Given directory is empty:);
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for empty dir file, i_fuzz=0.5)
%endTestcase;

/*-- 003 Simple directory with three files -----------------------------------------*/
%addentry(&path/file with blank.dat)
%addentry(&path/file1.txt)
%addentry(&path/filemitü.dat)

%initTestcase(i_object=_new_dir.sas, i_desc=directory with three files)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

data dircheck1; set dircheck; run; 

/*-- 004 recursive call with subdirectories --------------------------------------*/
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

%initTestcase(i_object=_new_dir.sas, i_desc=recursive call with subdirectories)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 005 recursive call with subdirectories and delimiter at end of path --------------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=recursive call with subdirectories and delimiter at end of path)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir/, i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 006 nonrecursive call with subdirectories -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=nonrecursive call with subdirectories)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck1, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 007 nonrecursive call with wildcards -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=nonrecursive call with wildcards)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir/%str(*).dat, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 008 recursive call with wildcards -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=recursive call with wildcards)
%_new_dir(i_path=%sysfunc(pathname(work))/testdir/%str(*).dat, i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 009 nonrecursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=nonrecursive call with wildcards and quoted path)
%_new_dir(i_path='%sysfunc(pathname(work))/testdir/*.dat', i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 010 recursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=recursive call with wildcards and quoted path)
%_new_dir(i_path='%sysfunc(pathname(work))/testdir/*.dat', i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 011 nonrecursive call with wildcards, macro function and quoted path -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=nonrecursive call with wildcards%str(,) macro function  and quoted path)
%_new_dir(i_path='%sysfunc(pathname(work))/testdir/%str(*).dat', i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 012 recursive call with wildcards, macro function and quoted path -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=recursive call with wildcards%str(,) macro function and quoted path)
%_new_dir(i_path='%sysfunc(pathname(work))/testdir/*.dat', i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 013 nonrecursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=nonrecursive call with wildcards and quoted path)
%_new_dir(i_path="%sysfunc(pathname(work))/testdir/%str(*).dat", i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 014 recursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=recursive call with wildcards and quoted path)
%_new_dir(i_path="%sysfunc(pathname(work))/testdir/%str(*).dat", i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 015 nonrecursive call with specific file -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=nonrecursive call with specific file)
%_new_dir(i_path="%sysfunc(pathname(work))/testdir/file1.txt", i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains "file1.txt";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 016 nonrecursive call with specific file in subdirectory -----------------------------------*/
%initTestcase(i_object=_new_dir.sas, i_desc=nonrecursive call with specific file in subdirectory)
%_new_dir(i_path="%sysfunc(pathname(work))/testdir/one/file_one_1.dat", i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains "file_one_1.dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;
/** \endcond */
