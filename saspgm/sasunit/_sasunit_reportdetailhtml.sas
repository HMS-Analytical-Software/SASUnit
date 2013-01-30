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
   \param   o_html         output file in HTML format

*/ /** \cond */ 

/* change log
   29.01.2013 BB	Hard coded date and time formats replaced. ReportDetail formats 49 and 50 applied.
   08.01.2013 KL  Empty cells are rendered incorrectly in MS IE. So &nbsp; is now used as contents of an empty cell
   26.09.2008 AM  bug fixing NLS: standard description texts for assertLog(Msg)
   18.08.2008 AM  added national language support
   11.08.2008 AM  Frameseite für den Vergleich zweier Reports bei ASSERTREPORT einbinden
   07.07.2008 AM  Formatierung für assertColumns verbessert
   05.02.2008 AM  assertManual nach assertReport umgestellt
   29.12.2007 AM  Informationen zum Prüfling hinzugefügt
   15.12.2007 AM  überflüssige Variable hlp entfernt.
*/ 

%MACRO _sasunit_reportDetailHTML (
   i_repdata =
  ,i_scnid   =
  ,i_casid   = 
  ,o_html    =
);

%LOCAL
   l_nls_reportdetail_errors
;
%LET l_nls_reportdetail_errors   = %STR(error(s));

