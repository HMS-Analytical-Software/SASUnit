/** \file
   \ingroup    SASUNIT_UTIL

   \brief      close the last test case at the end of a test scenario.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$   
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \return
*/ /** \cond */ 


%MACRO _termScenario();

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
      %endTestcase;
   %END;
   %IF &g_inTestcase EQ 2 %THEN %DO;
      %endTestcase;
   %END;
   %LET g_inTestcase=1;

%MEND _termScenario;
/** \endcond */
