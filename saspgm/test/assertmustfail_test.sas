/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Tests for macro assertMustFail

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */

%macro switch();
%global state save_root save_target;
%if &state= or &state=0 %then %do;
   %let state=1;
   %let save_root=&g_root;
   %let save_target=&g_target;
   %let g_root=&g_work;
   %let g_target=&g_work;
%end;
%else %do;
   %let state=0;
   %let g_root=&save_root;
   %let g_target=&save_target;
%end;
libname target "&g_target";
%mend switch;
data work.cas;
   cas_scnid=&g_scnid.;
   cas_id=4;
   output;
run;
data work.scn;
   scn_scnid=&g_scnid.;
   output;
run;

%*** Testcase 1 ***;
data work.tst;
   tst_scnid=&g_scnid.;
   tst_casid=4;
   tst_id=4;
   tst_res=2;
   output;
run;
data work.expected;
   set work.tst;
   tst_res=0;
run;
%initTestcase(i_object=assertMustFail.sas, i_desc=call with failed assert);

/*-- switch to example database -----------------------*/
%switch();
%assertMustFail;
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns(i_expected=work.expected, i_actual=work.tst);
%endTestcase();

%*** Testcase 2 ***;
data work.tst;
   tst_scnid=&g_scnid.;
   tst_casid=4;
   tst_id=4;
   tst_res=1;
   output;
run;
data work.expected;
   set work.tst;
   tst_res=2;
run;
%initTestcase(i_object=assertMustFail.sas, i_desc=call with manual assert);

/*-- switch to example database -----------------------*/
%switch();
%assertMustFail;
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns(i_expected=work.expected, i_actual=work.tst);
%endTestcase();

%*** Testcase 3 ***;
data work.tst;
   tst_scnid=&g_scnid.;
   tst_casid=4;
   tst_id=4;
   tst_res=0;
   output;
run;
data work.expected;
   set work.tst;
   tst_res=2;
run;
%initTestcase(i_object=assertMustFail.sas, i_desc=call with green assert);

/*-- switch to example database -----------------------*/
%switch();
%assertMustFail;
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns(i_expected=work.expected, i_actual=work.tst);
%endTestcase();

/** \endcond */