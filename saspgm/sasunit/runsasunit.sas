/**
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Invokes one or more test scenarios.

               Please refer to the description of the test tools in _sasunit_doc.sas.

               Procedure:
               - Check whether test repository was already initialized with \%initSASUnit, if not: End.
               - Determination of the test scenarios to be invoked.
               - For every test scenario:
                 - Check whether it already exists in the test repository.
                 - if yes: Check whether the test scenario was changed since last invocation.
                 - if no:  Creation of the test scenario in the test repository.
                 - In case the test scenario is new or changed:
                   - The test scenario is executed in an own SAS session which is initialized
                     by _sasunit_scenario.sas .
                     All test results are gathered in the test repository. 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_source       test scenario (path to SAS program) 
                           resp. test scenarios (search pattern with structure directory\filenamepattern, 
                           e.g. test\*_test.sas for all files that end with _test.sas
                           If the given path is not absolute, the path specified in the parameter i_root of 
                           \%initSASUnit will be used as prefix to the specified path
   \param   i_recursive    if a search pattern is specified: 1 .. subdirectories of &i_source are searched, too.
                           default 0 ... do not search subdirectories.
*/

/*DE 
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Führt ein Testszenario oder mehrere Testszenarien aus.

               weitere Informationen siehe _sasunit_doc.sas

               Ablauf:
               - prüfen, ob Testdatenbank mit \%initSASUnit initialisiert wurde, wenn nein: Ende
               - ermitteln der auszuführenden Testszenarien
               - für jedes Testszenario:
                 - prüfen, ob es schon in der Testdatenbank existiert
                 - wenn ja: prüfen, ob das Testszenario seit dem letzten Aufruf geändert wurde
                 - wenn nein: Anlegen des Testszenarios in der Testdatenbank
                 - wenn Testszenario neu oder geändert:
                   - Testszenario in einer eigenen SAS-Sitzung ausführen,
                     die über _sasunit_scenario.sas initialisiert wird.
                     Alle Testergebnisse werden in der Testdatenbank gesammelt 

   \param   i_source       Testszenario (Pfad zu SAS-Programm) 
                           bzw. Testszenarien (Suchmuster in der Form verzeichnis\dateimuster, 
                           z.B. test\*_test.sas für alle Dateien, die mit 
                           _test.sas aufhören)
                           Wenn der angegebene Pfad nicht absolut ist, wird der im Parameter i_root von 
                           \%initSASUnit angegebene Pfad vorangestellt
   \param   i_recursive    wenn Suchmuster angegeben: 1 .. auch Unterverzeichnisse von &i_source durchsuchen, 
                           Voreinstellung ist 0 ... keine Unterverzeichnisse durchsuchen
*/ /** \cond */ 

/* Änderungshistorie
   02.10.2008 NA  Modified for LINUX
   11.08.2008 AM  Fehler bereinigt für den Fall, dass in der aufrufenden Sitzung keine config-Option angegeben ist 
                  und die mit getoption abgefragte config-option dann Werte (mit Klammern) enthält, 
                  die nicht an die gestartete SAS-Sitzung übergeben werden können
   27.06.2008 AM  config-option aus Aufruf ggfs. an die SAS-Sitzungen der Testszenarien weitergeben
   29.12.2007 AM  SASUSER nach Aufruf Testszenario wieder löschen
   18.12.2007 KL  Bugfixing beim Ermitteln der möglichen Prüflinge
   15.12.2007 AM  Logik für Überprüfung auf auszuführende Testszenarien neu implementiert (checkSzenario) 
*/ 

%MACRO runSASUnit(
   i_source     =
  ,i_recursive  = 0
);
%LOCAL l_macname; %LET l_macname=&sysmacroname;
%LOCAL d_dir l_source; 
%_sasunit_tempFileName(d_dir);

/*-- Betriebssystembefehle einstellen --------------------------------------*/
%LOCAL l_removedir 
       l_makedir
       l_copydir
       l_endcommand
       l_sasstart
       l_splash
       ;
%if &sysscp. = WIN %then %do; 
        %let l_removedir = rd /S /Q;
        %let l_makedir = md;
        %let l_copydir = xcopy /E /I /Y;
        %let l_endcommand =;
        %let l_sasstart ="%sysget(sasroot)/sas.exe";
        %let l_splash = -nosplash;
%end;
%else %if &sysscp. = LINUX %then %do;
        %let l_removedir = rm -r;
        %let l_makedir = mkdir;
        %let l_copydir = cp -R;
        %let l_endcommand =%str(;);
        %_sasunit_xcmd(umask 0033);
        %let l_sasstart =%sysfunc(pathname(sasroot))/sasexe/sas;
        %let l_splash =;
%end;


/*-- prüfen, ob Testdatenbank zugewiesen -------------------------------------*/
%IF %_sasunit_handleError(&l_macname, NoTestDB, 
   NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project), 
   %nrstr(Testdatenbank nicht zugewiesen, %initSASUnit vor %runSASUnit aufrufen))
   %THEN %GOTO errexit;

