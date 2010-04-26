/** \file
   \ingroup    SASUNIT_REPORT

   \brief      Auflistung der Testfälle in einem HTML-Berichts erstellen

   \version \$Revision: 52 $
   \author  \$Author: mangold $
   \date    \$Date: 2009-07-16 14:42:16 +0200 (Do, 16 Jul 2009) $
   \sa      \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/sasunit/_sasunit_reportcashtml.sas $

   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   o_html         Ausgabedatei im HTML-Format

*/ /** \cond */ 

/* Änderungshistorie
   29.12.2007 AM  verbesserte Beschriftungen
*/ 

%MACRO _sasunit_reportCasHTML (
   i_repdata = 
  ,o_html    =
);

DATA _null_;
   SET &i_repdata END=eof;
   BY scn_id cas_id;

   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_sasunit_reportPageTopHTML(
         i_title   = %str(Testfälle nach Szenarien | &g_project - SASUnit Testdokumentation)
        ,i_current = 3
      )
   END;

   LENGTH abs_path $256 hlp $20;

   IF first.scn_id THEN DO;
      IF _n_>1 THEN DO;
         PUT '<hr size="1">';
      END;
      PUT '<table id="scn' scn_id z3. '"><tr>';
      PUT '   <td>Nr.</td>';
      PUT '   <td>' scn_id z3. '</td>';
      PUT '</tr><tr>';
      PUT '   <td>Szenario</td>';
      PUT '   <td>' scn_desc +(-1) '</td>';
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
/*    PUT '   <td>Gesamtergebnis</td>';
      PUT '   <td><img src=' @;
      SELECT (scn_res);
         WHEN (0) PUT '"ok.png" alt="OK"' @;
         WHEN (1) PUT '"error.png" alt="Fehler"' @;
         WHEN (2) PUT '"manual.png" alt="manuell"' @;
         OTHERWISE PUT '"?????" alt="Fehler in der Testausführung, siehe Log"' @;
      END;
      PUT '></img></td>';
      PUT '</tr><tr>';
*/    PUT '   <td>Testfälle</td>';
      PUT '</tr></table>';

      PUT '<table>';
      PUT '<tr>';
      PUT '   <td class="tabheader">Nr.</td>';
      PUT '   <td class="tabheader">Testfall</td>';
      PUT '   <td class="tabheader">Prüfling</td>';
     *PUT '   <td class="tabheader">Spezifikation</td>';
      PUT '   <td class="tabheader">letzter Lauf</td>';
      PUT '   <td class="tabheader">Dauer</td>';
      PUT '   <td class="tabheader">Ergebnis</td>';
      PUT '</tr>';
   END;

   IF first.cas_id THEN DO;
      PUT '<tr>';
      PUT '   <td class="idcolumn"><a class="lightlink" title="Details zum Testfall ' cas_id z3. '" href="cas_' scn_id z3. '_' cas_id z3. '.html">' cas_id z3. '</a></td>';
      PUT '   <td class="datacolumn"><a class="lightlink" title="Details zum Testfall ' cas_id z3. '" href="cas_' scn_id z3. '_' cas_id z3. '.html">' cas_desc +(-1) '</a></td>';
      IF cas_auton = '0' THEN hlp = '&g_sasautos';
      ELSE hlp = '&g_sasautos' !! put (cas_auton,1.);
      abs_path = resolve ('%_sasunit_abspath(' !! trim(hlp) !! ',' !! trim(cas_pgm) !! ')');
      PUT '   <td class="datacolumn"><a class="lightlink" title="zu prüfendes Programm unter &#x0D;' abs_path +(-1) '" href="' abs_path +(-1) '">' cas_pgm +(-1) '</a></td>';
  /*  PUT '   <td class="datacolumn">' @;
      IF cas_spec NE ' ' THEN DO;
         abs_path = resolve ('%_sasunit_abspath(&g_doc,' !! trim(cas_pgm) !! ')');
         PUT '<a class="lightlink" title="Spezifikation öffnen" href="' abs_path +(-1) '">' cas_spec +(-1) '</a>' @;
      END;
      ELSE 
         PUT '&nbsp;' @;
      PUT '</td>';
  */  PUT '   <td class="datacolumn"><a class="lightlink" title="SAS-Log für diesen Lauf des Testfalls anzeigen" href="' scn_id z3. '_' cas_id z3. '_log.html">' cas_start EURDFDT20. '</a></td>';
      duration = cas_end - cas_start;
      PUT '   <td class="datacolumn">' duration commax12.1 's</td>';
      PUT '   <td class="iconcolumn"><img src=' @;
      SELECT (cas_res);
         WHEN (0) PUT '"ok.png" alt="OK"' @;
         WHEN (1) PUT '"error.png" alt="Fehler"' @;
         WHEN (2) PUT '"manual.png" alt="manuell"' @;
         OTHERWISE PUT '"?????" alt="Fehler in der Testausführung, siehe Log"' @;
      END;
      PUT '></img></td>';
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
