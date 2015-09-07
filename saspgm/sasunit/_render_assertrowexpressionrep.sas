/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML pages for assertRowExpression 

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
   \param   o_html         Test report in HTML-format?
   \param   o_path         output folder

*/ /** \cond */ 

%macro _render_assertRowExpressionRep (i_assertype =
                                      ,i_repdata   =
                                      ,i_scnid     =
                                      ,i_casid     =
                                      ,i_tstid     =
                                      ,o_html      = 0
                                      ,o_path      =
                                      );

  %local l_path dsid cnt rc;

  TITLE;FOOTNOTE;

  %_getTestSubfolder (i_assertType=assertRowExpression
                     ,i_root      =&g_target./tst
                     ,i_scnid     =&i_scnid.
                     ,i_casid     =&i_casid.
                     ,i_tstid     =&i_tstid.
                     ,r_path      =l_path
                     );

   LIBNAME _areLib "&l_path";

   %IF (&o_html.) %then %do;
      ODS HTML4 FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._are_rep.html" stylesheet=(url="css/SAS_SASUnit.css")
                encoding="&g_rep_encoding.";
   %END;

   TITLE  "&g_nls_reportRowExpression_001.";
   TITLE2 "&g_nls_reportRowExpression_002.";
   %IF (%_nobs(_areLib.ViolatingObservations) > 0) %THEN %DO;
      PROC PRINT DATA=_areLib.ViolatingObservations;
      RUN;
   %END;
   %ELSE %DO;
      DATA _null_;
         FILE PRINT;
         PUT "&g_nls_reportRowExpression_003.";
      RUN;
   %END;

   %_reportFooter(o_html=&o_html.);

   %IF (&o_html.) %then %do;
      %_closeHtmlPage;
   %END;

  TITLE; FOOTNOTE;
%MEND _render_assertrowexpressionrep;
/** \endcond */
