/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertText

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
			   
   \param   i_sourceColumn       name of the column holding the value
   \param   o_html               Test report in HTML-format?
   \param   o_targetColumn       name of the target column holding the ODS formatted value

*/ /** \cond */  
%macro _render_assertTextExp (i_sourceColumn=
                             ,o_html=
                             ,o_targetColumn=
                             );
   href     = catt ('_',put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
   %if (&o_html.) %then %do;
      href_exp = catt (href,'_text_exp.txt');
   %end;
   &o_targetColumn. = catt ("^{style [flyover=""&g_nls_reportText_002"" url=""", href_exp, """] &g_nls_reportText_001. } ^n ^n ", &i_sourceColumn.);
%mend _render_assertTextExp;
/** \endcond */