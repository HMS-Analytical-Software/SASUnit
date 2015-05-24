/**
   \file
   \ingroup    SASUNIT_REPORT 

   \brief      Creation of a test report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_language     Language of the report (DE, EN) - refer to _nls
   \param   o_html         Test report in HTML-format?
   \param   o_junit        Test report in JUNIT-XML-format?
   \param   o_force        0 .. (default) incremental, 1 .. create complete report
   \param   o_output       (optional) full path of the directory in which the test report is created. 
                           If the parameter is not set, the subdirectory rep of the test repository is used.
   \return Results are created in the subdirectory rep of the test repository or in the directory 
           specified by parameter o_output.
           
*/ /** \cond */ 

%MACRO reportSASUnit (i_language   = EN
                     ,o_html       = 1
                     ,o_junit      = 0
                     ,o_force      = 0
                     ,o_output     =
                     );

   %LOCAL l_macname; 
   %LET l_macname=&sysmacroname;

   /*-- check parameters --------------------------------------------------------*/
   %IF "&o_html" NE "1" %THEN %LET o_html=0;

   %IF "&o_force" NE "1" %THEN %LET o_force=0;

   %IF "&o_junit" NE "1" %THEN %LET o_junit=0;

   %IF ("&o_html" NE "1" AND "&o_junit" NE "1") %THEN %DO;
      %GOTO exit;
   %END;

   %_nls (i_language=&i_language)

   /*-- check if target folder exists -------------------------------------------*/
   %LOCAL l_output; 
   %IF %length(&o_output) %THEN %LET l_output=&o_output;
   %ELSE %LET l_output =&g_target/rep;
   %LET l_output=%_abspath(&g_root,&l_output);

   %IF %_handleError(&l_macname.
                    ,InvalidOutputDir
                    ,NOT %_existDir(&l_output)
                    ,Error in parameter o_output: target folder does not exist
                    ,i_verbose=&g_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check if test database can be accessed ----------------------------------*/
   %IF %_handleError(&l_macname.
                    ,NoTestDB
                    ,NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project)
                    ,%nrstr(Test database cannot be accessed, call initSASUnit before reportSASUnit)
                    ,i_verbose=&g_verbose.
                    )
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
   %_tempFilename(d_rep)
   %_tempFilename(d_scn)
   %_tempFilename(d_cas01)
   %_tempFilename(d_auton)
   %_tempFilename(d_pgm)
   %_tempFilename(d_pcs)
   %_tempFilename(d_emptyscn)
   %_tempFilename(d_cas)
   %_tempFilename(d_tst)


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
        ,cas_obj
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
            ,'^_'
            ,"&l_sEmptyScnDummyCasDesc."
            ,'^_'
            ,.
            ,.
            ,2
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
      ,tst_errmsg
     )
     (
       SELECT
          scn_id
         ,1
         ,0
         ,'^_'
         ,'^_'
         ,'^_'
         ,'^_'
         ,2
         ,''
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

   PROC SQL noprint;
      create table &d_cas01. as
         select %scan (&d_cas.,2,.).*
               ,exa_pgm
               ,exa_filename
               ,exa_auton
               ,exa_path
         from &d_cas. left join target.exa
         on %scan (&d_cas.,2,.).cas_exaid = exa.exa_id
         order by cas_scnid, cas_id;
   quit;

   DATA &d_cas01.;
      SET &d_cas01.;
      BY cas_scnid;
      cas_last = last.cas_scnid;
      cas_objucase = upcase(exa_pgm);
   RUN;

   PROC SQL noprint;
      create table &d_auton. as
         select distinct exa_auton as auton_id
            from &d_cas. left join target.exa
            on cas_exaid = exa_id
            order by auton_id;
   QUIT;
   DATA &d_auton.;
      SET &d_auton. END=eof;
      auton_last = eof;
   RUN;

   PROC SQL noprint;
      create table &d_pgm. as 
         select exa_auton as pgm_auton
               ,upcase (exa_pgm) as pgm_ucase
         from &d_cas. left join target.exa
         on cas_exaid = exa_id;
   QUIT;
   PROC SORT DATA=&d_pgm. NODUPKEY;
      BY pgm_auton pgm_ucase;
   RUN;
   DATA &d_pgm._;
      SET &d_pgm.;
      BY pgm_auton;
      IF first.pgm_auton THEN pgm_id=0;
      pgm_id+1;
      pgm_last = last.pgm_auton;
   RUN;
   PROC SQL NOPRINT;
      create table work.pgm_res as
         select upcase (cas_obj) as pgm_ucase
               ,max (cas_res) as pgm_res
         from &d_cas.
         group by cas_obj;
      create table &d_pgm. as
         select a.*
               ,b.pgm_res
         from &d_pgm._ a left join work.pgm_res b
         on a.pgm_ucase = b.pgm_ucase;
   QUIT;

   PROC SQL noprint;
      create table &d_pcs. as 
         select exa_auton as pcs_auton
               ,upcase (exa_pgm) as pcs_ucase
               ,cas_scnid as pcs_scnid
               ,cas_id as pcs_casid
         from &d_cas. left join target.exa
         on cas_exaid = exa_id;
   QUIT;
   PROC SORT DATA=&d_pcs OUT=&d_pcs NODUPKEY;
      BY pcs_auton pcs_ucase pcs_scnid pcs_casid;
   RUN;
   DATA &d_pcs.;
      SET &d_pcs.;
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
         ,tsu_sasunit_os
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
         ,tsu_dbversion
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
         ,exa_auton
         ,exa_pgm
         ,exa_filename
         ,exa_path
         ,auton_last
         ,cas_obj  
         ,pgm_id
         ,pgm_last
         ,pcs_last
         ,pgm_res
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
         ,tst_errmsg
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
         scn_id       = tst_scnid AND
         cas_id       = tst_casid AND
         auton_id     = exa_auton AND
         cas_objucase = pgm_ucase AND
         exa_auton    = pgm_auton AND
         cas_objucase = pcs_ucase AND
         scn_id       = pcs_scnid AND
         cas_id       = pcs_casid
      ORDER BY scn_id, cas_id, tst_id;
      CREATE UNIQUE INDEX idx1 ON &d_rep. (scn_id, cas_id, tst_id);
      CREATE UNIQUE INDEX idx2 ON &d_rep. (exa_auton, pgm_id, scn_id, cas_id, tst_id);
   QUIT;

   %IF %_handleError(&l_macname.
                    ,ErrorTestDB
                    ,&syserr. NE 0
                    ,%nrstr(Fehler beim Zugriff auf die Testdatenbank)
                    ,i_verbose=&g_verbose.
                    )
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

   *** Create formats used in reports ***;
   proc format lib=work;
      value PictName     0 = "&g_sasunitroot./resources/html/ok.png"
                         1 = "&g_sasunitroot./resources/html/manual.png"
                         2 = "&g_sasunitroot./resources/html/error.png"
                         OTHER="?????";
      value PictNameHTML 0 = "ok.png"
                         1 = "manual.png"
                         2 = "error.png"
                         OTHER="?????";
      value PictDesc     0 = "OK"
                         1 = "&g_nls_reportDetail_026"
                         2 = "&g_nls_reportDetail_025"
                         OTHER = "&g_nls_reportDetail_027";
   run;

   *** set options for ODS ****;
   ods escapechar="^";

   *** create style ****;
   %local l_rc;
   %let l_rc = %_delfile(&g_sasunitroot./resources/style/template.sas7bitm);

   libname _style "&g_sasunitroot./resources/style";

   ods path reset;
   ods path (PREPEND) _style.template(UPDATE);
   %_reportCreateStyle;
   %_reportCreateTagset;

   ods path reset;
   ods path (PREPEND) _style.template(READ);
   ods path (PREPEND) WORK.template(UPDATE);

   %IF (&o_html.=1) %THEN %DO;
      %_openDummyHtmlPage;
      DATA _null_;
         SET &d_rep;
         BY scn_id cas_id;
         FILE repgen;

         IF _n_=1 THEN DO;
            /*-- only if testreport is generated competely anew --------------------*/
            IF tsu_lastrep=0 OR &o_force THEN DO;
               /*-- copy static files - images, css etc. ---------------------------*/
               PUT '%_copydir(' /
                   "    &g_sasunitroot./resources" '/html/%str(*)' /
                   "   ,&l_output" /
                   ")";
               /*-- create frame HTML page -----------------------------------------*/
               PUT '%_reportFrameHTML('             /
                   "    i_repdata = &d_rep"                 /
                   "   ,o_html    = &l_output/index.html"   /
                   ")";
            END;
            /*-- only if testsuite has been initialized anew after last report -----*/
            IF tsu_lastinit > tsu_lastrep OR &o_force THEN DO;
               /*-- convert SAS-log from initSASUnit -------------------------------*/
               PUT '%_reportLogHTML('                   /
                   "    i_log     = &g_log/000.log"             /
                   "   ,i_title   = &g_nls_reportSASUnit_001"    /
                   "   ,o_html    = &l_output/000_log.html" /
                   ")";
               /*-- create overview page -------------------------------------------*/
               PUT '%_reportHomeHTML('                   /
                   "    i_repdata = &d_rep"                      /
                   "   ,o_html    = &o_html."    /
                   "   ,o_path    = &l_output."    /
                   "   ,o_file    = overview"    /
                   ")";
            END;
            /*-- only if a test scenario has been run since last report ------------*/
            IF &l_lastrun > tsu_lastrep OR &l_bOnlyInexistingScnFound. OR &o_force. THEN DO;
               /*-- create table of contents ---------------------------------------*/
               PUT '%_reportTreeHTML('                  /
                   "    i_repdata = &d_rep"                     /
                   "   ,o_html    = &l_output/tree.html"    /
                   ")";
               /*-- create list of test scenarios ----------------------------------*/
               PUT '%_reportScnHTML('                   /
                   "    i_repdata = &d_rep."                     /
                   "   ,o_html    = &o_html."    /
                   "   ,o_path    = &l_output."    /
                   "   ,o_file    = scn_overview"    /
                   ")";
               /*-- create list of test cases --------------------------------------*/
               PUT '%_reportCasHTML('                   /
                   "    i_repdata = &d_rep"                     /
                   "   ,o_html    = &o_html."    /
                   "   ,o_path    = &l_output."    /
                   "   ,o_file    = cas_overview"    /
                   ")";
               /*-- create list of units under test --------------------------------*/
               PUT '%_reportAutonHTML('                   /
                   "    i_repdata = &d_rep"                     /
                   "   ,o_html    = &o_html."    /
                   "   ,o_path    = &l_output."    /
                   "   ,o_file    = auton_overview"    /
                   ")";
      /* Creates Report Lists Only
               PUT '%_reportpgmlists('                /
                   "    i_language = &i_language."          /
                   ")";
      /**/
            END;
         END;

         /*-- per scenario ---------------------------------------------------------*/
         IF first.scn_id AND scn_id NE . THEN DO;
            /*-- only if scenario has been run since report ------------------------*/
            IF scn_start > tsu_lastrep OR &o_force THEN DO;
               /*-- convert logfile of scenario ------------------------------------*/
               PUT '%_reportLogHTML(' / 
                   "    i_log     = &g_log/" scn_id z3. ".log"  /
                   "   ,i_title   = &g_nls_reportSASUnit_002 " scn_id z3. " (" cas_obj +(-1) ")" /
                   "   ,o_html    = &l_output/" scn_id z3. "_log.html" /
                   ")";
               /*-- compile detail information for test case -----------------------*/
               PUT '%_reportDetailHTML('                   /
                   "    i_repdata = &d_rep"                        /
                   "   ,i_scnid   = " scn_id z3.                   /
                   "   ,o_html    = &o_html."    /
                   "   ,o_path    = &l_output."    /
                   "   ,o_file    = cas_" scn_id z3.  /
                   ")";
/* Needs modification to create PGMDOC for ONE(!) examinee
               PUT '%_reportpgmdoc('                /
                   "    i_language = &i_language."          /
                   ")";
*/
            END;
         END;

         /*-- only if test case has been run since last report ---------------------*/
         IF cas_start > tsu_lastrep OR &o_force THEN DO;

            /*-- per test case -----------------------------------------------------*/
            IF first.cas_id AND scn_id NE . AND cas_id NE . THEN DO;
               /*-- convert logfile of test case -----------------------------------*/
               PUT '%_reportLogHTML(' /
                   "    i_log     = &g_log/" scn_id z3. "_" cas_id z3. ".log" /
                   "   ,i_title   = &g_nls_reportSASUnit_003 " cas_id z3. " &g_nls_reportSASUnit_004 " scn_id z3. " (" cas_obj +(-1) ")" /
                   "   ,o_html    = &l_output/" scn_id z3. "_" cas_id z3. "_log.html" /
                   ")";
            END;

         END; /* if test case has been run since last report */

      RUN;

      /*-- create report -----------------------------------------------------------*/
      ODS HTML CLOSE;
      ODS LISTING CLOSE;
      %INCLUDE repgen / source2;
      FILENAME repgen;
   %END;
   %IF (&o_junit.=1) %THEN %DO;
      %_reportJUnitXML(o_file=&l_output./junit.xml)
   %END;

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
