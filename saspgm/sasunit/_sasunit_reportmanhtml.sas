/** \file
   \ingroup    SASUNIT_REPORT

   \brief      Reports f�r assertReport kopieren und ggfs. Frameseite f�r Vergleich erstellen 
               (falls zwei Dateien angegeben wurden)

   \version 1.0
   \author  Andreas Mangold
   \date    21.10.2007
   \param   i_scnid        Szenario-Id der Pr�fung
   \param   i_casid        Case-Id der Pr�fung
   \param   i_tstid        Id der Pr�fung
   \param   i_extexp       Namenerweiterung der erwarteten Reportdatei mit f�hrendem Punkt, 
                           kann leer sein, dann keine Kopie
   \param   i_extact       Namenerweiterung der tats�chlichen Reportdatei mit f�hrendem Punkt, 
                           kann leer sein, dann keine Kopie 
   \param   o_html         kompletter Pfad zur Ausgabedatei f�r das Frameset, falls zwei 
                           Reports verglichen werden sollen

*/ /** \cond */  

/* change log
   19.08.2008 AM  national language support
   11.08.2008 AM  Frameseite erzeugen, wenn zwei Reports verglichen werden.
   05.02.2008 AM  Unterstrich zu Beginn der Kopierziele hinzugef�gt, 
                  damit auch SAS-Dateien korrekt verarbeitet werden.
*/ 

%MACRO _sasunit_reportManHTML (
   i_scnid   =
  ,i_casid   = 
  ,i_tstid   = 
  ,i_extexp  = 
  ,i_extact  = 
  ,o_html    = 
);

%local l_ifile l_ofile;
%let l_ifile=&g_target/tst/_&i_scnid._&i_casid._&i_tstid._man_;
%let l_ofile=&g_target/rep/_&i_scnid._&i_casid._&i_tstid._man_;

%if %sysfunc(fileexist(&l_ifile.exp&i_extexp)) %then %do;
   %_sasunit_copyFile (&l_ifile.exp&i_extexp, &l_ofile.exp&i_extexp);
%end;
%if %sysfunc(fileexist(&l_ifile.act&i_extact)) %then %do;
   %_sasunit_copyFile (&l_ifile.act&i_extact, &l_ofile.act&i_extact);
%end;

%if %sysfunc(fileexist(&l_ifile.exp&i_extexp)) and %sysfunc(fileexist(&l_ifile.act&i_extact)) %then %do;
data _null_;
   file "&o_html";
   %_sasunit_reportHeaderHTML(%str(&g_nls_reportMan_001 &i_scnid - &g_nls_reportMan_002 &i_casid - &g_nls_reportMan_003 &i_tstid - &g_nls_reportMan_004));
   put '<frameset rows="50%,50%">';
   put "   <frame src=""_&i_scnid._&i_casid._&i_tstid._man_exp&i_extexp"" name=""Expected"">";
   put "   <frame src=""_&i_scnid._&i_casid._&i_tstid._man_act&i_extact"" name=""Actual"">";
   put "</frameset>";
   put '</body>';
   put '</html>';
run; 
%end;

%MEND _sasunit_reportManHTML;
/** \endcond */
