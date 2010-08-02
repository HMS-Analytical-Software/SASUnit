/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether errors or warnings appear in the log.

               Please refer to the description of the test tools in _sasunit_doc.sas

               If number of errors and warnings does not appear in the log as expected, 
               the check of the assertion will fail.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_errors       number of errors, default 0
   \param   i_warnings     number of warnings, default 0
   \param   i_desc         description of the assertion to be checked, default value: "Scan for log message"
*/ /** \cond */ 

/* change log
   10.10.2008 AM  minimal correction for documentation 
   19.08.2008 AM  removed language specific text in order to enable national language support
*/ 

%MACRO assertLog (
    i_errors   = 0
   ,i_warnings = 0
   ,i_desc     = 
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
/* determine number of the current test case */
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid = &g_scnid;
QUIT;

%IF &l_casid = . OR &l_casid = %THEN %DO;
   %PUT &g_error: Assert darf nicht vor initTestcase aufgerufen werden;
   %RETURN;
%END;

/* Scan Log */
%LOCAL l_error_count l_warning_count;
%_sasunit_checklog (
    i_logfile = &g_log/%sysfunc(putn(&g_scnid,z3.))_%sysfunc(putn(&l_casid,z3.)).log
   ,i_error   = &g_error
   ,i_warning = &g_warning
   ,r_errors  = l_error_count
   ,r_warnings= l_warning_count
)

%LOCAL l_result;
%LET l_result = %eval (
      &l_error_count   NE &i_errors
   OR &l_warning_count NE &i_warnings
   );

%_sasunit_asserts(
    i_type     = assertLog
   ,i_expected = %str(&i_errors#&i_warnings)
   ,i_actual   = %str(&l_error_count#&l_warning_count)
   ,i_desc     = &i_desc
   ,i_result   = &l_result
)

%MEND assertLog;
/** \endcond */
