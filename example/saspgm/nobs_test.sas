/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for nobs.sas - has to fail!

               Example for a test scenario with the following features:
               - create simple test scenario
               - check value of macro symbol with assertEquals.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

%initScenario(i_desc=Tests for nobs.sas - has to fail!);

/*-- simple example with sashelp.class ---------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=simple example with sashelp.class)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=19, i_desc=number of observations in sashelp.class)
%assertLogMsg (i_logMsg=.let nobs=.nobs.sashelp.class.);
%endTestcase()

/*-- failed test -------------------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=failed test - must be red!)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=20, i_desc=number of observations in dataset sashelp.class - must be red!)
%endTestcase()

/*-- example with big dataset ------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(example with big dataset))
data work.big;
   do i=1 to 1000000;
      x=ranuni(0);
      output; 
   end;
run; 
%let nobs=%nobs(work.big);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=1000000, i_desc=number of observations in dataset work.big)
%endTestcase()

/*-- example with empty dataset ----------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(example with empty dataset))
data work.empty;
   stop; 
run; 
%let nobs=%nobs(work.empty);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=0, i_desc=number of observations in dataset work.empty)
%endTestcase()

/*-- dataset not specified ---------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(dataset not specified))
%let nobs=%nobs(xxx);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=, i_desc=number of observations when dataset is not specified)
%endTestcase()

/*-- invalid dataset ---------------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(invalid dataset))
%let nobs=%nobs(xxx);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=, i_desc=number of observations with invalid dataset)
%endTestcase()

proc datasets lib=work memtype=DATA nolist;
   delete big empty;
run;quit;

%endScenario();
/** \endcond */