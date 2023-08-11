/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create footer area of an page for reporting

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
			   
   \param   o_html         Test report in HTML-format?
   \param   i_offset       Offset for links to SASUnit logo

*/ /** \cond */ 
%MACRO _reportFooter (o_html=0
                     ,i_offset  =
                     );
   %local l_footnote;
   %if (&o_html.) %then %do;
      %_reportFooterHTML(i_offset  = &i_offset.);
   %end;
   %else %do;
      %let l_footnote=&g_nls_reportFooter_001. %sysfunc (putn(%sysfunc(today()),&g_nls_reportFooter_002.));
      %let l_footnote=&l_footnote.%str(,) %sysfunc (putn(%sysfunc(today()),&g_nls_reportFooter_003.));
      %let l_footnote=&l_footnote.%str(,) %sysfunc (putn(%sysfunc(time()), time8.0)) &g_nls_reportFooter_004.;
      %let l_footnote=&l_footnote. ^{style [URL="https://github.com/HMS-Analytical-Software/SASUnit/wiki" hreftarget="_blank" postimage="&i_offset.SASUnit_Logo.png"] SASUnit} Version &g_version (&g_revision);
      footnote '^{leaders "_"}_';
      footnote2 j=r %sysfunc(quote(&l_footnote.));
   %end;
%MEND _reportFooter;
/** \endcond */