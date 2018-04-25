/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for getvars.sas

               Example for a test scenario with the following features:
               - check value of macro symbol with assertEquals.sas
               - scan log with assertLog.sas
               - omit endTestcall.sas and endTestcase.sas
               - check for special cases

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

%initScenario(i_desc=Tests for getvars.sas);

/*-- simple example with sashelp.class ---------------------------------------*/
%macro testcase(i_object=getvars.sas, i_desc=%str(simple example with sashelp.class));
   /* setup environment for test call */

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %let vars=%getvars(sashelp.class);
   %endTestcall()

   /* assert */
   %assertEquals(i_actual=&vars, i_expected=Name Sex Age Height Weight, i_desc=Variablen prüfen)

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

/*-- simple example with sashelp.class, different delimiter ------------------*/
%macro testcase(i_object=getvars.sas, i_desc=%str(simple example with sashelp.class, different delimiter));
   /* setup environment for test call */

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %let vars=%getvars(sashelp.class,dlm=%str(,));
   %endTestcall()

   /* assert */
   %assertEquals(i_actual=&vars, i_expected=%str(Name,Sex,Age,Height,Weight), i_desc=check variables)

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

/*-- example with variable names containing special characters ---------------*/
%macro testcase(i_object=getvars.sas, i_desc=%str(example with variable names containing special characters));

   /* setup environment for test call */
   options validvarname=any;
   data work.test; 
      'a b c'n=1; 
      '$6789'n=2;
      ';6789'n=2;
   run; 

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %let vars="%getvars(test,dlm=%str(%",%"))";
   %endTestcall()

   /* assert */
   %assertEquals(i_actual=&vars., i_expected=%str("a b c","$6789",";6789"), i_desc=check variables)

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

/*-- example with empty dataset ----------------------------------------------*/
%macro testcase(i_object=getvars.sas, i_desc=%str(example with empty dataset));
   /* setup environment for test call */
   data work.test; 
      stop;
   run; 

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %let vars=%getvars(test);
   %endTestcall()

   /* assert */
   %assertEquals(i_actual=&vars, i_expected=, i_desc=no variables found)

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

/*-- example without dataset specified ---------------------------------------*/
%macro testcase(i_object=getvars.sas, i_desc=%str(example without dataset specified));
   /* setup environment for test call */

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %let vars=%getvars();
   %endTestcall()

   /* assert */
   %assertEquals(i_actual=&vars, i_expected=, i_desc=no variables found)

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;


/*-- example with invalid dataset --------------------------------------------*/
%macro testcase(i_object=getvars.sas, i_desc=%str(example with invalid dataset));
   /* setup environment for test call */

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %let vars=%getvars(xxx);
   %endTestcall()

   /* assert */
   %assertEquals(i_actual=&vars, i_expected=, i_desc=example with invalid dataset)

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

proc delete data=work.test;
run;
%endScenario();
/** \endcond */