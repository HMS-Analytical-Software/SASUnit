/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML header for a page in the HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_title        page title (displayed in browser window)
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