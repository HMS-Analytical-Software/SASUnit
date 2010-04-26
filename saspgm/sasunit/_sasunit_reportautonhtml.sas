/** \file
   \ingroup    SASUNIT_REPORT

   \brief      Auflistung der Prüflinge in einem HTML-Bericht erstellen

   \version \$Revision: 52 $
   \author  \$Author: mangold $
   \date    \$Date: 2009-07-16 14:42:16 +0200 (Do, 16 Jul 2009) $
   \sa      \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/sasunit/_sasunit_reportautonhtml.sas $

   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   o_html         Ausgabedatei im HTML-Format

*/ /** \cond */ 

/* Änderungshistorie
   29.12.2007 AM  Neuererstellung
*/ 

%MACRO _sasunit_reportAutonHTML (
   i_repdata = 
  ,o_html    =
);

/*-- ermittle Anzahl Szenarien pro Prüfling sowie 
     Anzahl Testfälle pro Prüfling und Prüfergebnis --------------------------*/
%LOCAL d_rep1 d_rep2;
%_sasunit_tempFileName(d_rep1)
%_sasunit_tempFileName(d_rep2)

PROC MEANS NOPRINT NWAY DATA=&i_repdata(KEEP=cas_auton pgm_id scn_id cas_res);
   BY cas_auton pgm_id scn_id;
   CLASS cas_res;
   OUTPUT OUT=&d_rep1 (drop=_type_);
RUN;

PROC TRANSPOSE DATA=&d_rep1 OUT=&d_rep1 (DROP=_name_) PREFIX=res;
   BY cas_auton pgm_id scn_id;
   VAR _freq_;
   ID cas_res;
RUN;

PROC MEANS NOPRINT NWAY DATA=&d_rep1(KEEP=cas_auton pgm_id);
   BY cas_auton pgm_id;
   OUTPUT OUT=&d_rep2 (DROP=_type_ RENAME=(_freq_=scn_count));
RUN;

DATA &d_rep1 (COMPRESS=YES);
   MERGE &i_repdata (KEEP=cas_auton pgm_id scn_id cas_pgm tsu_sasautos tsu_sasautos1-tsu_sasautos9) &d_rep1;
   BY cas_auton pgm_id scn_id;
   IF res0=. THEN res0=0;
   IF res1=. THEN res1=0;
   IF res2=. THEN res2=0;
RUN;

DATA &d_rep1 (COMPRESS=YES);
   MERGE &d_rep1 &d_rep2;
   BY cas_auton pgm_id;
RUN;

DATA _null_;
   SET &d_rep1 END=eof;
   BY cas_auton pgm_id scn_id;

   FILE "&o_html";

   IF _n_=1 THEN DO;
      %_sasunit_reportPageTopHTML(
         i_title   = %str(Prüflinge | &g_project - SASUnit Testdokumentation)
        ,i_current = 4
      )
   END;

   LENGTH hlp1 hlp2 hlp3 $256;
   RETAIN hlp3;

   IF first.cas_auton THEN DO;
      IF _n_>1 THEN DO;
         PUT '<hr size="1">';
      END;
      IF cas_auton NE . THEN hlp3 = 'auton' !! put (cas_auton, z3.);
      ELSE hlp3 = 'auton';
      PUT '<table id="' hlp3 +(-1) '"><tr>';
      PUT '   <td>Programmbibliothek</td>';
      IF cas_auton>=0 THEN DO;
         ARRAY sa(0:9) tsu_sasautos tsu_sasautos1-tsu_sasautos9;
         hlp1 = sa(cas_auton);
         IF cas_auton=0 THEN hlp2 = symget('g_sasautos');
         ELSE hlp2 = symget ('g_sasautos' !! compress(put(cas_auton,8.)));
         PUT '   <td><a class="lightlink" title="Programmbibliothek unter &#x0D;' hlp2 +(-1) '" href="file://' hlp2 +(-1) '">' hlp1 +(-1) '</a></td>';
      END;
      ELSE DO;
         PUT '   <td>(ohne)</td>';
      END;
      PUT '</tr></table>';

      PUT '<table>';
      PUT '<tr>';
      PUT '   <td class="tabheader">Prüfling</td>';
      PUT '   <td class="tabheader">Szenario</td>';
      PUT '   <td class="tabheader">Testfälle</td>';
      PUT '   <td class="tabheader">Ergebnis</td>';
      PUT '</tr>';
   END;

   IF first.scn_id THEN DO;
      PUT '<tr>';
   END;

   IF first.pgm_id THEN DO;
      IF cas_auton = . THEN DO;
         hlp2 = resolve ('%_sasunit_abspath(&g_root,' !! trim(cas_pgm) !! ')');   
      END;
      ELSE DO;
         IF cas_auton = 0 THEN hlp1 = '&g_sasautos';
         ELSE hlp1 = '&g_sasautos' !! compress (put (cas_auton,8.));
         hlp2 = resolve ('%_sasunit_abspath(' !! trim(hlp1) !! ',' !! trim(cas_pgm) !! ')');
      END;
      PUT '   <td id="' hlp3 +(-1) '_' pgm_id z3. '" rowspan="' scn_count +(-1) '" class="datacolumn"><a class="lightlink" title="zu prüfendes Programm unter &#x0D;' hlp2 +(-1) '" href="' hlp2 +(-1) '">' cas_pgm +(-1) '</a></td>';
   END;

   IF first.scn_id THEN DO;
      PUT '   <td class="datacolumn"><a class="lightlink" title="Details zu Testszenario ' scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_id z3. '</a></td>';
      hlp1 = left (put (sum (res0, res1, res2), 8.));
      PUT '   <td class="datacolumn">' hlp1 +(-1) '</td>';
      PUT '   <td class="iconcolumn"><img src=' @;
      IF      res1>0 THEN PUT '"error.png"  alt="Fehler"'                                  @;
      ELSE IF res2>0 THEN PUT '"manual.png" alt="manuell"'                                 @;
      ELSE IF res0>0 THEN PUT '"ok.png"     alt="OK"'                                      @;
      ELSE                PUT '"?????"      alt="Fehler in der Testausführung, siehe Log"' @;
      PUT '></img></td>';
      PUT '</tr>';
   END;

   IF last.cas_auton THEN DO;
      PUT '</table>';
   END;

   IF eof THEN DO;
      %_sasunit_reportFooterHTML()
   END;

RUN; 
   
PROC DATASETS NOWARN NOLIST LIB=work;
   DELETE %scan(&d_rep1,2,.) %scan(&d_rep2,2,.);
QUIT;

%MEND _sasunit_reportAutonHTML;
/** \endcond */
