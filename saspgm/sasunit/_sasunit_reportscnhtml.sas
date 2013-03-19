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
   \param   o_html         output file in HTML format

*/ /** \cond */ 

/* change log
   14.03.2013 KL  Rework assertion framework: Use of new rendering macros
   19.08.2008 AM  national language support
*/ 

%MACRO _sasunit_reportScnHTML (
   i_repdata = 
  ,o_html    =
);

DATA _null_;
   SET &i_repdata END=eof;
   BY scn_id;

   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_sasunit_reportPageTopHTML(
         i_title   = %str(&g_nls_reportScn_001 | &g_project - &g_nls_reportScn_002)
        ,i_current = 2
      )

      PUT '<table>';

      PUT '<tr>';
      PUT '   <td class="tabheader">' "&g_nls_reportScn_003</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportScn_004</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportScn_005</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportScn_006</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportScn_007</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportScn_008</td>";
      PUT '</tr>';
   END;

   LENGTH abs_path scn_pgm $256 LinkColumn1 LinkTitle1 LinkColumn2 LinkTitle2 LinkColumn3 LinkTitle3 $200;

   IF first.scn_id THEN DO;
      PUT '<tr>';

      abs_path    = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');
      scn_pgm     = resolve ('%_sasunit_stdpath(&g_root./saspgm/test,' !! trim(abs_path) !! ')');
      duration    = scn_end - scn_start;
      c_scnid     = put (scn_id, z3.);
      LinkTitle1  = "&g_nls_reportScn_009 " !! c_scnid;
      LinkColumn1 = "cas_overview.html#scn" !! c_scnid;
      LinkTitle2  = "&g_nls_reportScn_010" !! byte(13) !! abs_path;
      LinkColumn2 = "pgm_" !! tranwrd (scn_pgm, ".sas", ".html");
      LinkTitle3  = "&g_nls_reportScn_011";
      LinkColumn3 = c_scnid !! "_log.html";

      %_sasunit_render_IdColumn   (i_sourceColumn=scn_id
                                  ,i_format=z3.
                                  ,i_linkColumn=LinkColumn1
                                  ,i_linkTitle=LinkTitle1
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=scn_desc
                                  ,i_linkColumn=LinkColumn1
                                  ,i_linkTitle=LinkTitle1
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=scn_path
                                  ,i_linkColumn=abs_path
                                  ,i_linkTitle=LinkTitle2
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=scn_start
                                  ,i_format=&g_nls_reportScn_012.
                                  ,i_linkColumn=LinkColumn3
                                  ,i_linkTitle=LinkTitle3
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=duration
                                  ,i_format=&g_nls_reportScn_013.
                                  );
      %_sasunit_render_IconColumn (i_sourceColumn=scn_res
                                  );

      PUT '<tr>';
   END;

   IF eof THEN DO;
      PUT '</table>';
      %_sasunit_reportFooterHTML()
   END;

RUN; 
   
%MEND _sasunit_reportScnHTML;
/** \endcond */
