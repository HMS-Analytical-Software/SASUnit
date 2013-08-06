/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertColumns

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertColumnsAct (i_sourceColumn=
                                ,o_html=
                                ,o_targetColumn=
                                );
   href     = catt (put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
   %if (&o_html.) %then %do;
      href_act = catt (href,'_cmp_act.html');
      href_rep = catt (href,'_cmp_rep.html');
   %end;
   &o_targetColumn. = catt ("^{style [flyover=""&g_nls_reportDetail_016"" url=""", href_act, """] &g_nls_reportDetail_038. } ^n ");
   &o_targetColumn. = catt (&o_targetColumn., " ^{style [flyover=""&g_nls_reportDetail_017"" url=""", href_rep, """] &&g_nls_reportDetail_039. } ^n ", &i_sourceColumn.);
%mend _render_assertColumnsAct;
/** \endcond */