/*-- Parameter i_recursive ---------------------------------------------------*/
%IF "&i_recursive" NE "1" %THEN %LET i_recursive=0;

/*-- ermittle alle Testszenarien ---------------------------------------------*/
%LET l_source = %_sasunit_abspath(&g_root, &i_source);
%_sasunit_dir(i_path=&l_source, i_recursive=&i_recursive, o_out=&d_dir)
%IF %_sasunit_handleError(&l_macname, NoSourceFiles, 
   %_sasunit_nobs(&d_dir) EQ 0, 
   Fehler in Parameter i_source: keine Testszenarien gefunden) 
   %THEN %GOTO errexit;

%LOCAL l_nscn i;
%DO i=1 %TO %_sasunit_nobs(&d_dir); 
   %LOCAL l_scnfile&i l_scnchanged&i;
%END;
DATA _null_;
   SET &d_dir;
   CALL symput ('l_scnfile' !! left(put(_n_,8.)), trim(filename));
   CALL symput ('l_scnchanged' !! left(put(_n_,8.)), compress(put(changed,12.)));
   CALL symput ('l_nscn', compress(put(_n_,8.)));
RUN;

/*-- ermittle alle möglichen Prüflinge ---------------------------------------*/
%LOCAL l_auto l_autonr d_examinee;
%LET l_auto=&g_sasautos;
%LET l_autonr=0;
%_sasunit_tempFileName(d_examinee);
%DO %WHILE("&l_auto" ne "");  
   %LET l_auto=%quote(&l_auto/);
   %_sasunit_dir(i_path=&l_auto.*.sas, o_out=&d_dir)
   data &d_examinee;
      set %IF &l_autonr>0 %THEN &d_examinee; &d_dir(in=indir);
      if indir then auton=&l_autonr;
   run; 
   %LET l_autonr = %eval(&l_autonr+1);
   %LET l_auto=;
   %IF %symexist(g_sasautos&l_autonr) %THEN %LET l_auto=&&g_sasautos&l_autonr;
%END;

