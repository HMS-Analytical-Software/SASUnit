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

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/ /** \cond */ 

/*-- Compare linear regression between Excel and SAS -------------------------*/

%initScenario(i_desc=Tests for regression.sas);

%macro SetXLSType;
   %if (&sysver=9.1) %then EXCEL; %else XLS;
%mend;
proc import datafile="&g_testdata/regression.xls" dbms=%SetXLSType out=work.data replace;
   RANGE="data";
run;
data work.refdata (rename=(yhat=est)) work.testdata(drop=yhat); 
   set work.data; 
   format _all_;
run; 
proc import datafile="&g_testdata/regression.xls" dbms=%SetXLSType out=work.refparm replace;
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

proc datasets lib=work nolist;
   delete refparm refdata testdata data aus parameters;
run;
quit;

%endScenario();
/** \endcond */