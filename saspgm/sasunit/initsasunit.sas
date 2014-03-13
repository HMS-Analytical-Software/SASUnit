/**
   \file
   \ingroup    SASUNIT_CNTL 

   \brief      Initialization of a test suite that may comprise several test scenarios. 

               An existing test repository is opened or a new test repository is created.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
					Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_root         optional: root path for all other paths, is used for paths that do not begin 
                           with a drive letter or a slash/backslash
   \param   io_target      Path for the test repository and the generated documentation, has to exist
   \param   i_overwrite    0 (default) .. create test repository only in case it does not already exist
                           1 .. test repository is always created newly 
   \param   i_project      optional (in case test repository already exists): name of project
   \param   i_sasunit      optional (in case test repository already exists): path of SAS programs from SASUnit
   \param   i_sasautos     optional: i_sasautos, i_sasautos1 .. i_sasautos9: search paths for the programs 
                           under test and other sas macros invoked in test scenarios or programs under test
                           (the filename SASAUTOS predefined by SAS is always included at the beginning of
                           the search path)
   \param   i_autoexec     optional: a SAS program that is always invoked before a start of a test scenario
   \param   i_sascfg       optional: a SAS configuration file that is used for every invocation of a
                           test scenario
   \param   i_sasuser      optional: Template for a SASUSER directory including configuration catalogs.
                           A temporary SASUSER directory is created, existing only for the duration of a 
                           test scenario, in which all files are copied out of the specified directory.
   \param   i_testdata     optional: directory containing test data, has to exist in case parameter is set
                           (is accessed readonly)
   \param   i_refdata      optional: directory containing reference data, has to exist in case parameter is set
                           (is accessed readonly)
   \param   i_doc          optional: directory containing specification documents, etc., has to exist
                           in case parameter is set (is accessed readonly)
   \param   i_testcoverage optional: controls whether assessment of test coverage is activated
                           0 .. no assessment of test coverage
                           1 (default) .. assessment of test coverage is activated
   \param   i_verbose      optional: controls whether results of asserts are written to the SAS log
                           0 (default).. no results written to SAS log
                           1 .. results are written to SAS log
                           
*/ /** \cond */ 


