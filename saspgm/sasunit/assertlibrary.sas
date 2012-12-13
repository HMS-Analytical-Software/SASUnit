/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether all files are identical in the libraries i_expcected and i_actual.
               
               The comparison report is created later, as PROC REPORT does not support ODS Document.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

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

/* 
   13.12.2012 KL  Despite the noprint option PROC COMPARE issues a warning when there is no opeb output destination.
                  So the listing destination is opened prior to calling PROC COMPARE.
   28.05.2010 KL  Pfade mit Sonderzeichen machen unter SAS9.2 Probleme, deshalb Strings in Hochkommata
   06.02.2008 AM  Dokumentation verbessert
   05.11.2008 KL  Unterdrücken von Warnings (Keine ODS Destination offen).
   21.10.2008 KL  Logik bei MoreColumns etc. war leider falschrum.
   17.12.2007 KL  Parameter ExcludeList hinzugefügt
*/

%MACRO assertLibrary (
    i_actual       = _NONE_
   ,i_expected     = _NONE_
   ,i_desc         = Bibliotheken prüfen
   ,i_libraryCheck = STRICT
   ,i_CompareCheck = STRICT
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

   %LOCAL l_casid l_tstid;
   %_sasunit_asserts(
       i_type     = assertLibrary
      ,i_expected = %eval (%sysfunc (libref (&i_expected.))=0)
      ,i_actual   = %eval (%sysfunc (libref (&i_actual.))=0)
      ,i_desc     = &i_desc
      ,i_result   = .
      ,r_casid    = l_casid
      ,r_tstid    = l_tstid
   )

   %local l_actual_ok l_expected_ok l_result l_path_actual l_path_expected _sysinfo l_col_names l_id_col l_counter l_id;

   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;

   %*** check for valid actual libref ***;
   %let l_actual_ok=%sysfunc (libref (&i_actual.));
   %if (&l_actual_ok. > 0) %then %do;
       %put &g_error: Libref i_actual (&i_actual.) is invalid!;
       %let l_rc=1;
       %goto Update;
   %end;

   %*** check for valid expected libref ***;
   %let l_expected_ok=%sysfunc (libref (&i_expected.));
   %if (&l_expected_ok. > 0) %then %do;
       %put &g_error: Libref i_expected (&i_expected.) is invalid!;
       %let l_rc=1;
       %goto Update;
   %end;

   %*** check for equal librefs ***;
   %if (&i_actual. = &i_expected.) %then  %do;
       %put &g_error: Librefs are identical!;
       %let l_rc=1;
       %goto Update;
   %end;

   %*** check for identical paths ***;
   %let l_path_actual = %sysfunc (pathname (&i_actual.));
   %let l_path_expected = %sysfunc (pathname (&i_expected.));
   %if ("&l_path_actual."  = "&l_path_expected.") %then %do;
       %put &g_error: paths are identical!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let i_LibraryCheck = %upcase (%trim(&i_LibraryCheck.));
   %if (&i_LibraryCheck. ne STRICT AND &i_LibraryCheck. ne MORETABLES) %then %do;
       %put &g_error: Value of i_LibraryCheck (%trim(&i_LibraryCheck.)) is invalid!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let i_CompareCheck = %upcase (%trim(&i_CompareCheck.));
   %if (&i_CompareCheck. ne STRICT AND &i_CompareCheck. ne MORECOLUMNS 
        AND &i_CompareCheck. ne MOREOBS AND &i_CompareCheck. ne MORECOLSNOBS) %then %do;
       %put &g_error: Value of i_CompareCheck (%trim(&i_CompareCheck.)) is invalid!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let i_ExcludeList = %upcase (%trim(&i_ExcludeList.));

   %local AnzCompares;

   %*************************************************************;
   %*** start tests                                           ***;
   %*************************************************************;

   %*** get table names from the two libraries ***;
   proc sql noprint;
      create table WORK._assertLibraryActual as
         select libname as BaseLibname,
                memname as BaseMemName,
                nlobs as BaseObs format=commax18.,
                nvar as BaseNVar format=commax18.
         from dictionary.tables
         where libname = "%upcase(&i_actual)" 
            %if (&i_ExcludeList. ne _NONE_) %then %do;
               AND memname not in (
               %let counter=1;
               %let l_id_col = %scan (&i_ExcludeList.,&counter., %str ( ));
               %do %while (&l_id_col. ne );
                  "&l_id_col."
                  %let counter=%eval (&counter.+1);
                  %let l_id_col = %scan (&i_ExcludeList.,&counter., %str ( ));
               %end;
               )
            %end;
         order by memname;
      create table WORK._assertLibraryExpected as
         select libname as CmpLibname,
                memname as CmpMemName,
                nlobs as CmpObs format=commax18.,
                nvar as CmpNVar format=commax18.
         from dictionary.tables
         where libname = "%upcase(&i_expected)"
            %if (&i_ExcludeList. ne _NONE_) %then %do;
               AND memname not in (
               %let counter=1;
               %let l_id_col = %scan (&i_ExcludeList.,&counter., %str ( ));
               %do %while (&l_id_col. ne );
                  "&l_id_col."
                  %let counter=%eval (&counter.+1);
                  %let l_id_col = %scan (&i_ExcludeList.,&counter., %str ( ));
               %end;
               )
            %end;
         order by memname;
   quit;

   %*** flag tables according to check results ***;
   data work._ergebnis;
      length DoCompare CompareFailed l_rc 8;
      merge WORK._assertLibraryActual (in=InAct rename=(BaseMemname=memname))
            WORK._assertLibraryExpected (in=InExp rename=(CmpMemname=memname));
      by memname;
      l_rc = .;
      InActual=InAct;
      InExpected=InExp;
      if (InAct AND inExp) then do;
         DoCompare=1;
         CompareFailed=1;
         if (BaseObs ne CmpObs) then do;
            if ("&i_CompareCheck." = "STRICT" OR "&i_CompareCheck." = "MORECOLUMNS") then do;
               DoCompare=0;
            end;
         end;
         if (BaseNVar ne CmpNVar) then do;
            if ("&i_CompareCheck." = "STRICT" OR "&i_CompareCheck." = "MOREOBS") then do;
               DoCompare=0;
            end;
         end;
      end;
      else if (InAct AND not inExp AND "&i_LibraryCheck." ne "STRICT") then do;
         DoCompare=0;
         CompareFailed=0;
      end;
      else do;
         DoCompare=0;
         CompareFailed=1;
      end;
   run;

   %*** determine number of compared tables ***;
   proc sql noprint;
      select sum (DoCompare) into :AnzCompares
      from work._ergebnis;
   quit;

   %if (&AnzCompares. > 0) %then %do;
      %do i=1 %to &AnzCompares.;
         %local Memname&i.;
      %end;

      proc sql noprint;
         select memname into :Memname1-:Memname%trim(&AnzCompares.)
         from work._ergebnis 
         where DoCompare=1;
      quit;

      %*** upcase for id columns ***;
      %if (&i_id. ne _NONE_) %then %do;
         %let i_id=%upcase (&i_id.);
      %end;

      %*** Check for open ODS DESTINATIONS ***;
      %local OpenODSDestinations;
      %let   OpenODSDestinations=0;
      proc sql noprint;
         select count (*) into :OpenODSDestinations from sashelp.vdest;
      quit;

      %if (&OpenODSDestinations. = 0) %then %do;
         ods listing;
      %end;

      %*** Compare each pair of tables ***;
      %do i=1 %to &AnzCompares.;
         %if (&i_id. ne _NONE_) %then %do;
            %let l_col_names=;
            %let l_id=;
            proc sql noprint;
               select distinct upcase (name) into :l_col_names separated by ' '
               from dictionary.columns
               where libname = "%upcase (&i_actual.)" AND upcase (memname) = "%upcase(&&memname&i.)";
            quit;

            %let counter=1;
            %let l_id_col = %scan (&i_id.,&counter., %str ( ));
            %do %while (&l_id_col. ne );
                %let l_found=%sysfunc (indexw (&l_col_names, &l_id_col.));
                %if (&l_found. > 0) %then %do;
                   %let l_id = &l_id. &l_id_col;
                %end;
               %let counter=%eval (&counter.+1);
               %let l_id_col = %scan (&i_id.,&counter., %str ( ));
            %end;
         %end;

         proc compare 
            base=&i_expected..&&memname&i. 
            compare=&i_actual..&&memname&i.
            %if (&i_fuzz. ne _NONE_) %then %do;
               CRITERION=&i_fuzz.
            %end;
            noprint;
            %if (&i_id. ne _NONE_) %then %do;
               id &l_id.;
            %end;
         run;
         %let _sysinfo=&sysinfo.;
         proc sql noprint;
            update work._ergebnis
            set l_rc=&_sysinfo.
            where upcase (memname)="%upcase (&&memname&i.)";
         quit;
      %end;

      %if (&OpenODSDestinations. = 0) %then %do;
         ods listing close;
      %end;
   %end;
   
   %*** set test result ***;
   data work._ergebnis;
      set work._ergebnis;
      select (l_rc);
         when (0)
            Comparefailed=0;
         when (128) do; /* COMPOBS - Comparison data set has observation not in base */
            if ("&i_CompareCheck." = "MOREOBS" OR "&i_CompareCheck." = "MORECOLSNOBS") then do;
               Comparefailed=0;
            end;
         end;
         when (2048) do; /* COMPVAR - Comparison data set has variable not in base */
            if ("&i_CompareCheck." = "MORECOLUMNS" OR "&i_CompareCheck." = "MORECOLSNOBS") then do;
               Comparefailed=0;
            end;
         end;
         when (2176) do; /* COMPOBS & COMPVAR */
            if ("&i_CompareCheck." = "MORECOLSNOBS") then do;
               Comparefailed=0;
            end;
         end;
         otherwise;
      end;
   run;

   %*** format resuts for report ***;
   data work._ergebnis;
      length icon_column $45 i_LibraryCheck i_CompareCheck $15 i_id i_ExcludeList $80;
      set work._ergebnis;
      SELECT (CompareFailed);
         WHEN (0) icon_column='<img src="ok.png" alt="OK"></img>';
         WHEN (1) icon_column='<img src="error.png" alt="Fehler"></img>';
         OTHERWISE icon_column='&nbsp;';
      END;
      i_LibraryCheck="&i_LibraryCheck.";
      i_CompareCheck="&i_CompareCheck.";
      i_id="&i_id.";
      i_ExcludeList="&i_ExcludeList.";
   run;

   %*** determine return value for test ***;
   proc sql noprint;
      select max (CompareFailed) into :l_rc
      from work._ergebnis;
   quit;

   %*** create library listing ***;
   ods document name=testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._Library_act(WRITE);
      proc print data=WORK._assertLibraryActual label noobs;
      run;
   ods document close;
   ods document name=testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._Library_exp(WRITE);
      proc print data=WORK._assertLibraryExpected label noobs;
      run;
   ods document close;
   data testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._Library_rep;
      set work._ergebnis;
   run;

   proc datasets lib=work nolist memtype=(data view);
      delete _ergebnis _assertLibraryActual _assertLibraryExpected;
   quit;

%Update:;
   /* update result in test database */
   PROC SQL NOPRINT;
      UPDATE target.tst 
         SET tst_res = &l_rc 
         WHERE 
            tst_scnid = &g_scnid AND
            tst_casid = &l_casid AND
            tst_id    = &l_tstid
         ;
   QUIT;
%MEND;
/** \endcond */
