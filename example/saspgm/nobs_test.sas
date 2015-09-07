/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for nobs.sas - has to fail!

               Examplpe for a test scenario with the following features:
               - create simple test scenario
               - check value of macro symbol with assertEquals.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */ 

/*-- simple example with sashelp.class ---------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=simple example with sashelp.class)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=19, i_desc=number of observations in sashelp.class)
%endTestcase()

/*-- failed test -------------------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=failed test - must be red!)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=20, i_desc=number of observations in dataset sashelp.class - must be red!)
%endTestcase()

/*-- example with big dataset ------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(example with big dataset))
data big;
   do i=1 to 1000000;
      x=ranuni(0);
      output; 
   end;
run; 
%let nobs=%nobs(big);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=1000000, i_desc=number of observations in dataset work.big)
%endTestcase()

/*-- example with empty dataset ----------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(example with empty dataset))
data empty;
   stop; 
run; 
%let nobs=%nobs(empty);
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

/** \endcond */
