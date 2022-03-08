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
            
   \param   i_root                     optional: root path for all other paths except i_sasunit, is used for paths that do not begin 
                                       with a drive letter or a slash/backslash
   \param   io_target                  Path for the test repository and the generated documentation, has to exist
   \param   i_overwrite                0 (default) .. create test repository only in case it does not already exist
                                       1 .. test repository is always created newly 
   \param   i_project                  optional: (in case test repository already exists): name of project
   \param   i_sasunit                  optional: absolute installation path of SAS programs from SASUnit. It is checked whether installationpath
                                       is starting with path in environment variable SASUNIT_ROOT set by script file
   \param   i_sasautos                 optional: i_sasautos, i_sasautos1 .. i_sasautos9: search paths for the programs 
                                       under test and other sas macros invoked in test scenarios or programs under test
                                       (the filename SASAUTOS predefined by SAS is always included at the beginning of
                                       the search path)
   \param   i_autoexec                 optional: a SAS program that is always invoked before a start of a test scenario
   \param   i_sascfg                   optional: a SAS configuration file that is used for every invocation of a test scenario
   \param   i_sasuser                  optional: Template for a SASUSER directory including configuration catalogs.
                                       A temporary SASUSER directory is created, existing only for the duration of a 
                                       test scenario, in which all files are copied out of the specified directory.
   \param   i_testdata                 optional: directory containing test data, has to exist in case parameter is set
                                       (is accessed readonly)
   \param   i_refdata                  optional: directory containing reference data, has to exist in case parameter is set
                                       (is accessed readonly)
   \param   i_doc                      optional: directory containing specification documents, etc., has to exist
                                       in case parameter is set (is accessed readonly)
   \param   i_testcoverage             optional: controls whether assessment of test coverage is activated
                                       0 .. no assessment of test coverage
                                       1 (default) .. assessment of test coverage is activated
   \param   i_verbose                  optional: controls whether results of asserts are written to the SAS log
                                       0 (default).. no results written to SAS log
                                       1 .. results are written to SAS log
   \param   i_crossref                 optional: controls whether the cross reference is created
                                       0  .. cross reference will not be created 
                                       1 (default).. cross reference will be created                                                      
   \param   i_crossrefsasunit          optional: controls whether the SASUnit core macros are included in the scan for dependencies
                                       0 (default) .. SASUnit core macros are not included
                                       1 .. SASUnit core macros are included
   \param   i_language                 optional: specifying the language that should be used. This parameter is necessary to avoid using the respective environment variable under linux 
                                       supported values: "en" / "de"
                                       default: %sysget(SASUNIT_LANGUAGE)
   \param   i_logFolder                specifying the folder for overall logfiles like run_all.log and log file for SASUnit test suite
   \param   i_scnLogFolder             specifying the folder for scenario log files
   \param   i_log4SASSuiteLogLevel     optional specifying the log4sas logging level for test suite
                                       default: INFO
   \param   i_log4SASScenarioLogLevel  optional specifying the log4sas logging level for scenarios
                                       default: INFO
   \param   i_reportFolder             specifying the output folder for reporting
   \param   i_resourceFolder           optional specifying the input folder for SASUnit reporting source like icons and css- and java script files 
                                       default: %sysget(SASUNIT_ROOT)/resources
   \param   i_OSEncoding               optional specifying the encoding of the operating system. This may be different from the ensoding of the sas ssession
                                       default: %sysget(SASUNIT_HOST_ENCODING)
   \param   i_SASUnitRoot              optional specifying the root folder of SASUnit
                                       default: %sysget(SASUNIT_ROOT)

   \todo    check new parms for Logfiles and reportfolder
   \todo    check regeneration of empty folders; check not to delete test_db_folder

