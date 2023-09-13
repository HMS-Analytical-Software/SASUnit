/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      Creates formats used while rendering ODS output.

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
            
*/ /** \cond */ 
%macro _reportCreateFormats;

   *** Create formats used in reports ***;
   proc format lib=work;
      value PictName     0 = "&g_sasunitroot./resources/html/ok.png"
                         1 = "&g_sasunitroot./resources/html/manual.png"
                         2 = "&g_sasunitroot./resources/html/error.png"
                         OTHER="?????";
      value PictNameHTML 0 = "images/ok.png"
                         1 = "images/manual.png"
                         2 = "images/error.png"
                         OTHER="?????";
      value PictDesc     0 = "OK"
                         1 = "&g_nls_reportDetail_026"
                         2 = "&g_nls_reportDetail_025"
                         OTHER = "&g_nls_reportDetail_027";
   run;

%mend;
/** \endcond */