/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createExamineeTable.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _createExamineeTable.sas);

data work.exa;
   set target.exa;
   stop;
run;
data work.exa_expected;
   set target.exa (where=(exa_auton>=2));
run;

%initTestcase(i_object=_createExamineeTable.sas, i_desc=Test with correct call);

%_switch();
%let g_root=&save_root.;
%_createExamineeTable;
%_switch();

%endTestcall;

%assertColumns(i_expected=work.exa_expected
              ,i_actual  =work.exa
              ,i_desc    =Identical except test coverage
              ,i_exclude =exa_tcg_pct
              );
%endTestcase;

proc datasets lib=work nolist;
   delete exa;
run;quit;

%endScenario();

/** \endcond */
