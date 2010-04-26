/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Initialisieren eines Testszenarios, siehe initSASUnit.sas.
               _sasunit_scenario.sas wird verwendet, um die von runSASUnit.sas
               gestartete SAS-Batch-Sitzung zu initialisieren.
 
   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   io_target       Verzeichnis, in dem die Testdatenbank steht
*/ /** \cond */ 

%MACRO _sasunit_scenario(
   io_target  = 
);
%LOCAL l_macname; %LET l_macname=&sysmacroname;

OPTIONS MAUTOSOURCE MPRINT LINESIZE=100;

/* Fehlerbehandlung initialisieren */
%_sasunit_initErrorHandler;

/* Zielverzeichnis prüfen */
%IF %_sasunit_handleError(&l_macname, InvalidTargetDir, 
   "&io_target" EQ "" OR NOT %_sasunit_existDir(&io_target), 
   Zielverzeichnis &io_target existiert nicht) 
   %THEN %GOTO errexit;

/* Libname auf Testdatenbank anlegen */
LIBNAME target "&io_target";
%IF %_sasunit_handleError(&l_macname, ErrorNoTargetDirLib, 
   %quote(&syslibrc) NE 0, 
   Testdatenbank kann nicht geöffnet werden) 
   %THEN %GOTO errexit;

/* globale Makrovariablen und Librefs / Filerefs erzeugen */
%_sasunit_loadEnvironment()
%IF &g_error_code NE %THEN %GOTO errexit;

/* Autocall-Pfad erzeugen */
OPTIONS MAUTOSOURCE SASAUTOS=(SASAUTOS "&g_sasunit" 
%IF "&g_sasautos" NE "" %THEN "&g_sasautos";
%DO i=1 %TO 9;
   %IF "&&g_sasautos&i" NE "" %THEN "&&g_sasautos&i";
%END;     );

/* Flag für Testcases */
%GLOBAL g_inTestcase;
%LET g_inTestcase=0;

%GOTO exit;
%errexit:
   %PUT ========================== Fehler! Testszenario wird abgebrochen! ===============================;
LIBNAME target;
%exit:
%MEND _sasunit_scenario;
/** \endcond */
