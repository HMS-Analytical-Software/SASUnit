/** \file
   \ingroup    SASUNIT_REPORT

   \brief      Detailinformationen eines Testfalls als HTML-Bericht erstellen

   \version \$Revision: 52 $
   \author  \$Author: mangold $
   \date    \$Date: 2009-07-16 14:42:16 +0200 (Do, 16 Jul 2009) $
   \sa      \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/sasunit/_sasunit_reportdetailhtml.sas $

   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   i_scnid        Szenario-Id des Testfalls
   \param   i_casid        Case-Id des Testfalls
   \param   o_html         Ausgabedatei im HTML-Format

*/ /** \cond */ 

/* Änderungshistorie
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

DATA _null_;
   SET &i_repdata END=eof;
   WHERE scn_id = &i_scnid AND cas_id = &i_casid;

   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_sasunit_reportPageTopHTML(
         i_title   = %str(Details zu Testfall &i_scnid..&i_casid | &g_project - SASUnit Testdokumentation)
        ,i_current = 0
      )
   END;

   LENGTH abs_path $256 hlp $200;

   IF _n_=1 THEN DO;
      PUT '<table><tr>';
      PUT '   <td>Szenario Nr.</td>';
      PUT '   <td><a class="lightlink" title="Übersicht für Szenario ' scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_id z3. '</a></td>';
      PUT '</tr><tr>';
      PUT '   <td>Szenario</td>';
      PUT '   <td><a class="lightlink" title="Übersicht für Szenario ' scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_desc +(-1) '</a></td>';
      PUT '</tr><tr>';
      PUT '   <td>Programm</td>';
      abs_path = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');
      PUT '   <td><a class="lightlink" title="Programm des Testszenarios unter &#x0D;' abs_path +(-1) '" href="' abs_path +(-1) '">' scn_path +(-1) '</a></td>';
      PUT '</tr><tr>';
      PUT '   <td>letzter Lauf</td>';
      PUT '   <td><a class="lightlink" title="SAS-Log für diesen Lauf des Testszenarios anzeigen" href="' scn_id z3. '_log.html">' scn_start EURDFDT20. '</a></td>';
      duration = scn_end - scn_start;
      PUT '</tr><tr>';
      PUT '   <td>Dauer</td>';
      PUT '   <td>' duration commax12.1 's</td>';
      PUT '</tr><tr>';
      PUT '   <td>Testfall Nr.</td>';
      PUT '   <td>' cas_id z3. '</td>';
      PUT '</tr><tr>';
      PUT '   <td>Testfall</td>';
      PUT '   <td>' cas_desc +(-1) '</td>';
      IF cas_auton = '0' THEN hlp = '&g_sasautos';
      ELSE hlp = '&g_sasautos' !! put (cas_auton,1.);
      abs_path = resolve ('%_sasunit_abspath(' !! trim(hlp) !! ',' !! trim(cas_pgm) !! ')');
      PUT '</tr><tr>';
      PUT '   <td>Prüfling</td>';
      PUT '   <td><a class="lightlink" title="zu prüfendes Programm unter &#x0D;' abs_path +(-1) '" href="' abs_path +(-1) '">' cas_pgm +(-1) '</a></td>';
      PUT '</tr><tr>';
      PUT '   <td>letzter Lauf</td>';
      PUT '   <td><a class="lightlink" title="SAS-Log für diesen Lauf des Testfalls anzeigen" href="' scn_id z3. '_' cas_id z3. '_log.html">' cas_start EURDFDT20. '</a></td>';
      PUT '</tr><tr>';
      PUT '   <td>Prüfungen</td>';
      PUT '</tr></table>';

      PUT '<table>';
      PUT '<tr>';
      PUT '   <td class="tabheader">Nr.</td>';
      PUT '   <td class="tabheader">Prüfart</td>';
      PUT '   <td class="tabheader">Prüfzweck</td>';
      PUT '   <td class="tabheader">erwartet</td>';
      PUT '   <td class="tabheader">tatsächlich</td>';
      PUT '   <td class="tabheader">Ergebnis</td>';
      PUT '</tr>';
   END;

   PUT '<tr id="tst' tst_id z3. '">';
   PUT '   <td class="idcolumn">' tst_id z3. '</td>';
   PUT '   <td class="datacolumn">' tst_type +(-1) '</td>';
   PUT '   <td class="datacolumn">' tst_desc +(-1) '</td>';
   SELECT(upcase(tst_type));
      WHEN ('ASSERTCOLUMNS') DO;
         IF tst_act = ' ' THEN tst_act='&nbsp;';
         IF tst_exp = ' ' THEN tst_exp='&nbsp;';
         PUT '   <td class="datacolumn"><a class="lightlink" title="erwartete Tabelle öffnen" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_exp.html">Tabelle</a><br /><br />' tst_exp '</td>';
         PUT '   <td class="datacolumn"><a class="lightlink" title="tatsächlich erzeugte Tabelle öffnen" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_act.html">Tabelle</a><br />';
         PUT '                          <a class="lightlink" title="Vergleichsbericht öffnen" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_rep.html">Bericht</a><br />' tst_act '</td>';
      END;
      WHEN ('ASSERTLIBRARY') DO;
         PUT '   <td class="datacolumn"><a class="lightlink" title="erwartete Bibliothek öffnen" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_library_exp.html">Bibliothek</a></td>';
         PUT '   <td class="datacolumn"><a class="lightlink" title="tatsächlich erzeugte Bibliothek öffnen" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_library_act.html">Bibliothek</a><br />';
         PUT '                          <a class="lightlink" title="Vergleichsbericht öffnen" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_library_rep.html">Bericht</a></td>';
      END;
      WHEN ('ASSERTREPORT') DO;
         IF tst_exp NE ' ' AND tst_act NE ' ' THEN DO; 
            PUT '   <td class="datacolumn"><a class="lightlink" title="erwarteten und tatsächlichen Bericht öffnen" href="_' scn_id z3. "_" cas_id z3. "_" tst_id z3. '_rep.html">' tst_exp +(-1) '</a></td>';
            PUT '   <td class="datacolumn"><a class="lightlink" title="erwarteten und tatsächlichen Bericht öffnen" href="_' scn_id z3. "_" cas_id z3. "_" tst_id z3. '_rep.html">' tst_act +(-1) '</a></td>';
         END;
         ELSE DO; 
            IF tst_exp NE ' ' THEN 
               PUT '   <td class="datacolumn"><a class="lightlink" title="erwarteten Bericht öffnen" href="_' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_man_exp' tst_exp +(-1) '">' tst_exp +(-1) '</a></td>';
            ELSE 
               PUT '   <td class="datacolumn">&nbsp;</td>';
            IF tst_act NE ' ' THEN DO;
               IF tst_res=1 THEN hlp = trim (tst_act) !! ' - nicht neu erzeugt!';
               ELSE hlp = tst_act;
               PUT '   <td class="datacolumn"><a class="lightlink" title="tatsächlich erzeugten Bericht öffnen" href="_' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_man_act' tst_act +(-1) '">' hlp +(-1) '</a></td>';
            END;
            ELSE 
               PUT '   <td class="datacolumnerror">fehlt</td>';
         END;
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
      WHEN (1) PUT '"error.png" alt="Fehler"' @;
      WHEN (2) PUT '"manual.png" alt="manuell"' @;
      OTHERWISE PUT '"?????" alt="Fehler in der Testausführung, siehe Log"' @;
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
