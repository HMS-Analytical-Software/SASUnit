/**
   \file
   \ingroup    SASUNIT_CNTL 

   \brief      Initialization of a test suite that may comprise several test scenarios. 

               An existing test repository is opened or a new test repository is created.
               It conists of two steps:
               - validate configuration of initSASUnit
               - Setting up SASUnit session

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_root              optional: root path for all other paths except i_sasunit, is used for paths that do not begin 
                                with a drive letter or a slash/backslash
   \param   io_target           Path for the test repository and the generated documentation, has to exist
   \param   i_overwrite         0 (default) .. create test repository only in case it does not already exist
                                1 .. test repository is always created newly 
   \param   i_project           optional: (in case test repository already exists): name of project
   \param   i_sasunit           optional: absolute installation path of SAS programs from SASUnit. It is checked whether installationpath
                                is starting with path in environment variable SASUNIT_ROOT set by script file
   \param   i_sasautos          optional: i_sasautos, i_sasautos1 .. i_sasautos9: search paths for the programs 
                                under test and other sas macros invoked in test scenarios or programs under test
                                (the filename SASAUTOS predefined by SAS is always included at the beginning of
                                the search path)
   \param   i_autoexec          optional: a SAS program that is always invoked before a start of a test scenario
   \param   i_sascfg            optional: a SAS configuration file that is used for every invocation of a
                                test scenario
   \param   i_sasuser           optional: Template for a SASUSER directory including configuration catalogs.
                                A temporary SASUSER directory is created, existing only for the duration of a 
                                test scenario, in which all files are copied out of the specified directory.
   \param   i_testdata          optional: directory containing test data, has to exist in case parameter is set
                                (is accessed readonly)
   \param   i_refdata           optional: directory containing reference data, has to exist in case parameter is set
                                (is accessed readonly)
   \param   i_doc               optional: directory containing specification documents, etc., has to exist
                                in case parameter is set (is accessed readonly)
   \param   i_testcoverage      optional: controls whether assessment of test coverage is activated
                                0 .. no assessment of test coverage
                                1 (default) .. assessment of test coverage is activated
   \param   i_verbose           optional: controls whether results of asserts are written to the SAS log
                                0 (default).. no results written to SAS log
                                1 .. results are written to SAS log
   \param   i_crossref          optional: controls whether the cross reference is created
                                0  .. cross reference will not be created 
                                1 (default).. cross reference will be created                                                      
   \param   i_crossrefsasunit   optional: controls whether the SASUnit core macros are included in the scan for dependencies
                                0 (default) .. SASUnit core macros are not included
                                1 .. SASUnit core macros are included
   \param   i_language          optional: specifying the language that should be used. This parameter is necessary to avoid using the respective environment variable under linux 
                                supported values: "en" / "de"
                                default: %sysget(SASUNIT_LANGUAGE)
*//** \cond */ 

