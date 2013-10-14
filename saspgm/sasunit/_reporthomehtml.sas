/** 
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create home page of HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
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
                       ,o_html    =
                       ,o_path    =
                       ,o_file    =
                       );

%LOCAL i
       HTML_Reference
       Reference
       l_title
       l_footnote
       ;

   %LET Reference=%nrbquote(^{style [url="http://sourceforge.net/projects/sasunit/" postimage="SASUnit_Logo.png"]SASUnit});
   %*** because in HTML we want to open the link to SASUnit in a new window, ***;
   %*** we need to insert raw HTML ***;
   %LET HTML_Reference=%nrbquote(<a href="http://sourceforge.net/projects/sasunit/" class="link" target="_blank">SASUnit <img src="SASUnit_Logo.png" alt="SASUnit" width=26px height=26px align="top" border="0"></a>);

   DATA work._home_report;
      SET &i_repdata;

      length idColumn parameterColumn valueColumn $4000;

      IF _n_=1 THEN DO;
         idColumn = "&g_nls_reportHome_003.";
         parameterColumn="^{style [flyover=""&g_project.""]%str(&)amp;g_project}";
         valueColumn=tsu_project;
         output;
         idColumn = "&g_nls_reportHome_004.";
         parameterColumn="^{style [flyover=""&g_root.""]%str(&)amp;g_root}";
             

         valueColumn=catt ("^{style [flyover=""&g_root."" url=""file:///&g_root.""]", tsu_root, "}");
         output;
         idColumn = "&g_nls_reportHome_005.";
         parameterColumn="^{style [flyover=""&g_target.""]%str(&)amp;g_target}";
         valueColumn=catt ("^{style [flyover=""&g_target."" url=""file:///&g_target.""]", tsu_target, "}");
         output;
         if (tsu_sasautos ne "") then do;
            idColumn = "&g_nls_reportHome_006.";
            parameterColumn="^{style [flyover=""&g_sasautos.""]%str(&)amp;g_sasautos}";
            valueColumn=catt ("^{style [flyover=""&g_sasautos."" url=""file:///&g_sasautos.""]", tsu_sasautos, "}");
            %DO i=1 %TO 9;
            if (tsu_sasautos&i. ne "") then do;
               parameterColumn=catt(parameterColumn,"^n","^{style [flyover=""&&g_sasautos&i.""]%str(&)amp;g_sasautos&i.}");
               valueColumn=catt (valueColumn,"^n","^{style [flyover=""&&g_sasautos&i."" url=""file:///&&g_sasautos&i.""]", tsu_sasautos&i., "}");
            end;
            %END;
            output;
         end;
         if (tsu_autoexec ne "") then do;
            idColumn = "&g_nls_reportHome_007.";
            parameterColumn="^{style [flyover=""&g_autoexec.""]%str(&)amp;g_autoexec}";
            valueColumn=catt ("^{style [flyover=""&g_autoexec."" url=""file:///&g_autoexec.""]", tsu_autoexec, "}");
            output;
         end;
         if (tsu_sascfg ne "") then do;
            idColumn = "&g_nls_reportHome_008.";
            parameterColumn="^{style [flyover=""&g_sascfg.""]%str(&)amp;g_sascfg}";
            valueColumn=catt ("^{style [flyover=""&g_sascfg."" url=""file:///&g_sascfg.""]", tsu_sascfg, "}");
            output;
         end;
         if (tsu_sasuser ne "") then do;
            idColumn = "&g_nls_reportHome_009.";
            parameterColumn="^{style [flyover=""&g_sasuser.""]%str(&)amp;g_sasuser}";
            valueColumn=catt ("^{style [flyover=""&g_sasuser."" url=""file:///&g_sasuser.""]", tsu_sasuser, "}");
            output;
         end;
         if (tsu_testdata ne "") then do;
            idColumn = "&g_nls_reportHome_010.";
            parameterColumn="^{style [flyover=""&g_testdata.""]%str(&)amp;g_testdata}";
            valueColumn=catt ("^{style [flyover=""&g_testdata."" url=""file:///&g_testdata.""]", tsu_testdata, "}");
            output;
         end;
         if (tsu_refdata ne "") then do;
            idColumn = "&g_nls_reportHome_011.";
            parameterColumn="^{style [flyover=""&g_refdata.""]%str(&)amp;g_refdata}";
            valueColumn=catt ("^{style [flyover=""&g_refdata."" url=""file:///&g_refdata.""]", tsu_refdata, "}");
            output;
         end;
         if (tsu_doc ne "") then do;
            idColumn = "&g_nls_reportHome_012.";
            parameterColumn="^{style [flyover=""&g_doc.""]%str(&)amp;g_doc}";
            valueColumn=catt ("^{style [flyover=""&g_doc."" url=""file:///&g_doc.""]", tsu_doc, "}");
            output;
         end;
         idColumn = "&g_nls_reportHome_013.";
         parameterColumn="^{style [flyover=""&g_sasunit.""]%str(&)amp;g_sasunit}";
         valueColumn=catt ("^{style [flyover=""%trim(&g_sasunit.)"" url=""file:///%trim(&g_sasunit.)""]", tsu_sasunit, "}");
         output;
         if getoption("LOG") ne "" then do;
            idColumn = "&g_nls_reportHome_014.";
            parameterColumn="^_";
            valueColumn=catt ('^{style [flyover="', getoption("LOG"), '" url="', "file:///" , getoption("LOG"), '"]', resolve('%_stdPath (i_root=&g_root, i_path=%sysfunc(getoption(log)))'), "}");
            output;
         end;
         if (tsu_dbVersion ne "") then do;
            idColumn = "&g_nls_reportHome_022.";
            parameterColumn="^_";
            valueColumn=tsu_dbVersion;
            output;
         end;
         idColumn = "&g_nls_reportHome_015.";
         parameterColumn='&SYSSCP^n&SYSSCPL';
         valueColumn="&SYSSCP.^n&SYSSCPL.";
         output;
         idColumn = "&g_nls_reportHome_019.";
         parameterColumn='&SYSVLONG4';
         valueColumn="&SYSVLONG4.";
         output;
         idColumn = "&g_nls_reportHome_023.";
         parameterColumn='&SYSENCODING';
         valueColumn="&SYSENCODING.";
         output;
         idColumn = "&g_nls_reportHome_020.";
         parameterColumn='&SYSUSERID';
         valueColumn="&SYSUSERID.";
         output;
         idColumn = "&g_nls_reportHome_021.";
         parameterColumn="SASUNIT_LANGUAGE";
         valueColumn="%sysget(SASUNIT_LANGUAGE)";
         output;
         idColumn = "&g_nls_reportHome_016.";
         parameterColumn="^_";
         valueColumn="%_nobs(target.scn)";
         output;
         idColumn = "&g_nls_reportHome_017.";
         parameterColumn="^_";
         valueColumn="%_nobs(target.cas)";
         output;
         idColumn = "&g_nls_reportHome_018.";
         parameterColumn="^_";
         valueColumn="%_nobs(target.tst)";
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

      ods html file="&o_path./&o_file..html" 
                    (TITLE="&l_title.") 
                    headtext='<link href="tabs.css" rel="stylesheet" type="text/css"/><link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.SASUnit stylesheet=(URL="SAS_SASUnit.css");
      %_reportPageTopHTML(
         i_title   = %str(&g_project | &g_nls_reportHome_001.);
        ,i_current = 1
        )
   %end;

   proc report data=work._home_report nowd missing
         style(header)=blindHeader
         style(lines)=blindData
         ;

      columns idColumn parameterColumn valueColumn;

      define idColumn / display style(Column)=rowheader;

      compute before;
         line @1 "&g_nls_reportHome_002."; 
      endcomp;
   run;

   %if (&o_html.) %then %do;
      ods html close;
   %end;

   proc delete data=work._home_report;
   run;

   %*** Reset title and footnotes ***;
   title;
   footnote;

   options center;
%MEND _reportHomeHTML;
/** \endcond */
