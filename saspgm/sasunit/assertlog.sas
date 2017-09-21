/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether errors or warnings appear in the log.

               If number of errors and warnings does not appear in the log as expected, 
               the check of the assertion will fail.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_errors       number of errors, default 0
   \param   i_warnings     number of warnings, default 0
   \param   i_desc         description of the assertion to be checked \n
                           default: "Scan log for errors"
   
*/ /** \cond */ 

%MACRO assertLog (i_errors   = 0
                 ,i_warnings = 0
                 ,i_desc     = Scan log for errors
                 );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase g_inTestCall;
   %IF &g_inTestCall EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %IF &g_inTestCase NE 1 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;
   %IF (&g_runmode. EQ SASUNIT_INTERACTIVE) %THEN %DO;
      %RETURN;
   %END;

   %LOCAL l_casid l_error_count l_warning_count l_result l_errMsg;
   %LET l_errMsg=;

   PROC SQL NOPRINT;
      /* determine number of the current test case */
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid = &g_scnid;
   QUIT;

   %IF &l_casid = . OR &l_casid = %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must not be called before initTestcase;
      %RETURN;
   %END;

   /* Scan Log */
   %_checklog (
       i_logfile = &g_log/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).log
      ,i_error   = &g_error
      ,i_warning = &g_warning
      ,r_errors  = l_error_count
      ,r_warnings= l_warning_count
   )

   %LET l_result = %eval ((
         &l_error_count   NE &i_errors
      OR &l_warning_count NE &i_warnings
      )*2);

   %IF (&l_result. EQ 2) %THEN %DO;
      %LET l_errmsg=%bquote(expected &i_errors. error(s) and &i_warnings. warning(s), but actually there are &l_error_count. error(s) and &l_warning_count warning(s));
   %END;

   %_asserts(i_type     = assertLog
            ,i_expected = %str(&i_errors#&i_warnings)
            ,i_actual   = %str(&l_error_count#&l_warning_count)
            ,i_desc     = &i_desc
            ,i_result   = &l_result
            ,i_errMsg   = &l_errMsg
            )

%MEND assertLog;
/** \endcond */
