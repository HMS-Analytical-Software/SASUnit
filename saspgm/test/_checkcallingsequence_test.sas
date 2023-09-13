/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _checkCallingSequence.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _checkCallingSequence.sas);

%global g_inScenario g_inTestCase g_inTestCall;

%let g_currentLogger = &g_assertLogger.;

%initTestCase (i_object=_checkCallingSequence.sas
              ,i_desc=Test cases for parameters
              );
%put &=g_scnid.;
%endTestCall();
%put &=g_scnid.;
%assertEquals (i_expected=-1
              ,i_actual  =%_checkCallingSequence(i_callerType=Hugo)
              ,i_desc    =Call with invalid callerType
              );
%put &=g_scnid.;
%endTestCase();
%put &=g_scnid.;

%initTestCase (i_object=_checkCallingSequence.sas
              ,i_desc=Test cases for scenarios
              );
/* save values */
%let l_inScenario =&g_inScenario.;
%let l_inTestCase =&g_inTestCase.;
%let l_inTestCall =&g_inTestCall.;

/* set test values */
%let g_inScenario=0;
%let g_inTestCase=0;
%let g_inTestCall=0;
%let l_actual_ok=%_checkCallingSequence(i_callerType=Scenario);

/* set test values */
%let g_inScenario=1;
%let g_inTestCall=1;
%let g_inTestCase=1;
%let l_actual_twice=%_checkCallingSequence(i_callerType=Scenario);

/* set test values */
%let g_inScenario=0;
%let g_inTestCall=1;
%let g_inTestCase=1;
%let l_actual_testcall=%_checkCallingSequence(i_callerType=Scenario);

/* set test values */
%let g_inScenario=0;
%let g_inTestCall=0;
%let g_inTestCase=1;
%let l_actual_testcase=%_checkCallingSequence(i_callerType=Scenario);

%let g_inScenario =&l_inScenario.;
%let g_inTestCase =&l_inTestCase.;
%let g_inTestCall =&l_inTestCall.;
%endTestCall;
%assertEquals (i_expected=0
              ,i_actual  =&l_actual_ok.
              ,i_desc    =Test cases with scenarios %str(%()every thing is okay%str(%))
              );
%assertEquals (i_expected=1
              ,i_actual  =&l_actual_twice.
              ,i_desc    =Test cases with scenarios %str(%()initScenario is called twice%str(%))
              );
%assertLogMsg (i_logMsg  =initScenario must not be called twice!
              );
%assertEquals (i_expected=1
              ,i_actual  =&l_actual_testcall.
              ,i_desc    =Test cases with scenarios %str(%()Scenario is called within test call%str(%))
              );
%assertLogMsg (i_logMsg  =initScenario must not be called within a test call!
              );

%assertEquals (i_expected=1
              ,i_actual  =&l_actual_testcase.
              ,i_desc    =Test cases with scenarios %str(%()Scenario is called within test case%str(%))
              );
%assertLogMsg (i_logMsg  =initScenario must not be called within a test case!
              );
%assertLog    (i_errors=3
              ,i_warnings=0
              );
%endTestCase;


%initTestCase (i_object=_checkCallingSequence.sas
              ,i_desc=Test cases for asserts
              );
/* save values */
%let l_inScenario =&g_inScenario.;
%let l_inTestCase =&g_inTestCase.;

/* set test values */
%let l_actual_ok=%_checkCallingSequence(i_callerType=Assert);

/* set test values */
%let g_inScenario=0;
%let g_inTestCase=1;
%let l_actual_scenario=%_checkCallingSequence(i_callerType=Assert);

/* set test values */
%let g_inScenario=1;
%let g_inTestCase=0;
%let l_actual_testcase=%_checkCallingSequence(i_callerType=Assert);

%let g_inScenario =&l_inScenario.;
%let g_inTestCase =&l_inTestCase.;
%endTestCall;
%assertEquals (i_expected=0
              ,i_actual  =&l_actual_ok.
              ,i_desc    =Test cases with asserts %str(%()every thing is okay%str(%))
              );
%assertEquals (i_expected=1
              ,i_actual  =&l_actual_scenario.
              ,i_desc    =Test cases with asserts %str(%()Must be called after initScenario%str(%))
              );
%assertLogMsg (i_logMsg  =Assert must be called after initScenario!
              );
%assertEquals (i_expected=1
              ,i_actual  =&l_actual_testcase.
              ,i_desc    =Test cases with asserts %str(%()Scenario is called within test case%str(%))
              );
%assertLogMsg (i_logMsg  =Assert must be called after initTestCase!
              );
%assertLog    (i_errors=2
              ,i_warnings=0
              );
%endTestCase;

%endScenario();
/** \endcond */
