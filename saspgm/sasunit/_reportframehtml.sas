/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create frame page for HTML report

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   o_html         output file in HTML format
   \param   i_style        Name of the SAS style and css file to be used. 

*/ /** \cond */ 
%MACRO _reportFrameHTML (i_repdata = 
                        ,o_html    = 0
                        ,i_style   =
                        );

DATA _null_;
   SET &i_repdata;
   FILE "&o_html";

   IF _n_=1 THEN DO;

      %_reportHeaderHTML(%str(&g_project - &g_nls_reportFrame_001),&i_style.)

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