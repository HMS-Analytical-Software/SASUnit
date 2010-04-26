/** \file
   \ingroup    SASUNIT_REPORT

   \brief      die Startseite eines HTML-Berichts erstellen

   \version    \$Revision: 38 $
   \author     \$Author: mangold $
   \date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/sasunit/_sasunit_reportHomeHTML.sas $

   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   o_html         Ausgabedatei im HTML-Format

*/ /** \cond */ 

/* change log
   18.08.2008 AM  added national language support
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
         i_title   = %str(&g_project - &g_nls_reportHome_001)
        ,i_current = 1
      )

      PUT "&g_nls_reportHome_002";
      PUT '<table>';

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_003</td>";
      PUT '<td class="datacolumn"><span title="' "&g_project" '">&amp;g_project</span></td>';
      PUT '<td class="datacolumn">' tsu_project +(-1) '</td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_004</td>";
      PUT '<td class="datacolumn"><span title="' "&g_root" '">&amp;g_root</span></td>';
      PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_root" '" href="file://' tsu_root +(-1) '">' tsu_root +(-1) '</a></td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_005</td>";
      PUT '<td class="datacolumn"><span title="' "&g_target" '">&amp;g_target</span></td>';
      PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_target" '" href="file://' "&g_target" '">' tsu_target +(-1) '</a></td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_006</td>";
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
         PUT '<td class="idcolumn">' "&g_nls_reportHome_007</td>";
         PUT '<td class="datacolumn"><span title="' "&g_autoexec" '">&amp;g_autoexec</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank href="file://' "&g_autoexec" '">' tsu_autoexec +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_sascfg NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">' "&g_nls_reportHome_008</td>";
         PUT '<td class="datacolumn"><span title="' "&g_sascfg" '">&amp;g_sascfg</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank href="file://' "&g_sascfg" '">' tsu_sascfg +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_sasuser NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">' "&g_nls_reportHome_009</td>";
         PUT '<td class="datacolumn"><span title="' "&g_sasuser" '">&amp;g_sascfg</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank href="file://' "&g_sasuser" '">' tsu_sasuser +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_testdata NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">' "&g_nls_reportHome_010</td>";
         PUT '<td class="datacolumn"><span title="' "&g_testdata" '">&amp;g_testdata</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_testdata" '" href="file://' "&g_testdata" '">' tsu_testdata +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_refdata NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">' "&g_nls_reportHome_011</td>";
         PUT '<td class="datacolumn"><span title="' "&g_refdata" '">&amp;g_refdata</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_refdata" '" href="file://' "&g_refdata" '">' tsu_refdata +(-1) '</a></td>';
         PUT '</tr>';
      END;

      IF tsu_doc NE ' ' THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">' "&g_nls_reportHome_012</td>";
         PUT '<td class="datacolumn"><span title="' "&g_doc" '">&amp;g_doc</span></td>';
         PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_doc" '" href="file://' "&g_doc" '">' tsu_doc +(-1) '</a></td>';
         PUT '</tr>';
      END;

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_013</td>";
      PUT '<td class="datacolumn"><span title="' "&g_sasunit" '">&amp;g_sasunit</span></td>';
      PUT '<td class="datacolumn"><a class="link" target=_blank title="' "&g_sasunit" '" href="file://' "&g_sasunit" '">' tsu_sasunit +(-1) '</a></td>';
      PUT '</tr>';

      IF "%sysfunc(getoption(log))" NE " " THEN DO;
         PUT '<tr>';
         PUT '<td class="idcolumn">' "&g_nls_reportHome_014</td>";
         PUT '<td class="datacolumn">&nbsp;</td>';
         PUT '<td class="datacolumn"><a class="link" title="' "%sysfunc(getoption(log))" '" href="file://' "%sysfunc(getoption(log))" '">' "%_sasunit_stdPath (i_root=&g_root, i_path=%sysfunc(getoption(log)))" '</a></td>';
         PUT '</tr>';
      END;

     PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_015</td>";
      PUT '<td class="datacolumn"><div title="' "&g_error" '">&amp;g_error</div><div title="' "&g_warning" '">&amp;g_warning</div></td>';
      PUT '<td class="datacolumn"><div>' "&g_error" '</div><div>' "&g_warning" '</div></td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_016</td>";
      PUT '<td class="datacolumn">&nbsp;</td>';
      PUT '<td class="datacolumn">' "%_sasunit_nobs(target.scn)" '</td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_017</td>";
      PUT '<td class="datacolumn">&nbsp;</td>';
      PUT '<td class="datacolumn">' "%_sasunit_nobs(target.cas)" '</td>';
      PUT '</tr>';

      PUT '<tr>';
      PUT '<td class="idcolumn">' "&g_nls_reportHome_018</td>";
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
