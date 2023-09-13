/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of runSASUnit.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test New test case with reports only
         New test case with scenarios present possible?

*/ /** \cond */
%initScenario(i_desc=Test of runSASUnit.sas);
proc copy in=target out=work memtype=(DATA VIEW);
run;

%initTestcase(i_object=runSASUnit.sas, i_desc=Test with no scenarios in folder)
%_switch();
%runSASUnit(i_source     = %sysfunc(pathname(WORK))/%str(*)_test.sas
           ,i_recursive  = 0
           );
%_switch();
%endTestcall;

%assertLog    (i_errors=0, i_warnings=5);
%assertLogMsg (i_logMsg=WARNING: ----------------------);
%assertLogMsg (i_logMsg=WARNING: .NoSourceFiles. in Makro RUNSASUNIT .Condition. 0 EQ 0.);
%assertLogMsg (i_logMsg=WARNING: MessageText: Error in parameter i_source: no test scenarios found);


%endTestcase;

%endScenario();
/** \endcond */
