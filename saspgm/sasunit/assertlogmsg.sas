/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether a certain message appears in the log.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

               If the message does not appear in the log as expected, 
               the check of the assertion will fail.
               If i_not is set to 1, the check of the assertion will fail in case the 
               message is found in the log.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_logmsg       message of interest (Perl Regular Expression),non-case-sensitive log scan
                           special characters have to be quoted with a prefixed single backslash,
                           see http://support.sas.com/onlinedoc/913/getDoc/de/lrdict.hlp/a002288677.htm#a002405779
   \param   i_desc         description of the assertion to be checked, default value: "Scan for log message"
   \param   i_not          negates the assertion, if set to 1
*/ /** \cond */ 

%MACRO assertLogMsg (
    i_logmsg   =       
   ,i_desc     =   
   ,i_not      = 0
);

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
%END;
%ELSE %IF &g_inTestcase NE 2 %THEN %DO;
   %PUT &g_error: assert must be called after initTestcase;
   %RETURN;
%END;

PROC SQL NOPRINT;
%LOCAL l_casid;
/* determine number of the current test case */
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid = &g_scnid;
QUIT;

%IF &l_casid = . OR &l_casid = %THEN %DO;
   %PUT &g_error: assert must not be called before initTestcase;
   %RETURN;
%END;

/* scanne den Log */
%LOCAL l_msg_found; %LET l_msg_found=0;
DATA _null_;
   RETAIN pattern_id;
   IF _n_=1 THEN DO;
      pattern_id = prxparse("/%upcase(&i_logmsg)/");
   END;
   INFILE "&g_log/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).log" END=eof TRUNCOVER;
   INPUT logrec $char256.;
   logrec = upcase(logrec);
   IF prxmatch (pattern_id, logrec) THEN DO;
      call symput ('l_msg_found', '1');
   END;
RUN;

%LOCAL l_actual;
%IF &l_msg_found %THEN %DO;
   %LET l_actual = 1; /* message found */
%END;
%ELSE %DO;
   %LET l_actual = 2; /* message not found */
%END;

%LOCAL l_expected l_assert_failed;
%IF &i_not %THEN %DO;
   %LET l_expected = 2&i_logmsg; /* message not present */
   %LET l_assert_failed = %eval (&l_msg_found.*2);
%END;
%ELSE %DO;
   %LET l_expected = 1&i_logmsg; /* message present */
   %LET l_assert_failed = %eval((NOT &l_msg_found)*2);
%END;

%_asserts(
    i_type     = assertLogMsg
   ,i_expected = %str(&l_expected)
   ,i_actual   = %str(&l_actual)
   ,i_desc     = &i_desc
   ,i_result   = &l_assert_failed
)

%MEND assertLogMsg;
/** \endcond */
