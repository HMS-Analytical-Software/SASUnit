/**
    \file
    \ingroup  SASUNIT_UTIL

    \brief    Prüfen, ob Fehler oder Warnungen in einem SAS-Log.

    \param    i_logfile  Kompletter Pfad zum Logfile
    \param    i_error    Symbol für einen Fehler
    \param    i_warning  Symbol für eine Warnung
    \param    r_errors   Makrovariable, die nach dem Aufruf die Anzahl Fehler enthält (999, wenn Logfile nicht existiert)
    \param    r_warnings Makrovariable, die nach dem Aufruf die Anzahl Warnings enthält (999, wenn Logfile nicht existiert)
    \version  1.0
    \author   Andreas Mangold
    \date     10.08.2007
*/ /** \cond */ 

%MACRO _sasunit_checkLog(
    i_logfile  =
   ,i_error    = 
   ,i_warning  = 
   ,r_errors   = 
   ,r_warnings = 
);

%LET &r_errors   = 999;
%LET &r_warnings = 999;
DATA _null_;
   INFILE "&i_logfile" TRUNCOVER end=eof;
   INPUT logline $char255.;
   IF index (logline, "&i_error")   = 1 THEN error_count+1;
   IF index (logline, "&i_warning") = 1 THEN warning_count+1;
   IF eof THEN DO;
      CALL symput ("&r_errors"  , compress(put(error_count,8.)));
      CALL symput ("&r_warnings", compress(put(warning_count,8.)));
   END;
RUN;

%MEND _sasunit_checkLog;
/** \endcond */
