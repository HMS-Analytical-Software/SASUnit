/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create footer area of an HTML page for reporting

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

/* change log
   03.09.2012 KL  New logo; updated link to new resource
   30.10.2010 AM  link to sourceforge project page
   18.08.2008 AM  added national language support
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
   PUT '<a href="http://sourceforge.net/projects/sasunit/" target="_parent">';
   PUT 'SASUnit <img src="SASUnit_Logo.png" alt="SASUnit" width=20px height=20px align="top" border="0"></a>';
   PUT "Version &g_version (&g_revision)</small></address>";
   PUT '</body>';
   PUT '</html>';
   
%MEND _sasunit_reportFooterHTML;

/** \endcond */
