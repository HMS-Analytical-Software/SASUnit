/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _getScenarioTestId.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/*-- switch between example database and real database -----------------------*/
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

*** Testcase 1 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with missing parameters);

%_getScenarioTestId();

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Please specify a value for i_scnid.);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with missing parameter r_casid);

%_getScenarioTestId(i_scnid=1);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Please specify a value for r_casid.);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with missing parameter r_tstid);

%_getScenarioTestId(i_scnid=1, r_casid=hugo);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Please specify a value for r_tstid.);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with undeclared parameter r_casid);

%_getScenarioTestId(i_scnid=1, r_casid=hugo, r_tstid=fritz);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Macrovariable for return of test case id was not declared by a .local-statement.);

%endTestcase();

%global ret_casid;
*** Testcase 5 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with undeclared parameter r_tstid);

%_getScenarioTestId(i_scnid=1, r_casid=ret_casid, r_tstid=fritz);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Macrovariable for return of test assert id was not declared by a .local-statement.);

%endTestcase();

%global ret_tstid;

*** Testcase 7 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with inexisting tables cas);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=1, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Table target.cas does not exist. Start this macro only within SASUnit.);

%endTestcase();

data work.cas;
   num=0;
run;
*** Testcase 8 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with inexisting tables tst);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=1, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Table target.tst does not exist. Start this macro only within SASUnit.);

%endTestcase();

data work.tst;
   num=0;
run;
*** Testcase 9 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with invalid dataset cas);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=11, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=2,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=_ERROR_, i_desc=Values must be equal);
%assertLogmsg (i_logmsg=ERROR: Scenario was not found in the test database.);
%assertLogmsg (i_logmsg=Assert may not be called prior to initTestcase.);


%endTestcase();

data work.cas;
   do cas_scnid=1 to 5;
      do cas_id=1 to cas_scnid;
         output;
      end;
   end;
run;
*** Testcase 10 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with inexisting scenario);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=11, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=_ERROR_,i_desc=Check that error occured);

%endTestcase();

data work.tst;
   do tst_scnid=1 to 5;
      do tst_casid=1 to tst_scnid;
         tst_id=.;
         output;
      end;
   end;
run;
*** Testcase 11 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call with existing scenario without asserts);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=3, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=3, i_desc=Values must be equal);
%assertEquals (i_actual=&ret_tstid.,i_expected=1, i_desc=Values must be equal);

%endTestcase();

data work.tst;
   do tst_scnid=1 to 5;
      do tst_casid=1 to tst_scnid;
         do tst_id=1 to tst_scnid;
            output;
         end;
      end;
   end;
run;
*** Testcase 12 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call for existing scenario 1);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=1, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=1, i_desc=Values must be equal);
%assertEquals (i_actual=&ret_tstid.,i_expected=2, i_desc=Values must be equal);

%endTestcase();

*** Testcase 13 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call for existing scenario 2);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=2, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=2, i_desc=Values must be equal);
%assertEquals (i_actual=&ret_tstid.,i_expected=3, i_desc=Values must be equal);

%endTestcase();

*** Testcase 14 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call for existing scenario 3);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=3, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=3, i_desc=Values must be equal);
%assertEquals (i_actual=&ret_tstid.,i_expected=4, i_desc=Values must be equal);

%endTestcase();

*** Testcase 15 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call for existing scenario 4);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=4, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=4, i_desc=Values must be equal);
%assertEquals (i_actual=&ret_tstid.,i_expected=5, i_desc=Values must be equal);

%endTestcase();

*** Testcase 16 ***; 
%initTestcase(i_object=_getScenarioTestId.sas, i_desc=call for existing scenario 5);

/*-- switch to example database -----------------------*/
%switch();
%_getScenarioTestId(i_scnid=5, r_casid=ret_casid, r_tstid=ret_tstid);
/*-- switch to real database -----------------------*/
%switch();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&ret_casid.,i_expected=5, i_desc=Values must be equal);
%assertEquals (i_actual=&ret_tstid.,i_expected=6, i_desc=Values must be equal);

%endTestcase();

/** \endcond */
