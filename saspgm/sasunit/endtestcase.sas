/**
   \file
   \ingroup    SASUNIT_SCN

   \brief      Ends a test case

               Result and finish time are added to the test repository.


   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_assertLog if 1 .. an assertLog (0,0) will be invoked for the test case to be ended, provided that
                           assertLog was not invoked yet
               
*/ /** \cond */ 

%MACRO endTestcase(i_assertLog=1);

   %GLOBAL g_inTestCase g_inTestCall;
   %LOCAL l_casid l_assertLog l_result;
   
   %IF &g_inTestCall. EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestCase. NE 1 %THEN %DO;
      %PUT &g_error.(SASUNIT): endTestcase must be called after initTestcase;
      %RETURN;
   %END;

   PROC SQL NOPRINT;
   /* determine id of current test case */
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   %LET l_casid = &l_casid;
   %IF &l_casid=. %THEN %DO;
      %PUT &g_error.(SASUNIT): endTestcase muss nach InitTestcase aufgerufen werden;
      %RETURN;
   %END;
   %IF &i_assertLog %THEN %DO;
   /* call assertLog if not already coded by programmer */
      SELECT count(*) INTO :l_assertLog 
      FROM target.tst
      WHERE tst_scnid = &g_scnid AND tst_casid = &l_casid AND tst_type='assertLog';
      %IF &l_assertLog=0 %THEN %DO;
         %assertLog()
      %END;
   %END;
   QUIT;

   %LET g_inTestcase=0;

   /* determine test results */
   PROC SQL NOPRINT;
      SELECT max (tst_res) INTO :l_result FROM target.tst WHERE tst_scnid=&g_scnid AND tst_casid=&l_casid;
   QUIT;

   PROC SQL NOPRINT;
      UPDATE target.cas
      SET 
         cas_res = &l_result
      WHERE 
         cas_scnid = &g_scnid AND
         cas_id    = &l_casid;
   QUIT;

%MEND endTestcase;
/** \endcond */
