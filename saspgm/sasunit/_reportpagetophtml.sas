/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML header, tabs and title of an HTML page

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
			   
   \param   i_title        Title line of HTML page
   \param   i_current      number of the active tab, default is 1
   \param   i_offset       Offset for links to other html-pages

*/ /** \cond */  
%MACRO _reportPageTopHTML (i_title   =
                          ,i_current = 1
                          ,i_offset  =
                          );

      %_reportTabsHTML(&g_nls_reportPageTop_001
                      ,&i_offset.overview.html &i_offset.scn_overview.html &i_offset.cas_overview.html &i_offset.auton_overview.html
                      ,i_current=&i_current
                      )
%MEND _reportPageTopHTML;
/** \endcond */