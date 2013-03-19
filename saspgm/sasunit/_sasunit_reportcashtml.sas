/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create a list of test cases for HTML report

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   o_html         output dataset in HTML format

*/ /** \cond */ 

/* change history
   14.03.2013 KL  Rework assertion framework: Use of new rendering macros
   06.02.2012 OT  minor bugfix
   12.08.2008 AM  Mehrsprachigkeit
   29.12.2007 AM  verbesserte Beschriftungen
*/ 

%MACRO _sasunit_reportCasHTML (
   i_repdata = 
  ,o_html    =
);

%LOCAL
   l_nls_reportcas_errors
;
%LET l_nls_reportcas_errors   = %STR(error(s));

DATA _null_;
   SET &i_repdata END=eof;
   BY scn_id cas_id;

   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_sasunit_reportPageTopHTML(
         i_title   = %str(&g_nls_reportCas_001 | &g_project - &g_nls_reportCas_002)
        ,i_current = 3
      )
   END;

   LENGTH 
      abs_path    $  256 
      hlp         $  20
      errcountmsg $ 50
      LinkTitle1
      LinkTitle2
      LinkTitle3
      LinkColumn1
      LinkColumn2
      LinkColumn3 $200
   ;

   IF first.scn_id THEN DO;

      IF _n_>1 THEN DO;
         PUT '<hr size="1">';
      END;

      PUT '<table id="scn' scn_id z3. '"><tr>';
      PUT "   <td>&g_nls_reportCas_011</td>";
      PUT '   <td>' scn_id z3. '</td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportCas_003</td>";
      PUT '   <td>' scn_desc +(-1) '</td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportCas_004</td>";

      abs_path = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');

      PUT '   <td><a class="lightlink" title="' "&g_nls_reportCas_005 " '&#x0D;' abs_path +(-1) '" href="' abs_path +(-1) '">' scn_path +(-1) '</a></td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportCas_022</td>";
      
      IF scn_errorcount GT 0 THEN DO;
         errcountmsg = '(' !! put(scn_errorcount, 3.) !! ' ' !! "&l_nls_reportcas_errors." !! ')';
      END;
      ELSE DO;
         errcountmsg = '';
      END;

      PUT '   <td><a class="lightlink" title="' "&g_nls_reportCas_006" '" href="' scn_id z3. '_log.html">' scn_start &g_nls_reportCas_007 '</a>&nbsp;<span class="logerrcountmsg">' errcountmsg '</span> </td>';

      duration = scn_end - scn_start;

      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportCas_008</td>";
      PUT '   <td>' duration &g_nls_reportCas_009 's</td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportCas_010</td>";
      PUT '</tr></table>';

      PUT '<table>';
      PUT '<tr>';
      PUT '   <td class="tabheader">' "&g_nls_reportCas_011" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportCas_012" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportCas_013" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportCas_014" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportCas_015" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportCas_016" '</td>';
      PUT '</tr>';
   END;

   IF first.cas_id THEN DO;
      PUT '<tr>';

      IF cas_auton = '0' THEN hlp = '&g_sasautos';
      ELSE hlp = '&g_sasautos' !! put (cas_auton,1.);
      abs_path = resolve ('%_sasunit_abspath(' !! trim(hlp) !! ',' !! trim(cas_pgm) !! ')');
      duration = cas_end - cas_start;
      c_scnid  = put (scn_id, z3.);
      c_casid  = put (cas_id, z3.);

      LinkTitle1  = "&g_nls_reportCas_017 " !! c_casid;
      LinkTitle2  = "&g_nls_reportCas_018" !! byte(13) !! abs_path;
      LinkTitle3  = "&g_nls_reportCas_006";
      LinkColumn1 = "cas_" !! c_scnid !! "_" !! c_casid !! ".html";
      LinkColumn2 = "pgm_" !! tranwrd (cas_pgm, ".sas", ".html");
      LinkColumn3 = c_scnid !! "_" !! c_casid !! "_log.html";

      %_sasunit_render_IdColumn   (i_sourceColumn=cas_id
                                  ,i_format=z3.
                                  ,i_linkColumn=LinkColumn1
                                  ,i_linkTitle=LinkTitle1
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=cas_desc
                                  ,i_linkColumn=LinkColumn1
                                  ,i_linkTitle=LinkTitle1
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=cas_pgm
                                  ,i_linkColumn=abs_path
                                  ,i_linkTitle=LinkTitle2
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=cas_start
                                  ,i_format=&g_nls_reportCas_007.
                                  ,i_linkColumn=LinkColumn3
                                  ,i_linkTitle=LinkTitle3
                                  );
      %_sasunit_render_DataColumn (i_sourceColumn=duration
                                  ,i_format=&g_nls_reportCas_009.
                                  );
      %_sasunit_render_IconColumn (i_sourceColumn=cas_res
                                  );
      PUT '</tr>';
   END;

   IF last.scn_id THEN DO;
      PUT '</table>';
   END;

   IF eof THEN DO;
      %_sasunit_reportFooterHTML()
   END;

RUN; 
   
%MEND _sasunit_reportCasHTML;
/** \endcond */
