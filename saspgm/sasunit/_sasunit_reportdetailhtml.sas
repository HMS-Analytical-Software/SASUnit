/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create page with detail information of a test case in HTML format

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   i_scnid        scenario id of test case
   \param   i_casid        id of test case
   \param   o_html         flag to output file in HTML format
   \param   o_path         path for output file
   \param   o_file         name of the outputfile without extension

*/ /** \cond */ 

%MACRO _sasunit_reportDetailHTML (
   i_repdata =
  ,i_scnid   =
  ,i_casid   = 
  ,o_html    =
  ,o_path    =
  ,o_file    =
);

   %LOCAL
      l_nls_reportdetail_errors
      l_NumAssert
   ;
   %LET l_nls_reportdetail_errors   = %STR(error(s));

   proc sql noprint;
      select count (distinct tst_type) into :_numAsserts from target.tst where tst_scnid = &i_scnid AND tst_casid = &i_casid;
   quit;

   %do l_NumAssert=1 %to &_numAsserts.;
       %local assertType&l_NumAssert.
       ;
   %end;

   proc sql noprint;
      select distinct tst_type into :assertType1-:assertType%cmpres(&_numAsserts.) from &i_repdata. where scn_id = &i_scnid AND cas_id = &i_casid;
   quit;


   DATA work._test_report;
      SET &i_repdata. END=eof;
      WHERE scn_id = &i_scnid AND cas_id = &i_casid;

      LENGTH 
         scn_abs_path cas_abs_path $256 
         hlp hlp2    $200
         errcountmsg $50
         LinkTitle1
         LinkTitle2
         LinkTitle3
         href 
         href_act 
         href_exp 
         href_rep
         LinkColumn1
         LinkColumn2
         LinkColumn3 $200
         idColumn $80
         scnDescriptionColumn casDescriptionColumn descriptionColumn $1000
         scnProgramColumn casProgramColumn $1000
         scnLast_runColumn casLast_runColumn $1000
         scnDurationColumn $1000
         assertTypeColumn $200
         expectedColumn $1000
         actualColumn $1000
         resultColumn $1000;
         ;
      label 
         scnDescriptionColumn="&g_nls_reportDetail_029."
         scnProgramColumn    ="&g_nls_reportDetail_030."
         scnLast_runColumn   ="&g_nls_reportDetail_031."
         scnDurationColumn   ="&g_nls_reportDetail_032."
         casDescriptionColumn="&g_nls_reportDetail_034."
         casProgramColumn    ="&g_nls_reportDetail_035."
         casLast_runColumn   ="&g_nls_reportDetail_031."
         idColumn            ="&g_nls_reportDetail_009."
         assertTypeColumn    ="&g_nls_reportDetail_010."
         descriptionColumn   ="&g_nls_reportDetail_011."
         expectedColumn      ="&g_nls_reportDetail_012."
         actualColumn        ="&g_nls_reportDetail_013."
         resultColumn        ="&g_nls_reportDetail_014."
         ;

         *** Set default description per assert type ***;
         SELECT(upcase(tst_type));
            WHEN ('ASSERTLOG') DO; 
               IF tst_desc=' ' THEN tst_desc="&g_nls_reportDetail_041";
            END;
            WHEN ('ASSERTLOGMSG') DO; 
               IF tst_desc=' ' THEN tst_desc="&g_nls_reportDetail_047";
            END;
            OTHERWISE;
         END;
         if tst_act="" then tst_act='^_';
         if tst_exp="" then tst_exp='^_';

         *** Columns for scenario overview ***;
         scn_abs_path = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');
         scn_pgm      = resolve ('%_sasunit_stdpath(&g_root./saspgm/test,' !! trim(scn_abs_path) !! ')');
         scn_duration = put (scn_end - scn_start, ??&g_nls_reportScn_013.) !! " s";
         c_scnid      = put (scn_id, z3.);
         c_casid      = put (cas_id, z3.);
         LinkTitle1   = trim ("&g_nls_reportDetail_003") !!" " !! c_scnid;
         LinkTitle2   = "&g_nls_reportDetail_004" !! byte(13) !! scn_abs_path;
         LinkTitle3   = "&g_nls_reportDetail_005";

         cas_abs_path = resolve ('%_sasunit_abspath(&g_sasautos' !! put (cas_auton,1.) !! ',' !! trim(cas_pgm) !! ')');
         cas_pgm      = resolve ('%_sasunit_stdpath(&g_root./saspgm/,' !! trim(cas_abs_path) !! ')');
         LinkTitle4   = "&g_nls_reportDetail_006" !! byte(13) !! cas_abs_path;
         LinkTitle5   = "&g_nls_reportDetail_007";

         %if (&o_html.) %then %do;
            LinkColumn1  = catt("cas_overview.html#SCN", c_scnid, "_");
            LinkColumn2  = "pgm_" !! tranwrd (scn_pgm, ".sas", ".html");
            LinkColumn3  = c_scnid !! "_log.html";
            LinkColumn4  = "pgm_" !! tranwrd (cas_pgm, ".sas", ".html");
            LinkColumn5  = c_scnid !! "_" !! c_casid !! "_log.html";
         %end;

         %if (&o_html.) %then %do;
            %_sasunit_render_DataColumn (i_sourceColumn=scn_desc
                                        ,o_targetColumn=scnDescriptionColumn
                                        ,i_linkColumn=LinkColumn1
                                        ,i_linkTitle=LinkTitle1
                                        );
            %_sasunit_render_DataColumn (i_sourceColumn=scn_path
                                        ,i_linkColumn=scn_abs_path
                                        ,i_linkTitle=LinkTitle2
                                        ,o_targetColumn=scnProgramColumn
                                        );
            %_sasunit_render_DataColumn (i_sourceColumn=scn_start
                                        ,i_format=&g_nls_reportDetail_050.
                                        ,i_linkColumn=LinkColumn3
                                        ,i_linkTitle=LinkTitle3
                                        ,o_targetColumn=scnLast_runColumn
                                        );
            %_sasunit_render_DataColumn (i_sourceColumn=scn_duration
                                        ,o_targetColumn=scnDurationColumn
                                        );

            %_sasunit_render_DataColumn (i_sourceColumn=cas_desc
                                        ,o_targetColumn=casDescriptionColumn
                                        );
            %_sasunit_render_DataColumn (i_sourceColumn=cas_pgm
                                        ,i_linkColumn=cas_abs_path
                                        ,i_linkTitle=LinkTitle4
                                        ,o_targetColumn=casProgramColumn
                                        );
            %_sasunit_render_DataColumn (i_sourceColumn=cas_start
                                        ,i_format=&g_nls_reportDetail_050.
                                        ,i_linkColumn=LinkColumn5
                                        ,i_linkTitle=LinkTitle5
                                        ,o_targetColumn=casLast_runColumn
                                        );

            %_sasunit_render_IdColumn   (i_sourceColumn=tst_id
                                        ,i_format=z3.
                                        ,o_targetColumn=idColumn
                                        );
            %_sasunit_render_DataColumn (i_sourceColumn=tst_desc
                                        ,o_targetColumn=descriptionColumn
                                        );
            %_sasunit_render_DataColumn (i_sourceColumn=tst_type
                                        ,o_targetColumn=assertTypeColumn
                                        );
            %do l_NumAssert=1 %to &_numAsserts;
               if (upcase(tst_type)="%upcase(&&asserttype&l_NumAssert.)") then do;
                  %let l_NumAssertSubstr = &&asserttype&l_NumAssert.;
                  %if (%length(&l_NumAssertSubstr.) > 13) %then %do;
                     %let l_NumAssertSubstr = %substr(&l_NumAssertSubstr.,1,13);
                  %end;
                  %_sasunit_render_&l_NumAssertSubstr.Exp (i_sourceColumn=tst_exp
                                                                 ,o_html=&o_html.
                                                                 ,o_targetColumn=expectedColumn
                                                                 );
                  %_sasunit_render_&l_NumAssertSubstr.Act (i_sourceColumn=tst_act
                                                                 ,o_html=&o_html.
                                                                 ,o_targetColumn=actualColumn
                                                                 );
               end;
            %end;
            %_sasunit_render_IconColumn (i_sourceColumn=tst_res
                                        ,o_html=&o_html.
                                        ,o_targetColumn=resultColumn
                                        );
         %end;
   run;

   options nocenter;

   %*** Reset title and footnotes ***;
   title;
   footnote;

   %let l_title=%str(&g_nls_reportCas_001 | &g_project - &g_nls_reportCas_002);
   title j=c "&l_title.";

   %if (&o_html.) %then %do;
      ods html file="&o_path./&o_file..html" 
                    (TITLE="&l_title.") 
                    headtext="<link href=""tabs.css"" rel=""stylesheet"" type=""text/css""/><link rel=""shortcut icon"" href=""./favicon.ico"" type=""image/x-icon"" />"
                    style=styles.SASUnit stylesheet=(URL="SAS_SASUnit.css");
      %_sasunit_reportPageTopHTML(
         i_title   = &l_title
        ,i_current = 0
      )
   %end;
   
   data work._test_overview;
      set work._test_report (where=(tst_id=1));
      length Name $20 Value $1000;
      Name="&g_nls_reportDetail_028."; Value=c_scnid;output;
      Name="&g_nls_reportDetail_029."; Value=scnDescriptionColumn;output;
      Name="&g_nls_reportDetail_030."; Value=scnProgramColumn;output;
      Name="&g_nls_reportDetail_031."; Value=scnLast_runColumn;output;
      Name="&g_nls_reportDetail_032."; Value=scnDurationColumn;output;
      Name="&g_nls_reportDetail_033."; Value=c_casid;output;
      Name="&g_nls_reportDetail_034."; Value=casDescriptionColumn;output;
      Name="&g_nls_reportDetail_035."; Value=casProgramColumn;output;
      Name="&g_nls_reportDetail_031."; Value=casLast_runColumn;output;
      keep Name Value;
   run;

   proc print data=work._test_overview noobs label 
         style(report)=blindTable [borderwidth=0]
         style(column)=blindData
         style(header)=blindHeader;
   run;

   title;
   %_sasunit_reportFooter(o_html=&o_html.);

   proc report data=work._test_report nowd missing
         style(lines)=blindData
         ;

      columns idColumn assertTypeColumn descriptionColumn expectedColumn actualColumn resultColumn;

      define idColumn     / display style(Column)=rowheader;
      define resultColumn / display style(Column)=[background=white];

      compute before _page_;
         line @1 "&g_nls_reportDetail_008."; 
      endcomp;
   run;

   %if (&o_html.) %then %do;
      ods html close;
   %end;

   proc delete data=work._test_overview;
   run;
   proc delete data=work._test_report;
   run;

   %*** Reset title and footnotes ***;
   title;
   footnote;

   options center;
%MEND _sasunit_reportDetailHTML;
/** \endcond */
