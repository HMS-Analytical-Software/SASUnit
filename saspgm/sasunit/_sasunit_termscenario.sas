/** \file
   \ingroup    SASUNIT_UTIL

   \brief      dies wird aufgerufen nach dem Ende eines Testszenarios, um gegebenenfalls
               einen noch laufenden Testfall abzuschlieﬂen.

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
