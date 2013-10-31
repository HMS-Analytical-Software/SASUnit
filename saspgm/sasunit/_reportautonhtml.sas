/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create a list of units under test for HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input data set (created in reportSASUnit.sas)
   \param   o_html         flag to output file in HTML format
   \param   o_path         path for output file
   \param   o_file         name of the outputfile without extension

*/ /** \cond */ 

%MACRO _reportAutonHTML (i_repdata = 
                        ,o_html    =
                        ,o_path    =
                        ,o_file    =
                        );

   /*-- determine number of scenarios 
     and number of test cases per unit under test ----------------------------*/
   %LOCAL d_rep1 d_rep2 l_tcg_res l_pgmLibraries l_pgmLib l_title l_logpath l_cAuton;

   %_tempFileName(d_rep1)
   %_tempFileName(d_rep2)

   PROC MEANS NOPRINT NWAY missing DATA=&i_repdata(KEEP=cas_auton pgm_id scn_id cas_id);
      class cas_auton pgm_id scn_id cas_id;
      OUTPUT OUT=&d_rep1. (rename=(_FREQ_=scn_tst));
   RUN;

   PROC MEANS NOPRINT NWAY missing DATA=&d_rep1.(KEEP=cas_auton pgm_id scn_id scn_tst);
      class cas_auton pgm_id scn_id;
      OUTPUT OUT=&d_rep2. (rename=(_FREQ_=scn_cas)) sum(scn_tst)=scn_tst;
   RUN;

   proc sort data=&i_repdata. out=work._auton_report;
      by cas_auton pgm_id scn_id;
   run;

   data work._auton_report;
      set work._auton_report;
      by cas_auton pgm_id scn_id;
      if (first.scn_id);
   run;

   data work._auton_report;
      merge work._auton_report &d_rep2.;
      by cas_auton pgm_id scn_id;
   run;

   %IF &g_testcoverage. EQ 1 %THEN %DO;
       /*-- in the log subdir: append all *.tcg files to one file named 000.tcg
        This is done in order to get one file containing coverage data 
        of all calls to the macros under test -----------------------------------*/

      %let l_rc =%_delFile("&g_log/000.tcg");

      %let l_logpath=%_escapeBlanks(&g_log.);

      FILENAME allfiles "&l_logpath./*.tcg";
      DATA _null_;
         INFILE allfiles end=done dlm=',';
         FILE "&l_logpath./000.tcg";
         INPUT row :$256.;
         PUT row;
      RUN;

      /*-- for every unit under test (see ‘target’ database ): 
       call new macro _reporttcghtml.sas once in order to get a html 
       file showing test coverage for the given unit under test. For every call, 
       use the 000.tcg file as coverage analysis text file ---------------------*/
      
      PROC SQL NOPRINT;
         SELECT DISTINCT cas_pgm 
         INTO :l_unitUnderTestList SEPARATED BY '*'
         FROM work._auton_report;
      QUIT;
      /* Add col tcg_pct to data set &d_rep1 to store coverage percentage for report generation*/
      DATA work._auton_report (COMPRESS=YES);
         LENGTH tcg_pct 8;
         SET work._auton_report;
         tcg_pct = .;
      RUN;

      %LET l_listCount=%sysfunc(countw(&l_unitUnderTestList.,'*'));
      %do i = 1 %to &l_listCount;
         %LET l_currentUnit=%lowcase(%scan(&l_unitUnderTestList,&i,*));
         %IF "%sysfunc(compress(&l_currentUnit.))" EQ "" %THEN %DO;
            %LET l_tcg_res = .;
         %END;
         %ELSE %DO;
            /*determine where macro source file is located*/ 
            %let l_currentUnitLocation=;
            %let l_currentUnitFileName=;
            %IF (%SYSFUNC(FILEEXIST(&l_currentUnit.))) %THEN %DO; /*full absolute path given*/
               %_getAbsPathComponents(
                       i_absPath         = &l_currentUnit
                     , o_fileName        = l_currentUnitFileName
                     , o_pathWithoutName = l_currentUnitLocation
                     )
            %END; 
            %ELSE %DO; /*relative path given*/
               %IF (%SYSFUNC(FILEEXIST(&g_root./&l_currentUnit.))) %THEN %DO; /*relative path in root dir */
                  %_getAbsPathComponents(
                       i_absPath         = &g_root./&l_currentUnit.
                     , o_fileName        = l_currentUnitFileName
                     , o_pathWithoutName = l_currentUnitLocation
                     )
               %END;
               %ELSE %DO; /*relative path in one of the sasautos dirs */
                  %IF (%SYSFUNC(FILEEXIST(&g_sasunit./&l_currentUnit.))) %THEN %DO;
                      %_getAbsPathComponents(
                       i_absPath         = &g_sasunit./&l_currentUnit.
                     , o_fileName        = l_currentUnitFileName
                     , o_pathWithoutName = l_currentUnitLocation
                     )
                  %END;
                  %ELSE %IF (%SYSFUNC(FILEEXIST(&g_sasunit_os./&l_currentUnit.))) %THEN %DO;
                      %_getAbsPathComponents(
                       i_absPath         = &g_sasunit_os./&l_currentUnit.
                     , o_fileName        = l_currentUnitFileName
                     , o_pathWithoutName = l_currentUnitLocation
                     )
                  %END;
                  %ELSE %DO;
                     %LET j = 0;
                     %DO %UNTIL ("&l_currentUnitLocation." NE "" OR &j. EQ 10);
                        %IF (%SYSFUNC(FILEEXIST(&&g_sasautos&j/&l_currentUnit.))) %THEN %DO;
                           %_getAbsPathComponents(
                                i_absPath         = &&g_sasautos&j/&l_currentUnit.
                              , o_fileName        = l_currentUnitFileName
                              , o_pathWithoutName = l_currentUnitLocation
                             )
                        %END;
                        %LET j = %EVAL(&j + 1);
                     %END;
                  %END;
               %END;
            %END;
            %let l_tcg_res=.;

            %IF ("&l_currentUnitFileName." NE "" AND "&l_currentUnitLocation." NE "" 
                 AND %SYSFUNC(FILEEXIST(&l_currentUnitLocation./&l_currentUnitFileName.)) 
                 AND %SYSFUNC(FILEEXIST(&g_log./000.tcg)) ) %THEN %DO;
                 %_reporttcghtml(i_macroName                = &l_currentUnitFileName.
                                ,i_macroLocation            = &l_currentUnitLocation.
                                ,i_mCoverageName            = 000.tcg
                                ,i_mCoverageLocation        = &g_log
                                ,o_outputFile               = tcg_%SCAN(&l_currentUnitFileName.,1,.)
                                ,o_outputPath               = &g_target/rep
                                ,o_resVarName               = l_tcg_res
                                ,o_html                     = &o_html.
                                );
            %END;
         %END; /*%ELSE %DO;*/
         /*store coverage percentage for report generation*/
         PROC SQL NOPRINT;
           UPDATE work._auton_report
             SET tcg_pct=&l_tcg_res.
            WHERE upcase(cas_pgm) EQ "%upcase(&l_currentUnit.)";
         QUIT;
      %end; /*do i = 1 to &l_listCount*/
      
   %END;

   PROC SQL NOPRINT;
      SELECT DISTINCT cas_auton 
      INTO :l_pgmLibraries SEPARATED BY '§'
      FROM work._auton_report;
   QUIT;

   title;
   footnote;
   options nocenter;

   %let l_title=%str(&g_nls_reportAuton_001 | &g_project - SASUnit &g_nls_reportAuton_002);
   title j=c "&l_title.";

   %if (&o_html.) %then %do;
      ods html file="&o_path./&o_file..html" 
                    (TITLE="&l_title.") 
                    headtext='<link href="tabs.css" rel="stylesheet" type="text/css"/><link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.SASUnit stylesheet=(URL="SAS_SASUnit.css");
      %_reportPageTopHTML(i_title   = &l_title.
                         ,i_current = 4
                         )
   %end;

   options missing=" ";
   %LET l_listCount=%sysfunc(countw(&l_pgmLibraries.,'§'));
   %do i = 1 %to &l_listCount.;
      %LET l_pgmLib=%lowcase(%scan(&l_pgmLibraries,&i,§));
      %LET l_cAuton=;
      %IF (l_pgmLib ne .) %THEN %DO;
         %LET l_cAuton=%sysfunc (putn(&l_pgmLib.,z3.))_;
      %END;
      data work._current_auton;
         length pgmColumn scenarioColumn caseColumn assertColumn
                %IF &g_testcoverage. EQ 1 %THEN %DO;
                   coverageColumn
                %END;
                resultColumn
                linkTitle0  linkTitle1  LinkTitle2  LinkTitle3
                linkColumn0 linkColumn1 LinkColumn2 LinkColumn3 $1000
                _autonColumn autonColumn cas_abs_path scn_abs_path $400;
         set work._auton_report (where=(cas_auton=&l_pgmLib.));
         ARRAY sa(0:9) tsu_sasautos tsu_sasautos1-tsu_sasautos9;
         label 
            pgmColumn="&g_nls_reportAuton_005."
            scenarioColumn="&g_nls_reportAuton_006."
            caseColumn="&g_nls_reportAuton_007."
            assertColumn="&g_nls_reportAuton_014."
            %IF &g_testcoverage. EQ 1 %THEN %DO;
               coverageColumn="&g_nls_reportAuton_016." [%]
            %END;
            resultColumn="&g_nls_reportAuton_008.";

         if (cas_pgm="^_") then cas_pgm="";
         IF cas_auton = . THEN DO;
            cas_abs_path = resolve ('%_abspath(&g_root,' !! trim(cas_pgm) !! ')');   
         END;
         ELSE IF cas_auton = 0 THEN DO;
            cas_abs_path = resolve ('%_abspath(&g_sasunit,' !! trim(cas_pgm) !! ')');   
         END;
         ELSE IF cas_auton = 1 THEN DO;
            cas_abs_path = resolve ('%_abspath(&g_sasunit_os,' !! trim(cas_pgm) !! ')');   
         END;
         ELSE DO;
            cas_abs_path = resolve ('%_abspath(&g_sasautos' !! put (cas_auton-2,1.) !! ',' !! trim(cas_pgm) !! ')');
         END;
         scn_abs_path = resolve ('%_abspath(&g_root,' !! trim(scn_path) !! ')');

         %_render_dataColumn(i_sourceColumn=scn_cas
                            ,o_targetColumn=caseColumn
                            );
         %_render_dataColumn(i_sourceColumn=scn_tst
                            ,o_targetColumn=assertColumn
                            );
         %_render_iconColumn(i_sourceColumn=scn_res
                            ,o_html=&o_html.
                            ,o_targetColumn=resultColumn
                            );
         if (cas_auton = .) then do;
            _autonColumn = "&g_nls_reportAuton_015.";
         end;
         else do;
            if (cas_auton = 0) then do;
               _autonColumn = tsu_sasunit;
               linkTitle0   = symget("g_sasunit");
            end;
            else if (cas_auton = 1) then do;
               _autonColumn = tsu_sasunit_os;
               linkTitle0   = symget("g_sasunit_os");
            end;
            else do;
               _autonColumn = sa(cas_auton-2);
               linkTitle0   = symget("g_sasautos" !! put(cas_auton-2, z1.));
            end;
            linkColumn0  = "file:///" !! linkTitle0;
            linkTitle0   = "&g_nls_reportAuton_009. " !! linkTitle0;
         end;
         %_render_dataColumn(i_sourceColumn=_autonColumn
                            ,i_linkColumn=LinkColumn0
                            ,i_linkTitle=LinkTitle0
                            ,o_targetColumn=autonColumn
                            );
         autonColumn="&g_nls_reportAuton_003.: " !! trim(autonColumn);

         *** Any destination that renders links shares this if ***;
         %if (&o_html.) %then %do;
            LinkTitle1 = "&g_nls_reportAuton_009." !! byte(13) !! cas_abs_path;
            LinkTitle2 = "&g_nls_reportAuton_010." !! byte(13) !! scn_abs_path;
            LinkTitle3 = "&g_nls_reportAuton_017. " !! cas_pgm;

            *** HTML-links are destinations specific ***;
            %if (&o_html.) %then %do;
               LinkColumn1 = "file:///" !! cas_abs_path;
               LinkColumn2 = catt("cas_overview.html#SCN", put(scn_id,z3.), "_");
               if compress(cas_pgm) ne '' then do;
                  if index(cas_pgm,'/') GT 0 then do;
                     LinkColumn3 =  'tcg_'||trim(left(scan(substr(cas_pgm, findw(cas_pgm, scan(cas_pgm, countw(cas_pgm,'/'),'/'))),1,".") !! ".html"));
                  end;
                  else do;
                     LinkColumn3 =  'tcg_'||trim(left(scan(cas_pgm,1,".") !! ".html"));
                  end;
               end;
            %end;

            %_render_dataColumn(i_sourceColumn=cas_pgm
                               ,i_linkColumn=LinkColumn1
                               ,i_linkTitle=LinkTitle1
                               ,o_targetColumn=pgmColumn
                               );
            %_render_dataColumn(i_sourceColumn=scn_id
                               ,i_format=z3.
                               ,i_linkColumn=LinkColumn2
                               ,i_linkTitle=LinkTitle2
                               ,o_targetColumn=scenarioColumn
                               );
            %IF &g_testcoverage. EQ 1 %THEN %DO;
               %_render_dataColumn(i_sourceColumn=tcg_pct
                                  ,i_format=3.
                                  ,i_linkColumn=LinkColumn3
                                  ,i_linkTitle=LinkTitle3
                                  ,o_targetColumn=coverageColumn
                                  );
            %END;
         %end;
      run;

      %if (&i. = &l_listCount.) %then %do;
         %_reportFooter(o_html=&o_html.);
      %end;
      
      %if (&o_html.) %then %do;
         ods html anchor="AUTON&l_cAuton.";
      %end;

      proc report data=work._current_auton nowd missing spanrows
            style(lines)=blindData
            ;

         columns pgm_id pgmColumn scenarioColumn caseColumn assertColumn
            %IF &g_testcoverage. EQ 1 %THEN %DO;
                coverageColumn
            %END;
                resultColumn autonColumn;

         define autonColumn    / noprint;
         define pgm_id         / group noprint;
         define pgmColumn      / group;
         define scenarioColumn / group style(column)=[just=right];
         define caseColumn     / group style(column)=[just=right];
         define assertColumn   / group style(column)=[just=right];
         %IF &g_testcoverage. EQ 1 %THEN %DO;
             define coverageColumn / group style(column)=[just=right];
         %END;
         define resultColumn / group style(COLUMN)=[background=white];

         compute before _page_;
            line @1 autonColumn $;
         endcomp;
      run;

      *** Supress title between testcases ***;
      %if (&i. = 1) %then %do;
         title;
      %end;

      *** Render separation line between program libraries ***;
      %if (&o_html. AND &i. ne &l_listCount.) %then %do;
         ods html text="^{RAW <hr size=""1"">}";
      %end;

      proc delete data=work._current_auton;
      run;
   %end;
   options missing=.;


   %if (&o_html.) %then %do;
      ods html close;
   %end;

   title;
   footnote;
   options center;
   

   proc delete data=work._auton_report;
   run;
%MEND _reportAutonHTML;
/** \endcond */
