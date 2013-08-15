/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      This assert checks whether a certain number of records exist in a data set specified by parameters i_libref and i_memname.
               Furthermor a where condition can be specified (if not specified set to 1) as well as a the number of expected records 
               in the dataset that meet the given where condition.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/assertRecordCount.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_libref         Library containing the data set
   \param     i_memname        Data set to be tested    
   \param     i_operator       Optional Parameter: Logical operator to compare i_recordsExp and l_actual; if not specified "EQ" is assumed as default.
   \param     i_recordsExp     Number of records expected: a numeric value >= 0
   \param     i_where          Optional Parameter: where condition to be checked. Set to 1 by default. 
   \param     i_desc           Optional Parameter: description of the assertion to be checked
*/ /** \cond */ 

%MACRO assertRecordCount(i_libref         = 
                        ,i_memname        = 
                        ,i_operator       = EQ
                        ,i_recordsExp     = 
                        ,i_where          = 1
                        ,i_desc           = Check for a specific number of records
                        );

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error: assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_dsname l_result l_actual;
   %let l_dsname =%sysfunc(catx(., &i_libref., &i_memname.));
   %let l_result = 2;
   %let l_actual = -999;
   %let i_operator = %sysfunc(upcase(&i_operator.));
  
   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;
   
   %*** check for valid libref und existence of data set***;
   %if ((%sysfunc (libref (&i_libref.)) NE 0) or (%sysfunc(exist(&l_dsname)) EQ 0)) %THEN %DO;
      %let l_actual =-1;
      %goto Update;
   %END;

   %*** check for valid parameter i_recordsExp***;
   data _null_;
      IF (INPUT(&i_recordsExp., 32.) =.)  then call symput('l_actual',"-3");
      ELSE IF (&i_recordsExp. < 0) then call symput('l_actual',"-4");;
   run;
   
   %if (&l_actual. EQ -3 OR &l_actual. EQ -4) %THEN %DO;
      %put Parameter not valid;
      %goto Update;
   %END;

   %*** check for valid parameter i_operator***;
   data _null_;
     IF NOT("&i_operator." IN ("EQ", "NE", "GT", "LT", "GE", "LE", "=", "<", ">", ">=", "<=", "~="))  then call symput('l_actual',"-5");
   run;     
   %if (&l_actual. EQ -5) %THEN %DO;
      %put Operator not found;
      %goto Update;
   %END;

   %*************************************************************;
   %*** start tests                                           ***;
   %*************************************************************;
   
   %*** Determine results***;
   proc sql noprint;
      select count(*) into :l_actual 
         from &l_dsname.
         where &i_where.
      ;
   quit;
   %if(&SQLRC. NE 0) %then %do;
      %let l_actual = -2;
      %let l_result = 2;
      %goto Update;
   %end;

   %*** Determine results***;
   %if (&l_actual. &i_operator. &i_recordsExp. and &l_actual. NE -999) %then %do;
      %let l_result = 0;
   %end;

%Update:
   *** update result in test database ***;
   %_asserts(
             i_type     = assertRecordCount
            ,i_expected = %str(&i_operator. &i_recordsExp.)
            ,i_actual   = %str(&l_actual.)
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            )
%MEND;
/** \endcond */