%MACRO initSASUnit(i_root         = 
                  ,io_target      = 
                  ,i_overwrite    = 0
                  ,i_project      = 
                  ,i_sasunit      =
                  ,i_sasautos     =
                  ,i_sasautos1    =
                  ,i_sasautos2    =
                  ,i_sasautos3    =
                  ,i_sasautos4    =
                  ,i_sasautos5    =
                  ,i_sasautos6    =
                  ,i_sasautos7    =
                  ,i_sasautos8    =
                  ,i_sasautos9    =
                  ,i_autoexec     =
                  ,i_sascfg       =
                  ,i_sasuser      =
                  ,i_testdata     = 
                  ,i_refdata      = 
                  ,i_doc          = 
                  ,i_testcoverage = 1
                  ,i_verbose      = 0
                  );

   %GLOBAL g_version g_revision;

   %LET g_version   = 1.3.0;
   %LET g_revision  = $Revision$;
   %LET g_revision  = %scan(&g_revision,2,%str( $:));

   %LOCAL l_macname  l_current_dbversion l_target_abs  l_newdb       l_rc       l_project      l_root    l_sasunit          l_abs l_autoexec      l_autoexec_abs
          l_sascfg   l_sascfg_abs        l_sasuser     l_sasuser_abs l_testdata l_testdata_abs l_refdata l_refdata_abs      l_doc                 l_doc_abs  restore_sasautos 
          l_sasautos l_sasautos_abs      i             l_work        l_sysrc    l_sasautos_os  l_cmdfile l_abspath_sasautos l_abspath_sasautos_os l_sasunitroot
   ;

   %LET l_current_dbversion=0;
   %LET l_macname=&sysmacroname;

   /*-- Resolve relative root path like .../. to an absolute root path ----------*/
   libname _tmp "&i_root.";
   %let i_root=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- Get SASUnit root path from environement variable ----------*/
   libname _tmp "%sysget(SASUNIT_ROOT)";
   %let l_sasunitroot=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- initialize error --------------------------------------------------------*/
   %_initErrorHandler;

   /*-- check value of parameter i_verbose, if it has a value other than 0, 
        it will be set to 1 in order to assure that it will have only value 0 or 1 ------*/
   %IF (&i_verbose. NE 0) %THEN %DO;
      %LET i_verbose = 1;
   %END;

   /*-- check for operation system ----------------------------------------------*/
   %IF %_handleError(&l_macname.
                    ,WrongOS
                    ,(%upcase(&sysscp.) NE WIN) AND (%upcase(&sysscpl.) NE LINUX) /*AND (%upcase(&sysscpl.) NE AIX)*/
                    ,Invalid operating system - only WIN%str(,) LINUX/* AND AIX*/
                    ,i_verbose=&i_verbose.
                    ) 
   %THEN %GOTO errexit;

   /*-- set macro symbols for os commands ---------------------------------------*/
   %IF (&sysscp. = WIN) %THEN %DO;
      %LET l_sasautos_os = &i_sasunit./windows;
   %END;
   %ELSE %IF (%upcase(&sysscpl.) = LINUX) %THEN %DO;
      %LET l_sasautos_os = &i_sasunit./linux;
   %END;
   %ELSE %IF (%upcase(&sysscpl.) = AIX) %THEN %DO;
      %LET l_sasautos_os = &i_sasunit./unix_aix;
   %END;
   %LET l_abspath_sasautos   =%_abspath(&i_root.,&i_sasunit.);
   %LET l_abspath_sasautos_os=%_abspath(&i_root.,&l_sasautos_os.);
   OPTIONS SASAUTOS=(SASAUTOS "&l_abspath_sasautos." "&l_abspath_sasautos_os.");
   OPTIONS NOQUOTELENMAX;

   %_oscmds;

   /*-- check SAS version -------------------------------------------------------*/
   %IF %_handleError(&l_macname.
                    ,WrongVer
                    ,(&sysver. NE 9.2) AND (&sysver. NE 9.3) AND (&sysver. NE 9.4)
                    ,Invalid SAS version - only SAS 9.2 to 9.4
                    ,i_verbose=&i_verbose.
                    ) 
   %THEN %GOTO errexit;

   /*-- check value of parameter i_testcoverage, if it has an other value than 1, 
        set it to 0 in order to assure that it will have only value 0 or 1 ------*/
   %IF &i_testcoverage. NE 1 %THEN %DO;
      %LET i_testcoverage = 0;
   %END;
   %ELSE %DO;
      /*-- if test coverage should be assessed: check SAS version --------------*/
      %IF %_handleError(&l_macname.
                    ,ErrorTargetLib
                    ,%quote(&syslibrc) NE 0
                    ,Error in parameter io_target: target directory &l_target_abs. cannot be assigned as a SAS library
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   %END;

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
   data target._test;
   run;
   %IF %_handleError(&l_macname.
                    ,ErrorTargetLibNotWritable
                    ,%quote(&syserr.) NE 0
                    ,Error in parameter io_target: target directory not writeable
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   PROC SQL;
      DROP TABLE target._test;
   QUIT;

   /*-- does the test database exist already? -----------------------------------*/
   %IF "&i_overwrite" NE "1" %then %LET i_overwrite=0;
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
      %LET l_newdb=%eval ("&l_current_dbversion." NE "&g_version.");
   %END;

   /*-- create test database if necessary ---------------------------------------*/
   %IF &l_newdb %THEN %DO;
      PROC SQL NOPRINT;
         CREATE TABLE target.tsu(COMPRESS=CHAR)
         (                                      /* test suite */
             tsu_project      CHAR(1000)        /* see i_project */
            ,tsu_root         CHAR(1000)        /* see i_root */
            ,tsu_target       CHAR(1000)        /* see io_target */
            ,tsu_sasunitroot  CHAR(1000)        /* root path to sasunit files */
            ,tsu_sasunit      CHAR(1000)        /* see i_sasunit */
            ,tsu_sasunit_os   CHAR(1000)        /* os-specific sasunit macros */
            ,tsu_sasautos     CHAR(1000)        /* see i_sasautos */
      %DO i=1 %TO 9;
            ,tsu_sasautos&i   CHAR(1000)        /* see i_sasautos<n> */
      %END;
            ,tsu_autoexec     CHAR(1000)        /* see i_autoexec */
            ,tsu_sascfg       CHAR(1000)        /* see i_sascfg */
            ,tsu_sasuser      CHAR(1000)        /* see i_sasuser */
            ,tsu_testdata     CHAR(1000)        /* see i_testdata */
            ,tsu_refdata      CHAR(1000)        /* see i_refdata */
            ,tsu_doc          CHAR(1000)        /* see i_doc */
            ,tsu_lastinit     INT FORMAT=datetime21.2 /* date and time of last initialization */
            ,tsu_lastrep      INT FORMAT=datetime21.2 /* date and time of last report generation*/
            ,tsu_testcoverage INT FORMAT=8.     /* see i_testcoverage */
            ,tsu_dbversion    CHAR(8)           /* Version String to force creation of a new test data base */
            ,tsu_verbose      INT FORMAT=8.     /* see i_verbose */
         );
         INSERT INTO target.tsu VALUES (
         "","","","","","","","","","","","","","","","","","","","","","",0,0,&i_testcoverage.,"",&i_verbose.
         );

         CREATE TABLE target.scn(COMPRESS=CHAR)
         (                                            /* test scenario */
             scn_id           INT FORMAT=z3.          /* number of scenario */
            ,scn_path         CHAR(1000)              /* path to program file */ 
            ,scn_desc         CHAR(1000)              /* description of program (brief tag in comment header) */
            ,scn_start        INT FORMAT=datetime21.2 /* starting date and time of the last run */
            ,scn_end          INT FORMAT=datetime21.2 /* ending date and time of the last run */
            ,scn_rc           INT                     /* return code of SAS session of last run */
            ,scn_errorcount   INT                     /* number of detected errors in the scenario log */
            ,scn_warningcount INT                     /* number of detected warnings in the scenario log */
            ,scn_res          INT                     /* overall test result of last run: 0 .. OK, 1 .. not OK, 2 .. manual */
         );
         CREATE TABLE target.cas(COMPRESS=CHAR)
         (                                      /* test case */
             cas_scnid INT FORMAT=z3.           /* reference to test scenario */
            ,cas_id    INT FORMAT=z3.           /* sequential number of test case within test scenario */
            ,cas_auton INT                      /* number of autocall path where program under test has been found or ., if not found */
            ,cas_pgm   CHAR(255)                /* file name of program under test: only name if found in autocall paths, or fully qualified path otherwise */ 
            ,cas_desc  CHAR(1000)               /* description of test case */
            ,cas_spec  CHAR(1000)               /* optional: specification document, fully qualified path or only filename to be found in folder &g_doc */
            ,cas_start INT FORMAT=datetime21.2  /* starting date and time of the last run */
            ,cas_end   INT FORMAT=datetime21.2  /* ending date and time of the last run */
            ,cas_res   INT                      /* overall test result of last run: 0 .. OK, 1 .. not OK, 2 .. manual */
         );
         CREATE TABLE target.tst(COMPRESS=CHAR)
         (                                    /* Test */
             tst_scnid  INT FORMAT=z3.        /* reference to test scenario */
            ,tst_casid  INT FORMAT=z3.        /* reference to test case */
            ,tst_id     INT FORMAT=z3.        /* sequential number of test within test case */
            ,tst_type   CHAR(32)              /* type of test (name of assert macro) */
            ,tst_desc   CHAR(1000)            /* description of test */
            ,tst_exp    CHAR(255)             /* expected result */
            ,tst_act    CHAR(255)             /* actual result */
            ,tst_res    INT                   /* test result of the last run: 0 .. OK, 1 .. manual, 2 .. not OK */
            ,tst_errmsg CHAR(1000)            /* custom error message for asserts */
         );
      QUIT;
      %IF %_handleError(&l_macname.
                       ,ErrorCreateDB
                       ,&syserr. NE 0
                       ,Error on creation of test database
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;


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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_target = "&io_target";
   QUIT;

   /*-- project name ------------------------------------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_project INTO :l_project FROM target.tsu;
   QUIT;
   %LET l_project=&l_project;
   %IF "&i_project" NE "" %THEN %LET l_project=&i_project;
   %IF %_handleError(&l_macname.
                    ,MissingProjectName
                    ,"&l_project" EQ ""
                    ,Parameter i_project must be specified
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_project = "&l_project";
   QUIT;

   /*-- root folder -------------------------------------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_root INTO :l_root FROM target.tsu;
   QUIT;
   %LET l_root=&l_root;
   %IF "&i_root" NE "" %THEN %LET l_root=&i_root;
   %IF %_handleError(&l_macname.
                    ,InvalidRoot
                    ,"&l_root" NE "" AND NOT %_existdir(&l_root)
                    ,%str(Error in parameter i_root: folder must exist when specified)
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_root = "&l_root";
   QUIT;

   /*-- sasunit root folder -------------------------------------------------------------*/
   %LET l_sasunitroot=&l_sasunitroot;
   %IF %_handleError(&l_macname.
                    ,InvalidRoot
                    ,"&l_sasunitroot" NE "" AND NOT %_existdir(&l_sasunitroot)
                    ,%str(Error in parameter l_sasunitroot: folder must exist when specified)
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_sasunitroot = "&l_sasunitroot";
   QUIT;

   /*-- sasunit folder ----------------------------------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_sasunit INTO :l_sasunit FROM target.tsu;
   QUIT;
   %LET l_sasunit=&l_sasunit;
   %IF "&i_sasunit" NE "" %THEN %LET l_sasunit=&i_sasunit;
   %LET l_abs=%_abspath(&l_root.,&l_sasunit.);
   %IF %_handleError(&l_macname.
                    ,InvalidSASUnitDir
                    ,"&l_abs." EQ "" OR NOT %sysfunc(fileexist(&l_abs./_scenario.sas))
                    ,Error in parameter i_sasunit: SASUnit macro programs not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_sasunit = "&l_sasunit";
   QUIT;

   /*-- os-specific sasunit folder ----------------------------------------------------------*/
   %LET l_sasautos_os=&l_sasautos_os;
   %IF %_handleError(&l_macname.
                    ,InvalidSASUnitDir
                    ,"&l_abspath_sasautos_os." EQ "" OR NOT %sysfunc(fileexist(&l_abspath_sasautos_os./_oscmds.sas))
                    ,Error in parameter i_sasunit: os-specific SASUnit macro programs not found
                    ,i_verbose=&i_verbose.
                    ) 
      %THEN %GOTO errexit;
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_sasunit_os = "&l_sasautos_os";
   QUIT;
   /*-- check if autoexec exists where specified --------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_autoexec INTO :l_autoexec FROM target.tsu;
   QUIT;
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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_autoexec = "&l_autoexec";
   QUIT;

   /*-- check if sascfg exists where specified ----------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_sascfg INTO :l_sascfg FROM target.tsu;
   QUIT;
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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_sascfg = "&l_sascfg";
   QUIT;

   /*-- check sasuser folder ----------------------------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_sasuser INTO :l_sasuser FROM target.tsu;
   QUIT;
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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_sasuser = "&l_sasuser";
   QUIT;

   /*-- check test data folder --------------------------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_testdata INTO :l_testdata FROM target.tsu;
   QUIT;
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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_testdata = "&l_testdata";
   QUIT;

   /*-- check reference data folder ---------------------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_refdata INTO :l_refdata FROM target.tsu;
   QUIT;
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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_refdata = "&l_refdata";
   QUIT;

   /*-- check folder for specification documents --------------------------------*/
   PROC SQL NOPRINT;
      SELECT tsu_doc INTO :l_doc FROM target.tsu;
   QUIT;
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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_doc = "&l_doc";
   QUIT;

   /*-- check autocall paths ----------------------------------------------------*/
   %LET restore_sasautos=%sysfunc(getoption(sasautos));

   PROC SQL NOPRINT;
      SELECT tsu_sasautos INTO :l_sasautos FROM target.tsu;
   QUIT;
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
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_sasautos = "&l_sasautos";
   QUIT;
   
   %DO i=1 %TO 9;
      PROC SQL NOPRINT;
         SELECT tsu_sasautos&i. INTO :l_sasautos FROM target.tsu;
      QUIT;
      %LET l_sasautos=&l_sasautos;
      %IF "&&i_sasautos&i" NE "" %THEN %LET l_sasautos=&&i_sasautos&i;
      %LET l_sasautos_abs=%_abspath(&l_root,&l_sasautos);
      %IF %_handleError(&l_macname.
                       ,InvalidSASAutosN
                       ,"&l_sasautos_abs" NE "" AND NOT %_existdir(&l_sasautos_abs)
                       ,Error in parameter i_sasautos&i: folder not found
                       ,i_verbose=&i_verbose.
                       ) 
         %THEN %GOTO errexit;
      PROC SQL NOPRINT;
         UPDATE target.tsu SET tsu_sasautos&i. = "&l_sasautos";
      QUIT;
   %END; /* i=1 %TO 9 */

   /*-- update parameters ----------------------------------------------------*/
   PROC SQL NOPRINT;
      UPDATE target.tsu SET tsu_testcoverage=&i_testcoverage;
      UPDATE target.tsu SET tsu_verbose     =&i_verbose;
   QUIT;

   /*-- load relevant information from test database to global macro symbols ----*/
   %_loadEnvironment (i_withLibrefs = 0
                     )
   /* Correct Termstring in Textfiles */
   %_prepareTextFiles;
   
   %IF "&g_error_code" NE "" %THEN %GOTO errexit;

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

   /*-- save time of initialization ---------------------------------------------*/
   PROC SQL NOPRINT;
      UPDATE target.tsu 
         SET tsu_lastinit = %sysfunc(datetime())
      ;
   QUIT;

   /*-- update column tsu_dbVersion ------------------------------------------*/
   PROC SQL NOPRINT;
      UPDATE target.tsu 
         SET tsu_dbVersion = "&g_version."
      ;
   QUIT;

   %PUT;
   %PUT ============================ SASUnit has been initialized successfully ==========================;
   %PUT;

   %GOTO exit;
%errexit:
   %PUT;
   %PUT &g_error: ===================== Error! Testsuite aborted! ===========================================;
   %PUT;
   LIBNAME target;
    endsas;
%exit:
%MEND initSASUnit;
/** \endcond */
