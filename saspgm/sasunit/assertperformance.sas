/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether runtime of the testcase is below or equal a given limit.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_expected       expected value  
   \param   i_desc           description of the assertion to be checked \n
                             default: "Check for runtime"
*/ /** \cond */ 
%MACRO assertPerformance(i_expected=
                        ,i_desc    = Check for run time
                  );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase;
   %endTestCall(i_messageStyle=NOTE);
   %IF %_checkCallingSequence(i_callerType=assert) NE 0 %THEN %DO;      
      %RETURN;
   %END;

   %LOCAL
      l_casid 
      l_result 
      l_errMsg
      l_macname
   ;
   
   %LET l_macname  =&sysmacroname;
   
   /* determine current case id */
   PROC SQL NOPRINT;
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   QUIT;
   %LET l_casid = &l_casid;

   %IF %_handleError(&l_macname.
                    ,AssertPerformanceOutsideTestcase
                    ,(&l_casid = . OR &l_casid =)
                    ,&g_error.(SASUNIT): assert must not be called before initTestcase
                    ) 
                  %THEN %DO;   
      %RETURN;
   %END;

   PROC SQL NOPRINT;
      SELECT cas_end - cas_start
      INTO: l_cas_runtime
      FROM target.cas
      WHERE 
         cas_scnid = &g_scnid.
         AND cas_id = &l_casid.;
   QUIT;

   /* determine result */
   %LET l_result = %SYSEVALF((NOT(&l_cas_runtime <= &i_expected))*2); 
   /* evaluation negated because %_asserts awaits 0 for l_result if the assertion is true */

   %LET l_errMsg=%bquote(Expected run time was &i_expected. s, but test case took &l_cas_runtime. s!);

   %_asserts(i_type      = assertPerformance
            ,i_expected = &i_expected
            ,i_actual   = &l_cas_runtime
            ,i_desc     = &i_desc
            ,i_result   = &l_result
            ,i_errMsg   = &l_errMsg
            )
%MEND assertPerformance;
/** \endcond */