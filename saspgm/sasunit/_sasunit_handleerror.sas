/** \file
   \ingroup    SASUNIT_UTIL

   \brief      Fehlerabfrage durchführen, Statuscodes setzen

               Wenn die angegeben Bedingung i_condition wahr ist, wird eine Meldung in den SAS-Log ausgegeben 
               und folgende drei globalen Variablen gesetzt:
               - g_error_code ... Wert von i_errorcode (Fehlercode)
               - g_error_msg ... Wert von i_text (Fehlermeldung)
               - g_error_macro ... Wert von i_macroname (aufrufendes makro)

               Das aufrufende Programm sollte ganz oben den Makronamen ermitteln mit folgender Zeile:
               \%LOCAL l_macname; \%LET l_macname = &sysmacroname ;
               Nicht &sysmacroname direkt in den Aufruf von handleError reinschreiben, sonst erhält sie 
               den Wert handleError!

               Wenn i_verbose den Wert 1 hat, wird auch dann, wenn kein Fehler auftritt, eine
               Informationsmeldung in den SAS-Log ausgegeben.

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_macroname      Name des Makros, in dem der Fehler aufgetreten ist
   \param   i_errorcode      innerhalb des aufrufenden Makros eindeutiger Fehlercode
   \param   i_condition      Bedingung - logischer Ausdruck, wird ausgewertet und zurückgegeben
   \param   i_text           Fehlermeldung, weitere Informationen, wird in den SASLOG geschrieben
   \param   i_verbose        gib Logzeile auch dann aus, wenn kein Fehler gefunden wurde, Voreinstellung ist 0
   \return                   ausgewerteter Makroausdruck i_condition
*/ /** \cond */

%MACRO _sasunit_handleError (
    i_macroname      
   ,i_errorcode      
   ,i_condition      
   ,i_text           
   ,i_verbose=0       
);
%IF %unquote(&i_condition) %THEN %DO;
   1
   %PUT;
   %PUT --------------------------------------------------------------------------------;
   %PUT ERROR &i_errorcode in Makro &i_macroname (Condition: &i_condition);
   %IF "&i_text" NE ""
      %THEN %PUT &i_text;
   %PUT --------------------------------------------------------------------------------;
   %PUT;
   %LET g_error_code = &i_errorcode;
   %LET g_error_msg  = &i_text;
   %LET g_error_macro= &i_macroname;
%END;
%ELSE %DO;
   0
   %IF &i_verbose %THEN %DO;
      %PUT;
      %PUT handleError: OK: &i_errorcode &i_macroname (Bedingung: &i_condition);
      %PUT;
   %END;
%END;
%MEND _sasunit_handleError;
 /** \endcond */
