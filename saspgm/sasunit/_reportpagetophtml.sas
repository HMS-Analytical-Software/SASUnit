/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML header, tabs and title of an HTML page

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

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