/*-- Schleife über alle Testszenarien ----------------------------------------*/
%LOCAL l_scn l_scnid l_dorun l_scndesc l_sysrc;
%DO i=1 %TO &l_nscn;

   %LET l_scn = %_sasunit_stdPath(&g_root, &&l_scnfile&i);

   /* Prüfe, ob Szenario ausgeführt werden muss */
   %_sasunit_checkScenario(
      i_scnfile = &&l_scnfile&i
     ,i_changed = &&l_scnchanged&i
     ,i_dir     = &d_examinee
     ,r_scnid   = l_scnid
     ,r_run     = l_dorun
   )

   /*-- wenn Szenario noch nicht vorhanden: neues Szenario erstellen ---------*/
   %IF &l_scnid = 0 %THEN %DO;
      PROC SQL NOPRINT;
         SELECT max(scn_id) INTO :l_scnid FROM target.scn;
         %IF &l_scnid=. %THEN %LET l_scnid=0;
         %LET l_scnid = %eval(&l_scnid+1);
         INSERT INTO target.scn VALUES (
             &l_scnid
            ,"&l_scn"
            ,"",.,.,.,.
         );
      QUIT;
   %END;
   /*-- Wenn Szenario schon vorhanden und geändert: Szenariodaten löschen ----*/
   %ELSE %IF &l_dorun %THEN %DO;
      PROC SQL NOPRINT;
         DELETE FROM target.cas WHERE cas_scnid = &l_scnid;
         DELETE FROM target.tst WHERE tst_scnid = &l_scnid;
      QUIT;
   %END;

   %IF &l_dorun %THEN %DO;
      %PUT ======== Testszenario &l_scnid (&l_scn) wird ausgeführt ========;
      %PUT;
      %PUT;
   %END;
   %ELSE %DO;
      %PUT ======== Testszenario &l_scnid (&l_scn) wird nicht ausgeführt ==;
      %PUT;
      %PUT;
   %END;

   /*-- das Testszenario gegebenenfalls starten ------------------------------*/
   %IF &l_dorun %THEN %DO;

      /*-- Beschreibung und Startzeit des Szenarios eintragen ----------------*/
      %_sasunit_getPgmDesc (i_pgmfile=&&l_scnfile&i, r_desc=l_scndesc)
      PROC SQL NOPRINT;
         UPDATE target.scn SET
            scn_desc  = "&l_scndesc"
           ,scn_start = %sysfunc(datetime())
         WHERE scn_id = &l_scnid
         ;
      QUIT;
 
      /*-- sasuser vorbereiten -----------------------------------------------*/
      DATA _null_;
         FILE "%sysfunc(pathname(work))/x.cmd";
         PUT "&l_removedir ""%sysfunc(pathname(work))/sasuser""&l_endcommand";
         PUT "&l_makedir ""%sysfunc(pathname(work))/sasuser""&l_endcommand";
      %IF %length(&g_sasuser) %THEN %DO;
         PUT "&l_copydir ""&g_sasuser"" ""%sysfunc(pathname(work))/sasuser""&l_endcommand";
      %END;
      RUN;
      %if &sysscp. = LINUX %then %do;
          %_sasunit_xcmd(chmod u+x "%sysfunc(pathname(work))/x.cmd")
      %end;
      %_sasunit_xcmd("%sysfunc(pathname(work))/x.cmd")
      %LOCAL l_rc;
      %LET l_rc=_sasunit_delfile(%sysfunc(pathname(work))/x.cmd);
         
      /*-- das Testszenario im Batch aufrufen --------------------------------*/
      %LOCAL l_parms l_parenthesis;
      %LET l_parenthesis=(;
      %IF "&g_autoexec" NE "" %THEN %DO;
         %LET l_parms=&l_parms -autoexec "&g_autoexec";
      %END;
      %IF "&g_sascfg" NE "" %THEN %DO;
         %LET l_parms=&l_parms -config "&g_sascfg";
      %END;
      %ELSE %IF %length(%sysfunc(getoption(config))) NE 0 AND %index(%quote(%sysfunc(getoption(config))),%bquote(&l_parenthesis)) = 0 %THEN %DO; 
         %LET l_parms=&l_parms -config "%sysfunc(getoption(config))";
      %END; 
      %sysexec 
            &l_sasstart
            &l_parms
            -sysin "&&l_scnfile&i"
            -initstmt "%nrstr(%_sasunit_scenario%(io_target=)&g_target%nrstr(%)%let g_scnid=)&l_scnid;"
            -log   "&g_log/%substr(00&l_scnid,%length(&l_scnid)).log"
            -print "&g_testout/%substr(00&l_scnid,%length(&l_scnid)).lst"
            &l_splash
            -noovp
            -nosyntaxcheck
            -mautosource
            -mcompilenote all
            -sasautos "&g_sasunit"
            -sasuser "%sysfunc(pathname(work))/sasuser"
            -termstmt '%_sasunit_termScenario()'
         ;  
      %LET l_sysrc = &sysrc;
%PUT --------------TEST1;
      /*-- SASUSER löschen ---------------------------------------------------*/
      DATA _null_;
         FILE "%sysfunc(pathname(work))/x.cmd";
         PUT "&l_removedir ""%sysfunc(pathname(work))/sasuser""&l_endcommand";
      RUN;
      %if &sysscp. = LINUX %then %do;
          %_sasunit_xcmd(chmod u+x "%sysfunc(pathname(work))/x.cmd")
      %end;

      %_sasunit_xcmd("%sysfunc(pathname(work))/x.cmd")
      %LET l_rc=_sasunit_delfile(%sysfunc(pathname(work))/x.cmd);

      /*-- Listing löschen, wenn leer ----------------------------------------*/
      %LOCAL l_filled l_lstfile; 
      %LET l_filled=0;
      %LET l_lstfile=&g_testout/%substr(00&l_scnid,%length(&l_scnid)).lst;
      DATA _null_;
         INFILE "&l_lstfile";
         INPUT;
         CALL symput ('l_filled','1');
         STOP;
      RUN;
      %IF NOT &l_filled %THEN %DO;
         %LET l_filled=%_sasunit_delfile(&l_lstfile);
      %END;

      /*-- Die Metadaten des Testszenarios aktualisieren ---------------------*/
      PROC SQL NOPRINT;
         %LOCAL l_result0 l_result1 l_result2;
         /* ermittle Ergebnisse der Testfälle */
         SELECT count(*) INTO :l_result0 FROM target.cas WHERE cas_scnid=&l_scnid AND cas_res=0;
         SELECT count(*) INTO :l_result1 FROM target.cas WHERE cas_scnid=&l_scnid AND cas_res=1;
         SELECT count(*) INTO :l_result2 FROM target.cas WHERE cas_scnid=&l_scnid AND cas_res=2;
         
         %LOCAL l_result;
         %IF &l_result1 GT 0 %THEN %LET l_result=1;        /* Fehler aufgetreten */
         %ELSE %IF &l_result2 GT 0 %THEN %LET l_result=2;  /* manuell aufgetreten */
         %ELSE %LET l_result=0;                            /* alles OK */

         UPDATE target.scn
            SET 
                scn_end = %sysfunc(datetime())
               ,scn_rc  = &l_sysrc
               ,scn_res = &l_result
            WHERE 
               scn_id = &l_scnid
            ;
      QUIT;

   %END; /* Szenario ausführen */
%END; /* über alle Testszenarien */

%GOTO exit;
%errexit:
   %PUT;
   %PUT =========================== Fehler! runSASUnit wird abgebrochen! ================================;
   %PUT;
   %PUT;
%exit:
PROC DATASETS NOLIST NOWARN LIB=%scan(&d_dir,1,.);
   DELETE %scan(&d_dir,2,.);
   DELETE %scan(&d_examinee,2,.);
QUIT;
%MEND runSASUnit;
/** \endcond */
