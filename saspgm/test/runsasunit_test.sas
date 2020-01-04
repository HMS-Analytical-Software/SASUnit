/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of runSASUnit.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

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

%assertLog    (i_errors=5, i_warnings=0);
%assertLogMsg (i_logMsg=ERROR: ----------------------);
%assertLogMsg (i_logMsg=ERROR: .NoSourceFiles. in Makro RUNSASUNIT .Condition. 0 EQ 0.);
%assertLogMsg (i_logMsg=ERROR: MessageText: Error in parameter i_source: no test scenarios found);


%endTestcase;

%endScenario();
/** \endcond */
