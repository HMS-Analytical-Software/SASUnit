/**
   \file
   \ingroup    SASUNIT_TEST 
   \brief      Testcall for scenario with error only in scenario log - has to fail! 1 error (file WORK.CLASS.DATA does not exist)
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   

*/ /** \cond */ 
%initScenario (i_desc=%str(Testcall for scenario with error only in scenario log - has to fail! 1 error %(file WORK.CLASS.DATA does not exist%)))

data test;
   set work.class;
run;

/*-- first call: Everthing is ok ------------------------------------*/
%initTestcase(i_object=reportSASUnit.sas, i_desc=Correct assert)
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc=everything is OK)
%endTestcase()

%endScenario();
/** \endcond */