/** \file
   \ingroup    SASUNIT_REPORT

   \brief      die Frameseite eines HTML-Berichts erstellen

   \version 1.0
   \author  Andreas Mangold
   \date    18.10.2007
   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   o_html         Ausgabedatei im HTML-Format

*/ /** \cond */ 

%MACRO _sasunit_reportFrameHTML (
   i_repdata = 
  ,o_html    =
);

/* change log
   18.08.2008 AM  added national language support
*/

DATA _null_;
   SET &i_repdata;
   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_sasunit_reportHeaderHTML(%str(&g_project - &g_nls_reportFrame_001))

      PUT '<frameset cols="250,*">';
      PUT '  <frame src="tree.html" name="treefrm">';
      PUT '  <frame src="overview.html" name="basefrm">';
      PUT '  <noframes>';
      PUT '    <a href="home.html">' "&g_nls_reportFrame_002" '</a>';
      PUT '  </noframes>';
      PUT '</frameset>';
   
      PUT '</body>';
      PUT '</html>';

      STOP;
   END;

RUN; 
   
%MEND _sasunit_reportFrameHTML;
/** \endcond */
