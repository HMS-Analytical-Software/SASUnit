/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _readdirfile.sas

   \version    \$Revision: 535 $
   \author     \$Author: klandwich $
   \date       \$Date: 2017-09-21 14:15:47 +0200 (Do, 21 Sep 2017) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_dir_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _readdirfile.sas)

/*-- 001 german windows mapped drive ----------------------------------------------*/
proc import 
   datafile="&g_refdata./german_drive_refdata.txt" 
   out=work._german_drive_refdata dbms=CSV 
   replace;

   delimiter = ";";
run;
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=german windows mapped drive
             )
%_readdirfile (i_dirfile =&g_testdata./dir_german_drive.txt
              ,i_encoding=pcoem850
              ,o_out     =work.german_drive
              );
%endTestcall;

data work.german_drive_refdata;
   length membername filename $255;
   set work._german_drive_refdata;
   format _all_;
   informat _all_;
   format changed datetime20.;
run;

%assertColumns(i_expected=work.german_drive_refdata
              ,i_actual=work.german_drive
              ,i_desc=reading german output with mapped drive
              )
%endTestcase;

/*-- 002 german windows unc path ----------------------------------------------*/
proc import 
   datafile="&g_refdata./german_unc_refdata.txt" 
   out=work._german_unc_refdata dbms=CSV 
   replace;

   delimiter = ";";
run;
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=german windows unc path
             )
%_readdirfile (i_dirfile =&g_testdata./dir_german_unc.txt
              ,i_encoding=pcoem850
              ,o_out     =work.german_unc
              );
%endTestcall;

data work.german_unc_refdata;
   length membername filename $255;
   set work._german_unc_refdata;
   format _all_;
   informat _all_;
   format changed datetime20.;
run;

%assertColumns(i_expected=work.german_unc_refdata
              ,i_actual=work.german_unc
              ,i_desc=reading german output with mapped drive
              )
%endTestcase;

/*-- 003 english windows mapped drive ----------------------------------------------*/
proc import 
   datafile="&g_refdata./english_drive_refdata.txt" 
   out=work._english_drive_refdata dbms=CSV 
   replace;

   delimiter = ";";
run;
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=english windows mapped drive
             )
%_readdirfile (i_dirfile =&g_testdata./dir_english_drive.txt
              ,i_encoding=pcoem850
              ,o_out     =work.english_drive
              );
%endTestcall;

data work.english_drive_refdata;
   length membername filename $255;
   set work._english_drive_refdata;
   format _all_;
   informat _all_;
   format changed datetime20.;
run;

%assertColumns(i_expected=work.english_drive_refdata
              ,i_actual=work.english_drive
              ,i_desc=reading english output with mapped drive
              )
%endTestcase;

/*-- 004 english windows unc path ----------------------------------------------*/
proc import 
   datafile="&g_refdata./english_unc_refdata.txt" 
   out=work._english_unc_refdata dbms=CSV 
   replace;

   delimiter = ";";
run;
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=english windows unc path
             )
%_readdirfile (i_dirfile =&g_testdata./dir_english_unc.txt
              ,i_encoding=pcoem850
              ,o_out     =work.english_unc
              );
%endTestcall;

data work.english_unc_refdata;
   length membername filename $255;
   set work._english_unc_refdata;
   format _all_;
   informat _all_;
   format changed datetime20.;
run;

%assertColumns(i_expected=work.english_unc_refdata
              ,i_actual=work.english_unc
              ,i_desc=reading english output with unc path
              )
%endTestcase;

/*-- 005 hungarian windows mapped drive ----------------------------------------------*/
proc import 
   datafile="&g_refdata./hungarian_drive_refdata.txt" 
   out=work._hungarian_drive_refdata dbms=CSV 
   replace;

   delimiter = ";";
run;
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=hungarian windows mapped drive
             )
%_readdirfile (i_dirfile =&g_testdata./dir_hungarian_drive.txt
              ,i_encoding=pcoem850
              ,o_out     =work.hungarian_drive
              );
%endTestcall;

data work.hungarian_drive_refdata;
   length membername filename $255;
   set work._hungarian_drive_refdata;
   format _all_;
   informat _all_;
   format changed datetime20.;
run;

%assertColumns(i_expected=work.hungarian_drive_refdata
              ,i_actual=work.hungarian_drive
              ,i_desc=reading hungarian output with mapped drive
              )
%endTestcase;

/*-- 006 hungarian windows unc path ----------------------------------------------*/
proc import 
   datafile="&g_refdata./hungarian_unc_refdata.txt" 
   out=work._hungarian_unc_refdata dbms=CSV 
   replace;

   delimiter = ";";
run;
%initTestcase(i_object=_readdirfile.sas
             ,i_desc=hungarian windows unc path
             )
%_readdirfile (i_dirfile =&g_testdata./dir_hungarian_unc.txt
              ,i_encoding=pcoem850
              ,o_out     =work.hungarian_unc
              );
%endTestcall;

data work.hungarian_unc_refdata;
   length membername filename $255;
   set work._hungarian_unc_refdata;
   format _all_;
   informat _all_;
   format changed datetime20.;
run;

%assertColumns(i_expected=work.hungarian_unc_refdata
              ,i_actual=work.hungarian_unc
              ,i_desc=reading hungarian output with unc path
              )
%endTestcase;

proc datasets lib=work nolist;
   delete 
      german_drive
      german_drive_refdata
      _german_drive_refdata
      german_unc
      german_unc_refdata
      _german_unc_refdata
      english_drive
      english_drive_refdata
      _english_drive_refdata
      english_unc
      english_unc_refdata
      _english_unc_refdata
      hungarian_drive
      hungarian_drive_refdata
      _hungarian_drive_refdata
      hungarian_unc
      hungarian_unc_refdata
      _hungarian_unc_refdata
   ;
run;
quit;

%endScenario();
/** \endcond */
