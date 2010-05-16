/**
   \file
   \ingroup    SASUNIT_SCN 

   \brief      Determines an invocation of a program under test

               Please refer to the description of the test tools in _sasunit_doc.sas

               Ensure sequence
               End redirection of SAS log
               Reset ODS destinations
               ODS-Destinations r�cksetzen

   \version    \$Revision: 57 $
   \author     \$Author: mangold $
   \date       \$Date: 2010-05-16 14:51:20 +0200 (So, 16 Mai 2010) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/sasunit/endtestcall.sas $
*/

/*DE \file
   \ingroup    SASUNIT_SCN 

   \brief      Beendet den Aufruf des Pr�flings

               Siehe Beschreibung der Testtools in _sasunit_doc.sas

               Sequenz sicherstellen
               SASLOG-Umleitung beenden
               ODS-Destinations r�cksetzen

*/ /** \cond */ 


%MACRO endTestcall();

%GLOBAL g_inTestcase;
%IF &g_inTestcase NE 1 %THEN %DO;
   %PUT &g_error: endTestcall muss nach InitTestcase aufgerufen werden;
   %RETURN;
%END;
%LET g_inTestcase=2;

/* Logdatei und Listingdatei des Testszenarios wieder einsetzen */
PROC PRINTTO 
   LOG="&g_log/%substr(00&g_scnid,%length(&g_scnid)).log"
   PRINT="&g_testout/%substr(00&g_scnid,%length(&g_scnid)).lst"
;
RUN;

/* Endezeit des Testfalls ermitteln und eintragen */
PROC SQL NOPRINT;
%LOCAL l_casid;
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
%LET l_casid = &l_casid;
PROC SQL NOPRINT;
   UPDATE target.cas
   SET 
      cas_end = %sysfunc(datetime())
   WHERE 
      cas_scnid = &g_scnid AND
      cas_id    = &l_casid;
QUIT;

/* Listing l�schen, wenn leer */
%LOCAL l_casid;
PROC SQL NOPRINT;
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
QUIT;
%LET l_casid = &l_casid;
%LOCAL l_filled l_lstfile; 
%LET l_filled=0;
%LET l_lstfile=&g_testout/%substr(00&g_scnid,%length(&g_scnid))_%substr(00&l_casid,%length(&l_casid)).lst;
DATA _null_;
   INFILE "&l_lstfile";
   INPUT;
   CALL symput ('l_filled','1');
   STOP;
RUN;
%IF NOT &l_filled %THEN %DO;
   %LET l_filled=%_sasunit_delfile(&l_lstfile);
%END;

ODS _ALL_ CLOSE;

%MEND endTestcall;
/** \endcond */
