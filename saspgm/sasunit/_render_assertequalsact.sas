/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertEquals

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
			   
   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */  
%macro _render_assertEqualsAct (i_sourceColumn=
                               ,o_html=
                               ,o_targetColumn=
                               );
   %_render_dataColumn(i_sourceColumn=&i_sourceColumn.
                      ,o_targetColumn=&o_targetColumn.
                      );
%mend _render_assertEqualsAct;
/** \endcond */