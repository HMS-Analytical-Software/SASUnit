/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests for regression.sas

            Example for a test scenario with the following features:
            - check reports manually agains reference standard 
            - compare results from Microsoft Excel with assertColumns.sas, using fuzz because of rounding errors 
            - use test data in library testdata

            This example test scenario runs only with SAS under SAS Microsoft Windows.

\version    \$Revision$ - KL: Removed hint "Windows only".\n
            Revision: 71 - KL: Test case can now be run under LINUX.
\author     \$Author$
\date       \$Date$
\sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

/*-- Compare linear regression between Excel and SAS -------------------------*/

%macro SetXLSType;
   %if (&sysver=9.1) %then EXCEL; %else XLS;
%mend;
proc import datafile="&g_testdata/regression.xls" dbms=%SetXLSType out=work.data replace;
   RANGE="data";
run;
data refdata (rename=(yhat=est)) testdata(drop=yhat); 
   set work.data; 
   format _all_;
run; 
proc import datafile="&g_testdata/regression.xls" dbms=%SetXLSType out=refparm replace;
   RANGE="parameters";
run;

%initTestcase(i_object=regression.sas, i_desc=compare linear regression between Excel and SAS) 
%regression(data=testdata, x=x, y=y, out=aus, yhat=est, parms=parameters, report=&g_work/report1.rtf)
%endtestcall;

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
%assertPerformance(i_expected=5, i_desc=regression calculation should be done within 5 seconds.)

/** \endcond */
