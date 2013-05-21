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

   \param   i_assertype    type of assert beeing done. It is know be the program itself, but nevertheless specified as parameter.
   \param   i_repdata      name of reporting dataset containing information on the assert.
   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   o_html         Test report in HTML-format?
   \param   o_path         output folder

*/ /** \cond */ 

%macro _sasunit_render_assertLibraryRep (i_assertype=
                                        ,i_repdata  =
                                        ,i_scnid    =
                                        ,i_casid    =
                                        ,i_tstid    =
                                        ,o_html     =
                                        ,o_path     =
                                        );

   %local l_path;

   title;footnote;

   %_sasunit_getTestSubfolder (i_assertType=assertLibrary
                              ,i_root      =&g_target./tst
                              ,i_scnid     =&i_scnid.
                              ,i_casid     =&i_casid.
                              ,i_tstid     =&i_tstid.
                              ,r_path      =l_path
                              );

   libname _test "&l_path";

   %_sasunit_reportFooter(o_html=&o_html.);

   %if (&o_html.) %then %do;
      ODS HTML FILE="&o_path/&i_scnid._&i_casid._&i_tstid._library_exp.html" stylesheet=(url="SAS_SASUnit.css");
   %end;
   %if (%sysfunc (libref(_test))=0) %then %do;
      TITLE "&g_nls_reportLibrary_006";
      PROC DOCUMENT NAME=_test._library_exp;
         REPLAY / ACTIVETITLE ACTIVEFOOTN;
      RUN;
   %end;
   %else %do;
      DATA _null_;
         PUT ' ';
      RUN;
   %end;
   %if (&o_html.) %then %do;
      ODS HTML CLOSE;
   %end;

   %if (&o_html.) %then %do;
      ODS HTML FILE="&o_path/&i_scnid._&i_casid._&i_tstid._library_act.html" stylesheet=(url="SAS_SASUnit.css");
   %end;
   %if (%sysfunc (libref(_test))=0) %then %do;
      PROC DOCUMENT NAME=_test._library_act;
         REPLAY / ACTIVETITLE ACTIVEFOOTN;
      QUIT;
   %end;
   %else %do;
      DATA _null_;
         PUT ' ';
      RUN;
   %end;
   %if (&o_html.) %then %do;
      ODS HTML CLOSE;
   %end;

   %if (&o_html.) %then %do;
      ODS HTML FILE="&o_path/&i_scnid._&i_casid._&i_tstid._library_rep.html" stylesheet=(url="SAS_SASUnit.css");
   %end;
   %if (%sysfunc (exist (_test._library_rep, DATA))) %then %do;
      %local l_LibraryCheck l_CompareCheck l_id l_ExcludeList;
    
      %*** format results for report ***;
      data WORK._library_rep;
         Length resultColumn $400;
         set _test._library_rep;
         %_sasunit_render_iconColumn (i_sourceColumn=CompareFailed
                                     ,o_html=&o_html.
                                     ,o_targetColumn=resultColumn
                                     );
      run;
    
      proc sql noprint;
         select    i_LibraryCheck,  i_CompareCheck,  i_id,  i_ExcludeList 
             into :l_LibraryCheck, :l_CompareCheck, :l_id, :l_ExcludeList
         from _test._library_rep (obs=1);
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
      proc report data=WORK._library_rep nowd missing
         style (column)={vjust=center};
         columns memname
                 ("&g_nls_reportLibrary_003" CmpLibname CmpObs CmpNVar)
                 ("&g_nls_reportLibrary_004" BaseLibname BaseObs BaseNVar)
                 resultColumn
         ;
         define memname / id style={font_weight=bold foreground=black};
         define resultColumn / "&g_nls_reportLibrary_005" style(column)={background=white};
      run;
      options missing=.;
   %end;
   %else %do;
      DATA _null_;
         PUT ' ';
      RUN;
   %end;
   %if (&o_html.) %then %do;
      ODS HTML CLOSE;
   %end;
      
   LIBNAME _test;

   title;footnote;
%MEND _sasunit_render_assertLibraryRep;
/** \endcond */
