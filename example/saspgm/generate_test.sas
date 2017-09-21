/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for generate.sas

               Example for a test scenario with the following features:
               - generate test data as part of the test scenario
               - compare whole library with assertLibrary.sas 
               - generate various test cases
               - check error handling with assertLogMsg.sas
               - suppress automatic log scanning in endTestcase.sas

   \version    \$Revision$ - KL: Added hint for support of different languages in test assertion.\n
               Revision: 40 - KL: Added support for different languages in test assertion.
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */ 

%initScenario(i_desc=Tests for generate.sas);

/*-- Testcase 1: one by variable ---------------------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=example with one by variable)

/* assign two temporary librefs */
%_mkdir(&g_work/test1)
libname test1 "&g_work/test1";
%_mkdir(&g_work/test2)
libname test2 "&g_work/test2";

proc sort data=sashelp.class out=test2.class1 (label="Dataset for sex=F (9 observations)");
   by sex;
   where sex='F';
run;
proc sort data=sashelp.class out=test2.class2 (label="Dataset for sex=M (10 observations)");
   by sex;
   where sex='M';
run;
   
%generate(data=sashelp.class, by=sex, out=test1.class)
%endTestcall()
%assertLibrary(i_actual=test1, i_expected=test2, i_desc=check libraries)
%endTestcase() /* assertLog is called implicitly */

/*-- Testcase 2: two by variables --------------------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=example with two by variables)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
proc sort data=sashelp.prdsale out=test2.prdsale1 (label="Dataset for region=EAST, year=1993 (360 observations)");
   by region year;
   where region="EAST" and year=1993;
run;
proc sort data=sashelp.prdsale out=test2.prdsale2 (label="Dataset for region=EAST, year=1994 (360 observations)");
   by region year;
   where region="EAST" and year=1994;
run;
proc sort data=sashelp.prdsale out=test2.prdsale3 (label="Dataset for region=WEST, year=1993 (360 observations)");
   by region year;
   where region="WEST" and year=1993;
run;
proc sort data=sashelp.prdsale out=test2.prdsale4 (label="Dataset for region=WEST, year=1994 (360 observations)");
   by region year;
   where region="WEST" and year=1994;
run;
%generate(data=sashelp.prdsale, by=region year, out=test1.prdsale)
%endTestcall()
%assertLibrary(i_actual=test1, i_expected=test2, i_desc=check libraries)
%endTestcase() 

/*-- Testcase 3: one by variable with only one value -------------------------*/
%initTestcase(i_object=generate.sas, i_desc=example with one by variable with only one value)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
/* create input dataset */
proc sort data=sashelp.class out=class;
   by sex;
   where sex='F';
run;
/* create expected output dataset */
proc sort data=sashelp.class out=test2.class1 (label="Dataset for sex=F (9 observations)");
   by sex;
   where sex='F';
run;
%generate(data=class, by=sex, out=test1.class)
%endTestcall()
%assertLibrary(i_actual=test1, i_expected=test2, i_desc=check libraries)
%endTestcase() 

/*-- Testcase 4: invalid dataset ---------------------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=invalid dataset)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
%generate(data=sashelp.classXXX, by=sex, out=test1.class)
%endTestcall()
%assertLogMsg(i_logMsg=ERROR: Macro Generate: data= or by= specified incorrectly)
%endTestcase(i_assertLog=0)

/*-- Testcase 5: invalid by variable -----------------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=invalid by variable)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
%generate(data=sashelp.class, by=sexXXX, out=test1.class)
%endTestcall()
%assertLogMsg(i_logMsg=ERROR: Macro Generate: data= or by= specified incorrectly)
%endTestcase(i_assertLog=0)

/*-- Testcase 6: invalid output library --------------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=invalid output library)
proc datasets lib=test1 nolist kill;
quit;    
proc datasets lib=test2 nolist kill;
quit; 
%generate(data=sashelp.class, by=sex, out=test3.class)
%endTestcall()
%assertLogMsg(i_logMsg=ERROR: (Libname|Libref) TEST3 is not assigned|ERROR: (Libname|Libref) TEST3 ist nicht zugewiesen
             ,i_desc=regular expression used to support different languages
             )
%endTestcase(i_assertLog=0)

libname test1;
libname test2;


%endScenario();
/** \endcond */