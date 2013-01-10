/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for use of config file

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ 
/** \cond */ 

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

/** \endcond */ 
