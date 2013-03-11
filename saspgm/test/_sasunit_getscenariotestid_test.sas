/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_getScenarioTestId.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
      
*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with missing parameters);

%_sasunit_getScenarioTestId();

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Please specify a value for i_scnid.);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with missing parameter o_casid);

%_sasunit_getScenarioTestId(i_scnid=1);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Please specify a value for o_casid.);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with missing parameter o_tstid);

%_sasunit_getScenarioTestId(i_scnid=1, o_casid=hugo);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Please specify a value for o_tstid.);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with undeclared parameter o_casid);

%_sasunit_getScenarioTestId(i_scnid=1, o_casid=hugo, o_tstid=fritz);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Macrovariable for return of test case id was not declared by a .local-statement.);

%endTestcase();

%global r_casid;
*** Testcase 5 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with undeclared parameter o_tstid);

%_sasunit_getScenarioTestId(i_scnid=1, o_casid=r_casid, o_tstid=fritz);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Macrovariable for return of test assert id was not declared by a .local-statement.);

%endTestcase();

%global r_tstid;
*** Testcase 6 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with invalid i_libref);

%_sasunit_getScenarioTestId(i_scnid=1, o_casid=r_casid, o_tstid=r_tstid, i_libref=hugo);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Libref hugo was not assigned. Start this macro only within SASUnit.);

%endTestcase();

*** Testcase 7 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with inexisting tables cas);

%_sasunit_getScenarioTestId(i_scnid=1, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Table WORK.cas does not exist. Start this macro only within SASUnit.);

%endTestcase();

data work.cas;
   num=0;
run;
*** Testcase 8 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with inexisting tables tst);

%_sasunit_getScenarioTestId(i_scnid=1, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: Table WORK.tst does not exist. Start this macro only within SASUnit.);

%endTestcase();

data work.tst;
   num=0;
run;
*** Testcase 9 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with invalid dataset cas);

%_sasunit_getScenarioTestId(i_scnid=11, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=2,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=_ERROR_, i_desc=Values must be equal);
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
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with inexisting scenario);

%_sasunit_getScenarioTestId(i_scnid=11, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=_ERROR_,i_desc=Check that error occured);

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
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call with existing scenario without asserts);

%_sasunit_getScenarioTestId(i_scnid=3, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=3, i_desc=Values must be equal);
%assertEquals (i_actual=&r_tstid.,i_expected=1, i_desc=Values must be equal);

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
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call for existing scenario 1);

%_sasunit_getScenarioTestId(i_scnid=1, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=1, i_desc=Values must be equal);
%assertEquals (i_actual=&r_tstid.,i_expected=2, i_desc=Values must be equal);

%endTestcase();

*** Testcase 13 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call for existing scenario 2);

%_sasunit_getScenarioTestId(i_scnid=2, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=2, i_desc=Values must be equal);
%assertEquals (i_actual=&r_tstid.,i_expected=3, i_desc=Values must be equal);

%endTestcase();

*** Testcase 14 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call for existing scenario 3);

%_sasunit_getScenarioTestId(i_scnid=3, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=3, i_desc=Values must be equal);
%assertEquals (i_actual=&r_tstid.,i_expected=4, i_desc=Values must be equal);

%endTestcase();

*** Testcase 15 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call for existing scenario 4);

%_sasunit_getScenarioTestId(i_scnid=4, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=4, i_desc=Values must be equal);
%assertEquals (i_actual=&r_tstid.,i_expected=5, i_desc=Values must be equal);

%endTestcase();

*** Testcase 16 ***; 
%initTestcase(i_object=_sasunit_getScenarioTestId.sas, i_desc=call for existing scenario 5);

%_sasunit_getScenarioTestId(i_scnid=5, o_casid=r_casid, o_tstid=r_tstid, i_libref=WORK);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals (i_actual=&r_casid.,i_expected=5, i_desc=Values must be equal);
%assertEquals (i_actual=&r_tstid.,i_expected=6, i_desc=Values must be equal);

%endTestcase();

/** \endcond */
