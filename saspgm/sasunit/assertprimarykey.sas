/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Checks whether a set of columns can be used as primary key for the data set.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_Library            library of data set treated as master table
   \param   i_Dataset            member name of data set treated as master table
   \param   i_Variables          variables of the data set, that should be used as key. Multiple variables have to be separated by blank
   \param   i_desc               a description of the test \n
                                 default: "Check for primary key"
   \param   o_maxReportObs       optional: maximum number of records to be listed where lookup failed. By default set to MAX
   \param   o_listingVars        additional variables from master dataset to be listed. Additional variables have to be separated by blanks
   \param   o_treatMissings      optional: Handling of missing values in the master data set: Possible parameters are IGNORE, DISALLOW, VALUE(default)

*/ /** \cond */ 

%MACRO assertPrimaryKey (i_library        = _NONE_
                        ,i_dataset        = _NONE_
                        ,i_variables      = _NONE_
                        ,i_desc           = Check for primary key
                        ,o_maxReportObs   = MAX
                        ,o_listingVars    = _NONE_
                        ,o_treatMissings  = VALUE
                        );

   %GLOBAL g_inTestcase;
   %LOCAL l_result l_errMsg l_actual l_i l_variables l_name l_anz_lvars l_path l_lastVariable l_casid l_tstid l_missingWhere;

   %LET l_result = 2;
   %LET l_errMsg =;

   /*-- verify correct sequence of calls-----------------------------------------*/
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;
   
   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;
   %IF (&i_library. = _NONE_) %THEN %DO;
      %LET l_actual = -1;
      %LET l_errMsg =Specify a value for parameter i_library!;
      %GOTO Update;
   %END;
   %IF (&i_dataset. = _NONE_) %THEN %DO;
      %LET l_actual = -2;
      %LET l_errMsg =Specify a value for parameter i_dataset!;
      %GOTO Update;
   %END;
   %IF (&i_variables. = _NONE_) %THEN %DO;
      %LET l_actual = -3;
      %LET l_errMsg =Specify a value for parameter i_variables!;
      %GOTO Update;
   %END;
   
   %*** check for valid librefs und existence of data sets Master und Lookup***;
   %IF (%SYSFUNC (libref (&i_library.)) NE 0) %THEN %DO;
      %LET l_actual = -4;
      %LET l_errMsg =Libref "&i_library." of data set "&i_dataset." is not valid!;
      %GOTO Update;
   %END;
   %IF (%SYSFUNC(exist(&i_library..&i_dataset.)) EQ 0) %THEN %DO;
      %LET l_actual = -5;
      %LET l_errMsg =Data set "&i_library..&i_dataset." does not exist!;
      %GOTO Update;
   %END;

   %*** Is the number of variables specified for key greater Equal 1 ? ***;
   %LET l_anzvars = 0;
   %LET i_variables=&i_variables.;
   %LET l_anzvars = %eval(%SYSFUNC(count(&i_variables,%str( )))+1);
   %IF (%length(%trim(&i_variables.)) < 1 OR &l_anzvars. LT 1) %THEN %DO;
      %LET l_actual = -6;
      %LET l_errMsg =No variables specified to check primary key condition!;
      %GOTO Update;
   %END;

   %*** Check if parameter o_maxReportObs is valid ***;
   %IF NOT (%SYSFUNC(upcase(&o_maxReportObs.)) = MAX) %THEN %DO;
      %IF (%datatyp(&o_maxReportObs.) ~= NUMERIC) %THEN %DO;
         %LET l_actual = -8;
         %LET l_errMsg =%bquote(Parameter o_maxReportObs (&o_maxReportObs) must be MAX or numeric GE 0);
         %GOTO Update;
      %END;
      %ELSE %IF (&o_maxReportObs. < 0) %THEN %DO;
         %LET l_actual = -9;
         %LET l_errMsg =%bquote(Parameter o_maxReportObs(&o_maxReportObs) must be GE 0);
         %GOTO Update;
      %END;  
   %END;
      
   %*** Is the number of variables specified for key greater Equal 1 ? ***;
   %LET l_anz_lvars = 0;
   %LET o_listingVars=&o_listingVars.;
   %IF (&o_listingVars. ne _NONE_) %THEN %DO;
      %LET l_anz_lvars = %eval(%SYSFUNC(count(&o_listingVars,%str( )))+1);
      %IF (%length(%trim(&o_listingVars.)) < 1 OR &l_anz_lvars. LT 1) %THEN %DO;
         %LET l_actual = -10;
         %LET l_errMsg =No variables specified for printing the dataset!;
         %GOTO Update;
      %END;
   %END;

   %IF (%UPCASE(&o_treatMissings.) NE IGNORE 
        AND %UPCASE(&o_treatMissings.) NE DISALLOW 
        AND %UPCASE(&o_treatMissings.) NE VALUE) %THEN %DO;
      %LET l_actual = -12;
      %LET l_errMsg =Parameter o_treatMissings must be IGNORE%str(,) DISALLOW or VALUE!;
      %GOTO Update;
   %END;

   %*** Check existence of specified keys in their respective tables ***;
   %*** Get variables in source dataset ***;
   PROC CONTENTS data=&i_library..&i_dataset. out=work._Variables NOPRINT;
   RUN;
   QUIT;

   %LET l_variables =;
   %LET l_missingWhere =;
   %DO l_i=1 %TO &l_anzvars.;
      %LET l_name = %scan (&i_variables., &l_i.);
      %LET l_variables = &l_variables. "%upcase(&l_name.)";
      %IF (&l_i. > 1) %THEN %DO;
         %LET l_missingWhere = &l_missingWhere. AND;
      %END;            
      %LET l_missingWhere = &l_missingWhere. not missing (&l_name.);
   %END;
   %LET l_lastVariable=&l_name.;

   PROC SQL NOPRINT;
      select count (*) into :l_anzahlObs from work._Variables where upcase(name) in (&l_variables.);
   QUIT;
   
   %IF (&l_anzvars. ne &l_anzahlObs.) %THEN %DO;
      %LET l_actual = -7;
      %LET l_errMsg =Parameter i_variables contains invalid column names!;
      %GOTO Update;
   %END;

   %IF (&o_listingVars. ne _NONE_) %THEN %DO;
      %LET l_variables =;
      %DO l_i=1 %TO &l_anz_lvars.;
         %LET l_name = %scan (&o_listingVars., &l_i.);
         %LET l_variables = &l_variables. "%upcase(&l_name.)";
      %END;
      PROC SQL NOPRINT;
         select count (*) into :l_anzahlObs from work._Variables where upcase(name) in (&l_variables.);
      QUIT;
      %IF (&l_anz_lvars. ne &l_anzahlObs.) %THEN %DO;
         %LET l_actual = -11;
         %LET l_errMsg =Parameter o_listingVars contains invalid column names!;
         %GOTO Update;
      %END;
   %END;

   %IF (%upcase(&o_treatMissings.) eq DISALLOW) %THEN %DO;
      PROC SQL NOPRINT;
         select count (*) into :l_anzahlObs from &i_library..&i_dataset. where not (&l_missingWhere.);
      QUIT;
      %IF (&l_anzahlObs. > 0) %THEN %DO;
         %LET l_actual = -13;
         %LET l_errMsg =Parameter o_treatMissings is set to disallow but dataset contains missing values!;
         %GOTO Update;
      %END;
   %END;
   %*-- get current ids for test case and test ---------------------------------*;
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType =assertPrimaryKey
                         ,i_scnid      =&g_scnid.
                         ,i_casid      =&l_casid.
                         ,i_tstid      =&l_tstid.
                         ,r_path       =l_path
                          );

   libname _apk "&l_path.";

   %* sort dataset by i_variables *;
   proc sort data=&i_library..&i_dataset. out=work._sorted;
      by &i_variables;
      %IF (%upcase(&o_treatMissings.) = IGNORE) %THEN %DO;
      where &l_missingWhere.;
      %END;
   run;

   data work._notUnique;
      set work._sorted;
      by &i_variables;
      if not (first.&l_lastVariable. AND last.&l_lastVariable.);
   run;

   PROC SQL NOPRINT;
      select count (*) into :l_anzahlObs from work._notUnique;
   QUIT;

   data _apk._sorted;
      set work._sorted (OBS=&o_maxReportObs.);
      %IF (&o_listingVars. ne _NONE_) %THEN %DO;
         keep &o_listingVars.;
      %END;
   run;

   data _apk._notUnique;
      set work._notUnique (OBS=&o_maxReportObs.);
      %IF (&o_listingVars. ne _NONE_) %THEN %DO;
         keep &o_listingVars.;
      %END;
   run;

   %LET l_actual=%eval(&l_anzahlObs. = 0);
   %LET l_result=%eval((&l_anzahlObs. > 0)*2);

   %Update:
   %_asserts(i_type     = assertPrimaryKey
            ,i_expected = 1
            ,i_actual   = %str(&l_actual.)
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            ,i_errMsg   = &l_errMsg.
            )
%MEND assertPrimaryKey;
/** \endcond */
