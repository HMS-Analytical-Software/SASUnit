/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Wird von allen assertXxxxx-Makros aufgerufen, fügt die 
               Informationen in die Tabelle tst ein.

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param  i_type           Typ der Prüfung / Name des aufrufenden assertXxxxx-Makros
   \param  i_expected       erwarteter Wert
   \param  i_actual         tatsächlicher Wert 
   \param  i_desc           Beschreibung der Prüfung
   \param  i_result         Testergebnis 0 .. OK, 1 .. nicht OK, 2 .. manuell
   \param  r_casid          optional: Rückgabe Testfallnummer 
   \param  r_tstid          optional: Rückgabe Testnummer 
*/ /** \cond */ 

/* Änderungshistorie
   07.02.2008 AM  Quoting für Texte verbessert, die doppelte Hochkommata enthalten
*/ 


%MACRO _sasunit_asserts (
    i_type     =       
   ,i_expected =       
   ,i_actual   =       
   ,i_desc     =       
   ,i_result   =       
   ,r_casid    =       
   ,r_tstid    =       
);

%IF &r_casid= %THEN %DO;
   %LOCAL l_casid;
   %LET r_casid=l_casid;
%END;
%IF &r_tstid= %THEN %DO;
   %LOCAL l_tstid;
   %LET r_tstid=l_tstid;
%END;

PROC SQL NOPRINT;
   /* Ermittle Nummer des aktuellen Testfalls */
   SELECT max(cas_id) INTO :&r_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   %IF &&&r_casid=. %THEN %DO;
      %PUT &g_error: _sasunit_asserts: Fehler beim Ermitteln der Testfall-Id;
      %RETURN;
   %END;
   /* Ermittle neue Nummer für die aktuelle Prüfung */
   SELECT max(tst_id) INTO :&r_tstid 
   FROM target.tst 
   WHERE 
      tst_scnid = &g_scnid AND
      tst_casid = &&&r_casid
   ;
   %IF &&&r_tstid=. %THEN %LET &r_tstid=1;
   %ELSE                  %LET &r_tstid=%eval(&&&r_tstid+1);
   INSERT INTO target.tst VALUES (
       &g_scnid
      ,&&&r_casid
      ,&&&r_tstid
      ,"&i_type"
      ,%sysfunc(quote(&i_desc%str( )))
      ,%sysfunc(quote(&i_expected%str( )))
      ,%sysfunc(quote(&i_actual%str( )))
      ,&i_result
   );
QUIT;

%PUT ========================== Prüfung &&&r_casid...&&&r_tstid (&i_type) =====================================;

%LET &r_casid = %sysfunc(putn(&&&r_casid,z3.));
%LET &r_tstid = %sysfunc(putn(&&&r_tstid,z3.));

%MEND _sasunit_asserts;
/** \endcond */
