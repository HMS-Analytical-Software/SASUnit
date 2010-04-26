/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests für generate.sas

            Beispiel für ein Testszenario mit folgenden Eigenschaften:
            - Testdaten im Testszenario erzeugen
            - ganze SAS-Bibliothek vergleichen mit assertLibrary 
            - verschiedene Testfälle erzeugen
            - Fehlerhandling prüfen mit assertLogMsg
            - Unterdrücken des automatischen Logscannings in \%endTestcase

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/generate_test.sas $
*/ /** \cond */ 

/* Änderungshistorie
   05.02.2008 AM  erstellt
*/ 

/*-- Testfall 1: eine BY-Variable --------------------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=Beispiel mit einer BY-Variablen)

/* zwei temporäre Librefs anlegen */
options noxwait xsync xmin;
x "md ""&g_work/test1""";
libname test1 "&g_work/test1";
x "md ""&g_work/test2""";
libname test2 "&g_work/test2";

proc sort data=sashelp.class out=test2.class1 (label="Datei für sex=F (9 Beobachtungen)");
   by sex;
   where sex='F';
run;
proc sort data=sashelp.class out=test2.class2 (label="Datei für sex=M (10 Beobachtungen)");
   by sex;
   where sex='M';
run;
   
%generate(data=sashelp.class, by=sex, out=test1.class)
%endTestcall()
%assertLibrary(i_actual=test1, i_expected=test2, i_desc=Libraries prüfen)
%endTestcase() /* assertLog wird automatisch aufgerufen */

/*-- Testfall 2: zwei BY-Variablen -------------------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=Beispiel mit zwei BY-Variablen)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
proc sort data=sashelp.prdsale out=test2.prdsale1 (label="Datei für region=EAST, year=1993 (360 Beobachtungen)");
   by region year;
   where region="EAST" and year=1993;
run;
proc sort data=sashelp.prdsale out=test2.prdsale2 (label="Datei für region=EAST, year=1994 (360 Beobachtungen)");
   by region year;
   where region="EAST" and year=1994;
run;
proc sort data=sashelp.prdsale out=test2.prdsale3 (label="Datei für region=WEST, year=1993 (360 Beobachtungen)");
   by region year;
   where region="WEST" and year=1993;
run;
proc sort data=sashelp.prdsale out=test2.prdsale4 (label="Datei für region=WEST, year=1994 (360 Beobachtungen)");
   by region year;
   where region="WEST" and year=1994;
run;
%generate(data=sashelp.prdsale, by=region year, out=test1.prdsale)
%endTestcall()
%assertLibrary(i_actual=test1, i_expected=test2, i_desc=Libraries prüfen)
%endTestcase() 

/*-- Testfall 3: eine BY-Variable mit nur einer Ausprägung -------------------*/
%initTestcase(i_object=generate.sas, i_desc=Beispiel mit einer BY-Variablen mit nur einer Ausprägung)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
/* Eingabedatei herstellen */
proc sort data=sashelp.class out=class;
   by sex;
   where sex='F';
run;
/* erwartete Ausgabedatei herstellen */
proc sort data=sashelp.class out=test2.class1 (label="Datei für sex=F (9 Beobachtungen)");
   by sex;
   where sex='F';
run;
%generate(data=class, by=sex, out=test1.class)
%endTestcall()
%assertLibrary(i_actual=test1, i_expected=test2, i_desc=Libraries prüfen)
%endTestcase() 

/*-- Testfall 4: ungültige Datei angegeben -----------------------------------*/
%initTestcase(i_object=generate.sas, i_desc=ungültige Datei angegeben)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
%generate(data=sashelp.classXXX, by=sex, out=test1.class)
%endTestcall()
%assertLogMsg(i_logMsg=ERROR: Macro Generate: falsche Angabe für data= oder by=)
%endTestcase(i_assertLog=0)

/*-- Testfall 5: ungültige BY-Variable angegeben -----------------------------*/
%initTestcase(i_object=generate.sas, i_desc=ungültige BY-Variable angegeben)
proc datasets lib=test1 nolist kill;
quit; 
proc datasets lib=test2 nolist kill;
quit; 
%generate(data=sashelp.class, by=sexXXX, out=test1.class)
%endTestcall()
%assertLogMsg(i_logMsg=ERROR: Macro Generate: falsche Angabe für data= oder by=)
%endTestcase(i_assertLog=0)

/*-- Testfall 6: ungültige Ausgabebibliothek angegeben -----------------------*/
%initTestcase(i_object=generate.sas, i_desc=ungültige Ausgabebibliothek angegeben)
proc datasets lib=test1 nolist kill;
quit;    
proc datasets lib=test2 nolist kill;
quit; 
%generate(data=sashelp.class, by=sex, out=test3.class)
%endTestcall()
%assertLogMsg(i_logMsg=ERROR: Libname TEST3 is not assigned)
%endTestcase(i_assertLog=0)

libname test1;
libname test2;

/** \endcond */
