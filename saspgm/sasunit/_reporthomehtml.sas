/** 
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create home page of HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
            
   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   o_html         flag to output file in HTML format
   \param   o_path         path for output file
   \param   o_file         name of the outputfile without extension
   \param   i_style        name of the SAS style and css file to be used. 
*/ /** \cond */ 
%MACRO _reportHomeHTML (i_repdata = 
                       ,o_html    = 0
                       ,o_path    =
                       ,o_file    =
                       ,i_style   =
                       );

   %LOCAL 
      i
      l_title
      l_htmlTitle_center
      l_htmlTitle_left
      l_htmlTitle_right
      l_footnote
      l_scn_failed
      l_cas_failed
      l_tst_failed
      l_runtime
      l_scn_run
      l_i
      l_titleShort
      ;

   %let l_title      =%nrbquote(^{style [url="https://github.com/HMS-Analytical-Software/SASUnit/wiki" postimage="SASUnit_Logo.png"]SASUnit});
   %let l_title      =%str(&g_project. | &l_title. &g_nls_reportHome_001. | &g_nls_reportHome_039.);
   %let l_titleShort =%str(&g_project. | &g_nls_reportHome_001. | &g_nls_reportHome_039.);
   %*** because in HTML we want to open the link to SASUnit in a new window, ***;
   %*** we need to insert raw HTML ***;
   %let l_htmlTitle_center=<a href="https://github.com/HMS-Analytical-Software/SASUnit/wiki" class="link" title="SASUnit" target="_blank">SASUnit <img src="SASUnit_Logo.png" alt="SASUnit" title="SASUnit" width=26px height=26px align="top" border="0"></a>;
   %let l_htmlTitle_center=%str(&g_project | &l_htmlTitle_center. &g_nls_reportHome_001. | &g_nls_reportAuton_001.);
   %let l_htmlTitle_left  = <a class="link" title="&g_nls_reportHome_038." target="_blank"><img alt="&g_nls_reportAuton_029.";
   %let l_htmlTitle_left  = &l_htmlTitle_left. src="https://img.shields.io/badge/-%scan(&g_nls_reportAuton_029.,1)%20%scan(&g_nls_reportAuton_029.,2)%20%nrstr(&#x2605&#x2605&#x2605&#x2605&#x2606)-brightgreen.svg"</a>;
   %let l_htmlTitle_right = <a href="https://github.com/HMS-Analytical-Software/SASUnit/graphs/traffic" class="link" title="Downloads" target="_blank">;
   %let l_htmlTitle_right = &l_htmlTitle_right.<img alt="SASUnit Downloads" src="https://img.shields.io/github/downloads/HMS-Analytical-Software/SASUnit/total"></a>;

   %let l_scn_failed=0;
   %let l_cas_failed=0;
   %let l_tst_failed=0;
   %let l_scn_run=0;

   proc sql noprint;
      select count (distinct scn_id)                into :l_scn_failed from &i_repdata. where scn_res=2;
      select count (distinct catt (scn_id, cas_id)) into :l_cas_failed from &i_repdata. where cas_res=2;
      select count (*)                              into :l_tst_failed from &i_repdata. where tst_res=2;
      select sum (scn_end - scn_start)              into :l_runtime    from target.scn;
      select count (distinct scn_id)                into :l_scn_run    from &i_repdata. where scn_start >= tsu_lastrep;
   quit;
   
   proc format lib=work;
      value $headline 
               "PROJECT"     ="&g_nls_reportHome_024."
               "SASUnit"     ="&g_nls_reportHome_025."
               "TestResults" ="&g_nls_reportHome_036."
               "XSAS_Session"="&g_nls_reportHome_026."
           ;
     value YESNO 
              0 = "&g_nls_reportHome_028."
              1 = "&g_nls_reportHome_027."
           ;
     value $RowHeader 
          %do i=1 %to 45;
             %let l_i=%sysfunc(putn (&i., z3.));
              "&l_i." = "&&g_nls_reportHome_&l_i.."
          %end;
          ;
   run;

   DATA work._home_report;
      SET &i_repdata.;

      length Category $20 idColumn parameterColumn valueColumn $4000 sortColumn 8;
      keep Category idColumn parameterColumn valueColumn sortColumn;

      IF _n_=1 THEN DO;
         /*** Section PROJECT                                                             ***/
         idColumn = "003";
         parameterColumn="^{style [flyover=""&g_project.""]%str(&)g_project}";
         valueColumn=tsu_project;
         Category="PROJECT";
         SortColumn=0;
         output;
         idColumn = "004";
         parameterColumn="^{style [flyover=""&g_root.""]%str(&)g_root}";
         valueColumn=catt ("^{style [flyover=""", "&g_root.", """ url=""file:///", "&g_root.", """]", trim(tsu_root), "}");
         output;
         idColumn = "005";
         parameterColumn="^{style [flyover=""&g_target.""]%str(&)g_target}";
         valueColumn=catt ("^{style [flyover=""&g_target."" url=""file:///&g_target.""]", tsu_target, "}");
         output;
         if (tsu_sasautos ne "") then do;
            idColumn = "006";
            parameterColumn="^{style [flyover=""&g_sasautos.""]%str(&)g_sasautos}";
            valueColumn=catt ("^{style [flyover=""&g_sasautos."" url=""file:///&g_sasautos.""]", tsu_sasautos, "}");
            output;
            %DO i=1 %TO 29;
               if (tsu_sasautos&i. ne "") then do;
                  idColumn = "006";
                  parameterColumn=catt("^{style [flyover=""&&g_sasautos&i.""]%str(&)g_sasautos&i.}");
                  valueColumn=catt ("^{style [flyover=""&&g_sasautos&i."" url=""file:///&&g_sasautos&i.""]", tsu_sasautos&i., "}");
                  output;
               end;
            %END;
         end;
         if (tsu_testdata ne "") then do;
            idColumn = "010";
            parameterColumn="^{style [flyover=""&g_testdata.""]%str(&)g_testdata}";
            valueColumn=catt ("^{style [flyover=""&g_testdata."" url=""file:///&g_testdata.""]", tsu_testdata, "}");
            output;
         end;
         if (tsu_refdata ne "") then do;
            idColumn = "011";
            parameterColumn="^{style [flyover=""&g_refdata.""]%str(&)g_refdata}";
            valueColumn=catt ("^{style [flyover=""&g_refdata."" url=""file:///&g_refdata.""]", tsu_refdata, "}");
            output;
         end;
         if (tsu_doc ne "") then do;
            idColumn = "012";
            parameterColumn="^{style [flyover=""&g_doc.""]%str(&)g_doc}";
            valueColumn=catt ("^{style [flyover=""&g_doc."" url=""file:///&g_doc.""]", tsu_doc, "}");
            output;
         end;

         /*** Section SASUnit                                                             ***/
         idColumn = "013";
         parameterColumn="^{style [flyover=""&g_sasunit.""]%str(&)g_sasunit}";
         valueColumn=catt ("^{style [flyover=""%trim(&g_sasunit.)"" url=""file:///%trim(&g_sasunit.)""]", tsu_sasunit, "}");
         Category="SASUnit";
         SortColumn+1;
         output;
         idColumn = "013";
         parameterColumn="^{style [flyover=""&g_sasunit_os.""]%str(&)g_sasunit_os}";
         valueColumn=catt ("^{style [flyover=""%trim(&g_sasunit_os.)"" url=""file:///%trim(&g_sasunit_os.)""]", tsu_sasunit_os, "}");
         output;
         idColumn = "037";
         parameterColumn="^{style [flyover=""&g_version.""]%str(&)g_version}";
         valueColumn="&g_version.";
         output;
         if (tsu_dbVersion ne "") then do;
            idColumn = "022";
            parameterColumn="^{style [flyover=""&g_db_version.""]%str(&)g_db_version}";
            valueColumn=tsu_dbVersion;
            SortColumn+1;
            output;
         end;
         idColumn = "014";
         parameterColumn="^_";
         valueColumn=catt ("^{style [flyover=""&g_logFolder./log4sasunit_run_all.log"" url=""file:///&g_logFolder./log4sasunit_run_all.log""]", resolve("%_stdPath (i_root=&g_root, i_path=&g_logFolder./log4sasunit_run_all.log)"), "}");
         SortColumn+1;
         output;
         idColumn = "040";
         parameterColumn="^{style [flyover=""&g_logFolder.""]%str(&)g_logFolder}";
         valueColumn=catt ("^{style [flyover=""&g_logFolder."" url=""file:///&g_logFolder.""]", tsu_logFolder, "}");
         output;
         idColumn = "041";
         parameterColumn="^{style [flyover=""&g_scnLogFolder.""]%str(&)g_scnLogFolder}";
         valueColumn=catt ("^{style [flyover=""&g_scnLogFolder."" url=""file:///&g_scnLogFolder.""]", tsu_scnLogFolder, "}");
         output;
         idColumn = "042";
         parameterColumn="^{style [flyover=""&g_log4SASSuiteLogLevel.""]%str(&)g_log4SASSuiteLogLevel}";
         valueColumn=catt ("^{style [flyover=""&g_log4SASSuiteLogLevel.""]", tsu_log4SASSuiteLogLevel, "}");
         output;
         idColumn = "043";
         parameterColumn="^{style [flyover=""&g_log4SASScenarioLogLevel.""]%str(&)g_log4SASScenarioLogLevel}";
         valueColumn=catt ("^{style [flyover=""&g_log4SASScenarioLogLevel.""]", tsu_log4SASScenarioLogLevel, "}");
         output;
         idColumn = "044";
         parameterColumn="^{style [flyover=""&g_reportFolder.""]%str(&)g_reportFolder}";
         valueColumn=catt ("^{style [flyover=""&g_reportFolder."" url=""file:///&g_reportFolder.""]", tsu_reportFolder, "}");
         output;
         idColumn = "021";
         parameterColumn="SASUNIT_LANGUAGE";
         valueColumn="%sysget(SASUNIT_LANGUAGE)";
         SortColumn+1;
         output;
         idColumn = "033";
         parameterColumn='&g_rep_encoding';
         valueColumn="&g_rep_encoding.";
         output;
         idColumn = "029";
         parameterColumn='SASUNIT_COVERAGEASSESSMENT';
         valueColumn=catt (put (%sysget(SASUNIT_COVERAGEASSESSMENT), YESNO.));
         SortColumn+1;
         output;
         idColumn = "029";
         parameterColumn='&g_testcoverage';
         valueColumn=catt (put (&G_TESTCOVERAGE., YESNO.));
         output;
         idColumn = "030";
         parameterColumn="SASUNIT_OVERWRITE";
         valueColumn=put (%sysget(SASUNIT_OVERWRITE), YESNO.);
         Category="SASUnit";
         output;
         idColumn = "031";
         parameterColumn='&g_crossref';
         valueColumn=put (&g_crossref., YESNO.);
         output;
         idColumn = "032";
         parameterColumn='&g_crossrefsasunit';
         valueColumn=put (&g_crossrefsasunit., YESNO.);
         output;

         /*** Section TestResults                                                         ***/
         idColumn = "016";
         parameterColumn="^_";
         valueColumn="%_nobs(target.scn) (%cmpres(&l_scn_failed.))";
         Category="TestResults";
         output;
         idColumn = "017";
         parameterColumn="^_";
         valueColumn="%_nobs(target.cas) (%cmpres(&l_cas_failed.))";
         output;
         idColumn = "018";
         parameterColumn="^_";
         valueColumn="%_nobs(target.tst) (%cmpres(&l_tst_failed.))";
         output;
         idColumn = "034";
         parameterColumn="^_";
         valueColumn = put (&l_runtime., time8.);
         output;
         idColumn = "035";
         parameterColumn="^_";
         valueColumn = catx (" "
                            ,put (datetime() - dhms("&sysdate."d,hour("&systime.:00"t),minute("&systime.:00"t),second("&systime.:00"t)), time8.)
                            ,"(%cmpres(&l_scn_run.))"
                            );
         output;

         /*** Section XSAS_Session                                                        ***/
         if (tsu_autoexec ne "") then do;
            idColumn = "007";
            parameterColumn="^{style [flyover=""&g_autoexec.""]%str(&)g_autoexec}";
            valueColumn=catt ("^{style [flyover=""&g_autoexec."" url=""file:///&g_autoexec.""]", tsu_autoexec, "}");
            Category="XSAS_Session";
            SortColumn+1;
            output;
         end;
         if (tsu_sascfg ne "") then do;
            idColumn = "008";
            parameterColumn="^{style [flyover=""&g_sascfg.""]%str(&)g_sascfg}";
            valueColumn=catt ("^{style [flyover=""&g_sascfg."" url=""file:///&g_sascfg.""]", tsu_sascfg, "}");
            Category="XSAS_Session";
            output;
         end;
         if (tsu_sasuser ne "") then do;
            idColumn = "009";
            parameterColumn="^{style [flyover=""&g_sasuser.""]%str(&)g_sasuser}";
            valueColumn=catt ("^{style [flyover=""&g_sasuser."" url=""file:///&g_sasuser.""]", tsu_sasuser, "}");
            Category="XSAS_Session";
            output;
         end;
         idColumn = "015";
         parameterColumn='&SYSSCP';
         valueColumn="&SYSSCP.";
         Category="XSAS_Session";
         output;
         idColumn = "015";
         parameterColumn='&SYSSCPL';
         valueColumn="&SYSSCPL.";
         Category="XSAS_Session";
         output;
         idColumn = "019";
         parameterColumn='&SYSVLONG4';
         valueColumn="&SYSVLONG4.";
         Category="XSAS_Session";
         output;
         idColumn = "023";
         parameterColumn='&SYSENCODING';
         valueColumn="&SYSENCODING.";
         Category="XSAS_Session";
         output;
         idColumn = "020";
         parameterColumn='&SYSUSERID';
         valueColumn="&SYSUSERID.";
         Category="XSAS_Session";
         output;
         idColumn = "045";
         parameterColumn='&g_osencoding';
         valueColumn="&G_OSENCODING.";
         Category="XSAS_Session";
         output;
      END;
   run;

   title j=c %sysfunc(quote(&l_title.));

   %_reportFooter(o_html=&o_html.);

   options nocenter;

   %if (&o_html.) %then %do;
      %*** because in HTML we want to open the link to SASUnit in a new window, ***;
      %*** we need to insert raw HTML ***;
      title j=l %sysfunc (quote(^{RAW &l_htmlTitle_left.}))
            j=c %sysfunc (quote(^{RAW &l_htmlTitle_center.}))
            j=r %sysfunc (quote(^{RAW &l_htmlTitle_right.}))
      ;
            
      ods html4 file="&o_path./&o_file..html" 
                    (TITLE=%sysfunc (quote (&l_titleShort.)))
                    headtext='<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.&i_style. stylesheet=(URL="css/&i_style..css")
                    encoding="&g_rep_encoding.";
      %_reportPageTopHTML(i_title   = &l_titleShort.;
                         ,i_current = 1
                         )
   %end;

   proc report data=work._home_report nowd missing spanrows
         style(header)=blindHeader
         ;

      format idColumn $RowHeader.;

      columns Category sortColumn idColumn parameterColumn valueColumn;

      define Category        / group noprint;
      define sortColumn      / group noprint;
      define idColumn        / group order=internal style(Column)=rowheader;

      compute before Category / style=header;
         line Category $headline.;
      endcomp;
      compute before / style=blindDataStrong [fontsize=10pt];
         line @1 "&g_nls_reportHome_002."; 
      endcomp;
   run;

   %if (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
   %end;

   proc delete data=work._home_report;
   run;

   %*** Reset title and footnotes ***;
   title;
   footnote;

   options center;
%MEND _reportHomeHTML;
/** \endcond */