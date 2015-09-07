/** \file
   \ingroup    SASUNIT_UTIL

   \brief      close the last test case at the end of a test scenario.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
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
