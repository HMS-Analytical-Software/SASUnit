/** \file
   \ingroup    SASUNIT_REPORT

   \brief      den HTML-Vorspann einer Seite des HTML-Testberichts erstellen

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_title        Seitentitel
*/ /** \cond */ 

%MACRO _sasunit_reportHeaderHTML (
   i_title   
);

      PUT "<html xmlns=""http://www.w3.org/1999/xhtml"" xml:lang=""en"" lang=""en"">";
      PUT "  <head>";
      PUT "    <meta http-equiv=""Content-Type"" content=""text/xhtml;charset=windows-1252"" />";
      PUT "    <meta http-equiv=""Content-Style-Type"" content=""text/css"" />";
      PUT "    <meta http-equiv=""Content-Language"" content=""de"" />";
      PUT "    <link href=""sasunit.css"" rel=""stylesheet"" type=""text/css"">";
      PUT "    <link href=""tabs.css""    rel=""stylesheet"" type=""text/css"">";
      PUT "    <title>&i_title</title>";
      PUT "  </head>";

%MEND _sasunit_reportHeaderHTML;
/** \endcond */
