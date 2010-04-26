/** \file
   \ingroup    SASUNIT_REPORT

   \brief      Auflistung der Testszenarien in einem HTML-Berichts erstellen

   \version 1.0
   \author  Andreas Mangold
   \date    21.10.2007
   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   o_html         Ausgabedatei im HTML-Format

*/ /** \cond */ 

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
         i_title   = %str(Szenarien | &g_project - SASUnit Testdokumentation)
        ,i_current = 2
      )

      PUT '<table>';

      PUT '<tr>';
      PUT '   <td class="tabheader">Nr.</td>';
      PUT '   <td class="tabheader">Szenario</td>';
      PUT '   <td class="tabheader">Programm</td>';
      PUT '   <td class="tabheader">letzter Lauf</td>';
      PUT '   <td class="tabheader">Dauer</td>';
      PUT '   <td class="tabheader">Ergebnis</td>';
      PUT '</tr>';
   END;

   LENGTH abs_path $256;

   IF first.scn_id THEN DO;
      PUT '<tr>';
      PUT '   <td class="idcolumn"><a class="lightlink" title="Details zu Testszenario ' scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_id z3. '</a></td>';
      PUT '   <td class="datacolumn"><a class="lightlink" title="Details zu Testszenario ' scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_desc +(-1) '</a></td>';
      abs_path = resolve ('%_sasunit_abspath(&g_root,' !! trim(scn_path) !! ')');
      PUT '   <td class="datacolumn"><a class="lightlink" title="Programm des Testszenarios unter &#x0D;' abs_path +(-1) '" href="' abs_path +(-1) '">' scn_path +(-1) '</a></td>';
      PUT '   <td class="datacolumn"><a class="lightlink" title="SAS-Log für diesen Lauf anzeigen" href="' scn_id z3. '_log.html">' scn_start EURDFDT20. '</a></td>';
      duration = scn_end - scn_start;
      PUT '   <td class="datacolumn">' duration commax12.1 's</td>';
      PUT '   <td class="iconcolumn"><img src=' @;
      SELECT (scn_res);
         WHEN (0) PUT '"ok.png" alt="OK"' @;
         WHEN (1) PUT '"error.png" alt="Fehler"' @;
         WHEN (2) PUT '"manual.png" alt="manuell"' @;
         OTHERWISE PUT '"?????" alt="Fehler in der Testausführung, siehe Log"' @;
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
