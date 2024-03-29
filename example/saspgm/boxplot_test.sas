/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Tests for boxplot.sas

               Example for a test scenario with the following features: 
               - check reports manually with assertReport.sas with / without reference
               - various test cases with different input data
               - check error handling with assertLogMsg.sas
               - use test data in library testdata 

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

%initScenario(i_desc=Tests for boxplot.sas);

/*-- standard case without reference -----------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=standard case without reference)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report1.pdf)
%assertReport(i_actual=&g_work/report1.pdf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- standard case with reference --------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=standard case with reference)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report2.pdf)
%assertReport(i_actual=&g_work/report2.pdf, i_expected=&g_refdata\boxplot1.pdf,
              i_desc=please compare the two charts)

/*-- standard case with reference, missing values for Y ----------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=%str(standard case with reference, missing values for Y ))
data work.blood_pressure; 
   set testdata.blood_pressure; 
   output; 
   sbp=.;
   output;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report3.pdf)
%assertReport(i_actual=&g_work/report3.pdf, i_expected=&g_refdata/boxplot1.pdf,
              i_desc=%str(please compare the two charts, no changes produced by missing values in the y variable))
%assertLogMsg(i_logMsg=%str(NOTE: 240 observation\(s\) contained a MISSING value for the SBP \* Visit = Med request|NOTE: 240 Beobachtung\(en\) in fehlendem Wert enthalten f�r den Befehl SBP \* Visit = Med)
             ,i_desc=regular expression used to support different languages
             )

/*-- different scaling for x and y axis --------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=different scaling for x and y axis)
data work.blood_pressure; 
   set testdata.blood_pressure; 
   visit=visit*100; 
   sbp=sbp*100;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report4.pdf)
%assertReport(i_actual=&g_work/report4.pdf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- only two visits ---------------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=only two visits)
data work.blood_pressure; 
   set testdata.blood_pressure; 
   where visit in (1, 5);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report5.pdf)
%assertReport(i_actual=&g_work/report5.pdf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- Error: only one visit ---------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=only one visit)
data work.blood_pressure; 
   set testdata.blood_pressure; 
   where visit in (3);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report6.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: x variable must have at least two values)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report6.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- 18 visits ---------------------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=18 visits)
data work.blood_pressure; 
   set 
      testdata.blood_pressure (in=in1)
      testdata.blood_pressure (in=in2)
      testdata.blood_pressure (in=in3)
   ; 
   if in2 then visit=visit+6;
   if in3 then visit=visit+12;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report7.pdf)
%assertReport(i_actual=&g_work/report7.pdf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- Error: invalid input data set -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid input data set)
%boxplot(data=XXXXX, x=visit, y=sbp, group=med, report=&g_work/report8.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Data set XXXXX does not exist)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report8.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: input data set missing -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=input data set missing)
%boxplot(data=, x=visit, y=sbp, group=med, report=&g_work/report9.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Data set does not exist)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report9.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: invalid x variable -----------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid x variable)
%boxplot(data=testdata.blood_pressure, x=visitXXX, y=sbp, group=med, report=&g_work/report10.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable visitXXX does not exist in data set testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report10.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable missing -----------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable missing)
%boxplot(data=testdata.blood_pressure, x=, y=sbp, group=med, report=&g_work/report11.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: X variable not specified)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report11.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable not numeric -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable not numeric)
data work.blood_pressure;
   set testdata.blood_pressure; 
   visitc = put (visit, 1.);
run; 
%boxplot(data=blood_pressure, x=visitc, y=sbp, group=med, report=&g_work/report12.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable visitc in data set blood_pressure must be numeric)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report12.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable values not equidistant --------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable values not equidistant)
data work.blood_pressure;
   set testdata.blood_pressure; 
   if visit=5 then visit=6;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report13.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Values of x variable are not equidistant)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report13.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable has missing values ------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable has missing values)
data work.blood_pressure;
   set testdata.blood_pressure; 
   output; 
   visit=.; 
   output; 
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report14.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Missing values in x variable are not allowed)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report14.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: invalid y variable -----------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid y variable)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbpXXX, group=med, report=&g_work/report15.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable sbpXXX does not exist in data set testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report15.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: y variable not specified -----------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=y variable not specified)
%boxplot(data=testdata.blood_pressure, x=visit, y=, group=med, report=&g_work/report16.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Y variable not specified)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report16.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: y variable not numeric -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=y variable not numeric)
data work.blood_pressure;
   set testdata.blood_pressure; 
   sbpc = put (sbp, best32.);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbpc, group=med, report=&g_work/report17.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable sbpc in data set blood_pressure must be numeric)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report17.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: invalid group variable -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid group variable)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=medXXX, report=&g_work/report18.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable medXXX does not exist in data set testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report18.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable not specified -------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable not specified)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=, report=&g_work/report19.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Group variable not specified)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report19.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable has only one value --------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable has only one value)
data work.blood_pressure;
   set testdata.blood_pressure; 
   if med=1; 
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work/report20.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable med must have exactly two values)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report20.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable has more than two values -------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable has more than two values)
data work.blood_pressure2;
   set testdata.blood_pressure; 
   if med=1 then do; 
      output; 
      med=2; 
      output; 
   end;  
   else output;
run; 
%boxplot(data=blood_pressure2, x=visit, y=sbp, group=med, report=&g_work/report21.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable med must have exactly two values)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report21.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable has missing values --------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable has missing values)
data work.blood_pressure3;
   set testdata.blood_pressure; 
   if med=0 then do; 
      med=.; 
      output; 
   end;  
run; 
%boxplot(data=blood_pressure3, x=visit, y=sbp, group=med, report=&g_work/report22.pdf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Missing values in group variable are not allowed)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work/report22.pdf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

proc datasets lib=work nolist;
   delete blood_pressure blood_pressure2 blood_pressure3;
run;
quit;
%endScenario();
/** \endcond */