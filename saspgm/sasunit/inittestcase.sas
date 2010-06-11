/**
   \file
   \ingroup    SASUNIT_SCN 

   \brief      Start of a new test case that comprises an invocation of
               a program under test and one or more assertions.

               Please refer to the description of the test tools in _sasunit_doc.sas. 

               internally: 
               - Insertion of relevant data into the test repository
               - Redirection of SAS log
               - Setting of flag g_inTestcase

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_object          source code file of program under test, is searched in 
                              the AUTOCALL path in case only the name of the source code 
                              file is given, without path information
   \param   i_desc            description of the test case
   \param   i_specdoc         optional: path of specification document
   \return
*/

/*DE
   \file
   \ingroup    SASUNIT_SCN 

   \brief      Beginnen eines neuen Testfalls, der aus einem Aufruf des 
               Prüflings und aus einer oder mehreren Prüfungen besteht.

               Siehe Beschreibung der Testtools in _sasunit_doc.sas

               intern: 
               - Einfügen der relevanten Daten in die Testdatenbank
               - SASLOG umleiten
               - Flag g_inTestcase setzen 

   \param   i_object          Programmdatei des Prüflings, wird im Autocall-Pfad gesucht, 
                              falls nur der Name der Programmdatei angegeben wurde
   \param   i_desc            Beschreibung des Testfalls 
   \param   i_specdoc         optional: Pfad auf Spezifikationsdokument
   \return
*/ /** \cond */ 


%MACRO initTestcase(
   i_object   =  
  ,i_desc     =  
  ,i_specdoc  =  
);

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
   %endTestcase;
%END;
%IF &g_inTestcase EQ 2 %THEN %DO;
   %endTestcase;
%END;
%LET g_inTestcase=1;

/* absolute und relative Programmnamen behandeln */
%LOCAL l_pgm l_auton;
%IF %index(%sysfunc(translate(&i_object,/,\)),/) %THEN %DO;
   %LET l_pgm = %_sasunit_stdPath(&g_root,&i_object);
   %LET l_auton=.;
%END;
%ELSE %DO;
   %LET l_pgm = &i_object;
   %LET l_auton = %_sasunit_getAutocallNumber(&i_object);
%END;

/* bestimme die nächste Caseid */
%LOCAL l_casid;%LET l_casid=0;
PROC SQL NOPRINT;
   SELECT max(cas_id) INTO :l_casid FROM target.cas
   WHERE cas_scnid = &g_scnid;
%IF &l_casid=. %THEN %LET l_casid=1;
%ELSE                %LET l_casid=%eval(&l_casid+1);
/* Metadaten für diesen Testfall eintragen */
   INSERT INTO target.cas VALUES (
       &g_scnid
      ,&l_casid
      ,&l_auton
      ,"&l_pgm"
      ,"&i_desc"
      ,"%_sasunit_abspath(&g_doc,&i_specdoc)"
      ,%sysfunc(datetime())
      ,.
      ,.
   );
QUIT;

%PUT ========================== Testfall &l_casid =======================================================;

/* SASLOG und SASLIST umleiten */
PROC PRINTTO 
   NEW 
   LOG="&g_log/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).log"
   PRINT="&g_testout/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).lst"
;
RUN;

%MEND initTestcase;
/** \endcond */
