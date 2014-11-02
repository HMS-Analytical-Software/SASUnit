/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML header for a page in the HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

  \deprecated No longer used because we create HTML now via SAS ODS

   \param   i_title        page title (displayed in browser window)
*/ /** \cond */ 

%MACRO _reportHeaderHTML (i_title   
                         );

      PUT "<html xmlns=""http://www.w3.org/1999/xhtml"" xml:lang=""en"" lang=""en"">";
      PUT "  <head>";
      PUT "    <meta http-equiv=""Content-Type"" content=""text/xhtml;charset=windows-1252"" />";
      PUT "    <meta http-equiv=""Content-Style-Type"" content=""text/css"" />";
      PUT "    <meta http-equiv=""Content-Language"" content=""de"" />";
      PUT "    <link href=""sasunit.css"" rel=""stylesheet"" type=""text/css"">";
      PUT "    <link rel=""shortcut icon"" href=""./favicon.ico"" type=""image/x-icon"" />";
      PUT "    <title>&i_title</title>";
      PUT "  </head>";

%MEND _reportHeaderHTML;
/** \endcond */
