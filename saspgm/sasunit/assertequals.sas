/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether there are differences between the value of 
               a macro variable and an expected character string.

               Please refer to the description of the test tools in _sasunit_doc.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_expected       expected value
   \param   i_actual         actual value
   \param   i_desc           description of the assertion to be checked
   \param   i_fuzz           optional: maximal deviation of expected and actual values, 
                             only for numerical values 

*/

/*DE
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Prüfen, ob der Wert einer Makrovariablen dem erwarteten Wert
               entspricht

               Siehe Beschreibung der Testtools in _sasunit_doc.sas

   \param   i_expected       erwarteter Wert
   \param   i_actual         tatsächlicher Wert
   \param   i_desc           Beschreibung der Prüfung
   \param   i_fuzz           optional: maximale Abweichung von erwartetem und tatsächlichem Wert, 
                             darf nur für numerische Werte angegeben werden

*/ /** \cond */ 

/* Änderungshistorie
   30.06.2008 AM  Behandlung unterschiedlicher Datentypen verbessert 
*/ 
%MACRO assertEquals (
    i_expected =      
   ,i_actual   =      
   ,i_desc     =      
   ,i_fuzz     =      
);

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
%END;
%ELSE %IF &g_inTestcase NE 2 %THEN %DO;
   %PUT &g_error: assert muss nach initTestcase aufgerufen werden;
   %RETURN;
%END;

%LOCAL l_expected;
%LET l_expected = &i_expected;
%LOCAL l_result;

/* Alphanumerischer Wert? */
%IF   %sysfunc(prxmatch("^[0-9]*.?[0-9]*$",&i_expected))=0 
   OR %sysfunc(prxmatch("^[0-9]*.?[0-9]*$",&i_actual))=0 %THEN %DO; 
   %LET l_result = %eval("&i_expected" NE "&i_actual");
%END; 
/* numerisch und fuzz gegeben ? */
%ELSE %IF %quote(&i_fuzz) NE %THEN %DO;
   %LET l_expected = %quote(&l_expected(+-&i_fuzz)); 
   %IF %sysevalf(%sysfunc(abs(%sysevalf(&i_expected - &i_actual))) <= &i_fuzz) 
      %THEN %LET l_result = 0;
   %ELSE %LET l_result = 1;
%END;
/* numerisch ohne fuzz */
%ELSE %DO;
   %IF %quote(&i_expected) = %quote(&i_actual)
      %THEN %LET l_result = 0;
   %ELSE %LET l_result = 1;
%END;

%_sasunit_asserts(
    i_type     = assertEquals
   ,i_expected = &l_expected
   ,i_actual   = &i_actual
   ,i_desc     = &i_desc
   ,i_result   = &l_result
)
%MEND assertEquals;
/** \endcond */
