/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML header, tabs and title of an HTML page

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_title        Title line of HTML page
   \param   i_current      number of the active tab, default is 1

*/ /** \cond */ 

/* change log
   19.08.2008 AM  national language support
*/ 

%MACRO _sasunit_reportPageTopHTML (
    i_title   =
   ,i_current = 1
);
      %_sasunit_reportHeaderHTML(&i_title)

      %_sasunit_reportTabsHTML(
          &g_nls_reportPageTop_001
         ,"overview.html" "scn_overview.html" "cas_overview.html" "auton_overview.html"
         ,i_current=&i_current
      )

      PUT "<h1>&i_title</h1>";
   
%MEND _sasunit_reportPageTopHTML;
/** \endcond */
