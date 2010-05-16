/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether a certain message appears in the log.

               Please refer to the description of the test tools in _sasunit_doc.sas

               If the message does not appear in the log as expected, 
               the check of the assertion will fail.
               If i_not is set to 1, the check of the assertion will fail in case the 
               message is found in the log.

   \version    \$Revision: 57 $
   \author     \$Author: mangold $
   \date       \$Date: 2010-05-16 14:51:20 +0200 (So, 16 Mai 2010) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/sasunit/assertlogmsg.sas $

   \param   i_logmsg       message of interest (Perl Regular Expression),non-case-sensitive log scan
                           special characters have to be quoted with a prefixed single backslash,
                           see http://support.sas.com/onlinedoc/913/getDoc/de/lrdict.hlp/a002288677.htm#a002405779
   \param   i_desc         description of the assertion to be checked, default value: "Scan for log message"
   \param   i_not          negates the assertion, if set to 1
*/ 

/*DE
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Pr�fen, ob im Log eine bestimmte Meldung vorkommt.

                 Siehe Beschreibung der Testtools in _sasunit_doc.sas

               Der Test schl�gt fehl, wenn die Meldung nicht gefunden wird.
               Wenn i_not auf 1 gesetzt wird, schl�gt der Test fehl, wenn die Meldung
               gefunden wird.

   \param   i_logmsg       zu suchende Meldung (Perl Regular Expression), Gro�- und Kleinschrift 
                           wird beim Vergleich nicht beachtet. 
                           Sonderzeichen m�ssen durch einen vorangestellten Backslash 
                           maskiert werden, siehe http://support.sas.com/onlinedoc/913/getDoc/de/lrdict.hlp/a002288677.htm#a002405779
   \param   i_desc         Beschreibung der Pr�fung, Voreinstellung "Logmeldung pr�fen"
   \param   i_not          negiert die Pr�fung, wenn 1
*/ /** \cond */ 

/* change log
   26.09.2008 AM  bug fixing NLS: standard description text
   21.08.2008 AM  moved language dependent text to reportDetailHTML
   30.06.2008 AM  kleine Dokumentations�nderung
   07.02.2008 AM  doppelte Hochkammata wieder entfernt, Quoting wird jetzt in 
                  %_sasunit_asserts erledigt, Doku zu Sonderzeichen in Strings erg�nzt
   15.12.2007 AM  doppelte Hochkommata in l_expected erg�nzt.
*/ 

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
   %PUT &g_error: assert muss nach initTestcase aufgerufen werden;
   %RETURN;
%END;

PROC SQL NOPRINT;
%LOCAL l_casid;
/* Ermittle Nummer des aktuellen Testfalls */
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid = &g_scnid;
QUIT;

%IF &l_casid = . OR &l_casid = %THEN %DO;
   %PUT &g_error: Assert darf nicht vor initTestcase aufgerufen werden;
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
   %LET l_assert_failed = &l_msg_found;
%END;
%ELSE %DO;
   %LET l_expected = 1&i_logmsg; /* message present */
   %LET l_assert_failed = %eval(NOT &l_msg_found);
%END;

%_sasunit_asserts(
    i_type     = assertLogMsg
   ,i_expected = %str(&l_expected)
   ,i_actual   = %str(&l_actual)
   ,i_desc     = &i_desc
   ,i_result   = &l_assert_failed
)

%MEND assertLogMsg;
/** \endcond */
