/** 
   \file
   \ingroup    SASUNIT_TEST

   \brief      Testmacro for listcalling

               Please refer to <A href="https://github.com/HMS-Analytical-Software/SASUnit/wiki/User's%20Guide" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 

%macro Testmakro5;
   %Local l_obs l_title;
   
   %let l_obs = 4; /* n_obs set to 4 */
   %let l_title =A Test with SASHelp.Class;
   data test;
      set sashelp.class;
   run;
%mend Testmakro5;
/** \endcond */
