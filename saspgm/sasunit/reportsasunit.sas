/**
   \file
   \ingroup    SASUNIT_CNTL 

   \brief      Creation of a test report

               Please refer to the description of the test tools in _sasunit_doc.sas.

   \version \$Revision: 57 $
   \author  \$Author: mangold $
   \date    \$Date: 2010-05-16 14:51:20 +0200 (So, 16 Mai 2010) $
   \sa      \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/sasunit/reportsasunit.sas $

   \param   i_language     Language of the report (DE, EN) - refer to _sasunit_nls
   \param   o_html         Test report in HTML-format?
   \param   o_force        0 .. (default) incremental, 1 .. create complete report
   \param   o_output       (optional) full path of the directory in which the test report is created. 
                           If the parameter is not set, the subdirectory rep of the test repository is used.
   \return Results are created in the subdirectory rep of the test repository or in the directory 
           specified by parameter o_output.

*/

/*DE
   \file
   \ingroup    SASUNIT_CNTL 

   \brief      erstellen eines TestBerichts.

               siehe Beschreibung der Testtools in _sasunit_doc.sas.

   \param   i_language     Sprache für Report (DE, EN) - siehe _sasunit_nls
   \param   o_html         Testbericht im HTML-Format erstellen?
   \param   o_force        0 .. (default) inkrementell, 1 .. kompletten Bericht erstellen
   \param   o_output       (optional) kompletten Pfad zum Ordner, in dem der Bericht erstellt werden soll, 
                           wenn nicht angegeben, wird das Unterverzeichnis rep der Testdatenbank verwendet
   \return Ergebnisse werden im Unterverzeichnis rep oder im bei o_output angegebenen Verzeichnis erstellt

*/ /** \cond */ 

/* Änderungshistorie
   15.07.2009 AM  fixed copydir for Linux
   13.08.2008 AM  introduced o_force and o_output
   12.08.2008 AM  Reportingsprache umgestellt
   11.08.2008 AM  Dateiname der Frameseite an Reportgenerator für assertReport übergeben
   05.02.2008 AM  assertManual nach assertReport umgestellt
   29.12.2007 AM  Aufruf reportAuton aufgenommen 
*/ 

%MACRO reportSASUnit (
   i_language   = EN
  ,o_html       = 1
  ,o_force      = 0
  ,o_output     =
);
%LOCAL l_macname; %LET l_macname=&sysmacroname;

/*-- Parameterprüfung --------------------------------------------------------*/
%IF "&o_html" NE "1" %THEN %LET o_html=0;

%IF "&o_force" NE "1" %THEN %LET o_force=0;

%_sasunit_nls (i_language=&i_language)

/*-- prüfen, ob Zielverzeichnis existiert ------------------------------------*/
%LOCAL l_output; 
%IF %length(&o_output) %THEN %LET l_output=&o_output;
%ELSE %LET l_output =&g_target/rep;
%LET l_output=%_sasunit_abspath(&g_root,&l_output);

%IF %_sasunit_handleError(&l_macname, InvalidOutputDir, 
   NOT %_sasunit_existDir(&l_output), 
   Fehler in Parameter o_output: Zielverzeichnis existiert nicht) 
   %THEN %GOTO errexit;

/*-- prüfen, ob Testdatenbank zugewiesen -------------------------------------*/
%IF %_sasunit_handleError(&l_macname, NoTestDB, 
   NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project), 
   %nrstr(Testdatenbank nicht zugewiesen, %initSASUnit nach %reportSASUnit aufrufen))
   %THEN %GOTO errexit;

/*-- temporäre Dateien erzeugen ----------------------------------------------*/
%LOCAL d_rep d_scn d_cas d_auton d_pgm d_pcs;
%_sasunit_tempFilename(d_rep)
%_sasunit_tempFilename(d_scn)
%_sasunit_tempFilename(d_cas)
%_sasunit_tempFilename(d_auton)
%_sasunit_tempFilename(d_pgm)
%_sasunit_tempFilename(d_pcs)

