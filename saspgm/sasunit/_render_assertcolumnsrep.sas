/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create reports for assertColumns 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_assertype    type of assert beeing done. It is know be the program itself, but nevertheless specified as parameter.
   \param   i_repdata      name of reporting dataset containing information on the assert.
   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   i_style        Name of the SAS style and css file to be used. 
   \param   o_html         Test report in HTML-format?
   \param   o_path         output folder

*/ /** \cond */ 

%MACRO _render_assertColumnsRep (i_assertype=
                                ,i_repdata  =
                                ,i_scnid    =
                                ,i_casid    = 
                                ,i_tstid    = 
                                ,i_style    =
                                ,o_html     = 0
                                ,o_path     =
                                );

   %local l_path;

   title;footnote;

   %_getTestSubfolder (i_assertType=assertColumns
                      ,i_root      =&g_target./tst
                      ,i_scnid     =&i_scnid.
                      ,i_casid     =&i_casid.
                      ,i_tstid     =&i_tstid.
                      ,r_path      =l_path
                      );

   LIBNAME _acLib "&l_path";

   %if (&o_html.) %then %do;
      ODS HTML4 FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._cmp_exp.html" style=styles.&i_style. stylesheet=(URL="css/&i_style..css")
                encoding="&g_rep_encoding.";
   %end;

   %_reportFooter(o_html=&o_html.);

   TITLE "&g_nls_reportCmp_003";
   %IF %sysfunc(exist(_acLib._columns_exp)) %THEN %DO;
      PROC PRINT DATA=_acLib._columns_exp;
      RUN;
   %END;
   %ELSE %DO;
      DATA _null_;
         FILE PRINT;
         PUT "&g_nls_reportCmp_004";
      RUN;
   %END;

   %if (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
      ODS HTML4 FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._cmp_act.html" style=styles.&i_style. stylesheet=(URL="css/&i_style..css");
   %end;
   TITLE "&g_nls_reportCmp_001";
   %IF %sysfunc(exist(_acLib._columns_act)) %THEN %DO;
      PROC PRINT DATA=_acLib._columns_act;
      RUN;
   %END;
   %ELSE %DO;
      DATA _null_;
         FILE PRINT;
         PUT "&g_nls_reportCmp_002";
      RUN;
   %END;


   %if (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
      ODS HTML4 FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._cmp_rep.html" style=styles.&i_style. stylesheet=(URL="css/&i_style..css");
   %end;
      TITLE "&g_nls_reportCmp_005";
      PROC DOCUMENT NAME=_acLib._columns_rep;
         REPLAY / ACTIVETITLE ACTIVEFOOTN;
      QUIT;
   %if (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
   %end;
      
   LIBNAME _acLib;
%MEND _render_assertColumnsRep;
/** \endcond */
