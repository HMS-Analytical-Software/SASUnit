/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create list of test scenarios for HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_repdata       input dataset (created in reportSASUnit.sas)
   \param   o_html          flag to output file in HTML format
   \param   o_path          path for output file
   \param   o_file          name of the outputfile without extension
   \param   o_pgmdoc        Switch for generartion of program_documentation (0/1)
   \param   i_style         Name of the SAS style and css file to be used. 
   \param   o_testDocFolder Name of the subfolder in rep folder to hold all test documentation html pages

*/ /** \cond */ 
%MACRO _reportScnHTML (i_repdata        = 
                      ,o_html           = 0
                      ,o_pdf            = 0
                      ,o_rtf            = 0
                      ,o_path           =
                      ,o_file           =
                      ,o_pgmdoc         =
                      ,i_style          =
                      ,o_pgmDocFolder   =
                      ,o_testDocFolder  =
                      );

   %local 
      l_title 
      l_footnote
      l_htmlTitle_center
      l_htmlTitle_left
      l_htmlTitle_right
      l_titleShort
      l_workPath
   ;

   %let l_title      =%nrbquote(^{style [url="http://sourceforge.net/projects/sasunit/" postimage="SASUnit_Logo.png"]SASUnit});
   %let l_title      =%str(&g_project. | &l_title. &g_nls_reportScn_002. |  &g_nls_reportScn_001.);
   %let l_titleShort =%str(&g_project. | &g_nls_reportScn_002. |  &g_nls_reportScn_001.);
   %*** because in HTML we want to open the link to SASUnit in a new window, ***;
   %*** we need to insert raw HTML ***;
   %let l_htmlTitle_center=<a href="http://sourceforge.net/projects/sasunit/" class="link" title="SASUnit" target="_blank">SASUnit <img src="SASUnit_Logo.png" alt="SASUnit" title="SASUnit" width=26px height=26px align="top" border="0"></a>;
   %let l_htmlTitle_center=%str(&g_project | &l_htmlTitle_center. &g_nls_reportHome_001. |  &g_nls_reportScn_001.);
   %let l_htmlTitle_left  = <a href="https://sourceforge.net/projects/sasunit/reviews" class="link" title="&g_nls_reportHome_038." target="_blank"><img alt="&g_nls_reportAuton_029.";
   %let l_htmlTitle_left  = &l_htmlTitle_left. src="https://img.shields.io/badge/-%scan(&g_nls_reportAuton_029.,1)%20%scan(&g_nls_reportAuton_029.,2)%20%nrstr(&#x2605&#x2605&#x2605&#x2605&#x2606)-brightgreen.svg"</a>;
   %let l_htmlTitle_right = <a href="https://sourceforge.net/projects/sasunit/files/Distributions/stats/timeline" class="link" title="&g_nls_reportHome_038." target="_blank">;
   %let l_htmlTitle_right = &l_htmlTitle_right.<img alt="SASUnit Downloads" src="https://img.shields.io/sourceforge/dm/sasunit.svg"></a>;
   
   %let l_workPath = %sysfunc (pathname (WORK));

   DATA work._scenario_report;
      SET &i_repdata;
      by scn_id;

      LENGTH abs_path scn_pgm $256 
             LinkColumn1 LinkTitle1 LinkColumn2 LinkTitle2 LinkColumn3 LinkTitle3 $1000
             idColumn $80
             descriptionColumn $1000
             programColumn $1000
             last_runColumn $1000
             durationColumn $1000
             resultColumn $1000;
             ;
      label idColumn="&g_nls_reportScn_003."
            descriptionColumn="&g_nls_reportScn_004."
            programColumn="&g_nls_reportScn_005."
            last_runColumn="&g_nls_reportScn_006."
            durationColumn="&g_nls_reportScn_007."
            resultColumn="&g_nls_reportScn_008."
            ;

      abs_path    = resolve ('%_abspath(&g_root,' !! trim(scn_path) !! ')');
      scn_pgm     = scan (abs_path, -1, '/');
      duration    = put (scn_end - scn_start, ??&g_nls_reportScn_013.) !! " s";
      c_scnid     = put (scn_id, z3.);
      pgmdoc_name = catt ("scn_", put (scn_id, z3.));

      %_render_IdColumn   (i_sourceColumn=scn_id
                          ,i_format=z3.
                          ,o_targetColumn=idColumn
                          );
      %_render_DataColumn (i_sourceColumn=duration
                          ,o_targetColumn=durationColumn
                          );
      %_render_IconColumn (i_sourceColumn=scn_res
                          ,o_html=&o_html.
                          ,o_targetColumn=resultColumn
                          );

      *** Any destination that renders links shares this if-clause ***;
      %if (&o_html. OR &o_pdf. OR &o_rtf.) %then %do;
         LinkTitle1  = "&g_nls_reportScn_009 " !! c_scnid;
         LinkTitle2  = "&g_nls_reportScn_010" !! byte(13) !! abs_path;
         LinkTitle3  = "&g_nls_reportScn_011";
         *** HTML-links are destinations specific ***;
         %if (&o_html.) %then %do;
            LinkColumn1 = catt ("cas_overview.html#SCN", c_scnid, "_");
            if (&o_pgmdoc. = 1 and fileexist ("&g_reportFolder./doc/&o_pgmDocFolder./" !! trim(pgmdoc_name) !! ".html")) then do;
               LinkColumn2 = catt ("&o_pgmDocFolder./", pgmdoc_name, ".html");
            end;
            else do;
               LinkColumn2 = catt ("src/scn/scn_", put (scn_id, z3.), ".sas");
            end;
            LinkColumn3 = catt ("&o_testDocFolder./",  c_scnid,  "_log.html");
         %end;
         *** PDF- and RTF-links are not destination specific ***;
         %if (&o_pdf. OR &o_rtf.) %then %do;
            LinkColumn1 = catt ("SCN", c_scnid, "_");
            LinkColumn2 = "&o_pgmDocFolder./" !! scn_pgm !! "_";
            LinkColumn3 = c_scnid !! "_log";
         %end;
         %_render_DataColumn (i_sourceColumn=scn_desc
                             ,i_linkColumn=LinkColumn1
                             ,i_linkTitle=LinkTitle1
                             ,o_targetColumn=descriptionColumn
                             );
         %_render_DataColumn (i_sourceColumn=scn_path
                             ,i_linkColumn=LinkColumn2
                             ,i_linkTitle=LinkTitle2
                             ,o_targetColumn=programColumn
                             );
         %_render_DataColumn (i_sourceColumn=scn_start
                             ,i_format=&g_nls_reportScn_012.
                             ,i_linkColumn=LinkColumn3
                             ,i_linkTitle=LinkTitle3
                             ,o_targetColumn=last_runColumn
                             );
      %end;
      if (first.scn_id);
   RUN; 