/*-- Last-Kennzeichen für Treeview erzeugen ----------------------------------*/
PROC SORT DATA=target.scn OUT=&d_scn;
   BY scn_id;
RUN;
DATA &d_scn;
   SET &d_scn END=eof;
   scn_last = eof;
RUN;

PROC SORT DATA=target.cas OUT=&d_cas;
   BY cas_scnid cas_id;
RUN;
DATA &d_cas;
   SET &d_cas;
   BY cas_scnid;
   cas_last = last.cas_scnid;
   cas_pgmucase = upcase(cas_pgm);
RUN;

PROC SORT DATA=target.cas (KEEP=cas_auton RENAME=(cas_auton=auton_id)) 
          OUT=&d_auton NODUPKEY;
   BY auton_id;
RUN;
DATA &d_auton;
   SET &d_auton END=eof;
   auton_last = eof;
RUN;

data &d_pgm;
   SET target.cas (KEEP=cas_auton cas_pgm RENAME=(cas_auton=pgm_auton cas_pgm=pgm_ucase));
   pgm_ucase = upcase(pgm_ucase);
RUN;
PROC SORT DATA=&d_pgm NODUPKEY;
   BY pgm_auton pgm_ucase;
RUN;
DATA &d_pgm;
   SET &d_pgm;
   BY pgm_auton;
   IF first.pgm_auton THEN pgm_id=0;
   pgm_id+1;
   pgm_last = last.pgm_auton;
RUN;

DATA &d_pcs;
   SET target.cas (KEEP=cas_auton cas_pgm cas_scnid cas_id RENAME=(cas_auton=pcs_auton cas_pgm=pcs_ucase cas_scnid=pcs_scnid cas_id=pcs_casid));
   pcs_ucase = upcase(pcs_ucase);
PROC SORT DATA=&d_pcs OUT=&d_pcs NODUPKEY;
   BY pcs_auton pcs_ucase pcs_scnid pcs_casid;
RUN;
DATA &d_pcs;
   SET &d_pcs;
   BY pcs_auton pcs_ucase;
   pcs_last = last.pcs_ucase;
RUN;

/*-- Reportingdatei erzeugen -------------------------------------------------*/
%LOCAL i;
PROC SQL NOPRINT;
   CREATE TABLE &d_rep (COMPRESS=YES) AS
   SELECT 
       tsu_project    
      ,tsu_root       
      ,tsu_target       
      ,tsu_sasunit    
      ,tsu_sasautos   
%DO i=1 %TO 9;
      ,tsu_sasautos&i 
%END;
      ,tsu_autoexec   
      ,tsu_sascfg     
      ,tsu_sasuser    
      ,tsu_testdata   
      ,tsu_refdata    
      ,tsu_doc        
      ,tsu_lastinit
      ,tsu_lastrep
      ,scn_id     
      ,scn_path   
      ,scn_desc   
      ,scn_start  
      ,scn_end    
      ,scn_rc     
      ,scn_res    
      ,scn_last
      ,cas_id    
      ,cas_auton
      ,auton_last
      ,cas_pgm  
      ,pgm_id
      ,pgm_last
      ,pcs_last
      ,cas_desc  
      ,cas_spec  
      ,cas_start 
      ,cas_end   
      ,cas_res 
      ,cas_last 
      ,tst_id    
      ,tst_type  
      ,tst_desc  
      ,tst_exp   
      ,tst_act   
      ,tst_res
   FROM 
       target.tsu
      ,&d_scn
      ,&d_cas
      ,target.tst
      ,&d_auton
      ,&d_pgm
      ,&d_pcs
   WHERE 
      scn_id       = cas_scnid AND
      cas_scnid    = tst_scnid AND
      cas_id       = tst_casid AND
      cas_auton    = auton_id  AND
      cas_auton    = pgm_auton AND
      cas_pgmucase = pgm_ucase AND
      cas_auton    = pcs_auton AND
      cas_pgmucase = pcs_ucase AND
      cas_scnid    = pcs_scnid AND
      cas_id       = pcs_casid
   ;
   CREATE UNIQUE INDEX idx1 ON &d_rep (scn_id, cas_id, tst_id);
   CREATE UNIQUE INDEX idx2 ON &d_rep (cas_auton, pgm_id, scn_id, cas_id, tst_id);

