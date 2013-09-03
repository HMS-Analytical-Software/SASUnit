/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      This assert checks whether a certain number of records exist in a data set specified by parameters i_libref and i_memname.
               Furthermor a where condition can be specified (if not specified set to 1) as well as a the number of expected records 
               in the dataset that meet the given where condition.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_libref         Library containing the data set
   \param     i_memname        Data set to be tested    
   \param     i_where          Where condition that should be met by the variable 
   \param     i_desc           Optional Parameter: Description of the assertion to be checked
   \param     o_maxReportObs   Optional Parameter: Maximum number of invalid observations to printed in report (default: MAX)
   \param     o_listVars       Optional Parameter: Names the variables to be listed in the report
   
*/ /** \cond */ 

%MACRO assertRowExpression(i_libref         = 
                          ,i_memname        = 
                          ,i_where          =
                          ,i_desc           = Check of all observations meet the where expression
                          ,o_maxReportObs   = MAX
                          ,o_listVars       = _NONE_
                          );

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error: assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_dsname l_result l_actual l_errmsg l_nobs l_casid l_tstid l_path;
   %LET l_dsname =%sysfunc(catx(., &i_libref., &i_memname.));
   %LET l_result = 2;
   %LET l_actual = 0;
  
   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;
   %*** check for valid libref and existence of data set***;
   %IF (%sysfunc (libref (&i_libref.)) NE 0) %THEN %DO;
      %LET l_actual =-1;
      %LET l_errmsg =Libref &i_libref. is not valid!;
      %GOTO Update;
   %END;
   %IF (%sysfunc(exist(&l_dsname.)) EQ 0) %THEN %DO;
      %LET l_actual =-1;
      %LET l_errmsg =Dataset &l_dsname. does not exist!;
      %GOTO Update;
   %END;
   %IF (%upcase (&o_maxReportObs.) ne MAX) %THEN %DO;
      data _null_;
         num=input (symget ("o_maxReportObs"),??8.);
         if (num <= 0) then do;
            PUT "&G_WARNING.: o_maxReportObs contains invalid valid and is set to MAX";
            call symputx ("o_maxReportObs", "MAX", 'L');
         end;
      run;
   %END;

   %*************************************************************;
   %*** testing the assert condition                         ***;
   %*************************************************************;   
   %*** Retrieve number of observations in dataset ***;
   %LET l_nobs=%_nobs(&l_dsname.);
   %IF (&l_nobs.=0) %THEN %DO;
      %LET l_result = 0;
      %GOTO Update;
   %END;

   /*-- get current ids for test case and test --------- ------------------------*/
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType   =assertRowExpression
                         ,i_scnid        =&g_scnid.
                         ,i_casid        =&l_casid.
                         ,i_tstid        =&l_tstid.
                         ,r_path         =l_path
                         );

   libname _areLib "&l_path.";

   %*** Count matching observations ***;
   PROC SQL NOPRINT;
      select count (*) into :l_actual 
      from &l_dsname.
      where &i_where.;
   QUIT;
   %IF (&syserr. ne 0) %THEN %DO;
      %LET l_actual=-1;
      %LET l_errmsg=Where expression is not valid!;
      data _areLib.ViolatingObservations;
         set &l_dsname;
         stop;
      run; 
      libname _areLib clear;
      %GOTO Update;
   %END;

   options obs=&o_maxReportObs.;
   data _areLib.ViolatingObservations;
      set &l_dsname (where=(not (&i_where.)));
      %IF (&o_listVars. ne _NONE_) %THEN %DO;
         keep &o_listVars.;
      %END;
   run;
   %LET l_rc=&syserr.;
   options obs=MAX;
   libname _areLib clear;
   %IF (&l_rc. ne 0) %THEN %DO;
      %LET l_actual=-1;
      %LET l_errmsg=Error writing table with condition violating observations!;
      %GOTO Update;
   %END;
   
   %*** Determine results***;
   %if (&l_actual. eq &l_nobs.) %then %do;
      %let l_result = 0;
   %end;
   %else %do;
      %LET l_errmsg =Some observations are violating the condition!;
   %end;

%Update:
   *** update result in test database ***;
   %_asserts(i_type     = assertRowExpression
            ,i_expected = &l_nobs.
            ,i_actual   = &l_actual.
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            ,i_errmsg   = &l_errmsg.
            )
%MEND assertRowExpression;
/** \endcond */
