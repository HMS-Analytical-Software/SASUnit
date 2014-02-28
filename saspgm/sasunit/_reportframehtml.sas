/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create frame page for HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   o_html         output file in HTML format

*/ /** \cond */ 

%MACRO _reportFrameHTML (i_repdata = 
                        ,o_html    =
                        );

DATA _null_;
   SET &i_repdata;
   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_reportHeaderHTML(%str(&g_project - &g_nls_reportFrame_001))

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
   
%MEND _reportFrameHTML;
/** \endcond */
