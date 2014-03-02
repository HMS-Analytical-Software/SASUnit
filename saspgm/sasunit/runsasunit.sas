 /**
   \file
   \ingroup    SASUNIT_CNTL

   \brief      Invokes one or more test scenarios.

               Procedure:
               - Check whether test repository was already initialized with \%initSASUnit, if not: End.
               - Determination of the test scenarios to be invoked.
               - For every test scenario:
                 - Check whether it already exists in the test repository.
                 - if yes: Check whether the test scenario was changed since last invocation.
                 - if no:  Creation of the test scenario in the test repository.
                 - In case the test scenario is new or changed:
                   - The test scenario is executed in an own SAS session which is initialized
                     by _scenario.sas .
                     All test results are gathered in the test repository. 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
					Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_source       test scenario (path to SAS program) 
                           resp. test scenarios (search pattern with structure directory\filenamepattern, 
                           e.g. test\*_test.sas for all files that end with _test.sas
                           If the given path is not absolute, the path specified in the parameter i_root of 
                           \%initSASUnit will be used as prefix to the specified path
   \param   i_recursive    if a search pattern is specified: 1 .. subdirectories of &i_source are searched, too.
                           default 0 ... do not search subdirectories.
                           
*/ /** \cond */ 

%MACRO runSASUnit(i_source     =
                 ,i_recursive  = 0
                 );

   %LOCAL 
      l_macname
      d_dir  
      d_examinee 
      l_source
      l_nscn 
      i
      l_auto 
      l_autonr
      l_scn 
      l_scnid 
      l_dorun 
      l_scndesc 
      l_sysrc
      l_rc
      l_scnlogfullpath
      l_filled
      l_lstfile
      l_error_count 
      l_warning_count
      l_result0 
      l_result1 
      l_result2
      l_result
      l_nscncount
      l_c_scnid
      l_sysrc
   ;

   %LET l_macname=&sysmacroname;

   %_tempFileName(d_dir);
   %_tempFileName(d_examinee);

   /*-- check if testdatabase can be accessed -----------------------------------*/
   %IF %_handleError(&l_macname.
                    ,NoTestDB
                    ,NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project)
                    ,%nrstr(test database cannot be accessed, call %initSASUnit before %runSASUnit)
                    ,i_verbose=&g_verbose.
                    )
      %THEN %GOTO errexit;

   /*-- parameter i_recursive ---------------------------------------------------*/
   %IF "&i_recursive" NE "1" %THEN %LET i_recursive=0;

   /*-- find out all test scenarios ---------------------------------------------*/
   %LET l_source = %_abspath(&g_root, &i_source);
   %_dir(i_path=&l_source, i_recursive=&i_recursive, o_out=&d_dir)
   %IF %_handleError(&l_macname.
                    ,NoSourceFiles
                    ,%_nobs(&d_dir) EQ 0
                    ,Error in parameter i_source: no test scenarios found
                    ,i_verbose=&g_verbose.
                    ) 
      %THEN %GOTO errexit;

   %DO i=1 %TO %_nobs(&d_dir); 
      %LOCAL 
         l_scnfile&i 
         l_scnchanged&i
      ;
   %END;

   DATA _null_;
      SET &d_dir;
      CALL symput ('l_scnfile' !! left(put(_n_,8.)), trim(filename));
      CALL symput ('l_scnchanged' !! left(put(_n_,8.)), compress(put(changed,12.)));
      CALL symput ('l_nscn', compress(put(_n_,8.)));
   RUN;

   /*-- find out all possible units under test ----------------------------------*/
   %LET l_auto=&g_sasautos;
   %LET l_autonr=0;
   %DO %WHILE("&l_auto" ne "");  
      %LET l_auto=%quote(&l_auto/);
      %_dir(i_path=&l_auto.*.sas, o_out=&d_dir)
      data &d_examinee;
         set %IF &l_autonr>0 %THEN &d_examinee; &d_dir(in=indir);
         if indir then auton=&l_autonr.+2;
      run; 
      %LET l_autonr = %eval(&l_autonr+1);
      %LET l_auto=;
      %IF %symexist(g_sasautos&l_autonr) %THEN %LET l_auto=&&g_sasautos&l_autonr;
   %END;
   %LET l_auto=&g_sasunit;
   %LET l_auto=%quote(&l_auto/);
   %_dir(i_path=&l_auto.*.sas, o_out=&d_dir)
   data &d_examinee;
      set &d_examinee &d_dir(in=indir);
      if indir then auton=0;
   run; 
   %LET l_auto=&g_sasunit_os;
   %LET l_auto=%quote(&l_auto/);
   %_dir(i_path=&l_auto.*.sas, o_out=&d_dir)
   data &d_examinee;
      set &d_examinee &d_dir(in=indir);
      if indir then auton=1;
   run; 

   /*-- loop over all test scenarios --------------------------------------------*/
   %DO i=1 %TO &l_nscn;

      %LET l_scn = %_stdPath(&g_root, &&l_scnfile&i);

      /* check if test scenario must be run */
      %_checkScenario(
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
         /*-- delete corresponding files -----*/
         %_deletescenariofiles(i_scnid=&l_scnid.);  
      
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
         %_getPgmDesc (i_pgmfile=&&l_scnfile&i, r_desc=l_scndesc)
         PROC SQL NOPRINT;
            UPDATE target.scn SET
               scn_desc  = "&l_scndesc"
              ,scn_start = %sysfunc(datetime())
            WHERE scn_id = &l_scnid
            ;
         QUIT;
       
         %LET l_c_scnid        = %substr(00&l_scnid.,%length(&l_scnid));
         %LET l_scnlogfullpath = &g_log/&l_c_scnid..log;
         %_runProgramSpawned(i_program          =&&l_scnfile&i
                            ,i_scnid            =&l_c_scnid.
                            ,i_generateMcoverage=&g_testcoverage.
                            ,r_sysrc            =l_sysrc
                            );    
                     
         /*-- delete listing if empty -------------------------------------------*/
         %LET l_filled=0;
         %LET l_lstfile=&g_testout/%substr(00&l_scnid,%length(&l_scnid)).lst;
         %IF %SYSFUNC(FILEEXIST("&l_lstfile")) %THEN %DO;
           DATA _null_;
              INFILE "&l_lstfile";
              INPUT;
              CALL symput ('l_filled','1');
              STOP;
           RUN;
         %END;
         %IF NOT &l_filled %THEN %DO;
            %LET l_filled=%_delfile(&l_lstfile);
         %END;

         /*-- save metadata of test scenario ------------------------------------*/
         /* scan log for errors outside test cases */
         %_checklog (
             i_logfile = &l_scnlogfullpath.
            ,i_error   = &g_error.
            ,i_warning = &g_warning.
            ,r_errors  = l_error_count
            ,r_warnings= l_warning_count
         )

         PROC SQL NOPRINT;
            /* determine results of the test cases */
            %*** Treat missing scenario as error ***;
            %let l_result=2;

            SELECT max (cas_res) INTO :l_result FROM target.cas WHERE cas_scnid=&l_scnid;

            %*** Treat missing scenario as failed and treat scenario wit errors in scenario log as failed ***;
            %if (&l_result. = . or &l_error_count. > 0) %then %let l_result=2;
            
            UPDATE target.scn
               SET 
                   scn_end          = %sysfunc(datetime())
                  ,scn_rc           = &l_sysrc.
                  ,scn_errorcount   = &l_error_count.
                  ,scn_warningcount = &l_warning_count.
                  ,scn_res          = &l_result.
               WHERE 
                  scn_id = &l_scnid.
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

         /* ensure that dummy entry for inexisting scenario is present in test database, to be able to report it later
         */
         %LET l_scn = %_stdPath(&g_root., &l_source.);

         %LET l_nscncount = 0;
         PROC SQL NOPRINT;
            SELECT Count(scn_id)
               INTO :l_nscncount SEPARATED BY ''
            FROM target.scn
            WHERE Upcase(scn_path) = "%UPCASE(&l_scn.)";
         QUIT;

         %IF %EVAL(&l_nscncount. EQ 0) %THEN %DO;

            %LET l_scndesc = %STR(Scenario not found - has to fail!);
           
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
                     ,2
                  )
               ;
            QUIT;

         %END; /* if scenario is not present in database */

      %END;

%exit:
   PROC DATASETS NOLIST NOWARN LIB=%scan(&d_dir,1,.);
      DELETE %scan(&d_dir,2,.);
      DELETE %scan(&d_examinee,2,.);
   QUIT;
%MEND runSASUnit;
/** \endcond */
