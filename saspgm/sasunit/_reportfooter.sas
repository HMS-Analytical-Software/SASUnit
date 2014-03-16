/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create footer area of an page for reporting

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   o_html         Test report in HTML-format?

*/ /** \cond */ 

%MACRO _reportFooter (o_html=0
                     );
   %local l_footnote;
   %if (&o_html.) %then %do;
      %_reportFooterHTML;
   %end;
   %else %do;
      %let l_footnote=&g_nls_reportFooter_001. %sysfunc (putn(%sysfunc(today()),&g_nls_reportFooter_002.));
      %let l_footnote=&l_footnote.%str(,) %sysfunc (putn(%sysfunc(today()),&g_nls_reportFooter_003.));
      %let l_footnote=&l_footnote.%str(,) %sysfunc (putn(%sysfunc(time()), time8.0)) &g_nls_reportFooter_004.;
      %let l_footnote=&l_footnote. ^{style [URL="http://sourceforge.net/projects/sasunit/" hreftarget="_blank" postimage="&g_sasunit./SASUnit_Logo.png"] SASUnit} Version &g_version (&g_revision);
      footnote '^{leaders "_"}_';
      footnote2 j=r %sysfunc(quote(&l_footnote.));
   %end;
%MEND _reportFooter;
/** \endcond */
