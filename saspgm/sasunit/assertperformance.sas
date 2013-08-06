/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether runtime of the testcase is below or equal a given limit.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL: $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_expected       expected value  
   \param   i_desc           description of the assertion to be checked

*/ /** \cond */ 

%MACRO assertPerformance(i_expected=, i_desc=);

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error: assert has to be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_casid l_result l_errMsg;

   /* determine current case id */
   PROC SQL NOPRINT;
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
   QUIT;
   %LET l_casid = &l_casid;

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

   %_asserts(
      i_type      = assertPerformance
      ,i_expected = &i_expected
      ,i_actual   = &l_cas_runtime
      ,i_desc     = &i_desc
      ,i_result   = &l_result
      ,i_errMsg   = &l_errMsg
   )
%MEND assertPerformance;
/** \endcond */




