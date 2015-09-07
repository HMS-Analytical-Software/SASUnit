/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML header, tabs and title of an HTML page

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_title        Title line of HTML page
   \param   i_current      number of the active tab, default is 1

*/ /** \cond */  

%MACRO _reportPageTopHTML (i_title   =
                          ,i_current = 1
                          );

      %_reportTabsHTML(&g_nls_reportPageTop_001
                      ,overview.html scn_overview.html cas_overview.html auton_overview.html
                      ,i_current=&i_current
                      )
%MEND _reportPageTopHTML;
/** \endcond */
