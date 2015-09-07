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

/*-- simple example with sashelp.class ---------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=simple example with sashelp.class)
%let vars=%getvars(sashelp.class);
/* %endTestcall() can be omitted, will called implicitly by the first assert */
%assertEquals(i_actual=&vars, i_expected=Name Sex Age Height Weight, i_desc=Variablen prüfen)
/* %endTestcase() can be omitted, will called implicitly by the next initTestcase */

/*-- simple example with sashelp.class, different delimiter ------------------*/
%initTestcase(i_object=getvars.sas, i_desc=%str(simple example with sashelp.class, different delimiter))
%let vars=%getvars(sashelp.class,dlm=%str(,));
%assertEquals(i_actual=&vars, i_expected=%str(Name,Sex,Age,Height,Weight), i_desc=check variables)

/*-- example with variable names containing special characters ---------------*/
%initTestcase(i_object=getvars.sas, i_desc=example with variable names containing special characters)
options validvarname=any;
data test; 
   'a b c'n=1; 
   '$6789'n=2;
   ';6789'n=2;
run; 
%let vars="%getvars(test,dlm=%str(","))";
%assertEquals(i_actual=&vars, i_expected=%str("a b c","$6789",";6789"), i_desc=check variables)
%macro al;
%if &sysver=9.1 %then %do;
   %assertLog(i_warnings=1,i_desc=%str(check log, one warning due to validvarname))
   %endTestcase(i_assertLog=0) /* no assertLog */
%end;
%mend al;
%al;

/*-- example with empty dataset ----------------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=example with empty dataset)
data test; 
   stop;
run; 
%let vars=%getvars(test);
%assertEquals(i_actual=&vars, i_expected=, i_desc=no variables found)

/*-- example without dataset specified ---------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=example without dataset specified)
%let vars=%getvars();
%assertEquals(i_actual=&vars, i_expected=, i_desc=no variables found)

/*-- example with invalid dataset --------------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=example with invalid dataset)
%let vars=%getvars(xxx);
%assertEquals(i_actual=&vars, i_expected=, i_desc=example with invalid dataset)
/** \endcond */
