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
*/ /** \cond */ 

/* change log
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
%LOCAL d_dir  d_examinee l_source; 
%_sasunit_tempFileName(d_dir);
%_sasunit_tempFileName(d_examinee);

/*-- check if testdatabase can be accessed -----------------------------------*/
%IF %_sasunit_handleError(&l_macname, NoTestDB, 
   NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project), 
   %nrstr(test database cannot be accessed, call %initSASUnit before %runSASUnit))
   %THEN %GOTO errexit;

/*-- parameter i_recursive ---------------------------------------------------*/
%IF "&i_recursive" NE "1" %THEN %LET i_recursive=0;

/*-- find out all test scenarios ---------------------------------------------*/
%LET l_source = %_sasunit_abspath(&g_root, &i_source);
%_sasunit_dir(i_path=&l_source, i_recursive=&i_recursive, o_out=&d_dir)
%IF %_sasunit_handleError(&l_macname, NoSourceFiles, 
   %_sasunit_nobs(&d_dir) EQ 0, 
   Error in parameter i_source: no test scenarios found) 
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

/*-- find out all possible units under test ----------------------------------*/
%LOCAL l_auto l_autonr;
%LET l_auto=&g_sasautos;
%LET l_autonr=0;
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

/*-- loop over all test scenarios --------------------------------------------*/
%LOCAL l_scn l_scnid l_dorun l_scndesc l_sysrc;
%DO i=1 %TO &l_nscn;

   %LET l_scn = %_sasunit_stdPath(&g_root, &&l_scnfile&i);

   /* check if test scenario must be run */
   %_sasunit_checkScenario(
      i_scnfile = &&l_scnfile&i
     ,i_changed = &&l_scnchanged&i
     ,i_dir     = &d_examinee
     ,r_scnid   = l_scnid
     ,r_run     = l_dorun
   )

   /*-- if scenario not present in test database: create new scenario --------*/
   %IF &l_scnid = 0 %THEN %DO;
      PROC SQL NOPRINT;
         SELECT max(scn_id) INTO :l_scnid FROM target.scn;
         %IF &l_scnid=. %THEN %LET l_scnid=0;
         %LET l_scnid = %eval(&l_scnid+1);
         INSERT INTO target.scn VALUES (
             &l_scnid
            ,"&l_scn"
            ,"",.,.,.,.,.,.
         );
      QUIT;
   %END;
   /*-- if scenario already exists and has been changed: delete scenario -----*/
   %ELSE %IF &l_dorun %THEN %DO;
      PROC SQL NOPRINT;
         DELETE FROM target.cas WHERE cas_scnid = &l_scnid;
         DELETE FROM target.tst WHERE tst_scnid = &l_scnid;
      QUIT;
   %END;

   %IF &l_dorun %THEN %DO;
      %PUT ======== test scenario &l_scnid (&l_scn) will be run ========;
      %PUT;
      %PUT;
   %END;
   %ELSE %DO;
      %PUT ======== test scenario &l_scnid (&l_scn) will not be run ==;
      %PUT;
      %PUT;
   %END;

   /*-- start test scenario if necessary -------------------------------------*/
   %IF &l_dorun %THEN %DO;

      /*-- save description and start date and time of scenario --------------*/
      %_sasunit_getPgmDesc (i_pgmfile=&&l_scnfile&i, r_desc=l_scndesc)
      PROC SQL NOPRINT;
         UPDATE target.scn SET
            scn_desc  = "&l_scndesc"
           ,scn_start = %sysfunc(datetime())
         WHERE scn_id = &l_scnid
         ;
      QUIT;
 
      /*-- prepare sasuser ---------------------------------------------------*/
      DATA _null_;
         FILE "%sysfunc(pathname(work))/x.cmd";
         PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
         PUT "&g_makedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %IF %length(&g_sasuser) %THEN %DO;
         PUT "&g_copydir ""&g_sasuser"" ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      %END;
      RUN;
      %if &sysscp. = LINUX %then %do;
          %_sasunit_xcmd(chmod u+x "%sysfunc(pathname(work))/x.cmd")
      %end;
      %_sasunit_xcmd("%sysfunc(pathname(work))/x.cmd")
      %LOCAL l_rc;
      %LET l_rc=_sasunit_delfile(%sysfunc(pathname(work))/x.cmd);
         
      /*-- run test scenario in a new process --------------------------------*/
      %LOCAL l_parms l_parenthesis;
      %LET l_parms=;
      %LET l_parenthesis=(;
      %IF "&g_autoexec" NE "" %THEN %DO;
         %LET l_parms=&l_parms -autoexec ""&g_autoexec"";
      %END;
      %IF "&g_sascfg" NE "" %THEN %DO;
         %LET l_parms=&l_parms -config ""&g_sascfg"";
      %END;
      %ELSE %IF %length(%sysfunc(getoption(config))) NE 0 AND %index(%quote(%sysfunc(getoption(config))),%bquote(&l_parenthesis)) NE 1 %THEN %DO; 
         %LET l_parms=&l_parms -config ""%sysfunc(getoption(config))"";
      %END; 

      %LOCAL
         l_scnlogfullpath
      ;
      %LET l_scnlogfullpath = &g_log/%substr(00&l_scnid.,%length(&l_scnid)).log;

      DATA _null_;
         ATTRIB
            _sCmdString LENGTH = $32000
         ;
         FILE 
         "%sysfunc(pathname(work))/xx.cmd"
            LRECL=32000
         ;
         _sCmdString = 
         """" !! &g_sasstart !! """"
            !! " " 
            !! "&l_parms.
            -sysin ""&&l_scnfile&i""
            -initstmt ""%nrstr(%%%_sasunit_scenario%(io_target=)&g_target%nrstr(%);%%%let g_scnid=)&l_scnid.;""
            -log   ""&l_scnlogfullpath.""
            -print ""&g_testout/%substr(00&l_scnid.,%length(&l_scnid)).lst""
            &g_splash
            -noovp
            -nosyntaxcheck
            -mautosource
            -mcompilenote all
            -sasautos ""&g_sasunit""
            -sasuser ""%sysfunc(pathname(work))/sasuser""
            -termstmt ""%nrstr(%%%_sasunit_termScenario())""
         ";
         PUT
            _sCmdString
         ;
      RUN;

      %if &sysscp. = LINUX %then %do;
          %_sasunit_xcmd(chmod u+x "%sysfunc(pathname(work))/xx.cmd")
      %end;
     %_sasunit_xcmd("%sysfunc(pathname(work))/xx.cmd")
     
     
      %LET l_rc=_sasunit_delfile(%sysfunc(pathname(work))/xx.cmd);
      %LET l_sysrc = &sysrc;

      /*-- delete sasuser ----------------------------------------------------*/
      DATA _null_;
         FILE "%sysfunc(pathname(work))/x.cmd";
         PUT "&g_removedir ""%sysfunc(pathname(work))/sasuser""&g_endcommand";
      RUN;
      %if &sysscp. = LINUX %then %do;
          %_sasunit_xcmd(chmod u+x "%sysfunc(pathname(work))/x.cmd")
      %end;

      %_sasunit_xcmd("%sysfunc(pathname(work))/x.cmd")
      %LET l_rc=_sasunit_delfile(%sysfunc(pathname(work))/x.cmd);

      /*-- delete listing if empty -------------------------------------------*/
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

      /*-- save metadata of test scenario ------------------------------------*/
      /* scan log for errors outside test cases */
      %LOCAL 
         l_error_count 
         l_warning_count
      ;
      %_sasunit_checklog (
          i_logfile = &l_scnlogfullpath.
         ,i_error   = &g_error.
         ,i_warning = &g_warning.
         ,r_errors  = l_error_count
         ,r_warnings= l_warning_count
      )

      PROC SQL NOPRINT;
         %LOCAL 
            l_result0 
            l_result1 
            l_result2
         ;
         /* determine results of the test cases */
         SELECT count(*) INTO :l_result0 FROM target.cas WHERE cas_scnid=&l_scnid AND cas_res=0;
         SELECT count(*) INTO :l_result1 FROM target.cas WHERE cas_scnid=&l_scnid AND cas_res=1;
         SELECT count(*) INTO :l_result2 FROM target.cas WHERE cas_scnid=&l_scnid AND cas_res=2;
         
         %LOCAL l_result;
         %IF &l_result1 GT 0 %THEN %DO;
            %LET l_result=1; /* error occured */
         %END;   
         %ELSE %IF &l_result2 GT 0 %THEN %DO;
            %LET l_result=2; /* manual occured */
         %END;   
         %ELSE %IF %EVAL(%SYSFUNC(sum(&l_result0., &l_result1., &l_result2.)) EQ 0) %THEN %DO;
            %LET l_result=1; /* no test cases -> show as error occurred */
         %END;
         %ELSE %IF &l_error_count. GT 0 %THEN %DO;
            %LET l_result=1; /* error(s) in scenario log -> show as error occurred */
         %END;
         %ELSE %DO;
            %LET l_result=0; /* everything OK */
         %END;

         UPDATE target.scn
            SET 
                scn_end          = %sysfunc(datetime())
               ,scn_rc           = &l_sysrc.
               ,scn_errorcount   = &l_error_count.
               ,scn_warningcount = &l_warning_count.
               ,scn_res          = &l_result.
            WHERE 
               scn_id = &l_scnid
            ;
      QUIT;

   %END; /* run scenario */
%END; /* loop for all scenarios */

%GOTO exit;
%errexit:
   %PUT;
   %PUT =========================== Error! runSASUnit aborted! ==========================================;
   %PUT;
   %PUT;

   %IF %EVAL("%UPCASE(&g_error_code.)" EQ "%UPCASE(NoSourceFiles)") %THEN %DO;

      /* create dummy entry for inexisting scenario, to be able to report it later
      */
      %LET l_scndesc = %STR(scenario not found);
      %LET l_scn = %_sasunit_stdPath(&g_root., &l_source.);

      PROC SQL NOPRINT;
         SELECT max(scn_id) INTO :l_scnid FROM target.scn;
         %IF &l_scnid=. %THEN %LET l_scnid=0;
         %LET l_scnid = %eval(&l_scnid+1);
         INSERT INTO target.scn 
            ( 
              scn_id
             ,scn_path
             ,scn_desc
             ,scn_start
             ,scn_end
             ,scn_rc
             ,scn_errorcount
             ,scn_warningcount
             ,scn_res
            )
            VALUES 
            (
                &l_scnid
               ,"&l_scn."
               ,"&l_scndesc."
               ,.
               ,.
               ,.
               ,.
               ,.
               ,1
            )
         ;
      QUIT;

   %END;

%exit:
PROC DATASETS NOLIST NOWARN LIB=%scan(&d_dir,1,.);
   DELETE %scan(&d_dir,2,.);
   DELETE %scan(&d_examinee,2,.);
QUIT;
%MEND runSASUnit;
/** \endcond */
