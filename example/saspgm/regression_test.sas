/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests for regression.sas (Windows only)

            Example for a test scenario with the following features:
            - check reports manually agains reference standard 
            - compare results from Microsoft Excel with assertColumns.sas, using fuzz because of rounding errors 
            - use test data in library testdata

            This example test scenario runs only with SAS under SAS Microsoft Windows.

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
*/ /** \cond */ 

/*-- Compare linear regression between Excel and SAS -------------------------*/

%macro onlywin;
%if &sysscp ne WIN %then %do;
   %initTestcase(i_object=regression.sas, i_desc=This test scenario will only run under SAS for Windows)
   endsas;
%end;
%else %do;
   %initTestcase(i_object=regression.sas, i_desc=Compare linear regression between Excel and SAS)
%end;
%mend onlywin;
%onlywin;

%global _g_ExcelEngine;
%let _g_ExcelEngine =excel;
%macro CheckFor64Bits;
   %if (&sysaddrbits=64) %then %do;
      %let _g_ExcelEngine =%str(pcfiles type=excel path=);
   %end;
%mend;
%CheckFor64Bits;
libname testdata &_g_ExcelEngine. "&g_testdata/regression.xls";
data refdata (rename=(yhat=est)) testdata(drop=yhat); 
   set testdata.data; 
run; 
data refparm; 
   set testdata.parameters;
run; 
libname testdata;
   
%regression(data=testdata, x=x, y=y, out=aus, yhat=est, parms=parameters, report=&g_work\report1.rtf)

proc sql noprint; 
   select intercept into :intercept_sas from parameters; 
   select x into :slope_sas from parameters; 
   select f1 into :slope_xls from refparm; 
   select f2 into :intercept_xls from refparm; 
quit; 

%assertReport(i_actual=&g_work/report1.rtf, i_expected=&g_testdata/regression.xls,
              i_desc=please compare SAS chart with Excel chart)

%assertColumns(i_actual=aus, i_expected=refdata, i_desc=compare estimated values, i_fuzz=1E-10)

%assertEquals(i_actual=&intercept_xls, i_expected=&intercept_sas, i_desc=compare intercept parameter)
%assertEquals(i_actual=&slope_xls, i_expected=&slope_sas, i_desc=compare slope parameter)
%assertPerformance(i_expected=3, i_desc=Comparison should be done within 5 seconds.)

/** \endcond */
