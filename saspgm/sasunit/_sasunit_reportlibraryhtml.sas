/** \file
   \ingroup    SASUNIT_REPORT

   \brief      HTML-Seiten für assertLibrary erstellen

   \version 1.0
   \author  Klaus Landwich
   \date    14.12.2007

   \param   i_scnid        Szenario-Id der Prüfung
   \param   i_casid        Case-Id der Prüfung
   \param   i_tstid        Id der Prüfung

*/ /** \cond */ 

%macro _sasunit_reportLibraryHTML (
   i_scnid   =
  ,i_casid   = 
  ,i_tstid   = 
);

   /* 
      17.12.2007 KL: ExcludeList mit im Report anzeigen
   */

   title;footnote;
   LIBNAME testout "&g_target/tst";

   ODS HTML FILE="&g_target/rep/&i_scnid._&i_casid._&i_tstid._library_exp.html" stylesheet=(url="SAS_SASUnit.css");
      PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._library_exp;
         REPLAY;
      RUN;
   ODS HTML CLOSE;

   ODS HTML FILE="&g_target/rep/&i_scnid._&i_casid._&i_tstid._library_act.html" stylesheet=(url="SAS_SASUnit.css");
      PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._library_act;
         REPLAY;
      RUN;
   ODS HTML CLOSE;

   ODS HTML FILE="&g_target/rep/&i_scnid._&i_casid._&i_tstid._library_rep.html" stylesheet=(url="SAS_SASUnit.css");
      %if (%sysfunc (exist (testout._&i_scnid._&i_casid._&i_tstid._library_rep, DATA))) %then %do;
         %local l_LibraryCheck l_CompareCheck l_id i_ExcludeList;
         proc sql noprint;
            select    i_LibraryCheck,  i_CompareCheck,  i_id,  i_ExcludeList 
                into :l_LibraryCheck, :l_CompareCheck, :l_id, :l_ExcludeList
            from testout._&i_scnid._&i_casid._&i_tstid._library_rep (obs=1);
         quit;

         options missing=' ';
         TITLE "Prüfbericht - Vergleich der beiden Bibliotheken";
         Title2 h=3 "LibraryCheck=%trim(&l_LibraryCheck.) - CompareCheck=%trim(&l_CompareCheck.)";
         %if (&l_id. ne _NONE_) %then %do;
            Title3 h=3 "ID-Columns: %trim (&l_id.)";
         %end;
         %if (&l_ExcludeList. ne _NONE_) %then %do;
            Title4 h=3 "Nicht vergliche Dateien: %trim (&l_ExcludeList.)";
         %end;
         proc report data=testout._&i_scnid._&i_casid._&i_tstid._library_rep nowd missing
            style (column)={vjust=center};
            columns memname
                    ("erwartete Library" CmpLibname CmpObs CmpNVar)
                    ("aktuelle Library" BaseLibname BaseObs BaseNVar)
                    icon_column
            ;
            define memname / id style={font_weight=bold foreground=black};
            define icon_column / center "Ergebnis" style(column)={background=white};
         run;
         options missing=.;
      %end;
      %else %do;
         DATA _null_;
            PUT ' ';
         RUN;
      %end;
   ODS HTML CLOSE;
   
   LIBNAME testout;

   title;footnote;
%MEND _sasunit_reportLibraryHTML;
/** \endcond */




