/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether at least one record exists which satisfies a certain WHERE condition.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   
   \version    \$Revision: 194 $
   \author     \$Author: menrath $
   \date       \$Date: 2013-06-10 15:42:43 +0200 (Mo, 10 Jun 2013) $
   \sa         \$HeadURL: https://menrath@svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/assertcolumns.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_dataset      data set to check
   \param   i_whereExpr    data set where-expression to be checked
   \param   i_desc         description of the assertion to be checked
*/ /** \cond */ 

%MACRO assertRecordExists (i_dataset      =      
                          ,i_whereExpr    =      
                          ,i_desc         =      
                          );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall()
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error: assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_countMatches l_rc l_errMsg;
   %LET l_countMatches = -1;
   %LET l_errMsg=;

   /*-- check parameter i_dataset  ------------------------------------------------*/
   %IF NOT %SYSFUNC(EXIST(&i_dataset.)) %THEN %DO;
     %LET l_rc = 2;
     %LET l_errMsg=input dataset &i_dataset. does not exist!;
     %GOTO Update;
   %END;

   /*-- check parameter i_dataset  ------------------------------------------------*/
   %IF %LENGTH(&i_whereExpr) = 0 %THEN %DO;
     %LET l_rc = 2;
     %LET l_errMsg=where expression is empty!;
     %GOTO Update;
   %END;

   PROC SQL NOPRINT;
     SELECT COUNT(*) FORMAT=best12. INTO :l_countMatches
       FROM &i_dataset(WHERE=(%nrbquote(&i_whereExpr)))
     ;
   QUIT;

   %let l_countMatches = &l_countMatches; /* trim white space */

   %if %eval(&l_countMatches >= 1) 
     %then %let l_rc = 0;
   %else
     %let l_rc = 2;
   %LET l_errMsg=No matching records were found!;

%UPDATE:
   /*-- update comparison result in test database -------------------------------*/
   %_asserts(
       i_type     = assertRecordExists
      ,i_expected = > 0
      ,i_actual   = &l_countMatches.
      ,i_desc     = &i_desc.
      ,i_result   = &l_rc.
      ,i_errMsg   = &l_errMsg.
   );

%MEND assertRecordExists;
/** \endcond */
