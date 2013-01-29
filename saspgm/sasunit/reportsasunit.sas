/**
   \file
   \ingroup    SASUNIT_CNTL 

   \brief      Creation of a test report

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_language     Language of the report (DE, EN) - refer to _sasunit_nls
   \param   o_html         Test report in HTML-format?
   \param   o_force        0 .. (default) incremental, 1 .. create complete report
   \param   o_output       (optional) full path of the directory in which the test report is created. 
                           If the parameter is not set, the subdirectory rep of the test repository is used.
   \return Results are created in the subdirectory rep of the test repository or in the directory 
           specified by parameter o_output.

*/ /** \cond */ 

/* change log 
   29.01.2013 KL  changed link from _sasunit_doc.sas to Sourceforge SASUnit User's Guide
   28.01.2013 KL  Adjusted descriptions of testcases
   08.01.2013 KL  Empty cells are rendered incorrectly in MS IE. So &nbsp; is now used as contents of an empty cell
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

/*-- check parameters --------------------------------------------------------*/
%IF "&o_html" NE "1" %THEN %LET o_html=0;

%IF "&o_force" NE "1" %THEN %LET o_force=0;

%_sasunit_nls (i_language=&i_language)

/*-- check if target folder exists -------------------------------------------*/
%LOCAL l_output; 
%IF %length(&o_output) %THEN %LET l_output=&o_output;
%ELSE %LET l_output =&g_target/rep;
%LET l_output=%_sasunit_abspath(&g_root,&l_output);

%IF %_sasunit_handleError(&l_macname, InvalidOutputDir, 
   NOT %_sasunit_existDir(&l_output), 
   Error in parameter o_output: target folder does not exist) 
   %THEN %GOTO errexit;

/*-- check if test database can be accessed ----------------------------------*/
%IF %_sasunit_handleError(&l_macname, NoTestDB, 
   NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project), 
   %nrstr(Test database cannot be accessed, call %initSASUnit before %reportSASUnit))
   %THEN %GOTO errexit;

/*-- generate temporary datasets ---------------------------------------------*/
%LOCAL 
   d_rep 
   d_scn 
   d_cas01 
   d_auton 
   d_pgm 
   d_pcs 
   d_emptyscn 
   d_cas
   d_tst
;
%_sasunit_tempFilename(d_rep)
%_sasunit_tempFilename(d_scn)
%_sasunit_tempFilename(d_cas01)
%_sasunit_tempFilename(d_auton)
%_sasunit_tempFilename(d_pgm)
%_sasunit_tempFilename(d_pcs)
%_sasunit_tempFilename(d_emptyscn)
%_sasunit_tempFilename(d_cas)
%_sasunit_tempFilename(d_tst)


/*-- check for empty scenarios and generate entries in temporary copies of cas and tst datasets,
     in order to make scenario appear in report with a dummy test case --------------------------- */
%LOCAL
   l_sEmptyScnDummyCasDesc
;
%LET l_sEmptyScnDummyCasDesc = %STR(no valid test case found - must be red!);

PROC SQL NOPRINT;
   CREATE TABLE &d_emptyscn. AS
      SELECT
         t1.scn_id
         FROM target.scn t1
         WHERE t1.scn_id NOT IN
         (
            SELECT
               Distinct cas_scnid
               FROM target.cas
         )
   ;
QUIT;


PROC SQL NOPRINT;
   CREATE TABLE &d_cas. AS
      SELECT
        t1.*
       FROM target.cas t1
   ;
   INSERT INTO &d_cas.
   (
      cas_scnid
     ,cas_id
     ,cas_auton
     ,cas_pgm
     ,cas_desc
     ,cas_spec
     ,cas_start
     ,cas_end
     ,cas_res
   )
   (
      SELECT
          scn_id
         ,1
         ,0
         ,'&#160;'
         ,"&l_sEmptyScnDummyCasDesc."
         ,'&#160;'
         ,.
         ,.
         ,1
         FROM &d_emptyscn.
   )
   ;
QUIT;

PROC SQL NOPRINT;
  CREATE TABLE &d_tst. AS
    SELECT
      t1.*
      FROM target.tst t1
  ;
  INSERT INTO &d_tst.
  (
    tst_scnid
   ,tst_casid
   ,tst_id
   ,tst_type
   ,tst_desc
   ,tst_exp
   ,tst_act
   ,tst_res
  )
  (
    SELECT
       scn_id
      ,1
      ,0
      ,'&#160;'
      ,'&#160;'
      ,'&#160;'
      ,'&#160;'
      ,1
      FROM &d_emptyscn.
  )
  ;  
