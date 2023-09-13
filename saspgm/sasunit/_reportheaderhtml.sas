/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML header for a page in the HTML report

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
            
   \param   i_title  page title (displayed in browser window)
   \param   i_style  Name of the SAS style and css file to be used. 
   
*/ /** \cond */ 
%MACRO _reportHeaderHTML (i_title
                         ,i_style
                         );

      PUT "<html xmlns=""http://www.w3.org/1999/xhtml"" xml:lang=""en"" lang=""en"">";
      PUT "  <head>";
      PUT "    <meta http-equiv=""Content-Type"" content=""text/xhtml;charset=utf-8"" />";
      PUT "    <meta http-equiv=""Content-Style-Type"" content=""text/css"" />";
      PUT "    <meta http-equiv=""Content-Language"" content=""de"" />";
      PUT "    <link href=""css/&i_style..css"" rel=""stylesheet"" type=""text/css"">";
      PUT "    <link rel=""shortcut icon"" href=""./favicon.ico"" type=""image/x-icon"" />";
      PUT "    <title>&i_title</title>";
      PUT "  </head>";

%MEND _reportHeaderHTML;
/** \endcond */