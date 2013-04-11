/**
   \file
   \ingroup    SASUNIT_SCN

   \brief      Ends a test case

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

               Result and finish time are added to the test repository.

   \param      i_assertLog if 1 .. an assertLog (0,0) will be invoked for the test case to be ended, provided that
                           assertLog was not invoked yet

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 
/* change history
   29.01.2013 KL  changed link from _sasunit_doc.sas to Sourceforge SASUnit User's Guide
*/

%MACRO endTestcase(i_assertLog=1);

PROC SQL NOPRINT;
%LOCAL l_casid l_assertLog;
/* determine id of current test case */
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
%LET l_casid = &l_casid;
%IF &l_casid=. %THEN %DO;
   %PUT &g_error: endTestcase muss nach InitTestcase aufgerufen werden;
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

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
%END;
%ELSE %IF &g_inTestcase NE 2 %THEN %DO;
   %PUT &g_error: endTestcase muss nach initTestcase aufgerufen werden;
   %RETURN;
%END;
%LET g_inTestcase=0;

%LOCAL l_result;
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
