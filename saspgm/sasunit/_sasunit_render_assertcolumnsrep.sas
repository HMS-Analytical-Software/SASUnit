/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create reports for assertColumns 

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

%MACRO _sasunit_render_assertColumnsRep (i_assertype=
                                        ,i_repdata  =
                                        ,i_scnid    =
                                        ,i_casid    = 
                                        ,i_tstid    = 
                                        ,o_html     =
                                        ,o_path     =
                                        );

   %local l_path;

   title;footnote;

   %_sasunit_getTestSubfolder (i_assertType=assertColumns
                              ,i_root      =&g_target./tst
                              ,i_scnid     =&i_scnid.
                              ,i_casid     =&i_casid.
                              ,i_tstid     =&i_tstid.
                              ,r_path      =l_path
                              );

   LIBNAME _acLib "&l_path";

   %_sasunit_reportFooter(o_html=&o_html.);

   %if (&o_html.) %then %do;
      ODS HTML FILE="&o_path/&i_scnid._&i_casid._&i_tstid._cmp_act.html" stylesheet=(url="SAS_SASUnit.css");
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
      ODS HTML CLOSE;
   %end;

   %if (&o_html.) %then %do;
      ODS HTML FILE="&o_path/&i_scnid._&i_casid._&i_tstid._cmp_exp.html" stylesheet=(url="SAS_SASUnit.css");
   %end;
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
      ODS HTML CLOSE;
   %end;

   %if (&o_html.) %then %do;
      ODS HTML FILE="&o_path/&i_scnid._&i_casid._&i_tstid._cmp_rep.html" style=styles.SASUnit stylesheet=(url="SAS_SASUnit.css");
   %end;
      TITLE "&g_nls_reportCmp_005";
      PROC DOCUMENT NAME=_acLib._columns_rep;
         REPLAY / ACTIVETITLE ACTIVEFOOTN;
      QUIT;
   %if (&o_html.) %then %do;
      ODS HTML CLOSE;
   %end;
      
   LIBNAME _acLib;
%MEND _sasunit_render_assertColumnsRep;
/** \endcond */
