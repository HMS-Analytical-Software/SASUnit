/** 
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create home page of HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   o_html         flag to output file in HTML format
   \param   o_path         path for output file
   \param   o_file         name of the outputfile without extension

*/ /** \cond */ 

%MACRO _reportHomeHTML (i_repdata = 
                       ,o_html    = 0
                       ,o_path    =
                       ,o_file    =
                       );

%LOCAL i
       HTML_Reference
       Reference
       l_title
       l_footnote
       l_scn_failed
       l_cas_failed
       l_tst_failed
       ;

   %LET Reference=%nrbquote(^{style [url="http://sourceforge.net/projects/sasunit/" postimage="SASUnit_Logo.png"]SASUnit});
   %*** because in HTML we want to open the link to SASUnit in a new window, ***;
   %*** we need to insert raw HTML ***;
   %LET HTML_Reference=%nrbquote(<a href="http://sourceforge.net/projects/sasunit/" class="link" title="SASUnit" target="_blank">SASUnit <img src="SASUnit_Logo.png" alt="SASUnit" title="SASUnit" width=26px height=26px align="top" border="0"></a>);

   %let l_scn_failed=0;
   %let l_cas_failed=0;
   %let l_tst_failed=0;

   proc sql noprint;
      select count (distinct scn_id)                into :l_scn_failed from &i_repdata. where scn_res=2;
      select count (distinct catt (scn_id, cas_id)) into :l_cas_failed from &i_repdata. where cas_res=2;
      select count (*)                              into :l_tst_failed from &i_repdata. where tst_res=2;
   quit;

   proc format lib=work;
      value $headline 
               "PROJECT"    ="&g_nls_reportHome_024."
               "SASUnit"    ="&g_nls_reportHome_025."
               "SAS_Session"="&g_nls_reportHome_026."
           ;
     value YESNO 
              0 = "&g_nls_reportHome_028."
              1 = "&g_nls_reportHome_027."
           ;
   run;

   DATA work._home_report;
      SET &i_repdata.;

      length Category $20 idColumn parameterColumn valueColumn $4000;

      IF _n_=1 THEN DO;
         idColumn = "&g_nls_reportHome_003.";
         parameterColumn="^{style [flyover=""&g_project.""]%str(&)g_project}";
         valueColumn=tsu_project;
         Category="PROJECT";
         output;
         idColumn = "&g_nls_reportHome_004.";
         parameterColumn="^{style [flyover=""&g_root.""]%str(&)g_root}";
         valueColumn=catt ("^{style [flyover=""&g_root."" url=""file:///&g_root.""]", tsu_root, "}");
         Category="PROJECT";
         output;
         idColumn = "&g_nls_reportHome_005.";
         parameterColumn="^{style [flyover=""&g_target.""]%str(&)g_target}";
         valueColumn=catt ("^{style [flyover=""&g_target."" url=""file:///&g_target.""]", tsu_target, "}");
         Category="PROJECT";
         output;
         if (tsu_sasautos ne "") then do;
            idColumn = "&g_nls_reportHome_006.";
            parameterColumn="^{style [flyover=""&g_sasautos.""]%str(&)g_sasautos}";
            valueColumn=catt ("^{style [flyover=""&g_sasautos."" url=""file:///&g_sasautos.""]", tsu_sasautos, "}");
            %DO i=1 %TO 9;
            if (tsu_sasautos&i. ne "") then do;
               parameterColumn=catt(parameterColumn,"^n","^{style [flyover=""&&g_sasautos&i.""]%str(&)g_sasautos&i.}");
               valueColumn=catt (valueColumn,"^n","^{style [flyover=""&&g_sasautos&i."" url=""file:///&&g_sasautos&i.""]", tsu_sasautos&i., "}");
            end;
            %END;
            Category="PROJECT";
            output;
         end;
         if (tsu_autoexec ne "") then do;
            idColumn = "&g_nls_reportHome_007.";
            parameterColumn="^{style [flyover=""&g_autoexec.""]%str(&)g_autoexec}";
            valueColumn=catt ("^{style [flyover=""&g_autoexec."" url=""file:///&g_autoexec.""]", tsu_autoexec, "}");
            Category="SAS_Session";
            output;
         end;
         if (tsu_sascfg ne "") then do;
            idColumn = "&g_nls_reportHome_008.";
            parameterColumn="^{style [flyover=""&g_sascfg.""]%str(&)g_sascfg}";
            valueColumn=catt ("^{style [flyover=""&g_sascfg."" url=""file:///&g_sascfg.""]", tsu_sascfg, "}");
            Category="SAS_Session";
            output;
         end;
         if (tsu_sasuser ne "") then do;
            idColumn = "&g_nls_reportHome_009.";
            parameterColumn="^{style [flyover=""&g_sasuser.""]%str(&)g_sasuser}";
            valueColumn=catt ("^{style [flyover=""&g_sasuser."" url=""file:///&g_sasuser.""]", tsu_sasuser, "}");
            Category="SAS_Session";
            output;
         end;
         if (tsu_testdata ne "") then do;
            idColumn = "&g_nls_reportHome_010.";
            parameterColumn="^{style [flyover=""&g_testdata.""]%str(&)g_testdata}";
            valueColumn=catt ("^{style [flyover=""&g_testdata."" url=""file:///&g_testdata.""]", tsu_testdata, "}");
            Category="PROJECT";
            output;
         end;
         if (tsu_refdata ne "") then do;
            idColumn = "&g_nls_reportHome_011.";
            parameterColumn="^{style [flyover=""&g_refdata.""]%str(&)g_refdata}";
            valueColumn=catt ("^{style [flyover=""&g_refdata."" url=""file:///&g_refdata.""]", tsu_refdata, "}");
            Category="PROJECT";
            output;
         end;
         if (tsu_doc ne "") then do;
            idColumn = "&g_nls_reportHome_012.";
            parameterColumn="^{style [flyover=""&g_doc.""]%str(&)g_doc}";
            valueColumn=catt ("^{style [flyover=""&g_doc."" url=""file:///&g_doc.""]", tsu_doc, "}");
            Category="PROJECT";
            output;
         end;
         idColumn = "&g_nls_reportHome_013.";
         parameterColumn="^{style [flyover=""&g_sasunit.""]%str(&)g_sasunit}^n^{style [flyover=""&g_sasunit_os.""]%str(&)g_sasunit_os}";
         valueColumn=catt ("^{style [flyover=""%trim(&g_sasunit.)"" url=""file:///%trim(&g_sasunit.)""]", tsu_sasunit, "}"
                          ,"^n"
                          ,"^{style [flyover=""%trim(&g_sasunit_os.)"" url=""file:///%trim(&g_sasunit_os.)""]", tsu_sasunit_os, "}");
         Category="SASUnit";
         output;
         if getoption("LOG") ne "" then do;
            idColumn = "&g_nls_reportHome_014.";
            parameterColumn="^_";
            valueColumn=catt ('^{style [flyover="', getoption("LOG"), '" url="', "file:///" , getoption("LOG"), '"]', resolve('%_stdPath (i_root=&g_root, i_path=%sysfunc(getoption(log)))'), "}");
            Category="SASUnit";
            output;
         end;
         if (tsu_dbVersion ne "") then do;
            idColumn = "&g_nls_reportHome_022.";
            parameterColumn="^_";
            valueColumn=tsu_dbVersion;
            Category="SASUnit";
            output;
         end;
         idColumn = "&g_nls_reportHome_015.";
         parameterColumn='&SYSSCP^n&SYSSCPL';
         valueColumn="&SYSSCP.^n&SYSSCPL.";
         Category="SAS_Session";
         output;
         idColumn = "&g_nls_reportHome_019.";
         parameterColumn='&SYSVLONG4';
         valueColumn="&SYSVLONG4.";
         Category="SAS_Session";
         output;
         idColumn = "&g_nls_reportHome_023.";
         parameterColumn='&SYSENCODING';
         valueColumn="&SYSENCODING.";
         Category="SAS_Session";
         output;
         idColumn = "&g_nls_reportHome_020.";
         parameterColumn='&SYSUSERID';
         valueColumn="&SYSUSERID.";
         Category="SAS_Session";
         output;
         idColumn = "&g_nls_reportHome_021.";
         parameterColumn="SASUNIT_LANGUAGE";
         valueColumn="%sysget(SASUNIT_LANGUAGE)";
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_033.";
         parameterColumn='&g_rep_encoding';
         valueColumn="&g_rep_encoding.";
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_029.";
         parameterColumn='SASUNIT_COVERAGEASSESSMENT^n&g_testcoverage';
         valueColumn=catt (put (%sysget(SASUNIT_COVERAGEASSESSMENT), YESNO.)
                          ,"^n"
                          ,put (&G_TESTCOVERAGE., YESNO.)
                          );
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_030.";
         parameterColumn="SASUNIT_OVERWRITE";
         valueColumn=put (%sysget(SASUNIT_OVERWRITE), YESNO.);
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_031.";
         parameterColumn='&g_crossref';
         valueColumn=put (&g_crossref., YESNO.);
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_032.";
         parameterColumn='&g_crossrefsasunit';
         valueColumn=put (&g_crossrefsasunit., YESNO.);
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_016.";
         parameterColumn="^_";
         valueColumn="%_nobs(target.scn) (%cmpres(&l_scn_failed.))";
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_017.";
         parameterColumn="^_";
         valueColumn="%_nobs(target.cas) (%cmpres(&l_cas_failed.))";
         Category="SASUnit";
         output;
         idColumn = "&g_nls_reportHome_018.";
         parameterColumn="^_";
         valueColumn="%_nobs(target.tst) (%cmpres(&l_tst_failed.))";
         Category="SASUnit";
         output;
      END;
   run;

   %let l_title   =%str(&g_project | &Reference. &g_nls_reportHome_001.);
   title j=c %sysfunc(quote(&l_title.));

   %_reportFooter(o_html=&o_html.);

   options nocenter;

   %if (&o_html.) %then %do;
      %*** because in HTML we want to open the link to SASUnit in a new window, ***;
      %*** we need to insert raw HTML ***;
      %let l_title=%str(&g_project | &HTML_Reference. &g_nls_reportHome_001.);
      title j=c "^{RAW &l_title.}";

      ods html4 file="&o_path./&o_file..html" 
                    (TITLE="&l_title.") 
                    headtext='<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.SASUnit stylesheet=(URL="css/SAS_SASUnit.css")
                    encoding="&g_rep_encoding.";
      %_reportPageTopHTML(
         i_title   = %str(&g_project | &g_nls_reportHome_001.);
        ,i_current = 1
        )
   %end;

   proc report data=work._home_report nowd missing
         style(header)=blindHeader
         ;

      columns Category idColumn parameterColumn valueColumn;

      define Category / group noprint;
      define idColumn / display style(Column)=rowheader;

      compute before Category / style=header;
         line Category $headline.;
      endcomp;
      compute before / style=blindData;
         line @1 "&g_nls_reportHome_002."; 
      endcomp;
   run;

   %if (&o_html.) %then %do;
      %_closeHtmlPage;
   %end;

   proc delete data=work._home_report;
   run;

   %*** Reset title and footnotes ***;
   title;
   footnote;

   options center;
%MEND _reportHomeHTML;
/** \endcond */
