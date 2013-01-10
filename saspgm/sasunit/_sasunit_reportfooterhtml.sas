/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create footer area of an HTML page for reporting

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/* change log
   07.01.2013 BB  Open link zu sourceforge in new tab
                  Added class="link" to sourceforge link
   03.09.2012 KL  New logo; updated link to new resource
   30.10.2010 AM  Link to sourceforge project page
   18.08.2008 AM  Added national language support
*/

%MACRO _sasunit_reportFooterHTML (
);

   PUT '<hr size="1">';
   PUT '<address style="text-align: right;"><small>' "&g_nls_reportFooter_001 " @;
   _sasunit_reportFooterHTML = 
      trim(left(put(today(),&g_nls_reportFooter_002))) !! ', ' !! 
      trim(left(put(today(),&g_nls_reportFooter_003))) !! ', ' !! 
      put(time(),time8.0) !! " &g_nls_reportFooter_004 "
   ;
   PUT _sasunit_reportFooterHTML +(-1);
   PUT '<a href="http://sourceforge.net/projects/sasunit/" class="link" onclick="window.open(this.href); return false;">';
   PUT 'SASUnit <img src="SASUnit_Logo.png" alt="SASUnit" width=20px height=20px align="top" border="0"></a>';
   PUT "Version &g_version (&g_revision)</small></address>";
   PUT '</body>';
   PUT '</html>';
   
%MEND _sasunit_reportFooterHTML;

/** \endcond */