QUIT;

/*-- generate a last-flag for treeview ---------------------------------------*/
PROC SORT DATA=target.scn OUT=&d_scn;
   BY scn_id;
RUN;
DATA &d_scn;
   SET &d_scn END=eof;
   scn_last = eof;
RUN;

PROC SORT DATA=&d_cas OUT=&d_cas01;
   BY cas_scnid cas_id;
RUN;
DATA &d_cas01;
   SET &d_cas01;
   BY cas_scnid;
   cas_last = last.cas_scnid;
   cas_pgmucase = upcase(cas_pgm);
RUN;

PROC SORT DATA=&d_cas (KEEP=cas_auton RENAME=(cas_auton=auton_id)) 
          OUT=&d_auton NODUPKEY;
   BY auton_id;
RUN;
DATA &d_auton;
   SET &d_auton END=eof;
   auton_last = eof;
RUN;

data &d_pgm;
   SET &d_cas (KEEP=cas_auton cas_pgm RENAME=(cas_auton=pgm_auton cas_pgm=pgm_ucase));
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
   SET &d_cas (KEEP=cas_auton cas_pgm cas_scnid cas_id RENAME=(cas_auton=pcs_auton cas_pgm=pcs_ucase cas_scnid=pcs_scnid cas_id=pcs_casid));
   pcs_ucase = upcase(pcs_ucase);
PROC SORT DATA=&d_pcs OUT=&d_pcs NODUPKEY;
   BY pcs_auton pcs_ucase pcs_scnid pcs_casid;
RUN;
DATA &d_pcs;
   SET &d_pcs;
   BY pcs_auton pcs_ucase;
   pcs_last = last.pcs_ucase;
RUN;

/*-- create reporting dataset ------------------------------------------------*/
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
      ,scn_errorcount
      ,scn_warningcount 
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
      ,&d_cas01.
      ,&d_tst
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

/*-- determine last run ------------------------------------------------------*/
%LOCAL 
   l_lastrun
   l_bOnlyInexistingScnFound
;
PROC SQL NOPRINT;
   SELECT coalesce(max(scn_start),0) FORMAT=12.0 INTO :l_lastrun FROM target.scn;
QUIT;

/*-- determine whether only invalid scenarios are present (were not run, but shall be reported) ---*/
%LET l_bOnlyInexistingScnFound = 1;
DATA _NULL_;
   SET target.scn ( KEEP = scn_start );
   IF scn_start > 0 THEN DO;
      /* 'real' scenario found */
      Call Symputx ('l_bOnlyInexistingScnFound', '0');
      STOP;
   END;
RUN;

/*-- report generator --------------------------------------------------------*/
FILENAME repgen temp;

