/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether a certain message appears in the log.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

               If the message does not appear in the log as expected, 
               the check of the assertion will fail.
               If i_not is set to 1, the check of the assertion will fail in case the 
               message is found in the log.

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/asserttableexists.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_libref			 Library in which the test candidate can be found
   \param   i_memname			 Name of data set, view or catalog to be tested
   \param   i_target	 		 optional: Explicit test for existens of a dataset,view or catalog (Possible arguments: data, view, catalog)
   \param   i_desc         description of the assertion to be checked
   \param   i_not          negates the assertion, if set to 1
*/ /** \cond */ 
options symbolgen mprint mlogic;

%MACRO assertTableExists (
	i_libref 		= _NONE_
  ,i_memname  = _NONE_
	,i_target  	= DATA  
  ,i_desc    	= Test if table exists
  ,i_not     	= 0
);

  %GLOBAL g_inTestcase;
	/*
	%let i_libref = %UPCASE(&i_libref.);
	%let i_memname = %UPCASE(&i_memname.);
	*/
	%LOCAL l_dsname l_libref_ok l_table_exist l_result l_date;
	%let l_dsname =%sysfunc(catx(., &i_libref, &i_memname));
	%let l_table_exist = -1;
	%let l_result=2;
	%let l_date =;
	 
  %IF &g_inTestcase EQ 1 %THEN %DO;
    %endTestcall;
  %END;
  %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
    %PUT &g_error: assert must be called after initTestcase;
    %RETURN;
  %END;

  %*************************************************************;
  %*** Check preconditions                                   ***;
  %*************************************************************;

  %*** check for valid libref ***;
  %let l_libref_ok=%sysfunc (libref (&i_libref.));
  %if &l_libref_ok. NE 0 %then %do;
    %goto Update;
	%end;
	 
	%*** check if i_target is valid ***;
	%let i_target=%sysfunc(upcase(&i_target));
	%if not(&i_target=DATA or &i_target=VIEW or &i_target=CATALOG) %then %do;
		%let l_table_exist = -2;
	  %goto Update;
	%end;

  %*************************************************************;
  %*** start tests                                           ***;
  %*************************************************************;
		%if %sysfunc(exist(&l_dsname, &i_target)) %then %do;
		  %let l_table_exist=1;
			%put &i_target. &l_dsname. exists.;
		
			%*** get creation und modification date of tested member ***;
			data _null_ ;
			  length _crdate _modate $20;
				dsid=open("&l_dsname") ;
				_crdate = attrn(dsid,'CRDTE');
				_modate = attrn(dsid,'MODTE');
				dsid=close(dsid) ;
				call symput('l_date',catt("#",_crdate,"#",_modate));
			run ;
		%end;
		%else %do;
			%put &i_target. &l_dsname. does not exist.;
			%let l_table_exist=0;
		%end;

		%let l_result = %eval(1 - &l_table_exist.);
		%if(&i_not) %then %do;
			%let l_result = %eval(1 - &l_result.);
		%end;
		%let l_result = %eval(&l_result.*2);

%Update:;
	%_asserts(
			i_type     = assertTableExists
		 ,i_expected = %str(&i_target.:&l_dsname.:&i_not.)
		 ,i_actual   = %str(&l_table_exist.&l_date.)
		 ,i_desc     = &i_desc.
		 ,i_result   = &l_result.
)

%MEND assertTableExists;
/** \endcond */
