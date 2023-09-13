/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for use of autoexec file

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

%initScenario(i_desc =Tests for use of autoexec file);

/* test case 1 ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=special autoexec should be used);

proc options;
run;

%endTestcall()

%assertEquals (i_expected=Test for i_autoexec, i_actual=&HUGO, i_desc=must be equal);
%assertLogMsg (i_logMsg  =autoexec_for_autoexec_test.sas);

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

%endScenario();
/** \endcond */