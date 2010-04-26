/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests für getvars.sas

            Beispiel für ein Testszenario mit folgenden Eigenschaften:
            - Makrovariable prüfen mit assertEquals
            - Logscanning mit assertLog
            - weglassen von \%endTestcall und \%endTestcase
            - Sonderfälle prüfen

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/getvars_test.sas $
*/ /** \cond */ 

/* Änderungshistorie
   06.02.2008 AM  Neuerstellung
*/ 

/*-- einfaches Beispiel mit sashelp.class ------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=einfaches Beispiel mit sashelp.class)
%let vars=%getvars(sashelp.class);
/* %endTestcall() kann man auch weglassen, wird dann durch das erste assert erledigt */
%assertEquals(i_actual=&vars, i_expected=Name Sex Age Height Weight, i_desc=Variablen prüfen)
/* %endTestcase() kann man auch weglassen, wird dann durch das nächste initTestcase erledigt */

/*-- einfaches Beispiel mit sashelp.class, anderes Trennzeichen --------------*/
%initTestcase(i_object=getvars.sas, i_desc=%str(einfaches Beispiel mit sashelp.class, anderes Trennzeichen))
%let vars=%getvars(sashelp.class,dlm=%str(,));
%assertEquals(i_actual=&vars, i_expected=%str(Name,Sex,Age,Height,Weight), i_desc=Variablen prüfen)

/*-- Beispiel mit Variablennamen mit Sonderzeichen ---------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=Beispiel mit Variablennamen mit Sonderzeichen)
options validvarname=any;
data test; 
   'a b c'n=1; 
   '$6789'n=2;
   ';6789'n=2;
run; 
%let vars="%getvars(test,dlm=%str(","))";
%assertEquals(i_actual=&vars, i_expected=%str("a b c","$6789",";6789"), i_desc=Variablen prüfen)
%assertLog(i_warnings=1,i_desc=%str(Log prüfen, eine Warning wegen validvarname))
%endTestcase(i_assertLog=0) /* automatisches Assert abschalten */

/*-- Beispiel mit leerer Datei -----------------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=Beispiel mit leerer Datei)
data test; 
   stop;
run; 
%let vars=%getvars(test);
%assertEquals(i_actual=&vars, i_expected=, i_desc=keine Variablen vorhanden)

/*-- Beispiel mit fehlender Datei --------------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=Beispiel mit fehlender Datei)
%let vars=%getvars();
%assertEquals(i_actual=&vars, i_expected=, i_desc=keine Variablen gefunden)

/*-- Beispiel mit ungültiger Datei -------------------------------------------*/
%initTestcase(i_object=getvars.sas, i_desc=Beispiel mit ungültiger Datei)
%let vars=%getvars(xxx);
%assertEquals(i_actual=&vars, i_expected=, i_desc=keine Variablen gefunden)

/** \endcond */
