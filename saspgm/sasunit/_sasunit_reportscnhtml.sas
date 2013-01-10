/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create list of thest scenarios for HTML report

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

   LENGTH abs_path $256;

   IF first.scn_id THEN DO;
      PUT '<tr>';
      PUT '   <td class="idcolumn"><a class="lightlink" title="' "&g_nls_reportScn_009 " scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_id z3. '</a></td>';
      PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportScn_009 " scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_desc +(-1) '</a></td>';
      abs_path = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');
      PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportScn_010 " '&#x0D;' abs_path +(-1) '" href="' abs_path +(-1) '">' scn_path +(-1) '</a></td>';
      PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportScn_011" '" href="' scn_id z3. '_log.html">' scn_start &g_nls_reportScn_012 '</a></td>';
      duration = scn_end - scn_start;
      PUT '   <td class="datacolumn">' duration &g_nls_reportScn_013 's</td>';
      PUT '   <td class="iconcolumn"><img src=' @;
      SELECT (scn_res);
         WHEN (0) PUT '"ok.png" alt="OK"' @;
         WHEN (1) PUT '"error.png" alt="' "&g_nls_reportScn_014" '"' @;
         WHEN (2) PUT '"manual.png" alt="' "&g_nls_reportScn_015" '"' @;
         OTHERWISE PUT '"?????" alt="' "&g_nls_reportScn_016" '"' @;
      END;
      PUT '></img></td>';
      PUT '<tr>';
   END;

   IF eof THEN DO;
      PUT '</table>';
      %_sasunit_reportFooterHTML()
   END;

RUN; 
   
%MEND _sasunit_reportScnHTML;
/** \endcond */
