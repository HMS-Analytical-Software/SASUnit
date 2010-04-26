/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests für regression.sas

            Beispiel für ein Testszenario mit folgenden Eigenschaften:
            - Reports manuell prüfen mit assertReport mit Vergleichsstandard
            - Vergleich mit Daten aus Excel mit assertColumns
            - Testdaten in Library testdata verwenden

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/example/saspgm/boxplot_test.sas $
*/ /** \cond */ 

/* Änderungshistorie
   30.06.2008 AM  Neuerstellung
*/ 

/*-- Vergleich lineare Regression Excel mit Regression SAS -------------------*/
%initTestcase(i_object=regression.sas, i_desc=Vergleich lineare Regression Excel mit Regression SAS)

libname testdata excel "&g_testdata/regression.xls";
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
              i_desc=bitte vergleichen Sie die SAS-Grafik mit der Excel-Grafik)

%assertColumns(i_actual=aus, i_expected=refdata, i_desc=Erwartungswerte vergleichen, i_fuzz=1E-10)

%assertEquals(i_actual=&intercept_xls, i_expected=&intercept_sas, i_desc=Intercept vergleichen)
%assertEquals(i_actual=&slope_xls, i_expected=&slope_sas, i_desc=Steigung vergleichen)

/** \endcond */
