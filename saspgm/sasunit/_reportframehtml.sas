/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create frame page for HTML report

   \version    \$Revision: GitBranch: feature/18-bug-sasunitcfg-not-used-in-sas-subprocess $
   \author     \$Author: landwich $
   \date       \$Date: 2024-02-22 11:27:38 (Do, 22. Februar 2024) $
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
            
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

      PUT '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">';
      PUT '  <head>';
      PUT '    <meta http-equiv="Content-Type" content="text/xhtml;charset=utf-8" />';
      PUT '    <meta http-equiv="Content-Style-Type" content="text/css" />';
      PUT '    <meta http-equiv="Content-Language" content="de" />';
      PUT '    <link href="css/SASUnit.css" rel="stylesheet" type="text/css">';
      PUT '    <link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />';
      PUT '    <title>SASUnit Examples - SASUnit Test Documentation</title>';
      PUT '    <style>';
      PUT '      body {';
      PUT '        margin: 0;';
      PUT '        padding: 0;';
      PUT '        display: flex;';
      PUT '      }';
      PUT '      iframe {';
      PUT '        border: none;';
      PUT '        height: 100vh;';
      PUT '      }';
      PUT '      #treefrm {';
      PUT '        width: 250px;';
      PUT '      }';
      PUT '      #basefrm {';
      PUT '        flex: 1;';
      PUT '      }';
      PUT '    </style>';
      PUT '    <script src="https://unpkg.com/@ungap/custom-elements-builtin"></script>';
      PUT '    <script type="module" src="https://unpkg.com/x-frame-bypass"></script>';
      PUT '  </head>';
      PUT '  <body>';
      PUT '    <iframe is="x-frame-bypass" src="tree.html" name="treefrm" id="treefrm"></iframe>';
      PUT '    <iframe is="x-frame-bypass" src="overview.html" name="basefrm" id="basefrm"></iframe>';
      PUT '    <noscript>';
      PUT '      <a href="home.html">Frames are disabled. Click here to go to the main page.</a>';
      PUT '    </noscript>';
      PUT '  </body>';
      PUT '</html>';
      STOP;
   END;

RUN; 
   
%MEND _reportFrameHTML;
/** \endcond */ 