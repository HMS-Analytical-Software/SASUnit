/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Tests für nobs.sas

            Beispiel für ein Testszenario mit folgenden Eigenschaften:
            - Aufbau eines einfachen Testszenarios
            - Makrovariable prüfen mit assertEquals

\version    \$Revision: 23 $
\author     \$Author: mangold $
\date       \$Date: 2008-06-30 15:07:27 +0200 (Mo, 30 Jun 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/example/saspgm/nobs_test.sas $
*/ /** \cond */ 

/* Änderungshistorie
   27.06.2008 AM  Fehlgeschlagenen Test eingefügt
   07.02.2008 AM  Neuerstellung
*/ 

/*-- einfaches Beispiel mit sashelp.class ------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=einfaches Beispiel mit sashelp.class)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=19, i_desc=Anzahl Beobachtungen in sashelp.class)
%endTestcase()

/*-- fehlgeschlagener Test ---------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=fehlgeschlagener Test)
%let nobs=%nobs(sashelp.class);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=20, i_desc=Anzahl Beobachtungen in sashelp.class)
%endTestcase()

/*-- Beispiel mit großer Datei -----------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(Beispiel mit großer Datei))
data gross;
   do i=1 to 1000000;
      x=ranuni(0);
      output; 
   end;
run; 
%let nobs=%nobs(gross);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=1000000, i_desc=Anzahl Beobachtungen in Datei work.gross)
%endTestcase()

/*-- Beispiel mit leerer Datei -----------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(Beispiel mit leerer Datei))
data leer;
   stop; 
run; 
%let nobs=%nobs(leer);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=0, i_desc=Anzahl Beobachtungen in Datei work.leer)
%endTestcase()

/*-- fehlende Datei ----------------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(fehlende Datei))
%let nobs=%nobs(xxx);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=, i_desc=Anzahl Beobachtungen bei fehlender Datei)
%endTestcase()

/*-- ungültige Datei ---------------------------------------------------------*/
%initTestcase(i_object=nobs.sas, i_desc=%str(ungültige Datei))
%let nobs=%nobs(xxx);
%endTestcall()
%assertEquals(i_actual=&nobs, i_expected=, i_desc=Anzahl Beobachtungen bei ungültiger Datei)
%endTestcase()

/** \endcond */
