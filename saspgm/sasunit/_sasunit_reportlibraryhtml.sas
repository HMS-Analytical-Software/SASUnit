/** \file
   \ingroup    SASUNIT_REPORT

   \brief      HTML-Seiten f�r assertLibrary erstellen

   \version 1.0
   \author  Klaus Landwich
   \date    14.12.2007

   \param   i_scnid        Szenario-Id der Pr�fung
   \param   i_casid        Case-Id der Pr�fung
   \param   i_tstid        Id der Pr�fung
   \paramt  o_html         output folder

*/ /** \cond */ 

/* change log
   18.08.2008 AM  added national language support
   13.08.2008 AM  control for output folder
   17.12.2007 KL: ExcludeList mit im Report anzeigen
*/ 

%macro _sasunit_reportLibraryHTML (
   i_scnid   =
  ,i_casid   = 
  ,i_tstid   = 
  ,o_html    = 
);

   title;footnote;
   LIBNAME testout "&g_target/tst";

   ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._library_exp.html" stylesheet=(url="SAS_SASUnit.css");
      PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._library_exp;
         REPLAY;
      RUN;
   ODS HTML CLOSE;

   ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._library_act.html" stylesheet=(url="SAS_SASUnit.css");
      PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._library_act;
         REPLAY;
      RUN;
   ODS HTML CLOSE;

   ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._library_rep.html" stylesheet=(url="SAS_SASUnit.css");
      %if (%sysfunc (exist (testout._&i_scnid._&i_casid._&i_tstid._library_rep, DATA))) %then %do;
         %local l_LibraryCheck l_CompareCheck l_id i_ExcludeList;
         proc sql noprint;
            select    i_LibraryCheck,  i_CompareCheck,  i_id,  i_ExcludeList 
                into :l_LibraryCheck, :l_CompareCheck, :l_id, :l_ExcludeList
            from testout._&i_scnid._&i_casid._&i_tstid._library_rep (obs=1);
         quit;

         options missing=' ';
         TITLE " ";
         Title2 h=3 "LibraryCheck=%trim(&l_LibraryCheck.) - CompareCheck=%trim(&l_CompareCheck.)";
         %if (&l_id. ne _NONE_) %then %do;
            Title3 h=3 "ID-Columns: %trim (&l_id.)";
         %end;
         %if (&l_ExcludeList. ne _NONE_) %then %do;
            Title4 h=3 "&g_nls_reportLibrary_002: %trim (&l_ExcludeList.)";
         %end;
         proc report data=testout._&i_scnid._&i_casid._&i_tstid._library_rep nowd missing
            style (column)={vjust=center};
            columns memname
                    ("&g_nls_reportLibrary_003" CmpLibname CmpObs CmpNVar)
                    ("&g_nls_reportLibrary_004" BaseLibname BaseObs BaseNVar)
                    icon_column
            ;
            define memname / id style={font_weight=bold foreground=black};
            define icon_column / center "&g_nls_reportLibrary_005" style(column)={background=white};
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
