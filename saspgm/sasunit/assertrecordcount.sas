/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether at certain number of records exist which satisfy a certain WHERE condition

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/assertRecordCount.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_libref       	 Library containing the data set
   \param     i_memname        Data set to be tested    
   \param     i_operator			 Logical operator to compare i_recordsExp and l_actual
   \param     i_recordsExp     Number of records expected
	 \param			i_where					 Where condition to be checked.  Has to be used as follows: %str(where VARIABLE OPERATOR VALUE ... ). Can be empty. 
   \param     i_desc  				 Description of the assertion to be checked

   \return    ODS documents with the contents of the libraries and a SAS file with the comparison result.
*/ /** \cond */ 

%MACRO assertRecordCount (
    i_libref       	= _NONE_
   ,i_memname    		= _NONE_
   ,i_operator		  = EQ
   ,i_recordsExp 		= _NONE_
	 ,i_where					=
	 ,i_desc          = Check number of records
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
		  IF (INPUT(&i_recordsExp., 32.) =.)  then call symput('l_actual',-3);
			ELSE IF (&i_recordsExp. < 0) then call symput('l_actual',-4);;
		run;
		
		%if (&l_actual. EQ -3 OR &l_actual. EQ -4) %THEN %DO;
		  %put Parameter not valid;
			%goto Update;
		%END;

		%*** check for valid parameter i_operator***;
		data _null_;
		  IF NOT("&i_operator." IN ("EQ", "NE", "GT", "LT", "GE", "LE", "=", "<", ">", ">=", "<=", "~="))  then call symput('l_actual',-5);
		run;		
		%if (&l_actual. EQ -5) %THEN %DO;
			%put Operator not found;
			%goto Update;
		%END;

   %*************************************************************;
   %*** start tests                                           ***;
   %*************************************************************;
	 %*** Ergebnismenge bestimmen***;
		proc sql noprint;
						select count(*) into :l_actual 
							from &l_dsname.
							&i_where
						;
		quit;
		%if(&SQLRC. NE 0) %then %do;
			%let l_actual = -2;
			%let l_result = 2;
			%goto Update;
		%end;

		%*** Ergebnismenge bestimmen***;
		%if (&l_actual. &i_operator. &i_recordsExp and &l_actual. NE -999) %then %do;
			%let l_result = 0;
		%end;

%Update:;
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
