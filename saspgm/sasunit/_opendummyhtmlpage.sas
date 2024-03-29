/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      This macro is part of the HTML speedup solution and "closes" an open HTML page. 

               With SAS 9.2 came the possibility to use HTML4 which supports the new inline formatting \n
               syntax ^{style [<style-statements>]Text}. It is now a tagset and no more a programmed destination\n
               like HTML3. Opening the destination takes up to several seconds.
            
               Key concept of speeding up the creation of HTML4 pages is to keep the destination open. You can easily\n
               switch documents by specifying ODS HTML file="...". Both html pages the old one that is not explicity closed.\n
               and the new one that will be opened, comply fully to HTML standard.
            
               _OpenDummyHtml.sas open a dummy HTML page that will be left open through the runtime of reportSASUnit.sas.
               _CloseHtmlPage.sas redirects the destination to the dummy html page.

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
            
   \param   i_style  Name of the SAS style and css file to be used. 
   
*/ /** \cond */ 

%macro _openDummyHTMLPage (i_style);
   ods html4 file="%sysfunc(pathname(work))/dummyhtml.html" style=styles.&i_style. stylesheet=(URL="css/&i_style..css")
             encoding="&g_rep_encoding.";
%mend _openDummyHTMLPage;
/** \endcond */