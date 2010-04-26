/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Initialisierung der Fehlerbehandlungsroutinen.

               Muss vor der ersten Verwendung von handleError aufgerufen werden.
               Setzt alle globalen Variablen für die Fehlerbehandlung zurück

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \sa      _sasunit_handleError.sas
*/ /** \cond */ 

%MACRO _sasunit_initErrorHandler;
/* globales Signal für die Rückgabe von Fehlerbedingungen 
   an aufrufende Makros */
%GLOBAL g_error_code; 
%LET g_error_code=;

/* letzte Fehlermeldung */
%GLOBAL g_error_msg; 
%LET g_error_msg=;

/* letzter Makro, der Fehler erzeugt hat */
%GLOBAL g_error_macro; 
%LET g_error_macro=;

%MEND _sasunit_initErrorHandler;
/** \endcond */
