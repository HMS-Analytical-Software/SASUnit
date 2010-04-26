/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests for boxplot.sas

            Example for a test scenario with the following features: 
            - check reports manually with assertReport.sas with / without reference
            - various test cases with different input data
            - check error handling with assertLogMsg.sas
            - use test data in library testdata 

\version    \$Revision: 38 $
\author     \$Author: mangold $
\date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/example/saspgm/boxplot_test.sas $
*/ /** \cond */ 

/*-- standard case without reference -----------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=standard case without reference)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report1.rtf)
%assertReport(i_actual=&g_work\report1.rtf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- standard case with reference --------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Standardfall mit Vergleichsstandard)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report2.rtf)
%assertReport(i_actual=&g_work\report2.rtf, i_expected=&g_refdata\boxplot1.rtf,
              i_desc=please compare the two charts)

/*-- standard case with reference, missing values for Y ----------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=%str(standard case with reference, missing values for Y ))
data blood_pressure; 
   set testdata.blood_pressure; 
   output; 
   sbp=.;
   output;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report3.rtf)
%assertReport(i_actual=&g_work\report3.rtf, i_expected=&g_refdata\boxplot1.rtf,
              i_desc=%str(please compare the two charts, no changes produced by missing values in the y variable))
%assertLogMsg(i_logMsg=%str(NOTE: 240 observation\(s\) contained a MISSING value for the SBP \* Visit = Med request))

/*-- different scaling for x and y axis --------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=different scaling for x and y axis)
data blood_pressure; 
   set testdata.blood_pressure; 
   visit=visit*100; 
   sbp=sbp*100;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report4.rtf)
%assertReport(i_actual=&g_work\report4.rtf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- only two visits ---------------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=only two visits)
data blood_pressure; 
   set testdata.blood_pressure; 
   where visit in (1, 5);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report5.rtf)
%assertReport(i_actual=&g_work\report5.rtf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- Error: only one visit ---------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=only one visit)
data blood_pressure; 
   set testdata.blood_pressure; 
   where visit in (3);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report6.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: x variable must have at least two values)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report6.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- 18 visits ---------------------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=18 visits)
data blood_pressure; 
   set 
      testdata.blood_pressure (in=in1)
      testdata.blood_pressure (in=in2)
      testdata.blood_pressure (in=in3)
   ; 
   if in2 then visit=visit+6;
   if in3 then visit=visit+12;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report7.rtf)
%assertReport(i_actual=&g_work\report7.rtf, i_expected=,
              i_desc=please compare chart with specification in source code)

/*-- Error: invalid input data set -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid input data set)
%boxplot(data=XXXXX, x=visit, y=sbp, group=med, report=&g_work\report8.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Data set XXXXX does not exist)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report8.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: input data set missing -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=input data set missing)
%boxplot(data=, x=visit, y=sbp, group=med, report=&g_work\report9.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Data set does not exist)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report9.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: invalid x variable -----------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid x variable)
%boxplot(data=testdata.blood_pressure, x=visitXXX, y=sbp, group=med, report=&g_work\report10.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable visitXXX does not exist in data set testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report10.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable missing -----------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable missing)
%boxplot(data=testdata.blood_pressure, x=, y=sbp, group=med, report=&g_work\report11.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: X variable not specified)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report11.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable not numeric -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable not numeric)
data blood_pressure;
   set testdata.blood_pressure; 
   visitc = put (visit, 1.);
run; 
%boxplot(data=blood_pressure, x=visitc, y=sbp, group=med, report=&g_work\report12.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable visitc in data set blood_pressure must be numeric)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report12.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable values not equidistant --------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable values not equidistant)
data blood_pressure;
   set testdata.blood_pressure; 
   if visit=5 then visit=6;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report13.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Values of x variable are not equidistant)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report13.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: x variable has missing values ------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=x variable has missing values)
data blood_pressure;
   set testdata.blood_pressure; 
   output; 
   visit=.; 
   output; 
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report14.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Missing values in x variable are not allowed)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report14.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: invalid y variable -----------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid y variable)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbpXXX, group=med, report=&g_work\report15.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable sbpXXX does not exist in data set testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report15.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: y variable not specified -----------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=y variable not specified)
%boxplot(data=testdata.blood_pressure, x=visit, y=, group=med, report=&g_work\report16.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Y variable not specified)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report16.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: y variable not numeric -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=y variable not numeric)
data blood_pressure;
   set testdata.blood_pressure; 
   sbpc = put (sbp, best32.);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbpc, group=med, report=&g_work\report17.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable sbpc in data set blood_pressure must be numeric)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report17.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: invalid group variable -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=invalid group variable)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=medXXX, report=&g_work\report18.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable medXXX does not exist in data set testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report18.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable not specified -------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable not specified)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=, report=&g_work\report19.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Group variable not specified)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report19.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable has only one value --------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable has only one value)
data blood_pressure;
   set testdata.blood_pressure; 
   if med=1; 
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report20.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable med must have exactly two values)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report20.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable has more than two values -------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable has more than two values)
data blood_pressure2;
   set testdata.blood_pressure; 
   if med=1 then do; 
      output; 
      med=2; 
      output; 
   end;  
   else output;
run; 
%boxplot(data=blood_pressure2, x=visit, y=sbp, group=med, report=&g_work\report21.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable med must have exactly two values)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report21.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/*-- Error: group variable has missing values --------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=group variable has missing values)
data blood_pressure3;
   set testdata.blood_pressure; 
   if med=0 then do; 
      med=.; 
      output; 
   end;  
run; 
%boxplot(data=blood_pressure3, x=visit, y=sbp, group=med, report=&g_work\report22.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Missing values in group variable are not allowed)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report22.rtf)), i_expected=0, i_desc=no report created)
%endTestcase(i_assertLog=0)

/** \endcond */
