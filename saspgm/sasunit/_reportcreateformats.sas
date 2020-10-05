/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      Creates formats used while rendering ODS output.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
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