DATA _null_;
   SET &d_rep;
   BY scn_id cas_id;
   FILE repgen;

   IF _n_=1 THEN DO;
      /*-- only if testreport is generated competely anew --------------------*/
      IF tsu_lastrep=0 OR &o_force THEN DO;
         /*-- copy static files - images, css etc. ---------------------------*/
         PUT '%_sasunit_copydir(' /
             "    &g_sasunit" '/html/%str(*.*)' /
             "   ,&l_output" /
             ")";
         /*-- create frame HTML page -----------------------------------------*/
         PUT '%_sasunit_reportFrameHTML('                 /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/index.html"   /
             ")";
      END;
      /*-- only if testsuite has been initialized anew after last report -----*/
      IF tsu_lastinit > tsu_lastrep OR &o_force THEN DO;
         /*-- convert SAS-log from initSASUnit -------------------------------*/
         PUT '%_sasunit_reportLogHTML('                   /
             "    i_log     = &g_log/000.log"             /
             "   ,i_title   = &g_nls_reportSASUnit_001"    /
             "   ,o_html    = &l_output/000_log.html" /
             ")";
         /*-- create overview page -------------------------------------------*/
         PUT '%_sasunit_reportHomeHTML('                   /
             "    i_repdata = &d_rep"                      /
             "   ,o_html    = &l_output/overview.html" /
             ")";
      END;
      /*-- only if a test scenario has been run since last report ------------*/
      IF &l_lastrun > tsu_lastrep OR &l_bOnlyInexistingScnFound. OR &o_force. THEN DO;
         /*-- create table of contents ---------------------------------------*/
         PUT '%_sasunit_reportTreeHTML('                  /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/tree.html"    /
             ")";
         /*-- create list of test scenarios ----------------------------------*/
         PUT '%_sasunit_reportScnHTML('                   /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/scn_overview.html"    /
             ")";
         /*-- create list of test cases --------------------------------------*/
         PUT '%_sasunit_reportCasHTML('                   /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/cas_overview.html"    /
             ")";
         /*-- create list of units under test --------------------------------*/
         PUT '%_sasunit_reportAutonHTML('                   /
             "    i_repdata = &d_rep"                     /
             "   ,o_html    = &l_output/auton_overview.html"    /
             ")";
      END;
   END;

   /*-- per scenario ---------------------------------------------------------*/
   IF first.scn_id AND scn_id NE . THEN DO;
      /*-- only if scenario has been run since report ------------------------*/
      IF scn_start > tsu_lastrep OR &o_force THEN DO;
         /*-- convert logfile of scenario ------------------------------------*/
         PUT '%_sasunit_reportLogHTML(' / 
             "    i_log     = &g_log/" scn_id z3. ".log"  /
             "   ,i_title   = &g_nls_reportSASUnit_002 " scn_id z3. " (" cas_pgm +(-1) ")" /
             "   ,o_html    = &l_output/" scn_id z3. "_log.html" /
             ")";
      END;
   END;

   /*-- only if test case has been run since last report ---------------------*/
   IF cas_start > tsu_lastrep OR &o_force THEN DO;

      /*-- per test case -----------------------------------------------------*/
      IF first.cas_id AND scn_id NE . AND cas_id NE . THEN DO;
         /*-- convert logfile of test case -----------------------------------*/
         PUT '%_sasunit_reportLogHTML(' /
             "    i_log     = &g_log/" scn_id z3. "_" cas_id z3. ".log" /
             "   ,i_title   = &g_nls_reportSASUnit_003 " cas_id z3. " &g_nls_reportSASUnit_004 " scn_id z3. " (" cas_pgm +(-1) ")" /
             "   ,o_html    = &l_output/" scn_id z3. "_" cas_id z3. "_log.html" /
             ")";
         /*-- compile detail information for test case -----------------------*/
         PUT '%_sasunit_reportDetailHTML('                   /
             "    i_repdata = &d_rep"                        /
             "   ,i_scnid   = " scn_id z3.                   /
             "   ,i_casid   = " cas_id z3.                   /
             "   ,o_html    = &l_output/cas_" scn_id z3. "_" cas_id z3. ".html"    /
             ")";
      END;
 
      /*-- per test assertColumns --------------------------------------------*/
      IF scn_id NE . AND cas_id NE . AND tst_id NE . AND upcase(tst_type) = 'ASSERTCOLUMNS' THEN DO;
         PUT '%_sasunit_reportCmpHTML('                         /
             "    i_scnid = " scn_id z3.                        /
             "   ,i_casid = " cas_id z3.                        /
             "   ,i_tstid = " tst_id z3.                        /
             "   ,o_html  = &l_output"                          /
             ")";
      END;

      /*-- per test assertLibrary --------------------------------------------*/
      IF scn_id NE . AND cas_id NE . AND tst_id NE . AND upcase(tst_type) = 'ASSERTLIBRARY' THEN DO;
         PUT '%_sasunit_reportLibraryHTML('                         /
             "    i_scnid = " scn_id z3.                        /
             "   ,i_casid = " cas_id z3.                        /
             "   ,i_tstid = " tst_id z3.                        /
             "   ,o_html  = &l_output"                          /
             ")";
      END;

      /*-- per test assertReport ---------------------------------------------*/
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

   END; /* if test case has been run since last report */

RUN;

/*-- create report -----------------------------------------------------------*/
ODS LISTING CLOSE;
%INCLUDE repgen / source2;
FILENAME repgen;

/*-- save last report date ---------------------------------------------------*/
PROC SQL NOPRINT;
   UPDATE target.tsu 
      SET tsu_lastrep = %sysfunc(datetime())
   ;
QUIT;

%GOTO exit;
%errexit:
   %PUT;
   %PUT ======================== Error! reportSASUnit aborted! ==========================================;
   %PUT;
   %PUT;
%exit:
PROC DATASETS NOWARN NOLIST LIB=work;
   DELETE %scan(&d_rep,2,.) %scan(&d_scn,2,.) %scan(&d_cas01.,2,.) %scan(&d_cas.,2,.) %scan(&d_auton,2,.) 
          %scan(&d_pgm,2,.) %scan(&d_pcs,2,.) %scan(&d_emptyscn.,2,.);
QUIT;
%MEND reportSASUnit;
/** \endcond */
