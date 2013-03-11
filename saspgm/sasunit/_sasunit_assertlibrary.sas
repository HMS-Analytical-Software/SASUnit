/** 
   \file
   \ingroup    SASUNIT_UTIL

   \brief      Main routine of assertLibrary

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

   \retval    o_result       Return code of the assert 0: OK / 1: ERROR
*/ /** \cond */ 

/* change history 
   26.02.2013 KL created
*/ 

%macro _sasunit_assertlibrary (i_actual      =_NONE_
                              ,i_expected    =_NONE_
                              ,i_ExcludeList =_NONE_
                              ,i_CompareCheck=_NONE_
                              ,i_LibraryCheck=_NONE_
                              ,i_id          =_NONE_
                              ,i_fuzz        =_NONE_
                              ,i_scnid       =
                              ,i_casid       =
                              ,i_tstid       =
                              ,o_result      =
                              );

   %LOCAL l_casid l_tstid AnzCompares l_subfoldername l_path;

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

      %*** SASHELP.VDEST is only available in 9.2 or later ***;
      %if (&sysver. NE 9.1) %then %do; 
         proc sql noprint;
            select count (*) into :OpenODSDestinations from sashelp.vdest;
         quit;
      %end;

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
   %end;

   %if (&OpenODSDestinations. = 0) %then %do;
      ods listing close;
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

   %*** format results for report ***;
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
      select max (CompareFailed) into :&o_result.
      from work._ergebnis;
   quit;

   %_sasunit_getScenarioTestId (i_scnid=&g_scnid, o_casid=l_casid, o_tstid=l_tstid);

   %*** create subfolder ***;
   %_sasunit_createTestSubfolder (i_assertType   =assertLibrary
                                 ,i_scnid        =&g_scnid.
                                 ,i_casid        =&l_casid.
                                 ,i_tstid        =&l_tstid.
                                 ,o_path         =l_path
                                 );

   %*** create library listing ***;
   libname _alLib "&l_path.";
   ods document name=_alLib._Library_act(WRITE);
      proc print data=WORK._assertLibraryActual label noobs;
      run;
   ods document close;
   ods document name=_alLib._Library_exp(WRITE);
      proc print data=WORK._assertLibraryExpected label noobs;
      run;
   ods document close;
   data _alLib._Library_rep;
      set work._ergebnis;
   run;
   libname _alLib clear;

   proc datasets lib=work nolist memtype=(data view);
      delete _ergebnis _assertLibraryActual _assertLibraryExpected;
   quit;
%mend _sasunit_assertlibrary;
/** \endcond */
