/** \file
   \ingroup    SASUNIT_REPORT

   \brief      die Startseite eines HTML-Berichts erstellen

   \version    \$Revision: 52 $
   \author     \$Author: mangold $
   \date       \$Date: 2009-07-16 14:42:16 +0200 (Do, 16 Jul 2009) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/sasunit/_sasunit_reporthomehtml.sas $

   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   o_html         Ausgabedatei im HTML-Format

*/ /** \cond */ 

/* Änderungshistorie
   29.12.2007 AM  Ampersands kodiert, minimale Textänderung
*/ 

%MACRO _sasunit_reportHomeHTML (
   i_repdata = 
  ,o_html    =
);

%LOCAL i;

DATA _null_;
   SET &i_repdata;
   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_sasunit_reportPageTopHTML(
         i_title   = %str(&g_project - SASUnit Testdokumentation)
        ,i_current = 1
      )

      PUT 'Eigenschaften dieser Testsuite';
      PUT '<table>';

      PUT '<tr>';
      PUT '<td class="idcolumn">Projektname</td>';
      PUT '<td class="datacolumn"><span title="' "&g_project" '">&amp;g_project</span></td>';
      PUT '<td class="datacolumn">' tsu_project +(-1) '</td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">Wurzelverzeichnis</td>';
      PUT '<td class="datacolumn"><span title="' "&g_root" '">&amp;g_root</span></td>';
      PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_root" '" href="file://' tsu_root +(-1) '">' tsu_root +(-1) '</a></td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">Pfad zur Testdatenbank</td>';
      PUT '<td class="datacolumn"><span title="' "&g_target" '">&amp;g_target</span></td>';
      PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_target" '" href="file://' "&g_target" '">' tsu_target +(-1) '</a></td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">Programmbibliotheken<br>(Makro-Autocall-Pfade)</br></td>';
      PUT '<td class="datacolumn">';
      %IF "&g_sasautos" NE "" %THEN %DO;
         PUT '<div title="' "&g_sasautos" '">&amp;g_sasautos</div>';
      %END;
      %DO i=1 %TO 9;
         %IF "&&g_sasautos&i" NE "" %THEN %DO;
      PUT '<div title="' "&&g_sasautos&i" '">&amp;g_sasautos' "&i" '</div>';
         %END;
      %END;
      PUT '</td>';
      PUT '<td class="datacolumn">';
      %IF "&g_sasautos" NE "" %THEN %DO;
      PUT '<div><a class="link" target=_blank title="' "&g_sasautos" '" href="file://' "&g_sasautos" '">' tsu_sasautos +(-1) '</a></div>';
      %END;
      %DO i=1 %TO 9;
         %IF "&&g_sasautos&i" NE "" %THEN %DO;
      PUT '<div><a class="link" target=_blank  title="' "&&g_sasautos&i" '" href="file://' "&&g_sasautos&i" '">' tsu_sasautos&i +(-1) '</a></div>';
         %END;
      %END;
      PUT '</td>';
      PUT '</tr>';

      IF tsu_autoexec NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">Autoexec-Programm für Testszenarien</td>';
         PUT '<td class="datacolumn"><span title="' "&g_autoexec" '">&amp;g_autoexec</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank href="file://' "&g_autoexec" '">' tsu_autoexec +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_sascfg NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">SAS-Konfigurationsdatei für Testszenarien</td>';
         PUT '<td class="datacolumn"><span title="' "&g_sascfg" '">&amp;g_sascfg</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank href="file://' "&g_sascfg" '">' tsu_sascfg +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_sasuser NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">SASUSER-Verzeichnis für Testszenarien</td>';
         PUT '<td class="datacolumn"><span title="' "&g_sasuser" '">&amp;g_sascfg</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank href="file://' "&g_sasuser" '">' tsu_sasuser +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_testdata NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">Verzeichnis mit Testdaten</td>';
         PUT '<td class="datacolumn"><span title="' "&g_testdata" '">&amp;g_testdata</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_testdata" '" href="file://' "&g_testdata" '">' tsu_testdata +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_refdata NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">Verzeichnis mit Referenzdaten</td>';
         PUT '<td class="datacolumn"><span title="' "&g_refdata" '">&amp;g_refdata</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_refdata" '" href="file://' "&g_refdata" '">' tsu_refdata +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_doc NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">Verzeichnis mit Spezifikationsdokumenten</td>';
         PUT '<td class="datacolumn"><span title="' "&g_doc" '">&amp;g_doc</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_doc" '" href="file://' "&g_doc" '">' tsu_doc +(-1) '</a></td>';
         PUT '</tr>';
      END;

      PUT '<tr>';
      PUT '<td class="idcolumn">Pfad zu den SASUnit-Makros</td>';
      PUT '<td class="datacolumn"><span title="' "&g_sasunit" '">&amp;g_sasunit</span></td>';
      PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_sasunit" '" href="file://' "&g_sasunit" '">' tsu_sasunit +(-1) '</a></td>';
      PUT '</tr>';

      IF "%sysfunc(getoption(log))" NE " " THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">SAS-Log des Reporting-Jobs</td>';
         PUT '<td class="datacolumn">&nbsp;</td>';
         PUT '<td class="datacolumn"><a class="link" title="' "%sysfunc(getoption(log))" '" href="file://' "%sysfunc(getoption(log))" '">' "%_sasunit_stdPath (i_root=&g_root, i_path=%sysfunc(getoption(log)))" '</a></td>';
         PUT '</tr>';
      END;

     PUT '<tr>';
      PUT '<td class="idcolumn">Symbole</td>';
      PUT '<td class="datacolumn"><div title="' "&g_error" '">&amp;g_error</div><div title="' "&g_warning" '">&amp;g_warning</div></td>';
      PUT '<td class="datacolumn"><div>' "&g_error" '</div><div>' "&g_warning" '</div></td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">Anzahl Testszenarien</td>';
      PUT '<td class="datacolumn">&nbsp;</td>';
      PUT '<td class="datacolumn">' "%_sasunit_nobs(target.scn)" '</td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">Anzahl Testfälle</td>';
      PUT '<td class="datacolumn">&nbsp;</td>';
      PUT '<td class="datacolumn">' "%_sasunit_nobs(target.cas)" '</td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">Anzahl Prüfungen</td>';
      PUT '<td class="datacolumn">&nbsp;</td>';
      PUT '<td class="datacolumn">' "%_sasunit_nobs(target.tst)" '</td>';
      PUT '</tr>';

      PUT '</table>';

      %_sasunit_reportFooterHTML()

      STOP;
   END;

RUN; 
   
%MEND _sasunit_reportHomeHTML;
/** \endcond */
