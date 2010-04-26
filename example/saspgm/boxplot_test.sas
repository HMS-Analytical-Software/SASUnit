/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests für boxplot.sas

            Beispiel für ein Testszenario mit folgenden Eigenschaften:
            - Reports manuell prüfen mit assertReport mit / ohne Vergleichsstandard
            - verschiedene Testfälle mit unterschiedlichen Eingabedaten
            - Fehlerhandling prüfen mit assertLogMsg
            - Testdaten in Library testdata verwenden

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/boxplot_test.sas $
*/ /** \cond */ 

/* Änderungshistorie
   11.02.2008 AM  Fehlerkorrekturen
   07.02.2008 AM  Neuerstellung
*/ 

/*-- Standardfall ohne Vergleichsstandard ------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Standardfall ohne Vergleichsstandard)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report1.rtf)
%assertReport(i_actual=&g_work\report1.rtf, i_expected=,
              i_desc=bitte vergleichen Sie die Grafik mit der Spezifikation im Quellcode)

/*-- Standardfall mit Vergleichsstandard  ------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Standardfall mit Vergleichsstandard)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report2.rtf)
%assertReport(i_actual=&g_work\report2.rtf, i_expected=&g_refdata\boxplot1.rtf,
              i_desc=bitte vergleichen Sie die beiden Grafiken)

/*-- Standardfall mit Vergleichsstandard, zusätzlich Missing Values für Y ----*/
%initTestcase(i_object=boxplot.sas, i_desc=%str(Standardfall mit Vergleichsstandard, zusätzlich Missing Values für Y))
data blood_pressure; 
   set testdata.blood_pressure; 
   output; 
   sbp=.;
   output;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report3.rtf)
%assertReport(i_actual=&g_work\report3.rtf, i_expected=&g_refdata\boxplot1.rtf,
              i_desc=%str(bitte vergleichen Sie die beiden Grafiken, keine Änderung durch Missing Values in der Y-Variablen))
%assertLogMsg(i_logMsg=%str(NOTE: 240 observation\(s\) contained a MISSING value for the SBP \* Visit = Med request))

