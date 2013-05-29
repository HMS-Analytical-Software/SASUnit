/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether all files are identical in the libraries i_expcected and i_actual.
               
               The comparison report is created later, as PROC REPORT does not support ODS Document.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_actual       library with created files
   \param     i_expected     library with expected files
   \param     i_desc         description of the assertion to be checked, default value: "Bibliotheken prüfen"
   \param     i_LibraryCheck stringency of the library check: STRICT (default) -> Contents of libraries have to be identical. \n
                             MORETABLES -> Library i_actual is allowed to have more tables as library i_expected. 
   \param     i_CompareCheck stringency of the table check: STRICT (default) -> Tables have to be identical. \n
                             MORECOLUMNS -> Tables in library i_actual are allowed to have more columns as tables in library i_expected. \n
                             MOREOBS -> Tables in library i_actual are allowed to have more rows as tables in library i_expected. \n
                             MORECOLSNOBS -> Tables in library i_actual are allowed to have more columns and to have more rows as tables in library i_expected.
   \param     i_fuzz         optional: maximal deviation of expected and actual values, 
                             only for numerical values  
   \param     i_id           optional: Id-column for matching of observations   
   \param     i_ExcludeList  optional: Names of files to be exluded from the comparison.

   \return    ODS documents with the contents of the libraries and a SAS file with the comparison result.
*/ /** \cond */ 

%MACRO assertLibrary (
    i_actual       = _NONE_
   ,i_expected     = _NONE_
   ,i_desc         = Bibliotheken prüfen
   ,i_libraryCheck = STRICT
   ,i_compareCheck = STRICT
   ,i_fuzz         = _NONE_
   ,i_id           = _NONE_
   ,i_ExcludeList  = _NONE_
);

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error: assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_casid l_tstid ;
   %_sasunit_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %local l_actual_ok l_expected_ok l_result l_path_actual l_path_expected _sysinfo l_col_names l_id_col l_counter l_id l_rc;

   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;

   %*** check for valid actual libref ***;
   %let l_actual_ok=%sysfunc (libref (&i_actual.));
   %if (&l_actual_ok. > 0) %then %do;
       %put &g_error: Libref i_actual (&i_actual.) is invalid!;
       %let l_rc=2;
       %goto Update;
   %end;

   %*** check for valid expected libref ***;
   %let l_expected_ok=%sysfunc (libref (&i_expected.));
   %if (&l_expected_ok. > 0) %then %do;
       %put &g_error: Libref i_expected (&i_expected.) is invalid!;
       %let l_rc=2;
       %goto Update;
   %end;

   %*** check for equal librefs ***;
   %if (&i_actual. = &i_expected.) %then  %do;
       %put &g_error: Librefs are identical!;
       %let l_rc=2;
       %goto Update;
   %end;

   %*** check for identical paths ***;
   %let l_path_actual = %sysfunc (pathname (&i_actual.));
   %let l_path_expected = %sysfunc (pathname (&i_expected.));
   %if ("&l_path_actual."  = "&l_path_expected.") %then %do;
       %put &g_error: paths are identical!;
       %let l_rc=2;
       %goto Update;
   %end;

   %*** Check valid values for i_LibraryCheck ***;
   %let i_LibraryCheck = %upcase (%trim(&i_LibraryCheck.));
   %if (&i_LibraryCheck. ne STRICT AND &i_LibraryCheck. ne MORETABLES) %then %do;
       %put &g_error: Value of i_LibraryCheck (%trim(&i_LibraryCheck.)) is invalid!;
       %let l_rc=2;
       %goto Update;
   %end;

   %*** Check valid values for i_CompareCheck ***;
   %let i_CompareCheck = %upcase (%trim(&i_CompareCheck.));
   %if (&i_CompareCheck. ne STRICT AND &i_CompareCheck. ne MORECOLUMNS 
        AND &i_CompareCheck. ne MOREOBS AND &i_CompareCheck. ne MORECOLSNOBS) %then %do;
       %put &g_error: Value of i_CompareCheck (%trim(&i_CompareCheck.)) is invalid!;
       %let l_rc=2;
       %goto Update;
   %end;

   %let i_ExcludeList = %upcase (%trim(&i_ExcludeList.));

   %*************************************************************;
   %*** start tests                                           ***;
   %*************************************************************;
   %_sasunit_assertLibrary (i_actual      =&i_actual.
                           ,i_expected    =&i_expected.
                           ,i_ExcludeList =&i_Excludelist.
                           ,i_CompareCheck=&i_CompareCheck.
                           ,i_LibraryCheck=&i_LibraryCheck.
                           ,i_id          =&i_id.
                           ,i_fuzz        =&i_fuzz.
                           ,o_result      =l_rc
                           );
   %let l_rc=%eval(&l_rc.*2);

%Update:;
   *** update result in test database ***;
   %_sasunit_asserts(
       i_type     = assertLibrary
      ,i_expected = &i_expected.
      ,i_actual   = &i_actual.
      ,i_desc     = &i_desc.
      ,i_result   = &l_rc.
   )
%MEND;
/** \endcond */
