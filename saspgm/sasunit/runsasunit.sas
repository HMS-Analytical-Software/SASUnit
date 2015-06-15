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
      d_scenariosToRun
      d_scn_pre
      i
      l_auto 
      l_autonr
      l_c_scnid
      l_changed
      l_dorun 
      l_error_count 
      l_filename
      l_filled
      l_lstfile
      l_macname
      l_nscn 
      l_nscncount
      l_rc
      l_result
      l_result0 
      l_result1 
      l_result2
      l_scn 
      l_scndesc
      l_scnid 
      l_scnlogfullpath
      l_source
      l_sysrc
      l_warning_count
      l_max_exaid
   ;

   %LET l_macname=&sysmacroname;

   %_tempFileName(d_scenariosToRun);
   %_tempFileName(d_scn_pre);

   /*-- check if testdatabase can be accessed -----------------------------------*/
   %IF %_handleError(&l_macname.
                    ,NoTestDB
                    ,NOT %sysfunc(exist(target.tsu)) OR NOT %symexist(g_project)
                    ,%nrstr(test database cannot be accessed, call initSASUnit before runSASUnit)
                    ,i_verbose=&g_verbose.
                    )
      %THEN %GOTO errexit;

   /*-- parameter i_recursive ---------------------------------------------------*/
   %IF "&i_recursive." NE "1" %THEN %LET i_recursive=0;

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

   data &d_scn_pre.;
      set &d_dir.;
   run;

   /* check which test scenarios must be run */
   %_checkScenario(i_examinee        = target.exa
                  ,i_scn_pre         = &D_SCN_PRE.
                  ,o_scenariosToRun  = &d_scenariosToRun.
                  );

   /*-- if scenario already exists and has been changed: delete scenario files-----*/
   %_deletescenariofiles(i_scenariosToRun=&d_scenariosToRun.
                        );

   PROC SQL NOPRINT;
      DELETE * FROM target.cas WHERE cas_scnid in (select scn_id from &d_scenariosToRun where dorun=1);
      DELETE * FROM target.tst WHERE tst_scnid in (select scn_id from &d_scenariosToRun where dorun=1);
   QUIT;

   /*-- if scenario not present in test database: create new scenario --------*/
   DATA target.scn;
      SET target.scn &d_scenariosToRun.(where=(insertIntoDB=1) in=add);
         drop dorun insertIntoDB;
   RUN;

   /* Prepare Loop */
   PROC SQL noprint;
      select count(scn_id) into :l_nscn
         from &d_scenariosToRun.
      ;
   QUIT;

   /*-- loop over all test scenarios --------------------------------------------*/
   %DO i=1 %TO &l_nscn.;

      DATA _NULL_;
         in = &i.;
         set &d_scenariosToRun. point=in;
         Call Symputx('l_scnid',    scn_id,      'L');
         Call Symputx('l_dorun',    dorun,       'L');
         Call Symputx('l_filename', scn_path,    'L');
         Call Symputx('l_changed',  scn_changed, 'L');
         stop;
      RUN;

      %IF &l_dorun. %THEN %DO;
         %PUT ======== test scenario &l_scnid (&l_filename.) will be run ========;
         %PUT;
         %PUT;
      %END;
      %ELSE %DO;
         %PUT ======== test scenario &l_scnid (&l_filename.) will not be run ==;
         %PUT;
         %PUT;
      %END;

      /*-- start test scenario if necessary -------------------------------------*/
      %IF &l_dorun %THEN %DO;

         /*-- save description and start date and time of scenario --------------*/
         %_getPgmDesc (i_pgmfile=&l_filename, r_desc=l_scndesc)
         PROC SQL NOPRINT;
            UPDATE target.scn SET
               scn_desc    = "&l_scndesc"
              ,scn_start   = %sysfunc(datetime())
              ,scn_changed = &l_changed.
            WHERE scn_id = &l_scnid
            ;
         QUIT;
       
         %LET l_c_scnid        = %substr(00&l_scnid.,%length(&l_scnid));
         %LET l_scnlogfullpath = &g_log/&l_c_scnid..log;
         %_runProgramSpawned(i_program          =&l_filename
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

            %*** Treat missing scenario as failed and treat scenario with errors in scenario log as failed ***;
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

            UPDATE &d_scenariosToRun
               SET 
                   dorun          = 0
               WHERE 
                  scn_id = &l_scnid.
               ;         QUIT;

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
   PROC DATASETS NOLIST NOWARN LIB=%scan(&d_examinee,1,.);
      DELETE %scan(&d_dir,2,.);
      DELETE %scan(&d_examinee,2,.);
      DELETE %scan(&d_scenariosToRun,2,.);
      DELETE %scan(&d_scn_pre,2,.);
   QUIT;
%MEND runSASUnit;
/** \endcond */
