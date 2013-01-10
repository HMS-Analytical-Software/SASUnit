/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML pages for assertLibrary 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   o_html         output folder

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
      TITLE "&g_nls_reportLibrary_006";
      PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._library_exp;
         REPLAY / ACTIVETITLE;
      RUN;
   ODS HTML CLOSE;

   ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._library_act.html" stylesheet=(url="SAS_SASUnit.css");
      TITLE "&g_nls_reportLibrary_007";
      PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._library_act;
         REPLAY / ACTIVETITLE;
      RUN;
   ODS HTML CLOSE;

   ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._library_rep.html" stylesheet=(url="SAS_SASUnit.css");
      %if (%sysfunc (exist (testout._&i_scnid._&i_casid._&i_tstid._library_rep, DATA))) %then %do;
         %local l_LibraryCheck l_CompareCheck l_id l_ExcludeList;
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
