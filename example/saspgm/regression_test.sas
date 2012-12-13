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

%initTestcase(i_object=regression.sas, i_desc=Compare linear regression between Excel and SAS)

proc import datafile="&g_testdata/regression.xls" dbms=XLS out=work.data replace;
   RANGE="data";
run;
data refdata (rename=(yhat=est)) testdata(drop=yhat); 
   set work.data; 
   format _all_;
run; 
proc import datafile="&g_testdata/regression.xls" dbms=XLS out=refparm replace;
   RANGE="parameters";
run;
   
%regression(data=testdata, x=x, y=y, out=aus, yhat=est, parms=parameters, report=&g_work/report1.rtf)

proc sql noprint; 
   select intercept into :intercept_sas from parameters; 
   select put (x, best12.) into :slope_sas from parameters; 
   select put (e, best12.) into :slope_xls from refparm; 
   select f into :intercept_xls from refparm; 
quit; 

%assertReport(i_actual=&g_work/report1.rtf, i_expected=&g_testdata/regression.xls,
              i_desc=please compare SAS chart with Excel chart)

%assertColumns(i_actual=aus, i_expected=refdata, i_desc=compare estimated values, i_fuzz=1E-10)

%assertEquals(i_actual=&intercept_xls, i_expected=&intercept_sas, i_desc=compare intercept parameter)
%assertEquals(i_actual=&slope_xls, i_expected=&slope_sas, i_desc=compare slope parameter)
%assertPerformance(i_expected=5, i_desc=Comparison should be done within 5 seconds.)

/** \endcond */