/*-- andere Skalierung der X- und Y-Achsen -----------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=andere Skalierung der X- und Y-Achsen)
data blood_pressure; 
   set testdata.blood_pressure; 
   visit=visit*100; 
   sbp=sbp*100;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report4.rtf)
%assertReport(i_actual=&g_work\report4.rtf, i_expected=,
              i_desc=bitte vergleichen Sie die Grafik mit der Spezifikation im Quellcode)

/*-- nur zwei Visiten --------------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=nur zwei Visiten)
data blood_pressure; 
   set testdata.blood_pressure; 
   where visit in (1, 5);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report5.rtf)
%assertReport(i_actual=&g_work\report5.rtf, i_expected=,
              i_desc=bitte vergleichen Sie die Grafik mit der Spezifikation im Quellcode)

/*-- Fehler: nur eine Visite -------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=nur eine Visite)
data blood_pressure; 
   set testdata.blood_pressure; 
   where visit in (3);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report6.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: es müssen mindestens zwei X-Werte vorhanden sein)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report6.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- 18 Visiten --------------------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=18 Visiten)
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
              i_desc=bitte vergleichen Sie die Grafik mit der Spezifikation im Quellcode)

/*-- Fehler: Eingabedatei ungültig -------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Eingabedatei ungültig)
%boxplot(data=XXXXX, x=visit, y=sbp, group=med, report=&g_work\report8.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Datei XXXXX existiert nicht)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report8.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Eingabedatei fehlt ----------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Eingabedatei fehlt)
%boxplot(data=, x=visit, y=sbp, group=med, report=&g_work\report9.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Datei existiert nicht)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report9.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: X-Variable ungültig ---------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=X-Variable ungültig)
%boxplot(data=testdata.blood_pressure, x=visitXXX, y=sbp, group=med, report=&g_work\report10.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable visitXXX existiert nicht in Datei testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report10.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: X-Variable fehlt ------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=X-Variable fehlt)
%boxplot(data=testdata.blood_pressure, x=, y=sbp, group=med, report=&g_work\report11.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: X-Variable wurde nicht angegeben)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report11.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: X-Variable ist nicht numerisch ----------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=X-Variable ist nicht numerisch)
data blood_pressure;
   set testdata.blood_pressure; 
   visitc = put (visit, 1.);
run; 
%boxplot(data=blood_pressure, x=visitc, y=sbp, group=med, report=&g_work\report12.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable visitc in Datei blood_pressure muss numerisch sein)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report12.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: X-Variable hat keine gleichförmigen Abstände --------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=X-Variable hat keine gleichförmigen Abstände)
data blood_pressure;
   set testdata.blood_pressure; 
   if visit=5 then visit=6;
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report13.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: x-Achsen-Werte haben keine gleichförmigen Abstände)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report13.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: X-Variable hat missing Values -----------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=X-Variable hat missing Values)
data blood_pressure;
   set testdata.blood_pressure; 
   output; 
   visit=.; 
   output; 
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report14.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Fehlende Werte in der X-Variablen sind nicht zugelassen)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report14.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Y-Variable ungültig ---------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Y-Variable ungültig)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbpXXX, group=med, report=&g_work\report15.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable sbpXXX existiert nicht in Datei testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report15.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Y-Variable fehlt ------------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Y-Variable fehlt)
%boxplot(data=testdata.blood_pressure, x=visit, y=, group=med, report=&g_work\report16.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Y-Variable wurde nicht angegeben)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report16.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Y-Variable ist nicht numerisch ----------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Y-Variable ist nicht numerisch)
data blood_pressure;
   set testdata.blood_pressure; 
   sbpc = put (sbp, best32.);
run; 
%boxplot(data=blood_pressure, x=visit, y=sbpc, group=med, report=&g_work\report17.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable sbpc in Datei blood_pressure muss numerisch sein)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report17.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Group-Variable ungültig -----------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Group-Variable ungültig)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=medXXX, report=&g_work\report18.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable medXXX existiert nicht in Datei testdata.blood_pressure)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report18.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Group-Variable fehlt --------------------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Group-Variable fehlt)
%boxplot(data=testdata.blood_pressure, x=visit, y=sbp, group=, report=&g_work\report19.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Group-Variable wurde nicht angegeben)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report19.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Group-Variable hat nur eine Ausprägung --------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Group-Variable hat nur eine Ausprägung)
data blood_pressure;
   set testdata.blood_pressure; 
   if med=1; 
run; 
%boxplot(data=blood_pressure, x=visit, y=sbp, group=med, report=&g_work\report20.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable med muss genau zwei Ausprägungen haben)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report20.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Group-Variable hat mehr als zwei Ausprägungen -------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Group-Variable hat mehr als zwei Ausprägungen)
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
%assertLogMsg(i_logMsg=ERROR: boxplot: Variable med muss genau zwei Ausprägungen haben)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report21.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/*-- Fehler: Group-Variable hat missing Values -------------------------------*/
%initTestcase(i_object=boxplot.sas, i_desc=Group-Variable hat missing Values)
data blood_pressure3;
   set testdata.blood_pressure; 
   if med=0 then do; 
      med=.; 
      output; 
   end;  
run; 
%boxplot(data=blood_pressure3, x=visit, y=sbp, group=med, report=&g_work\report22.rtf)
%assertLogMsg(i_logMsg=ERROR: boxplot: Fehlende Werte in der Group-Variablen sind nicht zugelassen)
%assertEquals(i_actual=%sysfunc(fileexist(&g_work\report22.rtf)), i_expected=0, i_desc=kein Report erstellt)
%endTestcase(i_assertLog=0)

/** \endcond */
