/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Check whether all files are identical in the libraries i_expcected and i_actual.
               
               The comparison report is created later, as PROC REPORT does not support ODS Document.

   \version    \$Revision: 57 $
   \author     \$Author: mangold $
   \date       \$Date: 2010-05-16 14:51:20 +0200 (So, 16 Mai 2010) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/sasunit/assertlibrary.sas $

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
*/

/*DE
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      Prüfen, ob alle Dateien in den Bibliotheken i_expcected und i_actual identisch sind.

               Der Vergleichsreport wird erst später gemacht, da PROC REPORT keine Unterstützung von
               ODS Document hat!

   \param     i_actual       Library mit den erzeugten Dateien
   \param     i_expected     Library mit den erwarteten Dateien
   \param     i_desc         Beschreibung der Prüfung, Voreinstellung "Bibliotheken prüfen"
   \param     i_LibraryCheck Strenge der Libraryprüfung. STRICT (default) -> Libraryinhalte müssen identisch sein. \n
                             MORETABLES -> Library i_actual darf mehr Tabellen enthalten als Library i_expected. 
   \param     i_CompareCheck Strenge der Tabellenprüfung. STRICT (default) -> Tabellen müssen identisch sein. \n
                             MORECOLUMNS -> Tabelle in Library i_actual darf mehr Spalten haben als die Tabelle in Library i_expected. \n
                             MOREOBS -> Tabelle in Library i_actual darf mehr Zeilen haben als die Tabelle in Library i_expected. \n
                             MORECOLSNOBS -> Tabelle in Library i_actual darf mehr Spalten und mehr Zeilen haben als die Tabelle in Library i_expected.
   \param     i_fuzz         optional: maximale Abweichung von erwartetem und tatsächlichem Wert, 
                             nur für numerische Werte 
   \param     i_id           optional: Id-Spalten für das Matchen von Beobachtungen   
   \param     i_ExcludeList  optional Namen von Dateien, die NICHT verglichem werden sollen 

   \return    ODS-Dokumente mit den Inhalten der Bibliotheken und eine SAS Datei mit dem Vergleichsergebnis.
*/ 
/** \cond */ 

/* 
   06.02.2008 AM  Dokumentation verbessert
   17.12.2007 KL  Parameter ExcludeList hinzugefügt
   21.10.2008 KL  Logik bei MoreColumns etc. war leider falschrum.
   05.11.2008 KL  Unterdrücken von Warnings (Keine ODS Destination offen).
*/

%MACRO assertLibrary (
    i_actual      =_NONE_
   ,i_expected    =_NONE_
   ,i_desc        =Bibliotheken prüfen
   ,i_libraryCheck =STRICT
   ,i_CompareCheck =STRICT
   ,i_fuzz         =_NONE_
   ,i_id           =_NONE_
   ,i_ExcludeList  =_NONE_
);

   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error: assert muss nach initTestcase aufgerufen werden;
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

   %let l_actual_ok=%sysfunc (libref (&i_actual.));
   %if (&l_actual_ok. > 0) %then %do;
       %put &g_error: Libref i_actual (&i_actual.) ist ungültig!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let l_expected_ok=%sysfunc (libref (&i_expected.));
   %if (&l_expected_ok. > 0) %then %do;
       %put &g_error: Libref i_expected (&i_expected.) ist ungültig!;
       %let l_rc=1;
       %goto Update;
   %end;

   %if (&i_actual. = &i_expected.) %then  %do;
       %put &g_error: Beide Librefs sind identisch!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let l_path_actual = %sysfunc (pathname (&i_actual.));
   %let l_path_expected = %sysfunc (pathname (&i_expected.));
   %if (&l_path_actual.  = &l_path_expected.) %then %do;
       %put &g_error: Beide Pfade sind identisch!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let i_LibraryCheck = %upcase (%trim(&i_LibraryCheck.));
   %if (&i_LibraryCheck. ne STRICT AND &i_LibraryCheck. ne MORETABLES) %then %do;
       %put &g_error: Der Wert von i_LibraryCheck (%trim(&i_LibraryCheck.)) ist ungültig!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let i_CompareCheck = %upcase (%trim(&i_CompareCheck.));
   %if (&i_CompareCheck. ne STRICT AND &i_CompareCheck. ne MORECOLUMNS 
        AND &i_CompareCheck. ne MOREOBS AND &i_CompareCheck. ne MORECOLSNOBS) %then %do;
       %put &g_error: Der Wert von i_CompareCheck (%trim(&i_CompareCheck.)) ist ungültig!;
       %let l_rc=1;
       %goto Update;
   %end;

   %let i_ExcludeList = %upcase (%trim(&i_ExcludeList.));

   %local AnzCompares;

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

      %if (&i_id. ne _NONE_) %then %do;
         %let i_id=%upcase (&i_id.);
      %end;

      %do i=1 %to &AnzCompares.;
         %if (&i_id. ne _NONE_) %then %do;
            %let l_col_names=;
            %let l_id=;
            proc sql noprint;
               select distinct upcase (name) into :l_col_names separated by ' '
               from dictionary.columns
               where libname = "%upcase (&i_actual.)" AND upcase (memname) = "%upcase(&&memname&i.)";
            run;

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

   proc sql noprint;
      select max (CompareFailed) into :l_rc
      from work._ergebnis;
   quit;

   ods document name=testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._Library_act(WRITE);
      TITLE "Prüfbericht - Inhalt der aktuellen Bibliothek";
      proc print data=WORK._assertLibraryActual label noobs;
      run;
   ods document close;
   ods document name=testout._%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._Library_exp(WRITE);
      TITLE "Prüfbericht - Inhalt der erwarteten Bibliothek";
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
   /* Ergebnis aktualisieren */
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
