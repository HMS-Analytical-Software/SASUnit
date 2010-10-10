/** \file
   \ingroup    SASUNIT_UTIL

   \brief      close the last test case at the end of a test scenario.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \return
*/ /** \cond */ 


%MACRO _sasunit_termScenario(
);

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
   %endTestcase;
%END;
%IF &g_inTestcase EQ 2 %THEN %DO;
   %endTestcase;
%END;
%LET g_inTestcase=1;

%MEND _sasunit_termScenario;
/** \endcond */
