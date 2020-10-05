/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertForeignKey

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_sourceColumn   name of the column holding the value
   \param   i_expectedColumn name of the column holding the expected value.<em>(optional: Default=tst_exp)</em>
   \param   o_html           Test report in HTML-format?
   \param   o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 
%macro _render_assertForeignKeyAct (i_sourceColumn=
                                   ,o_html=0
                                   ,o_targetColumn=
                                   );

   hlp = trim(left(&i_sourceColumn.));
   select (hlp);
       when (-1)  hlp = "&g_nls_reportForeignKey_001.";
       when (-2)  hlp = "&g_nls_reportForeignKey_002.";
       when (-3)  hlp = "&g_nls_reportForeignKey_003.";
       when (-4)  hlp = "&g_nls_reportForeignKey_004.";
       when (-5)  hlp = "&g_nls_reportForeignKey_005.";
       when (-6)  hlp = "&g_nls_reportForeignKey_006.";
       when (-7)  hlp = "&g_nls_reportForeignKey_007.";
       when (-8)  hlp = "&g_nls_reportForeignKey_008.";
       when (-19) hlp = "&g_nls_reportForeignKey_019.";
       when (-20) hlp = "&g_nls_reportForeignKey_020.";
       when (-21) hlp = "&g_nls_reportForeignKey_021.";
       when (-22) hlp = "&g_nls_reportForeignKey_022.";
       when (-23) hlp = "&g_nls_reportForeignKey_023.";
       when (-24) hlp = "&g_nls_reportForeignKey_024.";
       otherwise hlp = catx(" ",hlp,"&g_nls_reportForeignKey_025.");
   end;
   
   href     = catt ('_', put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
   %if (&o_html.) %then %do;
      href_act = catt (href,'_foreignkey_rep.html');
   %end;
   
   &o_targetColumn. = catt ("^{style [flyover=""&g_nls_reportDetail_016"" url=""", href_act, """] &g_nls_reportDetail_038. } ^n ");
   &o_targetColumn. = catt (hlp, "^n", &o_targetColumn.);

%mend _render_assertForeignKeyAct;
/** \endcond */