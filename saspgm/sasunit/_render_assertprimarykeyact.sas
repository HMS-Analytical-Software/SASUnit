/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertPrimaryKey

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
   \param   o_html           Test report in HTML-format?
   \param   o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 
%macro _render_assertPrimaryKeyAct (i_sourceColumn=
                                   ,o_html=0
                                   ,o_targetColumn=
                                   );

   hlp = trim(left(&i_sourceColumn.));
   select (hlp);
       when (-1)  hlp = "&g_nls_reportPrimaryKey_008.";
       when (-2)  hlp = "&g_nls_reportPrimaryKey_009.";
       when (-3)  hlp = "&g_nls_reportPrimaryKey_010.";
       when (-4)  hlp = "&g_nls_reportPrimaryKey_011.";
       when (-5)  hlp = "&g_nls_reportPrimaryKey_012.";
       when (-6)  hlp = "&g_nls_reportPrimaryKey_013.";
       when (-8)  hlp = "&g_nls_reportPrimaryKey_014.";
       when (-9)  hlp = "&g_nls_reportPrimaryKey_015.";
       when (-10) hlp = "&g_nls_reportPrimaryKey_016.";
       when (-12) hlp = "&g_nls_reportPrimaryKey_017.";
       when (-7)  hlp = "&g_nls_reportPrimaryKey_018.";
       when (-11) hlp = "&g_nls_reportPrimaryKey_019.";
       when (-13) hlp = "&g_nls_reportPrimaryKey_020.";
       when (0)   hlp = "&g_nls_reportPrimaryKey_007.";
       when (1)   hlp = "&g_nls_reportPrimaryKey_006.";
       otherwise hlp = catx(" ",hlp,"sonst &g_nls_reportPrimaryKey_006.");
   end;
   
   href     = catt ('_', put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
   %if (&o_html.) %then %do;
      href_act = catt (href,'_primarykey_rep.html');
   %end;
   
   &o_targetColumn. = catt ("^{style [flyover=""&g_nls_reportPrimaryKey_005"" url=""", href_act, """] &g_nls_reportPrimaryKey_004. } ^n ");
   &o_targetColumn. = catt (hlp, "^n", &o_targetColumn.);

%mend _render_assertPrimaryKeyAct;
/** \endcond */