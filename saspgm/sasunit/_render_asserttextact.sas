/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertText

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_sourceColumn       name of the column holding the value
   \param   o_html               Test report in HTML-format?
   \param   o_targetColumn       name of the target column holding the ODS formatted value

*/ /** \cond */ 
%MACRO _render_assertTextAct (i_sourceColumn=
                             ,o_html=
                             ,o_targetColumn=
                             );
   hlp = TRIM(LEFT(&i_sourceColumn.));
   SELECT (hlp);
       WHEN ("-2")  hlp = "&g_nls_reportText_010.";
       WHEN ("-3")  hlp = "&g_nls_reportText_007.";
       WHEN ("-4")  hlp = "&g_nls_reportText_011.";
       WHEN ("-5")  hlp = "&g_nls_reportText_008.";
       WHEN ("-6")  hlp = "&g_nls_reportText_012.";
       WHEN ("-7")  hlp = "&g_nls_reportText_009.";
       WHEN ("-8")  hlp = "&g_nls_reportText_013.";

       otherwise hlp = hlp;
   end;

   href     = CATT ('_',PUT (scn_id, z3.),'_',PUT (cas_id, z3.),'_',PUT (tst_id, z3.));
   %IF (&o_html.) %THEN %DO;
      href_act = CATT (href,'_text_act.txt');
      href_rep = CATT (href,'_text_diff.txt');
   %END;
   &o_targetColumn. = CATT ("^{style [flyover=""&g_nls_reportText_005"" url=""", href_act, """] &g_nls_reportText_004. } ^n ");
   &o_targetColumn. = CATT (&o_targetColumn., " ^{style [flyover=""&g_nls_reportText_006"" url=""", href_rep, """] &&g_nls_reportText_003. } ^n ", hlp);
%MEND _render_assertTextAct;
/** \endcond */