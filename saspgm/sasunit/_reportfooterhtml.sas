/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create footer area of an HTML page for reporting

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
*/ /** \cond */ 
%MACRO _reportFooterHTML (
                         );
      %local l_footnote;

      %let l_footnote=^{RAW <small>&g_nls_reportFooter_001. %sysfunc (putn(%sysfunc(today()),&g_nls_reportFooter_002.));
      %let l_footnote=&l_footnote.%str(,) %sysfunc (putn(%sysfunc(today()),&g_nls_reportFooter_003.));
      %let l_footnote=&l_footnote.%str(,) %sysfunc (putn(%sysfunc(time()), time8.0)) &g_nls_reportFooter_004.;
      %let l_footnote=&l_footnote. <a href="http://sourceforge.net/projects/sasunit/" class="link" title="SASUnit" onclick="window.open(this.href); return false;">;
      %let l_footnote=&l_footnote. SASUnit <img src="SASUnit_Logo.png" title="SASUnit" alt="SASUnit" width=18px height=18px align="absmiddle" border="0"></a>;
      %let l_footnote=&l_footnote. Version &g_version (&g_revision) </small>};
      footnote  %sysfunc(quote(^{RAW <hr size="1">}));
      footnote2 j=r %sysfunc(quote(&l_footnote.));   
%MEND _reportFooterHTML;
/** \endcond */