/** \file
   \ingroup    SASUNIT_REPORT

   \brief      die Fuﬂzeile einer HTML-Seite erstellen

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007

*/ /** \cond */ 

%MACRO _sasunit_reportFooterHTML (
);

   PUT '<hr size="1">';
   PUT '<address style="text-align: right;"><small>Erzeugt am ' @;
   _sasunit_reportFooterHTML = 
      trim(left(put(today(),eurdfdwn.))) !! ', ' !! 
      trim(left(put(today(),eurdfwdx.))) !! ', ' !! 
      put(time(),time8.0) !! ' von '
   ;
   PUT _sasunit_reportFooterHTML +(-1);
   PUT '<a href="http://www.analytical-software.de">';
   PUT '<img src="sasunit.png" alt="SASUnit" align="middle" border="0"></a>';
   PUT "Version &g_version (&g_revision)</small></address>";
   PUT '</body>';
   PUT '</html>';
   
%MEND _sasunit_reportFooterHTML;
/** \endcond */
