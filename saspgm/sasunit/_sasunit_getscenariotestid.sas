/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Determine the test case id.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_scnid  Current scnenario id for which you want to 
   \param   i_libref Name of the libref for the sasunit test database. This paramter is used only for selftesting the macro
   \retval  o_casid  actual value of the test case
   \retval  o_tstid  actual value of the assert

*/ /** \cond */ 

/* change history 
   26.02.2013 KL created
*/ 
%macro _sasunit_getScenarioTestId (i_scnid=
                                  ,o_casid=
                                  ,o_tstid=
                                  ,i_libref=target
                                  );

   %LOCAL l_casid_gti l_tstid_gti;

   %*** Set return variable to missing, the designed value for an error ***;

   %IF %nrbquote (&i_scnid.) eq  %THEN %DO;
      %PUT &g_error: Please specify a value for i_scnid.;
      %RETURN;
   %END;

   %IF %nrbquote (&o_casid.) eq  %THEN %DO;
      %PUT &g_error: Please specify a value for o_casid.;
      %RETURN;
   %END;

   %IF %nrbquote (&o_tstid.) eq  %THEN %DO;
      %PUT &g_error: Please specify a value for o_tstid.;
      %RETURN;
   %END;

   %IF not %symexist(&o_casid.) %THEN %DO;
      %PUT &g_error: Macrovariable for return of test case id was not declared by a %nrstr(%%)local-statement.;
      %RETURN;
   %END;
   %let &o_casid.=_ERROR_;

   %IF not %symexist(&o_tstid.) %THEN %DO;
      %PUT &g_error: Macrovariable for return of test assert id was not declared by a %nrstr(%%)local-statement.;
      %RETURN;
   %END;
   %let &o_tstid.=_ERROR_;

   %IF %sysfunc (libref (&i_libref.)) %THEN %DO;
      %PUT &g_error: Libref &i_libref. was not assigned. Start this macro only within SASUnit.;
      %RETURN;
   %END;

   %IF not %sysfunc (exist (&i_libref..cas)) %THEN %DO;
      %PUT &g_error: Table &i_libref..cas does not exist. Start this macro only within SASUnit.;
      %RETURN;
   %END;

   %IF not %sysfunc (exist (&i_libref..tst)) %THEN %DO;
      %PUT &g_error: Table &i_libref..tst does not exist. Start this macro only within SASUnit.;
      %RETURN;
   %END;

   PROC SQL NOPRINT;
      *** determine number of the current test case ****;
      SELECT max(cas_id) INTO :l_casid_gti FROM &i_libref..cas WHERE cas_scnid = &i_scnid.;
   QUIT;

   %IF &l_casid_gti = . OR &l_casid_gti = %THEN %DO;
      %PUT &g_error: Scenario was not found in the test database.;
      %PUT &g_error- Assert may not be called prior to initTestcase.;
      %RETURN;
   %END;

   PROC SQL NOPRINT;
      *** determine number of the current test case ****;
      SELECT max(tst_id) INTO :l_tstid_gti FROM &i_libref..tst WHERE tst_scnid = &i_scnid. AND tst_casid=&l_casid_gti.;
   QUIT;
   %IF &l_tstid_gti.=. %THEN %LET l_tstid_gti=1;
   %ELSE %LET l_tstid_gti=%eval (&l_tstid_gti.+1);

   %let &o_casid.=&l_casid_gti.;
   %let &o_tstid.=&l_tstid_gti.;
%mend _sasunit_getScenarioTestId;
/** \endcond */
