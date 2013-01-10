/**
   \file
   \ingroup    SASUNIT_SCN

   \brief      Ends a test case

               Please refer to the description of the test tools in _sasunit_doc.sas

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

PROC SQL NOPRINT;
%LOCAL l_result0 l_result1 l_result2;
/* determine test results */
   SELECT count(*) INTO :l_result0 FROM target.tst WHERE tst_scnid=&g_scnid AND tst_casid=&l_casid AND tst_res=0;
   SELECT count(*) INTO :l_result1 FROM target.tst WHERE tst_scnid=&g_scnid AND tst_casid=&l_casid AND tst_res=1;
   SELECT count(*) INTO :l_result2 FROM target.tst WHERE tst_scnid=&g_scnid AND tst_casid=&l_casid AND tst_res=2;
QUIT;

/* determine overall result of testcase */
%LOCAL l_result;
%IF &l_result1 GT 0 %THEN %LET l_result=1;        /* errors occured */
%ELSE %IF &l_result2 GT 0 %THEN %LET l_result=2;  /* manual checks occured */
%ELSE %LET l_result=0;                            /* not errors and no manual checks */

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
