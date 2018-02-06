/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _noxcmd_dir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
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
   data _null_; file "&file"; put 'X'; run; 
   filename _did_it "&file.";
   data dircheck0; 
      length membername filename $255; 
      set sashelp.vextfl (where=(upcase(fileref) = "_DID_IT") keep=fileref modate rename=(modate=changed));
      format changed datetime20.; 
      filename = translate("&file", '/', '\');
      membername = substr(filename,length(filename) - length(scan(filename,-1,'/')) + 1);      
      output; 
      keep membername filename changed;
   run;
   filename _did_it clear;
   data dircheck; 
      set dircheck dircheck0; 
   run; 
%mend addentry; 

/*-- 001 Empty directory ---------------------------------------------------------*/
%let path = %sysfunc(pathname(work))/testdir;

%initScenario(i_desc=Test of _noxcmd_dir.sas);
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=directory does not exist)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
%assertLogMsg(i_logmsg=^ERROR.SASUNIT.: Given directory does not exist:);
%endTestcase;

/*-- 002 Empty directory ---------------------------------------------------------*/
%let path = %sysfunc(pathname(work))/testdir;
%_xcmd(mkdir "&path")

%initTestcase(i_object=_noxcmd_dir.sas, i_desc=empty directory)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
%assertLogMsg(i_logmsg=^NOTE.SASUNIT.: Given directory is empty:);
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for empty dir file, i_fuzz=0.5)
%endTestcase;

/*-- 003 Simple directory with three files -----------------------------------------*/
%addentry(&path/file with blank.dat)
%addentry(&path/file1.txt)
%addentry(&path/filemitü.dat)

%initTestcase(i_object=_noxcmd_dir.sas, i_desc=directory with three files)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
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

%initTestcase(i_object=_noxcmd_dir.sas, i_desc=recursive call with subdirectories)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 005 recursive call with subdirectories and delimiter at end of path --------------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=recursive call with subdirectories and delimiter at end of path)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir/, i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 006 nonrecursive call with subdirectories -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=nonrecursive call with subdirectories)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck; by filename; run;  
%assertColumns(i_expected=dircheck1, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 007 nonrecursive call with wildcards -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=nonrecursive call with wildcards)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir/%str(*).dat, i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 008 recursive call with wildcards -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=recursive call with wildcards)
%_noxcmd_dir(i_path=%sysfunc(pathname(work))/testdir/%str(*).dat, i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 009 nonrecursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=nonrecursive call with wildcards and quoted path)
%_noxcmd_dir(i_path='%sysfunc(pathname(work))/testdir/*.dat', i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 010 recursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=recursive call with wildcards and quoted path)
%_noxcmd_dir(i_path='%sysfunc(pathname(work))/testdir/*.dat', i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 011 nonrecursive call with wildcards, macro function and quoted path -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=nonrecursive call with wildcards%str(,) macro function  and quoted path)
%_noxcmd_dir(i_path='%sysfunc(pathname(work))/testdir/%str(*).dat', i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 012 recursive call with wildcards, macro function and quoted path -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=recursive call with wildcards%str(,) macro function and quoted path)
%_noxcmd_dir(i_path='%sysfunc(pathname(work))/testdir/*.dat', i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 013 nonrecursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=nonrecursive call with wildcards and quoted path)
%_noxcmd_dir(i_path="%sysfunc(pathname(work))/testdir/%str(*).dat", i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck1 out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 014 recursive call with wildcards and quoted path -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=recursive call with wildcards and quoted path)
%_noxcmd_dir(i_path="%sysfunc(pathname(work))/testdir/%str(*).dat", i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains ".dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 015 nonrecursive call with specific file -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=nonrecursive call with specific file)
%_noxcmd_dir(i_path="%sysfunc(pathname(work))/testdir/file1.txt", i_recursive=0, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains "file1.txt";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

/*-- 016 nonrecursive call with specific file in subdirectory -----------------------------------*/
%initTestcase(i_object=_noxcmd_dir.sas, i_desc=nonrecursive call with specific file in subdirectory)
%_noxcmd_dir(i_path="%sysfunc(pathname(work))/testdir/one/file_one_1.dat", i_recursive=1, o_out=dir);
%endTestcall;

%assertLog(i_errors=0, i_warnings=0);
proc sort data=dir; by filename; run;
proc sort data=dircheck out=dirchecktxt; by filename; where filename contains "file_one_1.dat";run;  
%assertColumns(i_expected=dirchecktxt, i_actual=dir, i_desc=check for contents of dir file, i_fuzz=0.5)
%endTestcase;

proc datasets lib=work kill memtype=(data) nolist;
run;
quit;

%endScenario();
/** \endcond */
