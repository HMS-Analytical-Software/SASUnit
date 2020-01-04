/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Determine the test case id.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_scnid  Current scnenario id for which you want to 
   \retval  r_casid  actual value of the test case
   \retval  r_tstid  actual value of the assert

*/ /** \cond */ 

%macro _getScenarioTestId (i_scnid=
                          ,r_casid=
                          ,r_tstid=
                          );

   %LOCAL l_casid_gti l_tstid_gti;

   %*** Set return variable to missing, the designed value for an error ***;

   %IF %nrbquote (&i_scnid.) eq  %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Please specify a value for i_scnid.);
      %RETURN;
   %END;

   %IF %nrbquote (&r_casid.) eq  %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Please specify a value for r_casid.);
      %RETURN;
   %END;

   %IF %nrbquote (&r_tstid.) eq  %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Please specify a value for r_tstid.);
      %RETURN;
   %END;

   %IF not %symexist(&r_casid.) %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Macrovariable for return of test case id was not declared by a %nrstr(%%)local-statement.);
      %RETURN;
   %END;
   %let &r_casid.=_ERROR_;

   %IF not %symexist(&r_tstid.) %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Macrovariable for return of test assert id was not declared by a %nrstr(%%)local-statement.);
      %RETURN;
   %END;
   %let &r_tstid.=_ERROR_;

   %IF not %sysfunc (exist (target.cas)) %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Table target.cas does not exist. Start this macro only within SASUnit.);
      %RETURN;
   %END;

   %IF not %sysfunc (exist (target.tst)) %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Table target.tst does not exist. Start this macro only within SASUnit.);
      %RETURN;
   %END;

   PROC SQL NOPRINT;
      *** determine number of the current test case ****;
      SELECT max(cas_id) INTO :l_casid_gti FROM target.cas WHERE cas_scnid = &i_scnid.;
   QUIT;

   %IF &l_casid_gti = . OR &l_casid_gti = %THEN %DO;
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Scenario was not found in the test database.);
      %_issueErrorMessage (&g_currentLogger.,_getScenarioTestId: Assert may not be called prior to initTestcase.);
      %RETURN;
   %END;

   PROC SQL NOPRINT;
      *** determine number of the current test case ****;
      SELECT max(tst_id) INTO :l_tstid_gti FROM target.tst WHERE tst_scnid = &i_scnid. AND tst_casid=&l_casid_gti.;
   QUIT;
   %IF &l_tstid_gti.=. %THEN %LET l_tstid_gti=1;
   %ELSE %LET l_tstid_gti=%eval (&l_tstid_gti.+1);

   %let &r_casid.=&l_casid_gti.;
   %let &r_tstid.=&l_tstid_gti.;
%mend _getScenarioTestId;
/** \endcond */
