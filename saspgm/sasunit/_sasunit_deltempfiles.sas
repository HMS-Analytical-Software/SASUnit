/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Löschen aller SAS-Dateien der Form WORK.DATAxxx, siehe tempFileName.sas

          Sollen die Dateien für das Debugging ausnahmsweise erhalten bleiben,
          die globale Makrovariable g_deltempfiles_debug definieren.

          Falls die Makrovariable l_first_temp im aufrufenden Programm 
          gesetzt ist (siehe Makro tempFileName) werden nur temporäre Dateien
          ab dieser Nummer gelöscht. 

   \%delTempFiles;
   \sa    tempFileName.sas

   \version 1.0
   \author  Andreas Mangold
   \date    02.02.2006
*/ 
/** \cond */ 

%MACRO _sasunit_delTempFiles;

%IF NOT %symexist(g_deltempfiles_debug) %THEN %DO;

DATA _null_;
   SET sashelp.vtable END=eof;
   WHERE libname = 'WORK' AND memname LIKE 'DATA%';
   IF _n_=1 THEN 
      CALL EXECUTE ('PROC SQL NOPRINT;');
%IF %symexist(l_first_temp) %THEN %DO;
   %IF &l_first_temp NE %THEN %DO;
   IF input(substr(memname,5),8.) >= &l_first_temp;
   %END;
%END;
   CALL execute ('DROP TABLE ' !! memname !! ';');
   IF eof THEN 
      CALL execute ('QUIT;');
RUN;

%END;

%MEND _sasunit_delTempFiles;
/** \endcond */
