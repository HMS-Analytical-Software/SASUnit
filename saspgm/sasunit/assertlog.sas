/** \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Prüfen, ob im Log Errors oder Warnings vorkommen.

                 Siehe Beschreibung der Testtools in _sasunit_doc.sas

               Der Test schlägt fehl, wenn nicht die angegebene Anzahl an Errors und Warnings
               vorkommt.

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_errors       Anzahl Errors, Voreinstellung 0
   \param   i_warnings     Anzahl Warnings, Voreinstellung 0
   \param   i_desc         Beschreibung der Prüfung, Voreinstellung "Log prüfen"
*/ /** \cond */ 

%MACRO assertLog (
    i_errors   = 0
   ,i_warnings = 0
   ,i_desc     = Log prüfen
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

/* Scanne Log */
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
   ,i_expected = %str(Fehler: &i_errors, Warnungen: &i_warnings)
   ,i_actual   = %str(Fehler: &l_error_count, Warnungen: &l_warning_count)
   ,i_desc     = &i_desc
   ,i_result   = &l_result
)

%MEND assertLog;
/** \endcond */
