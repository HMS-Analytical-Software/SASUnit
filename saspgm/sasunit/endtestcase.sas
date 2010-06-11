/**
   \file
   \ingroup    SASUNIT_SCN

   \brief      Determines a test case

               Please refer to the description of the test tools in _sasunit_doc.sas

               Result and finish time are added to the test repository.

   \param      i_assertLog if 1 .. an assertLog (0,0) will be invoked for the test case to be determined, provided that
                           assertLog was not invoked yet

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
*/

/*DE
   \file
   \ingroup    SASUNIT_SCN

   \brief      einen Testfall beenden

               Siehe Beschreibung der Testtools in _sasunit_doc.sas

               Ergebnis und Endzeit in Testdatenbank einfügen.

   \param      i_assertLog wenn 1 .. ein assertLog (0,0) für den zu beendenden Testfall absetzen, falls
                           noch keines abgesetzt wurde

*/ /** \cond */ 

%MACRO endTestcase(i_assertLog=1);

PROC SQL NOPRINT;
%LOCAL l_casid l_assertLog;
/* Ermittle Nummer des aktuellen Testfalls */
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
%LET l_casid = &l_casid;
%IF &l_casid=. %THEN %DO;
   %PUT &g_error: endTestcase muss nach InitTestcase aufgerufen werden;
   %RETURN;
%END;
%IF &i_assertLog %THEN %DO;
/* prüfe, ob bereits ein assertLog abgesetzt wurde, ggfs. dieses absetzen */
   SELECT count(*) INTO :l_assertLog 
   FROM target.tst
   WHERE tst_scnid = &g_scnid AND tst_casid = &l_casid AND tst_type='assertLog';
   %IF &l_assertLog=0 %THEN %DO;
      %assertLog()
   %END;
%END;
QUIT;

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
%END;
%ELSE %IF &g_inTestcase NE 2 %THEN %DO;
   %PUT &g_error: endTestcase muss nach initTestcase aufgerufen werden;
   %RETURN;
%END;
%LET g_inTestcase=0;

PROC SQL NOPRINT;
%LOCAL l_result0 l_result1 l_result2;
/* ermittle Ergebnisse der Tests */
   SELECT count(*) INTO :l_result0 FROM target.tst WHERE tst_scnid=&g_scnid AND tst_casid=&l_casid AND tst_res=0;
   SELECT count(*) INTO :l_result1 FROM target.tst WHERE tst_scnid=&g_scnid AND tst_casid=&l_casid AND tst_res=1;
   SELECT count(*) INTO :l_result2 FROM target.tst WHERE tst_scnid=&g_scnid AND tst_casid=&l_casid AND tst_res=2;
QUIT;

/* bestimme Gesamtergebnis */
%LOCAL l_result;
%IF &l_result1 GT 0 %THEN %LET l_result=1;        /* Fehler aufgetreten */
%ELSE %IF &l_result2 GT 0 %THEN %LET l_result=2;  /* manuell aufgetreten */
%ELSE %LET l_result=0;                            /* alles OK */

PROC SQL NOPRINT;
   UPDATE target.cas
   SET 
      cas_res = &l_result
   WHERE 
      cas_scnid = &g_scnid AND
      cas_id    = &l_casid;
QUIT;

%MEND endTestcase;
/** \endcond */