/*
   DATA work._scenario_report_new;
   
      LENGTH abs_path scn_pgm $256 
             LinkColumn1 LinkTitle1 LinkColumn2 LinkTitle2 LinkColumn3 LinkTitle3 $1000
             idColumn $80
             descriptionColumn $1000
             programColumn $1000
             last_runColumn $1000
             durationColumn $1000
             resultColumn $1000;
             ;
      label idColumn="&g_nls_reportScn_003."
            descriptionColumn="&g_nls_reportScn_004."
            programColumn="&g_nls_reportScn_005."
            last_runColumn="&g_nls_reportScn_006."
            durationColumn="&g_nls_reportScn_007."
            resultColumn="&g_nls_reportScn_008."
            ;
            
      SET &i_repdata;
      by scn_id cas_id;

      cScnId = put (scn_id, z3.);
      cCasId = put (cas_id, z3.);
      cTstId = put (tst_id, z3.);
      cCasScnId = catx ('-', cScnId, cCasId);
      cTstScnId = catx ('-', cCasScnId, cTstId);
      
      if (first.scn_id) then do;
         idColumn          = cScnId;
         descriptionColumn = scn_desc;
         programColumn     = scn_path;
         last_runColumn    = put (scn_start, &g_nls_reportScn_012.);
         durationColumn    = put (scn_end - scn_start, ??&g_nls_reportScn_013.) !! " s";
         resultColumn      = scn_res;
         count+1;
         call symputx (catt ("TR_ID", put (count, z3.)), cScnId, 'L');
         output;
      end;
      if (first.cas_id) then do;
         idColumn          = cCasScnId;
         descriptionColumn = cas_desc;
         programColumn     = cas_obj;
         last_runColumn    = put (cas_start, &g_nls_reportScn_012.);
         durationColumn    = put (cas_end - cas_start, ??&g_nls_reportScn_013.) !! " s";
         resultColumn      = cas_res;
         count+1;
         call symputx (catt ("TR_ID", put (count, z3.)), cCasScnId);
         output;
      end;
      idColumn  = cTstScnID;
      descriptionColumn = tst_desc;
      programColumn     = tst_type;
      last_runColumn    = '-';
      durationColumn    = '-';
      resultColumn      = tst_res;
      count+1;
      call symputx (catt ("TR_ID", put (count, z3.)), cTstScnid);
      call symputx ("NumOfTests", put (count, z3.));
      output;

      keep idColumn descriptionColumn programColumn last_runColumn durationColumn resultColumn cScnId cCasScnId;
   run;
*/

   title j=c %sysfunc(quote(&l_title.));

   %_reportFooter(o_html=&o_html);

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
                    /* Order of .js files in headtext attribute is essential */
                    headtext='<script src="./js/jquery.min.and.tablesorter.min.js"></script><link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.&i_style. stylesheet=(URL="./css/&i_style..css")
                    encoding="&g_rep_encoding.";
      %_reportPageTopHTML(i_title   = &l_titleShort.;
                         ,i_current = 2
                         )
   %end;
   %if (&o_pdf.) %then %do;
      ods pdf file="&o_path./&o_file..pdf" style=styles.&i_style. cssstyle="&g_reportFolder./&i_style..css";
   %end;
   %if (&o_rtf.) %then %do;
      ods rtf file="&o_path./&o_file..rtf" style=styles.&i_style. cssstyle="&g_reportFolder./&i_style..css";
   %end;

   data work._scenario_report;
      set work._scenario_report;
      descriptionColumn = tranwrd (descriptionColumn, "^n", "<br>");
   run;

   proc print data=work._scenario_report noobs label;
      var idColumn            / style(column)=rowheader;
      var descriptionColumn
          programColumn
          last_runColumn;
      var durationColumn   / style(column)=[just=right];
      var resultColumn     / style(column)=[background=white];
   run;
   
   %if (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
   %end;
   %if (&o_pdf.) %then %do;
      ods pdf close;
   %end;
   %if (&o_rtf.) %then %do;
      ods rtf close;
   %end;
/*
   %if (&o_html.) %then %do;
      %*** because in HTML we want to open the link to SASUnit in a new window, ***;
      %*** we need to insert raw HTML ***;
      title j=l %sysfunc (quote(^{RAW &l_htmlTitle_left.}))
            j=c %sysfunc (quote(^{RAW &l_htmlTitle_center.}))
            j=r %sysfunc (quote(^{RAW &l_htmlTitle_right.}))
      ;

      ods html4 file="&l_workPath./&o_file._new.html" 
                    (TITLE=%sysfunc (quote (&l_titleShort.)))
                    /* Order of .js files in headtext attribute is essential */
/*                    headtext='<script src="./js/jquery.min.and.tablesorter.min.js"></script><script src="./js/scn_overview.js"></script><link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.&i_style. stylesheet=(URL="./css/&i_style..css")
                    encoding="&g_rep_encoding.";
      %_reportPageTopHTML(i_title   = &l_titleShort.;
                         ,i_current = 2
                         )
   %end;

   proc print data=work._scenario_report_new noobs label;
      var idColumn            / style(column)=rowheader;
      var descriptionColumn
          programColumn
          last_runColumn;
      var durationColumn   / style(column)=[just=right];
      var resultColumn     / style(column)=[background=white];
   run;
   
   %if (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
   %end;
   
   data _null_;
      infile "&l_workPath./&o_file._new.html";
      file   "&o_path./&o_file._new.html";

      retain tBodyFound 0;

      input;
      
      if (index (_INFILE_, "<tbody>")) then do;
         tBodyFound = 1;
      end;

      if (tBodyFound AND _INFILE_ = "<tr>") then do;
         count+1;
         cID = symget ("TR_ID" !! put (count, z3.));
         if (index (cID, '-')) then do;
            _INFILE_ = catt ('<tr id="', cID,  '" hidden="hidden">');
         end;
         else do;
            _INFILE_ = catt ('<tr id="', cID,  '">');
         end;
      end;

      put _INFILE_;
   run;

   proc sql noprint;
      create table work._javascript_basis as
         select distinct cScnId, cCasScnId
         from work._scenario_report_new
      ;
   quit;

   data _null_;
      file   "&o_path./js/scn_overview.js";
      set work._javascript_basis;
      by cScnId cCasScnId;
      
      if (_N_=1) then do;
         put '$(document).ready(function() {';
      end;
      
      if (first.cScnId) then do;
         put '   $("#' cScnId +(-1) '").click(function () {';
         put '      if ($("#' cScnId +(-1) '-001").attr("hidden") == "hidden") {';
      end;
      put '         $("#' cCasScnId +(-1) '").attr("hidden", false);';
      if (last.cScnId) then do;
         put '      } else {';
         put '         $("[id^=''' cScnId +(-1) '-'']").attr("hidden", true)';
         put '      }';
         put '   });';
      end;
   run;
   
   data _null_;
      file   "&o_path./js/scn_overview.js" mod;
      set work._javascript_basis end=eof;
      
      put '   $("#' cCasScnId +(-1) '").click(function () {';
      put '      if ($("#' cCasScnId +(-1) '-001").attr("hidden") == "hidden") {';
      put '         $("[id^=''' cCasScnId +(-1) '-'']").attr("hidden", false)';
      put '      } else {';
      put '         $("[id^=''' cCasScnId +(-1) '-'']").attr("hidden", true)';
      put '      }';
      put '   });';
      
      if (eof) then do;
         put '});';
      end;
   run;
*/
   %*** Reset title and footnotes ***;
   title;
   footnote;

   options center;

   PROC DATASETS NOWARN NOLIST LIB=work;
      DELETE _scenario_report;
   QUIT;
%MEND _reportScnHTML;
/** \endcond */