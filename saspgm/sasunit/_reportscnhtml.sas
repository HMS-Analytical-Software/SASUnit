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
            
   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   o_html         flag to output file in HTML format
   \param   o_path         path for output file
   \param   o_file         name of the outputfile without extension
   \param   o_pgmdoc       Switch for generartion of program_documentation (0/1)
   \param   i_style        Name of the SAS style and css file to be used. 

*/ /** \cond */ 

%MACRO _reportScnHTML (i_repdata = 
                      ,o_html    = 0
                      ,o_pdf     = 0
                      ,o_rtf     = 0
                      ,o_path    =
                      ,o_file    =
                      ,o_pgmdoc  =
                      ,i_style   =
                      );

   %local l_title l_footnote;

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
      pgmdoc_name = catt ("pgm_scn_", put (scn_id, z3.));

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
            if (&o_pgmdoc. = 1 and fileexist ("&g_target./rep/" !! trim(pgmdoc_name) !! ".html")) then do;
               LinkColumn2 = catt (pgmdoc_name, ".html");
            end;
            else do;
               LinkColumn2 = catt ("src/scn/scn_", put (scn_id, z3.), ".sas");
            end;
            LinkColumn3 = c_scnid !! "_log.html";
         %end;
         *** PDF- and RTF-links are not destination specific ***;
         %if (&o_pdf. OR &o_rtf.) %then %do;
            LinkColumn1 = catt ("SCN", c_scnid, "_");
            LinkColumn2 = "pgm_" !! scn_pgm !! "_";
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

   %let l_title=%str(&g_nls_reportScn_001 | &g_project - &g_nls_reportScn_002);
   title j=c "&l_title.";

   %_reportFooter(o_html=&o_html);

   options nocenter;

   %if (&o_html.) %then %do;
      ods html4 file="&o_path./&o_file..html" 
                    (TITLE="&l_title.")
                    /* Order of .js files in headtext attribute is essential */
                    headtext='<script src="js/jquery.min.and.tablesorter.min.js"></script><link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.&i_style. stylesheet=(URL="css/&i_style..css")
                    encoding="&g_rep_encoding.";
      %_reportPageTopHTML(
         i_title   = &l_title.
        ,i_current = 2
        )
   %end;
   %if (&o_pdf.) %then %do;
      ods pdf file="&o_path./&o_file..pdf" style=styles.&i_style. cssstyle="&g_target./&i_style..css";
   %end;
   %if (&o_rtf.) %then %do;
      ods rtf file="&o_path./&o_file..rtf" style=styles.&i_style. cssstyle="&g_target./&i_style..css";
   %end;

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

   %*** Reset title and footnotes ***;
   title;
   footnote;

   options center;

   PROC DATASETS NOWARN NOLIST LIB=work;
      DELETE _scenario_report;
   QUIT;
%MEND _reportScnHTML;
/** \endcond */
