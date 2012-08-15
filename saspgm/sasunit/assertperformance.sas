/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether runtime of the testcase is below or equal a given limit.

               Please refer to the description of the test tools in _sasunit_doc.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL: $

   \param   i_expected       expected value  
   \param   i_desc           description of the assertion to be checked

*/ /** \cond */ 

/* change history
*/

%MACRO assertPerformance(i_expected=, i_desc=);

%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
%END;
%ELSE %IF &g_inTestcase NE 2 %THEN %DO;
   %PUT &g_error: assert has to be called after initTestcase;
   %RETURN;
%END;

/* determine current case id */
PROC SQL NOPRINT;
%LOCAL l_casid;
   SELECT max(cas_id) INTO :l_casid FROM target.cas WHERE cas_scnid=&g_scnid;
%LET l_casid = &l_casid;
QUIT;

/** calculate runtime **/
DATA target.cas;
	SET target.cas;
	cas_runt = cas_end - cas_start;
RUN;
PROC SQL NOPRINT;
	SELECT cas_runt
	INTO: l_cas_runtime
	FROM target.cas
	WHERE 
		cas_scnid = &g_scnid.
		AND cas_id = &l_casid.;
QUIT;


/* determine result */
%LET l_result = %SYSEVALF(NOT(&l_cas_runtime <= &i_expected)); 
					/* evaluation negated because %_sasunit_asserts awaits 0 for l_result if the assertion is true */

%_sasunit_asserts(
	i_type		= assertPerformance
	,i_expected	= &i_expected
	,i_actual	= &l_cas_runtime
	,i_desc		= &i_desc
	,i_result	= &l_result)
%MEND assertPerformance;
/** \endcond */




