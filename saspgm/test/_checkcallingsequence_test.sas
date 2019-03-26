/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _checkCallingSequence.sas

   \version    \$Revision: 314 $
   \author     \$Author: klandwich $
   \date       \$Date: 2014-02-15 10:57:09 +0100 (Sa, 15 Feb 2014) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_checklog_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _checkCallingSequence.sas);

%global g_inScenario g_inTestCase g_inTestCall;

%initTestCase (i_object=_checkCallingSequence.sas
              ,i_desc=Test cases for parameters
              );
%endTestCall;
%assertEquals (i_expected=-1
              ,i_actual  =%_checkCallingSequence(i_callerType=Hugo)
              ,i_desc    =Call with invalid callerType
              );
%endTestCase;

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

%endScenario;
/** \endcond */
