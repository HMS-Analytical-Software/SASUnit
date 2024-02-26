/**
   \file
   \ingroup    SASUNIT_REPORT 

   \brief      Creation of a test report

   \version    \$Revision: GitBranch: feature/18-bug-sasunitcfg-not-used-in-sas-subprocess $
   \author     \$Author: landwich $
   \date       \$Date: 2024-02-22 11:27:38 (Do, 22. Februar 2024) $
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
            
   \param   i_language         Language of the report (DE, EN) - refer to _nls
   \param   o_html             Test report in HTML-format?
   \param   o_junit            Test report in JUNIT-XML-format?
   \param   o_pgmdoc           Creates source code documentation per examinee (0 / 1)
   \param   o_pgmdoc_sasunit   Creates source code documentation also for sasunit macros (0 / 1)
   \param   o_crossref         Flag if cross reference was triggered (0 / 1) (optional: Default=G_CROSSREF)
   \param   o_testcoverage     Flag if test coverage was triggered (0 / 1) (optional: Default=G_TESTCOVERAGE)
   \param   o_force            0 .. (default) incremental, 1 .. create complete report
   \param   o_output           (optional) full path of the directory in which the test report is created. 
                               If the parameter is not set, the subdirectory rep of the test repository is used.
   \param   i_style            (optional) Name of the SAS style and css file to be used. 
   
   \return Results are created in the subdirectory rep of the test repository or in the directory 
           specified by parameter o_output.
*/ /** \cond */ 
%MACRO reportSASUnit (i_language         = _NONE_
                     ,o_html             = 1
                     ,o_pdf              = 0
                     ,o_junit            = 0
                     ,o_pgmdoc           = _DEFAULT_
                     ,o_pgmdoc_sasunit   = _DEFAULT_
                     ,o_crossref         = &G_CROSSREF.
                     ,o_testcoverage     = &G_TESTCOVERAGE.
                     ,o_force            = 0
                     ,o_output           =
                     ,i_style            = SASUnit
                     );

   %LOCAL
      l_macname
      l_reportsOnly
      l_force
   ; 
   
   %LET l_macname=&sysmacroname;

   %_issueInfoMessage (&g_currentLogger., %str (============================ reportSASUnit is starting... ==========================));
   
   /*-- check parameters --------------------------------------------------------*/
   %IF ("&o_html")  NE "1" %THEN %LET o_html =0;

   %IF ("&o_pdf")   NE "0" %THEN %LET o_pdf  =1;

   %IF ("&o_junit") NE "0" %THEN %LET o_junit=1;

   %IF ("&o_pgmdoc") EQ "_DEFAULT_" %THEN %LET o_pgmdoc=&g_overwrite.;

   %IF ("&o_pgmdoc") NE "1" %THEN %LET o_pgmdoc=0;

   %IF ("&o_pgmdoc_sasunit") EQ "_DEFAULT_" %THEN %LET o_pgmdoc_sasunit=&o_pgmdoc.;

   %IF ("&o_pgmdoc_sasunit") NE "1" %THEN %LET o_pgmdoc_sasunit=0;

   %IF ("&o_force" NE "1") %THEN %LET o_force=0;
   
   %_issueInfoMessage (&g_currentLogger., %str (============================ Checking for reports only... =======================));
   
   %_readParameterFromTestDBtsu (i_parameterName  = tsu_reportsOnly
                                ,o_parameterValue = l_reportsOnly
                                ,o_defaultValue   = 0
                                );
                                
   %let l_force = %eval((&o_force=1) OR (&l_reportsOnly.=1));

   %IF (&o_html. NE 1 AND &o_junit. NE 1 AND &o_pdf. NE 1) %THEN %DO;
      %GOTO exit;
   %END;

   %if (&i_language. = _NONE_) %then %do;
      %_nls (i_language=&g_language.)
   %end;
   %else %do;
      %_nls (i_language=&i_language.)
   %end;

   /*-- check if target folder exists -------------------------------------------*/
   %LOCAL l_output; 
   %IF %length(&o_output.) %THEN %LET l_output=&o_output;
   %ELSE %LET l_output =&g_reportFolder.;
   %LET l_output=%_abspath(&g_root,&l_output.);

   %IF %_handleError(&l_macname.
                    ,InvalidOutputDir
                    ,NOT %_existDir(&l_output.)
                    ,Error in parameter o_output: target &l_output. folder does not exist
                    ) 
      %THEN %GOTO errexit;

   /*-- check if test database can be accessed ----------------------------------*/
   %IF %_handleError(&l_macname.
                    ,NoTestDB
                    ,NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project)
                    ,%nrstr(Test database cannot be accessed, call initSASUnit before reportSASUnit)
                    )
      %THEN %GOTO errexit;

   %LOCAL 
      d_rep 
      d_repexa
   ;
   %_tempFilename(d_rep)
   %_tempFilename(d_repexa)
   %_createRepData(d_reporting =&d_rep.
                  ,d_repexa    =&d_repexa.
                  );

   %IF (%sysfunc(exist (d_rep.))) %THEN %GOTO errexit;

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
   %_reportCreateFormats;

   *** set options for ODS ****;
   ods escapechar="^";

   *** create style ****;
   %local l_rc;
   %let l_rc = %_delfile(&g_resourceFolder./style/template.sas7bitm);

   libname _style "&g_resourceFolder./style";

   ods path reset;
   ods path (PREPEND) _style.template(UPDATE);
   %_reportCreateStyle;
   %_reportCreateTagset;

   ods path reset;
   ods path (PREPEND) _style.template(READ);
   ods path (PREPEND) WORK.template(UPDATE);

   %_mkdir (&l_output./testDoc);
   %_copyMacrosToRepSrc (o_pgmdoc_sasunit=&o_pgmdoc_sasunit.);
   
   %IF (&o_pgmdoc.=1) %THEN %DO;
      %_mkdir (&l_output./pgmDoc);
      %_reportPgmDoc(i_language      =&i_language.
                    ,i_repdata       =&d_rep.
                    ,o_html          =&o_html.
                    ,o_pdf           =&o_pdf.
                    ,o_path          =&l_output.
                    ,o_pgmdoc_sasunit=&o_pgmdoc_sasunit.
                    ,i_style         =&i_style.
                    ,i_srcFolder     =src
                    ,o_pgmDocFolder  =pgmDoc
                    ,i_testDocFolder =testDoc
                    );
   %END;
   %IF (&o_html.=1) %THEN %DO;
      %_openDummyHtmlPage(i_style=&i_style.);
      DATA _null_;
         SET &d_rep end=eof;
         BY scn_id cas_id;
         FILE repgen;

         IF _n_=1 THEN DO;
            /*-- only if testreport is generated competely anew --------------------*/
            IF tsu_lastrep=0 OR &l_force THEN DO;
               /*-- copy static files - images, css etc. ---------------------------*/
               PUT '%_copydir(' /
                   "    &g_resourceFolder." '/html/%str(*)' /
                   "   ,&l_output." /
                   ")";
               /*-- create frame HTML page -----------------------------------------*/
               PUT '%_reportFrameHTML('                   /
                   "    i_repdata = &d_rep"               /
                   "   ,o_html    = &l_output./index.html" /
                   "   ,i_style   = &i_style."            /
                   ")";
            END;
            /*-- only if testsuite has been initialized anew after last report -----*/
            IF tsu_lastinit > tsu_lastrep OR &l_force. THEN DO;
               /*-- convert SAS-log from initSASUnit -------------------------------*/
               PUT '%_reportLogHTML('                            /
                   "    i_log     = &g_scnLogFolder./000.log"              /
                   "   ,i_title   = &g_nls_reportSASUnit_001."    /
                   "   ,o_html    = &l_output./testDoc/000_log.html"      /
                   ")";
            END;
            /*-- only if a test scenario has been run since last report ------------*/
            IF &l_lastrun > tsu_lastrep OR &l_bOnlyInexistingScnFound. OR &l_force. THEN DO;
               /*-- create table of contents ---------------------------------------*/
               PUT '%_reportTreeHTML('                            /
                   "    i_repdata        = &d_rep."               /
                   "   ,o_html           = &l_output./tree.html"  /
                   "   ,o_pgmdoc         = &o_pgmdoc"             /
                   "   ,o_pgmdoc_sasunit = &o_pgmdoc_sasunit"     /
                   "   ,i_style          = &i_style."             /
                   "   ,o_pgmDocFolder   = pgmDoc"                /
                   "   ,i_repdataexa     = &d_repexa."            /
                   ")";
               if (&o_pdf.) then do;
                  PUT "ods pdf file=""&l_output./SASUnit_Test_Doc.pdf"" style=styles.&i_style. cssstyle=""css/&i_style..css""" /
                      " startpage=never;";
               end;
               /*-- create list of test scenarios ----------------------------------*/
               PUT '%_reportScnHTML('                    /
                   "    i_repdata       = &d_rep."       /
                   "   ,o_html          = &o_html."      /
                   "   ,o_path          = &l_output."    /
                   "   ,o_file          = scn_overview"  /
                   "   ,o_pgmdoc        = &o_pgmdoc"     /
                   "   ,i_style         = &i_style."     /
                   "   ,o_pgmDocFolder  = pgmDoc"       /
                   "   ,o_testDocFolder = testDoc"       /
                   ")";
               if (&o_pdf.) then do;
                  PUT "ods pdf startpage=now;";
               end;
               /*-- create list of test cases --------------------------------------*/
               PUT '%_reportCasHTML('              /
                   "    i_repdata = &d_rep"        /
                   "   ,o_html    = &o_html."      /
                   "   ,o_path    = &l_output."    /
                   "   ,o_file    = cas_overview"  /
                   "   ,o_pgmdoc  = &o_pgmdoc."    /
                   "   ,i_style   = &i_style."     /
                   ")";
               if (&o_pdf.) then do;
                  PUT "ods pdf startpage=now;";
               end;
               /*-- create list of units under test --------------------------------*/
               PUT '%_reportAutonHTML('              /
                   "    i_repdata      = &d_rep"          /
                   "   ,o_html         = &o_html."        /
                   "   ,o_path         = &l_output."      /
                   "   ,o_file         = auton_overview"  /
                   "   ,o_pgmdoc       = &o_pgmdoc."      /
                   "   ,o_crossref     = &o_crossref."    /
                   "   ,o_testcoverage = &o_testcoverage."    /
                   "   ,i_style        = &i_style."       /
                   ")";
               if (&o_pdf.) then do;
                  PUT 'ods pdf close;';
               end;
            END;
         END;

         /*-- per scenario ---------------------------------------------------------*/
         IF first.scn_id AND scn_id NE . THEN DO;
            /*-- only if scenario has been run since report ------------------------*/
            IF scn_start > tsu_lastrep OR &l_force THEN DO;
               /*-- convert logfile of scenario ------------------------------------*/
               PUT '%_reportLogHTML(' / 
                   "    i_log     = &g_scnLogFolder./" scn_id z3. ".log"  /
                   "   ,i_title   = &g_nls_reportSASUnit_002 " scn_id z3. " (" cas_obj +(-1) ")" /
                   "   ,o_html    = &l_output./testDoc/" scn_id z3. "_log.html" /
                   ")";
               /*-- compile detail information for test case -----------------------*/
               PUT '%_reportDetailHTML('              /
                   "    i_repdata = &d_rep"           /
                   "   ,i_scnid   = " scn_id z3.      /
                   "   ,o_html    = &o_html."         /
                   "   ,o_path    = &l_output./testDoc"       /
                   "   ,o_file    = cas_" scn_id z3.  /
                   "   ,i_style   = &i_style."        /
                   ")";
            END;
         END;

         /*-- only if test case has been run since last report ---------------------*/
         IF cas_start > tsu_lastrep OR &l_force THEN DO;

            /*-- per test case -----------------------------------------------------*/
            IF first.cas_id AND scn_id NE . AND cas_id NE . THEN DO;
               /*-- convert logfile of test case -----------------------------------*/
               PUT '%_reportLogHTML(' /
                   "    i_log     = &g_scnLogFolder./" scn_id z3. "_" cas_id z3. ".log" /
                   "   ,i_title   = &g_nls_reportSASUnit_003 " cas_id z3. " &g_nls_reportSASUnit_004 " scn_id z3. " (" cas_obj +(-1) ")" /
                   "   ,o_html    = &l_output./testDoc/" scn_id z3. "_" cas_id z3. "_log.html" /
                   ")";
            END;

         END; /* if test case has been run since last report */

         IF (eof) THEN DO;
            /*-- only if a test scenario has been run since last report ------------*/
            IF &l_lastrun > tsu_lastrep OR &l_bOnlyInexistingScnFound. OR &l_force. THEN DO;
               /*-- create overview page -------------------------------------------*/
               PUT '%_reportHomeHTML('             /
                   "    i_repdata = &d_rep"        /
                   "   ,o_html    = &o_html."      /
                   "   ,o_path    = &l_output."    /
                   "   ,o_file    = overview"      /
                   "   ,i_style   = &i_style."     /
                   ")";
            END;
         END;
      RUN;

      /*-- create report -----------------------------------------------------------*/
      ODS HTML CLOSE;
      ODS LISTING CLOSE;
      %INCLUDE repgen / source2;
      FILENAME repgen;
   %END;
   %IF (&o_junit.=1) %THEN %DO;
      %_reportJUnitXML(i_repdata=&d_rep.
                      ,o_file   =&l_output./junit.xml
                      )
   %END;

   /*-- save last report date ---------------------------------------------------*/
   %_writeParameterToTestDBtsu (i_parameterName=tsu_lastrep, i_parameterValue=%sysfunc(datetime()));

   %GOTO exit;
%errexit:
      %_issueInfoMessage (&g_currentLogger., %str (======================== Error! reportSASUnit aborted! ==========================================));
%exit:
   PROC DATASETS NOWARN NOLIST LIB=work;
      DELETE %scan(&d_rep.,2,.)
             ;
   QUIT;
   %_issueInfoMessage (&g_currentLogger., %str (============================ reportSASUnit has finished creating documentation ==========================));
%MEND reportSASUnit;
/** \endcond */ 