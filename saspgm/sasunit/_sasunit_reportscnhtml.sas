/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create list of test scenarios for HTML report

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

%MACRO _sasunit_reportScnHTML (
   i_repdata = 
  ,o_html    =
  ,o_path    =
  ,o_file    =
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

         abs_path    = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');
         scn_pgm     = resolve ('%_sasunit_stdpath(&g_root./saspgm/test,' !! trim(abs_path) !! ')');
         duration    = scn_end - scn_start;
         c_scnid     = put (scn_id, z3.);
         LinkTitle1  = "&g_nls_reportScn_009 " !! c_scnid;
         LinkColumn1 = catt ("cas_overview.html#SCN", c_scnid, "_");
         LinkTitle2  = "&g_nls_reportScn_010" !! byte(13) !! abs_path;
         LinkColumn2 = "pgm_" !! tranwrd (scn_pgm, ".sas", ".html");
         LinkTitle3  = "&g_nls_reportScn_011";
         LinkColumn3 = c_scnid !! "_log.html";

         %_sasunit_render_IdColumn   (i_sourceColumn=scn_id
                                     ,i_format=z3.
                                     ,o_targetColumn=idColumn
                                     );
         %_sasunit_render_DataColumn (i_sourceColumn=scn_desc
                                     ,i_linkColumn=LinkColumn1
                                     ,i_linkTitle=LinkTitle1
                                     ,o_targetColumn=descriptionColumn
                                     );
         %_sasunit_render_DataColumn (i_sourceColumn=scn_path
                                     ,i_linkColumn=abs_path
                                     ,i_linkTitle=LinkTitle2
                                     ,o_targetColumn=programColumn
                                     );
         %_sasunit_render_DataColumn (i_sourceColumn=scn_start
                                     ,i_format=&g_nls_reportScn_012.
                                     ,i_linkColumn=LinkColumn3
                                     ,i_linkTitle=LinkTitle3
                                     ,o_targetColumn=last_runColumn
                                     );
         %_sasunit_render_DataColumn (i_sourceColumn=duration
                                     ,i_format=&g_nls_reportScn_013.
                                     ,o_targetColumn=durationColumn
                                     );
         %_sasunit_render_IconColumn (i_sourceColumn=scn_res
                                     ,o_html=&o_html.
                                     ,o_targetColumn=resultColumn
                                     );
         if (first.scn_id);
   RUN; 

   %let l_title=%str(&g_nls_reportScn_001 | &g_project - &g_nls_reportScn_002);
   title j=c "&l_title.";

   %_sasunit_reportFooter(o_html=&o_html);

   options nocenter;

   %if (&o_html.) %then %do;
      ods html file="&o_path./&o_file..html" 
                    (TITLE="&l_title.") 
                    headtext="<link href=""tabs.css"" rel=""stylesheet"" type=""text/css""/><link rel=""shortcut icon"" href=""./favicon.ico"" type=""image/x-icon"" />"
                    style=styles.SASUnit stylesheet=(URL="SAS_SASUnit.css");
      %_sasunit_reportPageTopHTML(
         i_title   = &l_title.
        ,i_current = 2
        )
   %end;

   proc print data=work._scenario_report noobs label;
      var idColumn / style(column)=rowheader;
      var descriptionColumn
          programColumn
          last_runColumn
          durationColumn;
      var resultColumn / style(column)=[background=white]
          ;
   run;
   %if (&o_html.) %then %do;
      ods html close;
   %end;

   proc delete data=work._scenario_report;
   run;

   %*** Reset title and footnotes ***;
   title;
   footnote;

   options center;
%MEND _sasunit_reportScnHTML;
/** \endcond */