QUIT;
%IF %_sasunit_handleError(&l_macname, ErrorTestDB, 
   &syserr NE 0, 
   %nrstr(Fehler beim Zugriff auf die Testdatenbank))
   %THEN %GOTO errexit;

/*-- letzten Run bestimmen ---------------------------------------------------*/
%LOCAL l_lastrun;
PROC SQL NOPRINT;
   SELECT coalesce(max(scn_start),0) FORMAT=12.0 INTO :l_lastrun FROM target.scn;
QUIT;

/*-- Reportgenerator ---------------------------------------------------------*/
FILENAME repgen temp;

DATA _null_;
   SET &d_rep;
   BY scn_id cas_id;
   FILE repgen;

   IF _n_=1 THEN DO;
      /*-- nur, wenn der Testreport von Grund auf neu erstellt wird ----------*/
      IF tsu_lastrep=0 OR &o_force THEN DO;
         /*-- Images und css-Dateien kopieren --------------------------------*/
         PUT '%_sasunit_copydir(' /
             "    &g_sasunit" '/html/%str(*.*)' /
             "   ,&l_output" /
             ")";
         /*-- die Frameseite erstellen ---------------------------------------*/
         PUT '%_sasunit_reportFrameHTML('                 /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/index.html"   /
             ")";
      END;
      /*-- nur, wenn seit der letzen Reporterstellung %initSASUnit lief ------*/
      IF tsu_lastinit > tsu_lastrep OR &o_force THEN DO;
         /*-- SAS-Log des Testaufrufs aus initSASUnit umwandeln --------------*/
         PUT '%_sasunit_reportLogHTML('                   /
             "    i_log     = &g_log/000.log"             /
             "   ,i_title   = &g_nls_reportSASUnit_001"    /
             "   ,o_html    = &l_output/000_log.html" /
             ")";
         /*-- Übersichtsseite erstellen --------------------------------------*/
         PUT '%_sasunit_reportHomeHTML('                   /
             "    i_repdata = &d_rep"                      /
             "   ,o_html    = &l_output/overview.html" /
             ")";
      END;
      /*-- nur, wenn seit der letzten Reporterstellung ein Testszenario lief -*/
      IF &l_lastrun > tsu_lastrep OR &o_force THEN DO;
         /*-- Inhaltsverzeichnis erstellen -----------------------------------*/
         PUT '%_sasunit_reportTreeHTML('                  /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/tree.html"    /
             ")";
         /*-- Szenarioliste erstellen ----------------------------------------*/
         PUT '%_sasunit_reportScnHTML('                   /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/scn_overview.html"    /
             ")";
         /*-- Testfallliste erstellen ----------------------------------------*/
         PUT '%_sasunit_reportCasHTML('                   /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/cas_overview.html"    /
             ")";
         /*-- Liste der Prüflinge erstellen ----------------------------------*/
         PUT '%_sasunit_reportAutonHTML('                   /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/auton_overview.html"    /
             ")";
      END;
   END;

   /*-- pro Szenario ---------------------------------------------------------*/
   IF first.scn_id AND scn_id NE . THEN DO;
      /*-- nur, wenn Szenario seit der letzten Reporterstellung lief ---------*/
      IF scn_start > tsu_lastrep OR &o_force THEN DO;
         /*-- Szenario-Log umwandeln -----------------------------------------*/
         PUT '%_sasunit_reportLogHTML(' / 
             "    i_log     = &g_log/" scn_id z3. ".log"  /
             "   ,i_title   = &g_nls_reportSASUnit_002 " scn_id z3. " (" cas_pgm +(-1) ")" /
             "   ,o_html    = &l_output/" scn_id z3. "_log.html" /
             ")";
      END;
   END;

   /*-- falls Testfall seit der letzten Reporterstellung lief ----------------*/
   IF cas_start > tsu_lastrep OR &o_force THEN DO;

      /*-- pro Testfall ------------------------------------------------------*/
      IF first.cas_id AND scn_id NE . AND cas_id NE . THEN DO;
         /*-- Testfall-Log umwandeln -----------------------------------------*/
         PUT '%_sasunit_reportLogHTML(' /
             "    i_log     = &g_log/" scn_id z3. "_" cas_id z3. ".log" /
             "   ,i_title   = &g_nls_reportSASUnit_003 " cas_id z3. " &g_nls_reportSASUnit_004 " scn_id z3. " (" cas_pgm +(-1) ")" /
             "   ,o_html    = &l_output/" scn_id z3. "_" cas_id z3. "_log.html" /
             ")";
         /*-- Detailinformationen pro Testfall zusammenstellen ---------------*/
         PUT '%_sasunit_reportDetailHTML('                   /
             "    i_repdata = &d_rep"                        /
             "   ,i_scnid   = " scn_id z3.                   /
             "   ,i_casid   = " cas_id z3.                   /
             "   ,o_html    = &l_output/cas_" scn_id z3. "_" cas_id z3. ".html"    /
             ")";
      END;
 
      /*-- pro Test assertColumns --------------------------------------------*/
      IF scn_id NE . AND cas_id NE . AND tst_id NE . AND upcase(tst_type) = 'ASSERTCOLUMNS' THEN DO;
         PUT '%_sasunit_reportCmpHTML('                         /
             "    i_scnid = " scn_id z3.                        /
             "   ,i_casid = " cas_id z3.                        /
             "   ,i_tstid = " tst_id z3.                        /
             "   ,o_html  = &l_output"                          /
             ")";
      END;

      /*-- pro Test assertLibrary --------------------------------------------*/
      IF scn_id NE . AND cas_id NE . AND tst_id NE . AND upcase(tst_type) = 'ASSERTLIBRARY' THEN DO;
         PUT '%_sasunit_reportLibraryHTML('                         /
             "    i_scnid = " scn_id z3.                        /
             "   ,i_casid = " cas_id z3.                        /
             "   ,i_tstid = " tst_id z3.                        /
             "   ,o_html  = &l_output"                          /
             ")";
      END;

      /*-- pro Test assertReport ---------------------------------------------*/
      IF scn_id NE . AND cas_id NE . AND tst_id NE . AND upcase(tst_type) = 'ASSERTREPORT' THEN DO;
         PUT '%_sasunit_reportManHTML('                         /
             "    i_scnid = " scn_id z3.                        /
             "   ,i_casid = " cas_id z3.                        /
             "   ,i_tstid = " tst_id z3.                        /
             "   ,i_extexp= " tst_exp                           /
             "   ,i_extact= " tst_act                           /
             "   ,o_html  = &l_output/_" scn_id z3. "_" cas_id z3. "_" tst_id z3. "_rep.html"    /
             "   ,o_output= &l_output"                          /
             ")";
      END;

   END; /* falls Testfall seit der letzten Reporterstellung lief */

RUN;

/*-- Report erzeugen ---------------------------------------------------------*/
ODS LISTING CLOSE;
%INCLUDE repgen / source2;
FILENAME repgen;

/*-- Letztes Erstellungsdatum merken -----------------------------------------*/
PROC SQL NOPRINT;
   UPDATE target.tsu 
      SET tsu_lastrep = %sysfunc(datetime())
   ;
QUIT;

%GOTO exit;
%errexit:
   %PUT;
   %PUT ======================== Fehler! reportSASUnit wird abgebrochen! ================================;
   %PUT;
   %PUT;
%exit:
PROC DATASETS NOWARN NOLIST LIB=work;
   DELETE %scan(&d_rep,2,.) %scan(&d_scn,2,.) %scan(&d_cas,2,.) %scan(&d_auton,2,.) 
          %scan(&d_pgm,2,.) %scan(&d_pcs,2,.);
QUIT;
%MEND reportSASUnit;
/** \endcond */
