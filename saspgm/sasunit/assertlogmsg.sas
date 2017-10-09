/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether a certain message appears in the log.

               If the message does not appear in the log as expected, 
               the check of the assertion will fail.
               If i_not is set to 1, the check of the assertion will fail in case the 
               message is found in the log.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_logmsg       message of interest (Perl Regular Expression), non-case-sensitive log scan,
                           special characters have to be quoted with a prefixed single backslash,
                           see http://support.sas.com/onlinedoc/913/getDoc/de/lrdict.hlp/a002288677.htm#a002405779
   \param   i_desc         description of the assertion to be checked \n
                           default: "Scan for log messages"
   \param   i_not          negates the assertion, if set to 1
   
*/ /** \cond */ 

%MACRO assertLogMsg (i_logmsg   =       
                    ,i_desc     = Scan for log messages  
                    ,i_not      = 0
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

   %LOCAL l_casid l_msg_found l_actual l_expected l_assert_failed l_errmsg;
   PROC SQL NOPRINT;
   /* determine number of the current test case */
      SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid = &g_scnid;
   QUIT;

   %IF &l_casid = . OR &l_casid = %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must not be called before initTestcase;
      %RETURN;
   %END;

   %LET l_errmsg=_NONE_;

   %IF (&g_runmode. EQ SASUNIT_INTERACTIVE) %THEN %DO;
      %let l_assert_failed=1;
      %let l_errmsg=Current SASUnit version does not support interactive execution of assertLogMsg.;
      %let l_actual=-1;
      %let l_expected=-1;
      %goto exit;
   %END;

   /* scanne den Log */
   %LET l_msg_found=0;
   DATA _null_;
      RETAIN pattern_id;
      IF _n_=1 THEN DO;
         pattern_id = prxparse("/%upcase(&i_logmsg)/");
      END;
      INFILE "&g_log/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).log" END=eof TRUNCOVER &g_infile_options.;
      INPUT logrec $char256.;
      logrec = upcase(logrec);
      IF prxmatch (pattern_id, logrec) THEN DO;
         call symput ('l_msg_found', '1');
      END;
   RUN;

   %IF &l_msg_found. %THEN %DO;
      %LET l_actual = 1; /* message found */
   %END;
   %ELSE %DO;
      %LET l_actual = 2; /* message not found */
   %END;

   %IF &i_not. %THEN %DO;
      %LET l_expected = 2&i_logmsg; /* message not present */
      %LET l_assert_failed = %eval (&l_msg_found.*2);
   %END;
   %ELSE %DO;
      %LET l_expected = 1&i_logmsg; /* message present */
      %LET l_assert_failed = %eval((NOT &l_msg_found)*2);
   %END;
%exit:
   %_asserts(i_type     =assertLogMsg
            ,i_expected =%str(&l_expected.)
            ,i_actual   =%str(&l_actual.)
            ,i_desc     =&i_desc.
            ,i_result   =&l_assert_failed.
            ,i_errmsg   =&l_errmsg.
            )

%MEND assertLogMsg;
/** \endcond */