%MACRO initSASUnit(i_root            = 
                  ,io_target         = 
                  ,i_overwrite       =0
                  ,i_project         = 
                  ,i_sasunit         =%sysget(SASUNIT_ROOT)/saspgm/sasunit
                  ,i_sasautos        =
                  ,i_sasautos1       =
                  ,i_sasautos2       =
                  ,i_sasautos3       =
                  ,i_sasautos4       =
                  ,i_sasautos5       =
                  ,i_sasautos6       =
                  ,i_sasautos7       =
                  ,i_sasautos8       =
                  ,i_sasautos9       =
                  ,i_sasautos10      =
                  ,i_sasautos11      =
                  ,i_sasautos12      =
                  ,i_sasautos13      =
                  ,i_sasautos14      =
                  ,i_sasautos15      =
                  ,i_sasautos16      =
                  ,i_sasautos17      =
                  ,i_sasautos18      =
                  ,i_sasautos19      =
                  ,i_sasautos20      =
                  ,i_sasautos21      =
                  ,i_sasautos22      =
                  ,i_sasautos23      =
                  ,i_sasautos24      =
                  ,i_sasautos25      =
                  ,i_sasautos26      =
                  ,i_sasautos27      =
                  ,i_sasautos28      =
                  ,i_sasautos29      =
                  ,i_autoexec        =
                  ,i_sascfg          =
                  ,i_sasuser         =
                  ,i_testdata        = 
                  ,i_refdata         = 
                  ,i_doc             = 
                  ,i_testcoverage    =1
                  ,i_verbose         =0
                  ,i_crossref        =1
                  ,i_crossrefsasunit =0
                  ,i_language        =%sysget(SASUNIT_LANGUAGE)
                  );

   %GLOBAL g_version g_revision g_db_version g_verbose g_error g_warning g_note g_runMode g_language;

   %LET g_version    = 2.1.0;
   %LET g_db_version = 2.1;
   %LET g_revision   = $Revision$;
   %LET g_revision   = %scan(&g_revision,2,%str( $:));

   /******************************************************************************/
   /*** Step one                                                               ***/
   /***    Check supported OSes and SAS Versions                               ***/
   /***    Validate configuration of initSASUnit                               ***/
   /***       Check all paths for existence                                    ***/
   /***       Check boolean parameters vs default value                        ***/
   /******************************************************************************/

   /*-- check for operation system and SAS version -------------------------------*/
   %IF (%_checkRunEnvironment(&i_verbose.) ne 0) %THEN %GOTO errexit;

   %LOCAL 
      l_macname
      l_current_dbversion
      l_target_abs
      l_newdb
      l_rc
      l_project
      l_root    
      l_sasunitroot l_sasunit l_sasunit_os l_abspath_sasunit_os
      l_abs 
      l_autoexec    l_autoexec_abs
      l_sascfg      l_sascfg_abs
      l_sasuser     l_sasuser_abs
      l_testdata    l_testdata_abs 
      l_refdata     l_refdata_abs      
      l_doc         l_doc_abs  
      l_sasautos    l_sasautos1  l_sasautos2  l_sasautos3  l_sasautos4  l_sasautos5  l_sasautos6  l_sasautos7  l_sasautos8  l_sasautos9 
      l_sasautos10  l_sasautos11 l_sasautos12 l_sasautos13 l_sasautos14 l_sasautos15 l_sasautos16 l_sasautos17 l_sasautos18 l_sasautos19 
      l_sasautos20  l_sasautos21 l_sasautos22 l_sasautos23 l_sasautos24 l_sasautos25 l_sasautos26 l_sasautos27 l_sasautos28 l_sasautos29 
      l_sasautos_abs
      i
      l_work
      l_sysrc
      l_cmdfile    
      l_overwrite
      l_testcoverage
      _root _sasunit
   ;
   
   /*-- Initialize error handler --------------------------------------------------------*/
   %_initErrorHandler;
   %LET l_macname=&sysmacroname;

   /*-- check value of parameters i_verbose, i_crossref and i_crossrefsasunit, 
        if one of them has a value other than default, 
        they will be set to 1/0 in order to assure that values will only be 0 or 1 ------*/
   %IF (&i_crossrefsasunit. NE 0) %THEN %DO;
      %LET i_crossrefsasunit = 1;
   %END;
   %IF (&i_crossref. NE 1) %THEN %DO;
      %LET i_crossref = 0;
   %END;
   %IF (&i_verbose. NE 0) %THEN %DO;
      %LET i_verbose = 1;
   %END;
   %LET g_verbose   = &i_verbose;
   %IF (&i_testcoverage. NE 1)%THEN %DO;
      %LET i_testcoverage = 0;
   %END;
   %IF (&i_overwrite NE 0) %THEN %DO;
      %LET i_overwrite=1;
   %END;

   /*-- check shell values vs. parameters ------------------------------------------*/
   %LET l_testcoverage=%sysget (SASUNIT_COVERAGEASSESSMENT);
   %IF (&l_testcoverage. ne ) %THEN %DO;
      %IF (&l_testcoverage. ne &i_testcoverage.) %THEN %DO;
          %PUT &G_WARNING.:(SASUNIT) Shell variable SASUNIT_COVERAGEASSESSMENT not passed correctly to parameter i_testcoverage!;
      %END;
   %END;
   %LET l_overwrite=%sysget(SASUNIT_OVERWRITE);
   %IF (&l_overwrite. ne ) %THEN %DO;
      %IF (&l_overwrite. ne &i_overwrite.) %THEN %DO;
          %PUT &G_WARNING.:(SASUNIT) Shell variable SASUNIT_OVERWRITE not passed correctly to parameter i_overwrite!;
      %END;
   %END;

   /*-- Resolve relative root path like ../. to an absolute root path ----------*/
   libname _tmp "&i_root.";
   %let l_root=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- Get SASUnit root path from environment variable ----------*/
   libname _tmp "%sysget(SASUNIT_ROOT)";
   %let l_sasunitroot=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- Get SASUnit macro paths ----------*/
   libname _tmp "&i_sasunit.";
   %let l_sasunit=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /* Read values from test db if it exists */
   %IF (%sysfunc (exist (target.tsu))) %THEN %DO;
      PROC SQL NOPRINT;
         SELECT tsu_root     INTO :_root      FROM target.tsu;
         SELECT tsu_project  INTO :l_project  FROM target.tsu;
         SELECT tsu_sasunit  INTO :_sasunit   FROM target.tsu;
         SELECT tsu_sasautos INTO :l_sasautos FROM target.tsu;
      %DO i=1 %TO 29;
         SELECT tsu_sasautos&i. INTO :l_sasautos&i. FROM target.tsu;
      %END; /* i=1 %TO 29 */
         SELECT tsu_autoexec INTO :l_autoexec FROM target.tsu;
         SELECT tsu_sascfg   INTO :l_sascfg   FROM target.tsu;
         SELECT tsu_sasuser  INTO :l_sasuser  FROM target.tsu;
         SELECT tsu_testdata INTO :l_testdata FROM target.tsu;
         SELECT tsu_refdata  INTO :l_refdata  FROM target.tsu;
         SELECT tsu_doc      INTO :l_doc      FROM target.tsu;
      QUIT;
   %END;

   /*-- if test coverage should be assessed: check SAS version --------------*/
   %IF (&i_testcoverage. EQ 1) %THEN %DO;
      %IF %_handleError(&l_macname.
                    ,TestCoverageNotSupported
                    ,(&sysver. = 9.2)
                    ,Error SAS Option MCOVERAGE is only supported since SAS 9.3
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   %END;

   /*-- root folder -------------------------------------------------------------*/
   %IF "&l_root" = "" %THEN %DO;
      %LET l_root=&_root;
   %END;
   %IF %_handleError(&l_macname.
                    ,InvalidRoot
                    ,"&l_root" NE "" AND NOT %_existdir(&l_root)
                    ,%str(Error in parameter i_root: folder must exist when specified)
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check for target directory ----------------------------------------------*/
   %LET l_target_abs=%_abspath(&i_root,&io_target);
   %IF %_handleError(&l_macname.
                    ,InvalidTargetDir
                    ,"&l_target_abs" EQ "" OR NOT %_existDir(&l_target_abs)
                    ,Error in parameter io_target: target directory does not exist
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   LIBNAME target "&l_target_abs";
   %IF %_handleError(&l_macname
                    ,ErrorTargetLib
                    ,%quote(&syslibrc.) NE 0
                    ,Error in parameter io_target: target directory &l_target_abs. cannot be assigned as a SAS library
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   %IF %_handleError(&l_macname.
                    ,ErrorTargetLibNotWritable
                    ,%quote(&syserr.) NE 0
                    ,Error in parameter io_target: target directory not writeable
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- project name ------------------------------------------------------------*/
   %IF "&i_project" = "" %THEN %DO;
      %LET l_project=&l_project;
   %END;
   %ELSE %DO;
      %LET l_project=&i_project;
   %END;
   %IF %_handleError(&l_macname.
                    ,MissingProjectName
                    ,"&l_project" EQ ""
                    ,Parameter i_project must be specified
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- sasunit root folder -------------------------------------------------------------*/
   %LET l_sasunitroot=&l_sasunitroot;
   %IF %_handleError(&l_macname.
                    ,InvalidRoot
                    ,"&l_sasunitroot" NE "" AND NOT %_existdir(&l_sasunitroot)
                    ,%str(Error in parameter l_sasunitroot: folder must exist when specified)
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- sasunit folder ----------------------------------------------------------*/
   %IF "&l_sasunit" = "" %THEN %DO;
      %LET l_sasunit=&_sasunit;
   %END;
   %LET l_abs=%_abspath(&l_root.,&l_sasunit.);
   %IF %_handleError(&l_macname.
                    ,InvalidSASUnitDir
                    ,"&l_abs." EQ "" OR NOT %sysfunc(fileexist(&l_abs./_scenario.sas))
                    ,Error in parameter i_sasunit: SASUnit macro programs not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check for correct sasunit path ----------------------------------------------*/
   %IF %_handleError(&l_macname.
                    ,WrongSASUnitPath
                    ,%index (&l_sasunit.,&l_sasunitroot.) NE 1
                    ,Invalid path to SASUnit - SASUnit root is &l_sasunitroot. - SASUnit path is &l_sasunit.
                    ,i_verbose=&i_verbose.
                    ) 
   %THEN %GOTO errexit;

   /*-- check autocall paths ----------------------------------------------------*/
   %LET l_sasautos=&l_sasautos;
   %IF "&i_sasautos" NE "" %THEN %LET l_sasautos=&i_sasautos;
   %LET l_sasautos_abs=%_abspath(&l_root,&l_sasautos);
   %IF %_handleError(&l_macname.
                    ,InvalidSASAutos
                    ,"&l_sasautos_abs" NE "" AND NOT %_existdir(&l_sasautos_abs)
                    ,Error in parameter i_sasautos: folder not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   
   %DO i=1 %TO 29;
      %LET l_sasautos&i.=&&l_sasautos&i..;
      %IF "&&i_sasautos&i" NE "" %THEN %LET l_sasautos&i.=&&i_sasautos&i..;
      %LET l_sasautos_abs=%_abspath(&l_root,&&l_sasautos&i..);
      %IF %_handleError(&l_macname.
                       ,InvalidSASAutosN
                       ,"&l_sasautos_abs" NE "" AND NOT %_existdir(&l_sasautos_abs)
                       ,Error in parameter i_sasautos&i: folder not found
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;
   %END; /* i=1 %TO 29 */

   /*-- check if autoexec exists where specified --------------------------------*/
   %LET l_autoexec=&l_autoexec;
   %*** because we need to specify a real blank (%str( )) as parameter, ***;
   %*** we need to use a different method of assignment.                ***;
   %IF "&i_autoexec" NE "" %THEN %LET l_autoexec=%trim(&i_autoexec);
   %LET l_autoexec_abs=%_abspath(&l_root,&l_autoexec);
   %IF %_handleError(&l_macname.
                    ,AutoexecNotFound
                    ,"&l_autoexec" NE "" AND NOT %sysfunc(fileexist(&l_autoexec_abs%str( )))
                    ,Error in parameter i_autoexec: file not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check if sascfg exists where specified ----------------------------------*/
   %LET l_sascfg=&l_sascfg;
   %IF "&i_sascfg" NE "" %THEN %LET l_sascfg=&i_sascfg;
   %LET l_sascfg_abs=%_abspath(&l_root,&l_sascfg);
   %IF %_handleError(&l_macname.
                    ,SASCfgNotFound
                    ,"&l_sascfg" NE "" AND NOT %sysfunc(fileexist(&l_sascfg_abs%str( )))
                    ,Error in parameter i_sascfg: file not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check sasuser folder ----------------------------------------------------*/
   %LET l_sasuser=&l_sasuser;
   %IF "&i_sasuser" NE "" %THEN %LET l_sasuser=&i_sasuser;
   %LET l_sasuser_abs=%_abspath(&l_root,&l_sasuser);
   %IF %_handleError(&l_macname.
                    ,InvalidSasuser
                    ,"&l_sasuser_abs" NE "" AND NOT %_existdir(&l_sasuser_abs)
                    ,Error in parameter i_sasuser: folder not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check test data folder --------------------------------------------------*/
   %LET l_testdata=&l_testdata;
   %IF "&i_testdata" NE "" %THEN %LET l_testdata=&i_testdata;
   %LET l_testdata_abs=%_abspath(&l_root,&l_testdata);
   %IF %_handleError(&l_macname.
                    ,InvalidTestdata
                    ,"&l_testdata_abs" NE "" AND NOT %_existdir(&l_testdata_abs)
                    ,Error in parameter i_testdata: folder not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check reference data folder ---------------------------------------------*/
   %LET l_refdata=&l_refdata;
   %IF "&i_refdata" NE "" %THEN %LET l_refdata=&i_refdata;
   %LET l_refdata_abs=%_abspath(&l_root,&l_refdata);
   %IF %_handleError(&l_macname.
                    ,InvalidRefdata
                    ,"&l_refdata_abs" NE "" AND NOT %_existdir(&l_refdata_abs)
                    ,Error in parameter i_refdata: folder not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- check folder for specification documents --------------------------------*/
   %LET l_doc=&l_doc;
   %IF "&i_doc" NE "" %THEN %LET l_doc=&i_doc;
   %LET l_doc_abs=%_abspath(&l_root,&l_doc);
   %IF %_handleError(&l_macname.
                    ,InvalidDoc
                    ,"&l_doc_abs" NE "" AND NOT %_existdir(&l_doc_abs)
                    ,Error in parameter i_doc: folder not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   /*-- set macro symbols for os commands ---------------------------------------*/
   %IF (&sysscp. = WIN) %THEN %DO;
      %LET l_sasunit_os = &l_sasunit./windows;
   %END;
   %ELSE %IF (%upcase(&sysscpl.) = LINUX) %THEN %DO;
      %LET l_sasunit_os = &l_sasunit./linux;
   %END;
   %ELSE %IF (%upcase(&sysscpl.) = AIX) %THEN %DO;
      %LET l_sasunit_os = &l_sasunit./unix_aix;
   %END;
   %LET l_abspath_sasunit_os=%_abspath(&l_sasunitroot.,&l_sasunit_os.);
   OPTIONS APPEND=(SASAUTOS=("&l_sasunit." "&l_abspath_sasunit_os."));
   OPTIONS NOQUOTELENMAX;

   /*-- os-specific sasunit folder ----------------------------------------------------------*/
   %LET l_sasunit_os=&l_sasunit_os;
   %IF %_handleError(&l_macname.
                    ,InvalidSASUnitDir
                    ,"&l_abspath_sasunit_os." EQ "" OR NOT %sysfunc(fileexist(&l_abspath_sasunit_os./_oscmds.sas))
                    ,Error in parameter i_sasunit: os-specific SASUnit macro programs not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;

   %_readEnvMetadata;

   /******************************************************************************/
   /*** End of Step one                                                        ***/
   /******************************************************************************/

   /*-- Under linux g_language is used in _oscmds -------------------------------------------*/
   /*-- Moving this call after _loadenvironment causes other errors -------------------------*/
   /*-- So g_language is simply set here ----------------------------------------------------*/
   %let g_language=&i_language.;

   %_oscmds;
   
   %_detectSymbols(r_error_symbol=g_error, r_warning_symbol=g_warning, r_note_symbol=g_note);

   %LET l_current_dbversion=0;

   /*-- does the test database exist already? -----------------------------------*/
   %IF &i_overwrite %THEN %LET l_newdb=1;
   %ELSE %LET l_newdb=%eval(NOT %sysfunc(exist(target.tsu)));

   *** Check tsu db version                      ***;
   *** Is there a need to recreate the database? ***;
   %IF &l_newdb. ne 1 %THEN %DO;
      data _null_;
         if (exist ("target.tsu")) then do;
            did = open ("target.tsu");
            if varnum (did, "tsu_dbVersion") then do;
               rc            = fetch (did);
               tsu_dbVersion = getvarc (did, varnum (did, "tsu_dbVersion"));
               call symput ("l_current_dbversion", trim(tsu_dbVersion));
            end;
            did = close(did);
         end;
      run;
      %LET l_newdb=%eval ("&l_current_dbversion." NE "&g_db_version.");
   %END;

   /*-- create test database if necessary ---------------------------------------*/
   %IF &l_newdb %THEN %DO;
      %_createTestDatabase(libref=target)
      %IF %_handleError(&l_macname.
                       ,ErrorCreateDB
                       ,&syserr. NE 0
                       ,Error on creation of test database
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;
   %END; /* %if &l_newdb */

   %IF (&g_runMode. = SASUNIT_BATCH) %THEN %DO;
      /*-- recreate empty folders if necessary -------------------------------------*/
      %IF &l_newdb %THEN %DO;
         /*-- regenerate empty folders ------------------------------------------------*/
         %LET l_cmdfile=%sysfunc(pathname(WORK))/remove_dir.cmd;
         DATA _null_;
            FILE "&l_cmdfile." encoding=pcoem850; /* wg. Umlauten in Pfaden */
            PUT "&g_removedir ""&l_target_abs/log""&g_endcommand";
            PUT "&g_removedir ""&l_target_abs/tst""&g_endcommand";
            PUT "&g_removedir ""&l_target_abs/rep""&g_endcommand";
         RUN;
         %_executeCMDFile(&l_cmdfile.);
         %LET l_rc=%_delfile(&l_cmdfile.);
         %LET rc = %sysfunc (sleep(2,1));
         %LET l_cmdfile=%sysfunc(pathname(WORK))/make_dir.cmd;
         DATA _null_;
            FILE "&l_cmdfile." encoding=pcoem850; /* wg. Umlauten in Pfaden */
            PUT "&g_makedir ""&l_target_abs/log""&g_endcommand";
            PUT "&g_makedir ""&l_target_abs/tst""&g_endcommand";
            PUT "&g_makedir ""&l_target_abs/rep""&g_endcommand";
         RUN;
         %_executeCMDFile(&l_cmdfile.);
         %LET l_rc=%_delfile(&l_cmdfile.);
      %END; /* %if &l_newdb */

      /*-- folder for crossreference json files has to be always recreated -----------*/
      %LET l_cmdfile=%sysfunc(pathname(WORK))/remove_dir.cmd;
      DATA _null_;
         FILE "&l_cmdfile." encoding=pcoem850; /* wg. Umlauten in Pfaden */
         PUT "&g_removedir ""&l_target_abs/tst/crossreference""&g_endcommand";
      RUN;
      %_executeCMDFile(&l_cmdfile.);
      %LET l_rc=%_delfile(&l_cmdfile.);
      %LET rc = %sysfunc (sleep(2,1));
      %LET l_cmdfile=%sysfunc(pathname(WORK))/make_dir.cmd;
      DATA _null_;
         FILE "&l_cmdfile." encoding=pcoem850; /* wg. Umlauten in Pfaden */
         PUT "&g_makedir ""&l_target_abs/tst/crossreference""&g_endcommand";
      RUN;
      %_executeCMDFile(&l_cmdfile.);
      %LET l_rc=%_delfile(&l_cmdfile.);

      /*-- check folders -----------------------------------------------------------*/
      %IF %_handleError(&l_macname.
                       ,NoLogDir
                       ,NOT %_existdir(&l_target_abs./log)
                       ,folder &l_target_abs./log does not exist
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;
      %IF %_handleError(&l_macname.
                       ,NoTstDir
                       ,NOT %_existdir(&l_target_abs./tst)
                       ,folder &l_target_abs./tst does not exist
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;
      %IF %_handleError(&l_macname.
                       ,NoRepDir
                       ,NOT %_existdir(&l_target_abs./rep)
                       ,folder &l_target_abs./rep does not exist
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;
   %END; 
   /*-- update parameters ----------------------------------------------------*/
   PROC SQL NOPRINT;
      UPDATE target.tsu 
            SET tsu_sasautos  = "&l_sasautos"
      %DO i=1 %TO 29;
               ,tsu_sasautos&i. = "&&l_sasautos&i"
      %END; /* i=1 %TO 29 */
               ,tsu_project         = "&l_project"
               ,tsu_target          = "&io_target"
               ,tsu_root            = "&l_root"
               ,tsu_sasunitroot     = "&l_sasunitroot"
               ,tsu_sasunit         = "&l_sasunit"
               ,tsu_sasunit_os      = "&l_sasunit_os"
               ,tsu_autoexec        = "&l_autoexec"
               ,tsu_sascfg          = "&l_sascfg"
               ,tsu_sasuser         = "&l_sasuser"
               ,tsu_testdata        = "&l_testdata"
               ,tsu_refdata         = "&l_refdata"
               ,tsu_doc             = "&l_doc"
               ,tsu_testcoverage    =&i_testcoverage.
               ,tsu_verbose         =&i_verbose.
               ,tsu_crossref        =&i_crossref.
               ,tsu_crossrefsasunit =&i_crossrefsasunit.
               ,tsu_language        ="&i_language.";
   QUIT;

   /*-- load relevant information from test database to global macro symbols ----*/
   %_loadEnvironment (i_withLibrefs   =0
                     ,i_appendSASAutos=Y
                     )

   /* Correct Termstring in Textfiles */
   %_prepareTextFiles;
   
   %IF "&g_error_code" NE "" %THEN %GOTO errexit;

   %IF (&g_runMode. = SASUNIT_BATCH) %THEN %DO;
      /*-- check spawning of a SAS process -----------------------------------------*/
      /* a file will be created in the work library of the parent (this) process 
         to check whether spawning works */
      %LET l_work = %sysfunc(pathname(work));
      PROC DATASETS NOLIST NOWARN LIB=work;
         DELETE check;
      QUIT;

      DATA _null_;
         FILE "&l_work/check_spawning.sas";
         PUT "LIBNAME awork ""&l_work"";";
         PUT "DATA awork.check; RUN;";
      RUN;
      
      %_runProgramSpawned(i_program          =&l_work./check_spawning.sas
                         ,i_scnid            =000
                         ,i_generateMcoverage=0
                         ,r_sysrc            =l_sysrc
                         ,i_pgmIsScenario    =0
                         );                

      %IF %_handleError(&l_macname.
                       ,ErrorSASCall2
                       ,NOT %sysfunc(exist(work.check))
                       ,Error spawning SAS process in initialization
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;

      PROC DATASETS NOLIST NOWARN LIB=work;
         DELETE check;
      QUIT;

      %LET l_rc=%_delFile(&l_work/run.sas);
   %END;

   %_createExamineeTable;

   PROC SQL NOPRINT;
      /*-- save time of initialization ---------------------------------------------*/
      UPDATE target.tsu SET tsu_lastinit = %sysfunc(datetime());
      /*-- update column tsu_dbVersion ------------------------------------------*/
      UPDATE target.tsu SET tsu_dbVersion = "&g_db_version.";
   QUIT;

   %IF (&g_runMode. = SASUNIT_INTERACTIVE) %THEN %DO;
      %_reportCreateStyle;
      %_reportCreateTagset;
   %END;

   %PUT;
   %PUT ============================ SASUnit has been initialized successfully ==========================;
   %PUT;

   %RETURN;
%errexit:
   %PUT;
   %PUT &g_error: ===================== Errors occured! Check log files! ===========================================;
   %PUT;
   %*RETURN;
%fatalexit:
   %PUT;
   %PUT &g_error: ===================== Fatal errors occured! test suite aborted! ===========================================;
   %PUT;
   LIBNAME target;
   endsas;
%MEND initSASUnit;

/** \endcond */
