/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether at least one record exists which satisfies a certain WHERE condition.

   
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_dataset      data set to check
   \param   i_whereExpr    data set where-expression to be checked
   \param   i_desc         description of the assertion to be checked \n
                           default: "Check for existence of specific records"
   
*/ /** \cond */ 

%MACRO assertRecordExists (i_dataset      =      
                          ,i_whereExpr    =      
                          ,i_desc         = Check for existence of specific records
                          );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
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

   %LET l_countMatches = &l_countMatches; /* trim white space */

   %IF %eval(&l_countMatches >= 1) 
      %THEN %LET l_rc = 0;
   %ELSE
      %LET l_rc = 2;
   %LET l_errMsg=No matching records were found!;

%UPDATE:
   /*-- update comparison result in test database -------------------------------*/
   %_asserts(i_type   = assertRecordExists
            ,i_expected = > 0
            ,i_actual   = &l_countMatches.
            ,i_desc     = &i_desc.
            ,i_result   = &l_rc.
            ,i_errMsg   = &l_errMsg.
            );

%MEND assertRecordExists;
/** \endcond */
