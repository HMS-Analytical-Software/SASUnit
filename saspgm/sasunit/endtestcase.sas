/**
   \file
   \ingroup    SASUNIT_SCN

   \brief      Ends a test case

               Result of the tests is added to the test repository.

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
            
   \param      i_assertLog if 1 .. an assertLog (0,0) will be invoked for the test case to be ended, provided that
                           assertLog was not invoked yet
               
*/ /** \cond */ 
%MACRO endTestcase(i_assertLog=1,i_messageStyle=ERROR);

   %GLOBAL g_inTestCase g_inTestCall;
   %LOCAL l_casid l_assertLog l_result;   

   %endTestcall(i_messageStyle=TRACE);
   %IF &g_inTestCase. NE 1 %THEN %DO;
      %IF (&i_messageStyle=ERROR) %THEN %DO;
         %_issueErrorMessage (&g_currentLogger.,endTestcase: endTestcase must be called after initTestcase!)
      %END;
      %ELSE %DO;
         %_issueTraceMessage (&g_currentLogger.,endTestcase: endTestcall already run by user. This call was issued from endScenario.)
      %END;
      %RETURN;
   %END;

   PROC SQL NOPRINT;
   /* determine id of current test case */
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   %LET l_casid = &l_casid;
   %IF &l_casid=. %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,endTestcase: endTestcase must be called after initTestcase!)
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

   %LET g_inTestCase=0;

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