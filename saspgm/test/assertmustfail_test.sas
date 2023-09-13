/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Test of macro assertMustFail

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */

%initScenario(i_desc =Test of macro assertMustFail);

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
%_switch();
%assertMustFail;
/*-- switch to real database -----------------------*/
%_switch();

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
%_switch();
%assertMustFail;
/*-- switch to real database -----------------------*/
%_switch();

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
%_switch();
%assertMustFail;
/*-- switch to real database -----------------------*/
%_switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns(i_expected=work.expected, i_actual=work.tst);
%endTestcase();

%endScenario();
/** \endcond */