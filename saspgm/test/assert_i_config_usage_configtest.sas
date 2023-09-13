/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for use of config file

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ 
/** \cond */ 

%let old_sasautos=%sysfunc(getoption(SASAUTOS));
/* test case 1 ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=special config should be used);

proc options;
run;

%endTestcall()

%assertEquals (i_expected=Test for i_config, i_actual=&HUGO, i_desc=must be equal);
%assertLogMsg (i_logMsg  =config_for_testing.cfg);
%assertLogMsg (i_logMsg  =autoexec_for_config_test.sas);

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/* test case 2 ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=special config should be used);

options sasautos=(SASAUTOS "\TEMP\HUGO" "\TEMP\FRITZ");

proc options;
run;

options sasautos=&old_sasautos.;
%endTestcall()

%assertLogMsg (i_logMsg  =SASAUTOS=.+\\TEMP1\\HUGO,  i_not=1);
%assertLogMsg (i_logMsg  =SASAUTOS=.+\\TEMP1\\FRITZ, i_not=1);
%assertLogMsg (i_logMsg  =SASAUTOS=.+\\TEMP\\HUGO);
%assertLogMsg (i_logMsg  =SASAUTOS=.+\\TEMP\\FRITZ);

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

%endScenario();
/** \endcond */