*//** \cond */ 
%MACRO initSASUnit(i_root                    =
                  ,io_target                 =
                  ,i_overwrite               =0
                  ,i_project                 =
                  ,i_sasunit                 =%sysget(SASUNIT_ROOT)/saspgm/sasunit
                  ,i_sasautos                =
                  ,i_sasautos1               =
                  ,i_sasautos2               =
                  ,i_sasautos3               =
                  ,i_sasautos4               =
                  ,i_sasautos5               =
                  ,i_sasautos6               =
                  ,i_sasautos7               =
                  ,i_sasautos8               =
                  ,i_sasautos9               =
                  ,i_sasautos10              =
                  ,i_sasautos11              =
                  ,i_sasautos12              =
                  ,i_sasautos13              =
                  ,i_sasautos14              =
                  ,i_sasautos15              =
                  ,i_sasautos16              =
                  ,i_sasautos17              =
                  ,i_sasautos18              =
                  ,i_sasautos19              =
                  ,i_sasautos20              =
                  ,i_sasautos21              =
                  ,i_sasautos22              =
                  ,i_sasautos23              =
                  ,i_sasautos24              =
                  ,i_sasautos25              =
                  ,i_sasautos26              =
                  ,i_sasautos27              =
                  ,i_sasautos28              =
                  ,i_sasautos29              =
                  ,i_autoexec                =
                  ,i_sascfg                  =
                  ,i_sasuser                 =
                  ,i_testdata                = 
                  ,i_refdata                 = 
                  ,i_doc                     = 
                  ,i_testcoverage            =1
                  ,i_verbose                 =0
                  ,i_crossref                =1
                  ,i_crossrefsasunit         =0
                  ,i_language                =%sysget(SASUNIT_LANGUAGE)
                  ,i_logFolder               =
                  ,i_scnLogFolder            =
                  ,i_log4SASSuiteLogLevel    =INFO
                  ,i_log4SASScenarioLogLevel =INFO
                  ,i_reportFolder            =
                  ,i_resourceFolder          =%sysget(SASUNIT_ROOT)/resources
                  ,i_OSEncoding              =%sysget(SASUNIT_HOST_ENCODING)
                  ,i_SASUnitRoot             =%sysget(SASUNIT_ROOT)
                  );

   %GLOBAL g_version g_revision g_db_version g_error g_warning g_note g_runMode g_language g_currentLogger g_currentLogLevel g_log4SASScenarioLogger;

   %LET g_version    = 2.1;
   %LET g_db_version = 2.1;
   %LET g_revision   = $Revision$;
   %LET g_revision   = %scan(&g_revision,2,%str( $:));
   
   %LET l_log4SASSuiteLogger     = App.Program.SASUnit;
   %LET g_currentLogger          = &l_log4SASSuiteLogger.;
   %LET g_currentLogLevel        = &i_log4SASSuiteLogLevel.;
   /*** Setting logging information  ***/
   %_setLog4SASLogLevel (loggername =&g_currentlogger.
                        ,level      =&g_currentLogLevel.
                        );   
                        
   %_issueInfoMessage(&g_currentLogger., --------------------------------------------------------------------------------)
   %_issueInfoMessage(&g_currentLogger., Starting SASUnit (InitSASUnit) in version &g_version..)
   %_issueInfoMessage(&g_currentLogger., SASUnit DB Version is &g_db_version..)
   %_issueInfoMessage(&g_currentLogger., --------------------------------------------------------------------------------)

   /******************************************************************************/
   /*** Step one                                                               ***/
   /***    Checking OSes and SAS Version                                       ***/
   /******************************************************************************/
   %_issueDebugMessage(&g_currentLogger., Determining runtime information)
   %_readEnvMetadata;
   
   /*-- check for operation system and SAS version -------------------------------*/
   %IF (%_checkRunEnvironment ne 0) %THEN %GOTO errexit;

   /******************************************************************************/
   /*** Step two                                                               ***/
   /***    Checking incoming parameters                                        ***/
   /******************************************************************************/

   %*** Declare local variables for later use ***;
   %LOCAL 
      l_macname
      l_current_dbversion l_newdb
      l_target l_abs 
      l_root l_sasunitroot l_sasunit l_sasunit_os l_abspath_sasunit_os
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
      l_rc
      l_parameterNames
      l_goOn
      l_logFolder l_scnLogFolder l_reportFolder
   ;
   
   /*-- Initialize error handler --------------------------------------------------------*/
   %_initErrorHandler;
   %LET l_macname=&sysmacroname;

   %LET l_goOn = DoNothing;

   /*-- Check value of incoming parameters ---------------------------------------------*/
   /*-- Theses parameters must be set --------------------------------------------------*/
   %let l_parameterNames = i_root io_target i_project i_sasunit i_sasautos i_language i_testdata i_refdata i_OSEncoding i_SASUnitRoot; 

   %_checkListOfParameters (i_listOfParameters    = &l_parameterNames.
                           ,i_returnCodeVariable  = l_goOn
                           ,i_callingMacroName    = &l_macname.
                           ,i_MessageLevel        = DEBUG
                           ,i_MissingValueAllowed = NO
                           );
   %if (&l_goOn. = STOP) %then %do;
      %goto %errexit;
   %end;

   /*-- Check value of incoming parameters ---------------------------------------------*/
   /*-- Theses parameters must be set only in batch mode -------------------------------*/
   %if (&g_runMode. = SASUNIT_BATCH) %then %do;
      %let l_parameterNames = i_logFolder i_scnLogFolder i_reportFolder i_resourceFolder; 

      %_checkListOfParameters (i_listOfParameters    = &l_parameterNames.
                              ,i_returnCodeVariable  = l_goOn
                              ,i_callingMacroName    = &l_macname.
                              ,i_MessageLevel        = DEBUG
                              ,i_MissingValueAllowed = NO
                              );
      %if (&l_goOn. = STOP) %then %do;
         %goto %errexit;
      %end;
   %end;
   /*-- Theses parameters may be given --------------------------------------------------*/
   %let l_parameterNames = i_sasuser i_doc;
   %DO l_i=1 %TO 29;
      %let l_parameterNames = &l_parameterNames. i_sasautos&l_i.;
   %END;
   %let l_parameterNames = &l_parameterNames. i_autoexec i_sascfg;
   
   %_checkListOfParameters (i_listOfParameters    = &l_parameterNames.
                           ,i_returnCodeVariable  = l_goOn
                           ,i_callingMacroName    = &l_macname.
                           ,i_MessageLevel        = DEBUG
                           ,i_MissingValueAllowed = YES
                           );
   %if (&l_goOn. = STOP) %then %do;
      %goto %errexit;
   %end;

   /*-- check value of parameters i_verbose, i_crossref and i_crossrefsasunit, 
        if one of them has a value other than default, 
        they will be set to 1/0 in order to assure that values will only be 0 or 1 ------*/
   %IF (&i_crossrefsasunit. NE 0) %THEN %DO;
      %LET i_crossrefsasunit = 1;
   %END;
   %IF (&i_crossref. NE 1) %THEN %DO;
      %LET i_crossref = 0;
   %END;
   %IF (&i_testcoverage. NE 1)%THEN %DO;
      %LET i_testcoverage = 0;
   %END;
   %IF (&i_overwrite NE 0) %THEN %DO;
      %LET i_overwrite=1;
   %END;
   /******************************************************************************/
   /*** End of Step two                                                        ***/
   /******************************************************************************/

   /******************************************************************************/
   /*** Step three                                                             ***/
   /***    Checking validity of parameter values                               ***/
   /******************************************************************************/
   /*-- check shell values vs. parameters ------------------------------------------*/
   %IF (&g_runMode. = SASUNIT_BATCH) %THEN %DO;
      %LET l_testcoverage=%sysget (SASUNIT_COVERAGEASSESSMENT);
      %IF (&l_testcoverage. ne ) %THEN %DO;
         %IF (&l_testcoverage. ne &i_testcoverage.) %THEN %DO;
             %_issueWarningMessage (&g_currentLogger., initSASUnit: Shell variable SASUNIT_COVERAGEASSESSMENT not passed correctly to parameter i_testcoverage!);
         %END;
      %END;
      %LET l_overwrite=%sysget(SASUNIT_OVERWRITE);
      %IF (&l_overwrite. ne ) %THEN %DO;
         %IF (&l_overwrite. ne &i_overwrite.) %THEN %DO;
             %_issueWarningMessage (&g_currentLogger., initSASUnit: Shell variable SASUNIT_OVERWRITE not passed correctly to parameter i_overwrite!);
         %END;
      %END;
   %END;

   /*-- Resolve relative root path like ../. to an absolute root path ----------*/
   libname _tmp "&i_root.";
   %let l_root=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- Get SASUnit root path from environment variable ----------*/
   libname _tmp "&i_SASUnitRoot.";
   %let l_sasunitroot=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- Get SASUnit macro path ----------*/
   libname _tmp "&i_sasunit.";
   %let l_sasunit=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- Get SASUnit target path ----------*/
   libname _tmp "&io_target.";
   %let l_target=%sysfunc (pathname(_tmp));
   libname _tmp clear;

   /*-- root folder -------------------------------------------------------------*/
   %IF %_handleError(&l_macname.
                    ,InvalidPath
                    ,"&l_root" NE "" AND NOT %_existdir(&l_root)
                    ,%str(Error in parameter i_root: folder must exist when specified)
                    ) 
      %THEN %GOTO errexit;

   /*-- check for target directory ----------------------------------------------*/
   %IF %_handleError(&l_macname.
                    ,InvalidPath
                    ,"&l_target." EQ "" OR NOT %_existDir(&l_target.)
                    ,Error in parameter io_target: target directory does not exist
                    ) 
      %THEN %GOTO errexit;

   LIBNAME target "&l_target.";
   %IF %_handleError(&l_macname
                    ,InvalidLibrary
                    ,%quote(&syslibrc.) NE 0
                    ,Error in parameter io_target: target directory &l_target. cannot be assigned as a SAS library
                    ) 
      %THEN %GOTO errexit;
   %IF %_handleError(&l_macname.
                    ,LibraryNotWritable
                    ,%quote(&syserr.) NE 0
                    ,Error in parameter io_target: target directory not writeable
                    ) 
      %THEN %GOTO errexit;

   /*-- sasunit root folder -------------------------------------------------------------*/
   %LET l_sasunitroot=&l_sasunitroot;
   %IF %_handleError(&l_macname.
                    ,InvalidPath
                    ,"&l_sasunitroot" NE "" AND NOT %_existdir(&l_sasunitroot)
                    ,%str(Error in parameter l_sasunitroot: folder must exist when specified)
                    ) 
      %THEN %GOTO errexit;

   /*-- sasunit folder ----------------------------------------------------------*/
   %LET l_abs=%_abspath(&l_root.,&l_sasunit.);
   %IF %_handleError(&l_macname.
                    ,InvalidPath
                    ,"&l_abs." EQ "" OR NOT %sysfunc(fileexist(&l_abs./_scenario.sas))
                    ,Error in parameter i_sasunit: SASUnit macro programs not found
                    ) 
      %THEN %GOTO errexit;

   /*-- check for correct sasunit path ----------------------------------------------*/
   %IF %_handleError(&l_macname.
                    ,InvalidPath
                    ,%index (&l_sasunit.,&l_sasunitroot.) NE 1
                    ,Invalid path to SASUnit - SASUnit root is &l_sasunitroot. - SASUnit path is &l_sasunit.
                    ) 
   %THEN %GOTO errexit;

   /*-- check autocall paths ----------------------------------------------------*/
   %LET l_sasautos=&i_sasautos;
   %LET l_sasautos_abs=%_abspath(&l_root,&l_sasautos);
   %IF %_handleError(&l_macname.
                    ,InvalidAutocallPath
                    ,"&l_sasautos_abs" NE "" AND NOT %_existdir(&l_sasautos_abs)
                    ,Error in parameter i_sasautos: folder not found
                    ) 
      %THEN %GOTO errexit;
   
   %DO i=1 %TO 29;
      %LET l_sasautos&i.=&&i_sasautos&i..;
      %LET l_sasautos_abs=%_abspath(&l_root,&&l_sasautos&i..);
      %IF %_handleError(&l_macname.
                       ,InvalidAutocallPath
                       ,"&l_sasautos_abs" NE "" AND NOT %_existdir(&l_sasautos_abs)
                       ,Error in parameter i_sasautos&i: folder not found
                       ) 
         %THEN %GOTO errexit;
   %END; /* i=1 %TO 29 */

   /*-- check if autoexec exists where specified --------------------------------*/
   %*** In case of no autoexec you need to specify a real blank as value ***;
   %*** because we need to specify a real blank (%str( )) as parameter,  ***;
   %*** we need to use a different method of assignment.                 ***;
   %LET l_autoexec=%trim(&i_autoexec.);
   %LET l_autoexec_abs=%_abspath(&l_root.,&l_autoexec.);
   %IF %_handleError(&l_macname.
                    ,AutoexecIsGiven
                    ,"&l_autoexec" NE ""
                    ,Parameter i_autoexec was not given by user so no autoexec will be used for calling scenarios
                    ,i_msgtype=DEBUG
                    ) 
      %THEN %DO;
      %IF %_handleError(&l_macname.
                       ,AutoexecNotFound
                       ,NOT %sysfunc(fileexist(&l_autoexec_abs.))
                       ,Error in parameter i_autoexec: file not found
                       ) 
         %THEN %GOTO errexit;
      %_issueInfoMessage (&g_currentLogger., initSASUnit: Using the following autoexec file: &l_autoexec_abs.);
   %END;

   /*-- check if sascfg exists where specified ----------------------------------*/
   %LET l_sascfg=%trim(&i_sascfg.);
   %LET l_sascfg_abs=%_abspath(&l_root.,&l_sascfg.);
   %IF %_handleError(&l_macname.
                    ,SASCfgIsGiven
                    ,"&l_sascfg" NE ""
                    ,Parameter i_sascfg was not given by user so no project config file will be used for calling scenarios
                    ,i_msgtype=DEBUG
                    ) 
      %THEN %DO;
      %IF %_handleError(&l_macname.
                       ,SASCfgNotFound
                       ,NOT %sysfunc(fileexist(&l_sascfg_abs.))
                       ,Error in parameter i_sascfg: file not found
                       ) 
         %THEN %GOTO errexit;
      %_issueInfoMessage (&g_currentLogger., initSASUnit: Using the following config file: &l_sascfg_abs.);
   %END;

   /*-- check sasuser folder ----------------------------------------------------*/
   %LET l_sasuser=&i_sasuser;
   %LET l_sasuser_abs=%_abspath(&l_root,&l_sasuser);
   %IF %_handleError(&l_macname.
                    ,InvalidSasuserPath
                    ,"&l_sasuser_abs" NE "" AND NOT %_existdir(&l_sasuser_abs)
                    ,Error in parameter i_sasuser: folder not found
                    ) 
      %THEN %GOTO errexit;

   /*-- check test data folder --------------------------------------------------*/
   %LET l_testdata=&i_testdata;
   %LET l_testdata_abs=%_abspath(&l_root,&l_testdata);
   %IF %_handleError(&l_macname.
                    ,InvalidTestdataPath
                    ,"&l_testdata_abs" NE "" AND NOT %_existdir(&l_testdata_abs)
                    ,Error in parameter i_testdata: folder not found
                    ) 
      %THEN %GOTO errexit;

   /*-- check reference data folder ---------------------------------------------*/
   %LET l_refdata=&i_refdata;
   %LET l_refdata_abs=%_abspath(&l_root,&l_refdata);
   %IF %_handleError(&l_macname.
                    ,InvalidRefdataPath
                    ,"&l_refdata_abs" NE "" AND NOT %_existdir(&l_refdata_abs)
                    ,Error in parameter i_refdata: folder not found
                    ) 
      %THEN %GOTO errexit;

   /*-- check folder for specification documents --------------------------------*/
   %LET l_doc=&i_doc;
   %LET l_doc_abs=%_abspath(&l_root,&l_doc);
   %IF %_handleError(&l_macname.
                    ,InvalidDoc
                    ,"&l_doc_abs" NE "" AND NOT %_existdir(&l_doc_abs)
                    ,Error in parameter i_doc: folder not found
                    ) 
      %THEN %GOTO errexit;

   /*-- resource folder ----------------------------------------------------------*/
   %LET l_abs=%_abspath(&l_root.,&i_resourceFolder.);
   %IF %_handleError(&l_macname.
                    ,InvalidPath
                    ,"&l_doc_abs" NE "" AND NOT %_existdir(&l_doc_abs)
                    ,Error in parameter i_resourceFolder: folder not found
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
   %LET l_sasunit_os=&l_sasunit_os.;
   %LET l_abspath_sasunit_os=%_abspath(&l_sasunitroot.,&l_sasunit_os.);

   /*-- os-specific sasunit folder ----------------------------------------------------------*/
   %IF %_handleError(&l_macname.
                    ,InvalidSASUnitOSDir
                    ,"&l_abspath_sasunit_os." EQ "" OR NOT %sysfunc(fileexist(&l_abspath_sasunit_os./_oscmds.sas))
                    ,Error in parameter l_sasunit_os: folder for os-specific SASUnit macro programs not found!
                    ) 
      %THEN %GOTO errexit;
   %IF %_handleError(&l_macname.
                    ,SASUnitOsMacroNotFound
                    ,"&l_abspath_sasunit_os." EQ "" OR NOT %sysfunc(fileexist(&l_abspath_sasunit_os./_oscmds.sas))
                    ,Error in parameter i_sasunit: os-specific SASUnit macro _oscmds not found!
                    ) 
      %THEN %GOTO errexit;
   %IF %_handleError(&l_macname.
                    ,SASUnitOsMacroNotFound
                    ,"&l_abspath_sasunit_os." EQ "" OR NOT %sysfunc(fileexist(&l_abspath_sasunit_os./_makesasunitpath.sas))
                    ,Error in parameter i_sasunit: os-specific SASUnit macro _makesasunitpath not found!
                    ) 
      %THEN %GOTO errexit;

   %include "&l_abspath_sasunit_os./_makesasunitpath.sas";
   
   /******************************************************************************/
   /*** End of Step three                                                      ***/
   /******************************************************************************/
   
   %LET l_root=%_makeSASUnitPath(&l_root.);
   %LET l_sasunitroot=%_makeSASUnitPath(&l_sasunitroot.);
   %LET l_sasunit=%_makeSASUnitPath(&l_sasunit.);
   %LET l_sasunit_os=%_makeSASUnitPath(&l_sasunit_os.);
   %LET l_target=%_makeSASUnitPath(&l_target.);
   %LET l_sasautos=%_makeSASUnitPath(&l_sasautos.);
   %DO i=1 %TO 29;
      %LET l_sasautos&i=%_makeSASUnitPath(&&l_sasautos&i);
   %END; /* i=1 %TO 29 */
   %LET l_logFolder=%_makeSASUnitPath(&i_logFolder.);
   %LET l_scnLogFolder=%_makeSASUnitPath(&i_scnLogFolder.);
   %LET l_reportFolder=%_makeSASUnitPath(&i_reportFolder.);

   %_insertAutocallPath (&l_sasunit.);
   %_insertAutocallPath (&l_abspath_sasunit_os.);
   OPTIONS NOQUOTELENMAX;

   %let g_overwrite=&i_overwrite.;
   
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
      %_readParameterFromTestDBtsu (i_parameterName  =tsu_dbVersion 
                                   ,o_parameterValue =l_current_dbversion
                                   );
      
      %LET l_newdb=%eval ("&l_current_dbversion." NE "&g_db_version.");
   %END;

   /*-- create test database if necessary ---------------------------------------*/
   %IF &l_newdb %THEN %DO;
      %_createTestDatabase(libref=target)
      %IF %_handleError(&l_macname.
                       ,ErrorCreateDB
                       ,&syserr. NE 0
                       ,Error on creation of test database
                       ) 
         %THEN %GOTO errexit;
   %END; /* %if &l_newdb */

   %IF (&g_runMode. = SASUNIT_BATCH) %THEN %DO;
      /*-- recreate empty folders if necessary -------------------------------------*/
      %IF &l_newdb %THEN %DO;
         /*-- regenerate empty folders ------------------------------------------------*/
         %LET l_cmdfile=%sysfunc(pathname(WORK))/remove_dir.cmd;
         DATA _null_;
            FILE "&l_cmdfile." encoding=&i_OSEncoding.; /* wg. Umlauten in Pfaden */
            PUT %Sysfunc (quote (&g_removedir %_adaptSASUnitPathToOS (&l_reportFolder.)&g_endcommand));
            PUT %Sysfunc (quote (&g_removedir %_adaptSASUnitPathToOS (&l_scnLogFolder.)&g_endcommand));            
         RUN;
         %_executeCMDFile(&l_cmdfile.);
         %LET l_rc=%_delfile(&l_cmdfile.);
         %LET rc = %sysfunc (sleep(2,1));
         %_mkDir (&i_logFolder.
                 ,makeCompletePath = 1
                 );
         %_mkDir (&i_scnLogFolder.
                 ,makeCompletePath = 1
                 );
         %_mkDir (&l_reportFolder./testDoc/testCoverage
                 ,makeCompletePath = 1
                 );
         %_mkDir (&l_reportFolder./tempDoc/crossreference
                 ,makeCompletePath = 1
                 );
              
      %END; /* %if &l_newdb */

      /*-- check folders -----------------------------------------------------------*/
      %IF %_handleError(&l_macname.
                       ,NoLogDir
                       ,NOT %_existdir(&l_logFolder.)
                       ,folder &l_logFolder. does not exist
                       ) 
         %THEN %GOTO errexit;
      %IF %_handleError(&l_macname.
                       ,NoScnLogDir
                       ,NOT %_existdir(&l_scnLogFolder.)
                       ,folder &l_scnLogFolder. does not exist
                       ) 
         %THEN %GOTO errexit;
      %IF %_handleError(&l_macname.
                       ,NoRepDir
                       ,NOT %_existdir(&l_reportFolder.)
                       ,folder &l_reportFolder. does not exist
                       ) 
         %THEN %GOTO errexit;
      %IF %_handleError(&l_macname.
                       ,NoRepDir
                       ,NOT %_existdir(&l_reportFolder./testDoc)
                       ,folder &l_reportFolder./testDoc does not exist
                       ) 
         %THEN %GOTO errexit;
      %IF %_handleError(&l_macname.
                       ,NoRepDir
                       ,NOT %_existdir(&l_reportFolder./tempDoc)
                       ,folder &l_reportFolder./tempDoc does not exist
                       ) 
         %THEN %GOTO errexit;
      %IF %_handleError(&l_macname.
                       ,NoRepDir
                       ,NOT %_existdir(&l_reportFolder./tempDoc/crossreference)
                       ,folder &l_reportFolder./tempDoc/crossreference does not exist
                       ) 
         %THEN %GOTO errexit;
   %END; 

   /*-- update parameters ----------------------------------------------------*/
   %_writeParameterToTestDBtsu (i_parameterName=tsu_sasautos                  ,i_parameterValue =&l_sasautos.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_sasautos0                 ,i_parameterValue =&l_sasautos.);
   %DO i=1 %TO 29;
      %_writeParameterToTestDBtsu (i_parameterName=tsu_sasautos&i.            ,i_parameterValue =&&l_sasautos&i.);
   %END; /* i=1 %TO 29 */
   %_writeParameterToTestDBtsu (i_parameterName=tsu_project                   ,i_parameterValue =&i_project.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_target                    ,i_parameterValue =&l_target.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_root                      ,i_parameterValue =&l_root.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_project_bin               ,i_parameterValue =&i_root./bin);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_sasunitroot               ,i_parameterValue =&l_sasunitroot.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_sasunit                   ,i_parameterValue =&l_sasunit.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_sasunit_os                ,i_parameterValue =&l_sasunit_os.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_autoexec                  ,i_parameterValue =&l_autoexec.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_sascfg                    ,i_parameterValue =&l_sascfg.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_sasuser                   ,i_parameterValue =&l_sasuser.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_testdata                  ,i_parameterValue =&l_testdata.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_refdata                   ,i_parameterValue =&l_refdata.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_doc                       ,i_parameterValue =&l_doc.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_testcoverage              ,i_parameterValue =&i_testcoverage.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_verbose                   ,i_parameterValue =&i_verbose.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_crossref                  ,i_parameterValue =&i_crossref.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_crossrefsasunit           ,i_parameterValue =&i_crossrefsasunit.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_language                  ,i_parameterValue =&i_language.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_overwrite                 ,i_parameterValue =&i_overwrite.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_log4SASSuiteLogger        ,i_parameterValue =&l_log4SASSuiteLogger.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_log4SASSuiteLogLevel      ,i_parameterValue =&i_log4SASSuiteLogLevel.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_log4SASScenarioLogger     ,i_parameterValue =App.Program.SASUnitScenario);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_log4SASScenarioLogLevel   ,i_parameterValue =&i_log4SASScenarioLogLevel.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_log4SASAssertLogger       ,i_parameterValue =App.Program.SASUnitScenario.Asserts);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_log4SASAssertLogLevel     ,i_parameterValue =&i_log4SASScenarioLogLevel.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_logFolder                 ,i_parameterValue =&l_logFolder.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_scnLogFolder              ,i_parameterValue =&l_scnLogFolder.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_reportFolder              ,i_parameterValue =&l_reportFolder.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_resourceFolder            ,i_parameterValue =&i_resourceFolder.);
   %_writeParameterToTestDBtsu (i_parameterName=tsu_OSEncoding                ,i_parameterValue =&i_OSEncoding.);

   /*-- load relevant information from test database to global macro symbols ----*/
   %_loadEnvironment (i_withLibrefs   =0
                     ,i_caller        =SUITE
                     )

   /* Correct Termstring in Textfiles */
   %_prepareTextFiles;
   
   %IF "&g_error_code." NE "" %THEN %GOTO errexit;

   %IF (&g_runMode. = SASUNIT_BATCH) %THEN %DO;
      /*-- check spawning of a SAS process -----------------------------------------*/
      /* a file will be created in the work library of the parent (this) process 
         to check whether spawning works */
      %LET l_work = %sysfunc(pathname(work));
      PROC DATASETS NOLIST NOWARN LIB=work;
         DELETE check;
      QUIT;

      DATA _null_;
         FILE "&l_work./check_spawning.sas";
         PUT "LIBNAME awork ""&l_work."";";
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
                       ) 
         %THEN %GOTO errexit;

      PROC DATASETS NOLIST NOWARN LIB=work;
         DELETE check;
      QUIT;

      %LET l_rc=%_delFile(&l_work/check_spawning.sas);
   %END;

   %_createExamineeTable;

   /*-- save time of initialization ---------------------------------------------*/
   %_writeParameterToTestDBtsu (i_parameterName=tsu_lastinit         ,i_parameterValue =%sysfunc(datetime()));
   /*-- update column tsu_dbVersion ------------------------------------------*/
   %_writeParameterToTestDBtsu (i_parameterName=tsu_dbVersion        ,i_parameterValue =&g_db_version.);

   %IF (&g_runMode. = SASUNIT_INTERACTIVE) %THEN %DO;
      %_reportCreateStyle;
      %_reportCreateTagset;
   %END;

   %_issueInfoMessage(&g_currentLogger., %str (============================ SASUnit has been initialized successfully ==========================));
   %RETURN;
   
%errexit:
   %_issueErrorMessage(&g_currentLogger., %str (===================== Errors occured! Check log files! ===========================================));
   %goto EndSASUnit;
   
%fatalexit:
   %_issueFatalMessage(&g_currentLogger., %str (===================== Fatal errors occured! test suite aborted! ===========================================));
   
%EndSASUnit:   
   LIBNAME target clear;
   %abort 9;
%MEND initSASUnit;
/** \endcond */
