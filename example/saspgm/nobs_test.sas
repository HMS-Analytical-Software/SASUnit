/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests for nobs.sas

            Examplpe for a test scenario with the following features:
            - create simple test scenario
            - check value of macro symbol with assertEquals.sas

\version    \$Revision: 38 $
\author     \$Author: mangold $
\date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/example/saspgm/nobs_test.sas $
*/ /** \cond */ 

/*-- simple example with sashelp.class ---------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=simple example with sashelp.class)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=19, i_desc=number of observations in sashelp.class)
%endTestcase()

/*-- failed test -------------------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=failed test)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=20, i_desc=number of observations in dataset sashelp.class)
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