DATA _null_;
   SET &i_repdata END=eof;
   WHERE scn_id = &i_scnid AND cas_id = &i_casid;

   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_sasunit_reportPageTopHTML(
         i_title   = %str(&g_nls_reportDetail_001 &i_scnid..&i_casid | &g_project - &g_nls_reportDetail_002)
        ,i_current = 0
      )
   END;

   LENGTH 
      abs_path    $  256 
      hlp         $  200 
      hlp2        $  200
      errcountmsg $  50
   ;

   IF _n_=1 THEN DO;

      PUT '<table><tr>';
      PUT "   <td>&g_nls_reportDetail_028</td>";
      PUT '   <td><a class="lightlink" title="' "&g_nls_reportDetail_003 " scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_id z3. '</a></td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_029</td>";
      PUT '   <td><a class="lightlink" title="' "&g_nls_reportDetail_003 " scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_desc +(-1) '</a></td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_030</td>";

      abs_path = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');

      PUT '   <td><a class="lightlink" title="' "&g_nls_reportDetail_004 &#x0D;" abs_path +(-1) '" href="' abs_path +(-1) '">' scn_path +(-1) '</a></td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_031</td>";

      IF scn_errorcount GT 0 THEN DO;
         errcountmsg = '(' !! put(scn_errorcount, 3.) !! ' ' !! "&l_nls_reportdetail_errors." !! ')';
      END;
      ELSE DO;
         errcountmsg = '';
      END;

      PUT '   <td><a class="lightlink" title="' "&g_nls_reportDetail_005" '" href="' scn_id z3. '_log.html">' scn_start &g_nls_reportDetail_050 '</a>&nbsp;<span class="logerrcountmsg">' errcountmsg '</span> </td>';

      duration = scn_end - scn_start;

      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_032</td>";
      PUT '   <td>' duration &g_nls_reportDetail_049 's</td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_033</td>";
      PUT '   <td>' cas_id z3. '</td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_034</td>";
      PUT '   <td>' cas_desc +(-1) '</td>';

      IF cas_auton = '0' THEN hlp = '&g_sasautos';
      ELSE hlp = '&g_sasautos' !! put (cas_auton,1.);

      abs_path = resolve ('%_sasunit_abspath(' !! trim(hlp) !! ',' !! trim(cas_pgm) !! ')');

      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_035</td>";
      PUT '   <td><a class="lightlink" title="' "&g_nls_reportDetail_006 &#x0D;" abs_path +(-1) '" href="' abs_path +(-1) '">' cas_pgm +(-1) '</a></td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_031</td>";
      PUT '   <td><a class="lightlink" title="' "&g_nls_reportDetail_007" '" href="' scn_id z3. '_' cas_id z3. '_log.html">' cas_start &g_nls_reportDetail_050 '</a></td>';
      PUT '</tr><tr>';
      PUT "   <td>&g_nls_reportDetail_008</td>";
      PUT '</tr></table>';

      PUT '<table>';
      PUT '<tr>';
      PUT '   <td class="tabheader">' "&g_nls_reportDetail_009</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportDetail_010</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportDetail_011</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportDetail_012</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportDetail_013</td>";
      PUT '   <td class="tabheader">' "&g_nls_reportDetail_014</td>";
      PUT '</tr>';
   END;

   PUT '<tr id="tst' tst_id z3. '">';
   PUT '   <td class="idcolumn">' tst_id z3. '</td>';
   PUT '   <td class="datacolumn">' tst_type +(-1) '</td>';
   SELECT(upcase(tst_type));
      WHEN ('ASSERTLOG') DO; 
         IF tst_desc=' ' THEN tst_desc="&g_nls_reportDetail_041";
      END;
      WHEN ('ASSERTLOGMSG') DO; 
         IF tst_desc=' ' THEN tst_desc="&g_nls_reportDetail_047";
      END;
      OTHERWISE;
   END;
   IF tst_desc = ' ' THEN tst_desc='&nbsp;';
   PUT '   <td class="datacolumn">' tst_desc +(-1) '</td>';
   SELECT(upcase(tst_type));
      WHEN ('ASSERTCOLUMNS') DO;
         IF tst_act  = ' ' THEN tst_act ='&nbsp;';
         IF tst_exp  = ' ' THEN tst_exp ='&nbsp;';
         PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_015" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_exp.html">' "&g_nls_reportDetail_038" '</a><br /><br />' tst_exp '</td>';
         PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_016" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_act.html">' "&g_nls_reportDetail_038" '</a><br />';
         PUT '                          <a class="lightlink" title="' "&g_nls_reportDetail_017" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_rep.html">' "&g_nls_reportDetail_039" '</a><br />' tst_act '</td>';
      END;
      WHEN ('ASSERTLIBRARY') DO;
         PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_018" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_library_exp.html">' "&g_nls_reportDetail_040" '</a></td>';
         PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_019" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_library_act.html">' "&g_nls_reportDetail_040" '</a><br />';
         PUT '                          <a class="lightlink" title="' "&g_nls_reportDetail_017" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_library_rep.html">' "&g_nls_reportDetail_039" '</a></td>';
      END;
      WHEN ('ASSERTREPORT') DO;
         IF tst_exp NE ' ' AND tst_act NE ' ' THEN DO; 
            PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_020" '" href="_' scn_id z3. "_" cas_id z3. "_" tst_id z3. '_rep.html">' tst_exp +(-1) '</a></td>';
            PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_020" '" href="_' scn_id z3. "_" cas_id z3. "_" tst_id z3. '_rep.html">' tst_act +(-1) '</a></td>';
         END;
         ELSE DO; 
            IF tst_exp NE ' ' THEN 
               PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_021" '" href="_' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_man_exp' tst_exp +(-1) '">' tst_exp +(-1) '</a></td>';
            ELSE 
               PUT '   <td class="datacolumn">&nbsp;</td>';
            IF tst_act NE ' ' THEN DO;
               IF tst_res=1 THEN hlp = trim (tst_act) !! " - &g_nls_reportDetail_022!";
               ELSE hlp = tst_act;
               PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_023" '" href="_' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_man_act' tst_act +(-1) '">' hlp +(-1) '</a></td>';
            END;
            ELSE 
               PUT '   <td class="datacolumnerror">' "&g_nls_reportDetail_048" '</td>';
         END;
      END;
      WHEN ('ASSERTLOG') DO;
         hlp  = scan(tst_exp,1,'#');
         hlp2 = scan(tst_exp,2,'#');
         PUT '   <td class="datacolumn">' "&g_nls_reportDetail_036: " hlp +(-1) ", &g_nls_reportDetail_037: " hlp2 +(-1) '</td>';
         hlp  = scan(tst_act,1,'#');
         hlp2 = scan(tst_act,2,'#');
         PUT '   <td class="datacolumn">' "&g_nls_reportDetail_036: " hlp +(-1) ", &g_nls_reportDetail_037: " hlp2 +(-1) '</td>';
      END;
      WHEN ('ASSERTLOGMSG') DO;
         hlp  = substr(tst_exp,1,1); 
         if hlp='1' then hlp="&g_nls_reportDetail_042"; 
         else            hlp="&g_nls_reportDetail_043"; 
         tst_exp= substr(tst_exp,2);
         PUT '   <td class="datacolumn">' "&g_nls_reportDetail_044 '" tst_exp +(-1) "' " hlp +(-1) '</td>';
         hlp  = substr(tst_act,1,1); 
         if hlp='1' then hlp="&g_nls_reportDetail_045"; 
         else            hlp="&g_nls_reportDetail_046"; 
         PUT '   <td class="datacolumn">' hlp +(-1) '</td>';
      END;
      OTHERWISE DO;
         IF tst_exp NE ' ' THEN 
            PUT '   <td class="datacolumn">' tst_exp  +(-1) '</td>';
         ELSE 
            PUT '   <td class="datacolumn">&nbsp;</td>';
         IF tst_act NE ' ' THEN 
            PUT '   <td class="datacolumn">' tst_act  +(-1) '</td>';
         ELSE 
            PUT '   <td class="datacolumn">&nbsp;</td>';
      END;
   END;

   PUT '   <td class="iconcolumn"><img src=' @;
   SELECT (tst_res);
      WHEN (0) PUT '"ok.png" alt="OK"' @;
      WHEN (1) PUT '"error.png" alt="' "&g_nls_reportDetail_025" '"' @;
      WHEN (2) PUT '"manual.png" alt="' "&g_nls_reportDetail_026" '"' @;
      OTHERWISE PUT '"?????" alt="' "&g_nls_reportDetail_027" '"' @;
   END;
   PUT '></img></td>';
   PUT '</tr>';

   IF eof THEN DO;
      PUT '</table>';
      %_sasunit_reportFooterHTML()
   END;

RUN; 
   
%MEND _sasunit_reportDetailHTML;
/** \endcond */
