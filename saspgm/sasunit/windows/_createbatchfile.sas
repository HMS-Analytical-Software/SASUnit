/**

\todo Header
*/

%macro _createBatchFile(i_sasunitCommandFile       =
                       ,i_operatingSystem          =
                       ,i_sasVersion               =
                       ,i_sasExe                   =
                       ,i_sasConfig                =
                       ,i_sasunitRootFolder        =
                       ,i_projectRootFolder        =
                       ,i_sasunitTestDBFolder      =
                       ,i_sasunitLogFolder         =
                       ,i_sasunitScnLogFolder      =
                       ,i_sasunitPgmDoc            =
                       ,i_sasunitRunAllPgm         =
                       ,i_sasunitReportFolder      =
                       ,i_sasunitOverwrite         =
                       ,i_sasunitLanguage          =
                       ,i_sasunitTestCoverage      =
                       ,i_sasunitPgmDocSASUnit     =
                       ,i_sasunitCrossRef          =
                       ,i_sasunitCrossRefSASUnit   =
                       ,i_sasunitLogLevel          =
                       ,i_sasunitScnLogLevel       =
                       );
                       
   data _null_;
      file "&i_sasunitCommandFile..cmd";
      
      put "@echo off";
      put "REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.";
      put "REM For copyright information and terms of usage under the GPL license see included file readme.txt";
      put "REM or https://sourceforge.net/p/sasunit/wiki/readme/.";
      put;
      put "cd ..";
      put;
      put "REM --------------------------------------------------------------------------------";
      put "REM --- EnvVars for SAS Configuration ----------------------------------------------";
      put "SET SASUNIT_HOST_OS=&i_operatingSystem.";
      put "SET SASUNIT_SAS_VERSION=&i_sasVersion.";
      put "SET SASUNIT_SAS_EXE=&i_sasExe.";
      put "SET SASUNIT_SAS_CFG=&i_sasConfig.";
      put "REM --------------------------------------------------------------------------------";
      put "REM --- EnvVars for SAS Unit Configuration -----------------------------------------";
      put "SET SASUNIT_ROOT=&i_sasunitRootFolder.";
      put "SET SASUNIT_PROJECT_ROOT=&i_projectRootFolder.";
      put "SET SASUNIT_TEST_DB_FOLDER=&i_sasunitTestDBFolder.";
      put "SET SASUNIT_LOG_FOLDER=&i_sasunitLogFolder.";
      put "SET SASUNIT_SCN_LOG_FOLDER=&i_sasunitScnLogFolder.";
      put "SET SASUNIT_RUNALL=&i_sasunitRunAllPgm.";
      put "SET SASUNIT_REPORT_FOLDER=&i_sasunitReportFolder.";
      put "SET SASUNIT_OVERWRITE=&i_sasunitOverwrite.";
      put "SET SASUNIT_LANGUAGE=&i_sasunitLanguage.";
      put "SET SASUNIT_COVERAGEASSESSMENT=&i_sasunitTestCoverage.";
      put "SET SASUNIT_PGMDOC=&i_sasunitPgmDoc.";
      put "SET SASUNIT_PGMDOC_SASUNIT=&i_sasunitPgmDocSASUnit.";
      put "SET SASUNIT_CROSSREFERENCE=&i_sasunitCrossRef.";
      put "SET SASUNIT_CROSSREFERENCE_SASUNIT=&i_sasunitCrossRefSASUnit.";
      put "SET SASUNIT_LOGLEVEL=&i_sasunitLogLevel.";
      put "SET SASUNIT_SCN_LOGLEVEL=&i_sasunitScnLogLevel.";
      put;
      put "REM Check if SASUnit Jenkins Plugin is present and use given SASUnit root path";
      put "echo Checking for presence of SASUnit Jenkins plugin...";
      put "if not [%1] == [] SET SASUNIT_ROOT=%~1";
      put "if [%1] == [] (";
      put "   echo ... parameter not found. Using SASUnit root path from script";
      put "   echo.";
      put ") else (";
      put "   echo ...plugin found. Using plugin provided SASUnit root path";
      put "   echo.";
      put ")";
      put;
      put "echo.";
      put "echo --- EnvVars for SAS Configuration ----------------------------------------------";
      put 'echo Host Operating System     = %SASUNIT_HOST_OS%';
      put 'echo SAS Version               = %SASUNIT_SAS_VERSION%';
      put 'echo SAS Exceutable            = %SASUNIT_SAS_EXE%';
      put 'echo SAS Config File           = %SASUNIT_SAS_CFG%';
      put "echo --- EnvVars for SAS Unit Configuration -----------------------------------------";
      put 'echo SASUnit Root Path         = %SASUNIT_ROOT%';
      put 'echo Project Root Path         = %SASUNIT_PROJECT_ROOT%';
      put 'echo Folder for TestDB         = %SASUNIT_TEST_DB_FOLDER%';
      put 'echo Folder for Log Files      = %SASUNIT_LOG_FOLDER%';
      put 'echo Folder for Scn Log Files  = %SASUNIT_SCN_LOG_FOLDER%';
      put 'echo Folder for Reports        = %SASUNIT_REPORT_FOLDER%';
      put 'echo Name of RUN_ALL Program   = %SASUNIT_RUNALL%';
      put 'echo Overwrite                 = %SASUNIT_OVERWRITE%';
      put 'echo Language                  = %SASUNIT_LANGUAGE%';
      put 'echo Testcoverage              = %SASUNIT_COVERAGEASSESSMENT%';
      put 'echo Program Documentation     = %SASUNIT_PGMDOC%';
      put 'echo PgmDoc for SASUnit        = %SASUNIT_PGMDOC_SASUNIT%';
      put 'echo Crossreference            = %SASUNIT_CROSSREFERENCE%';
      put 'echo Crossref for SASUnit      = %SASUNIT_CROSSREFERENCE_SASUNIT%';
      put 'echo Log Level for RUN_ALL     = %SASUNIT_LOGLEVEL%';
      put 'echo Log Level for Scenarios   = %SASUNIT_SCN_LOGLEVEL%';
      put 'echo SASUnit config            = bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg';
      put "echo.";
      put;
      put "echo ""Starting SASUnit ...""";
      put """&i_sasexe."" -CONFIG ""bin\sasunit.%nrstr(%%SASUNIT_SAS_VERSION%%.%%SASUNIT_HOST_OS%%.%%SASUNIT_LANGUAGE%%).cfg"" -no$syntaxcheck -noovp -nosplash -LOGCONFIGLOC ""bin\sasunit.logconfig.&i_sasunitLanguage..xml""";
      put;
      put 'if %ERRORLEVEL%==0 goto normalexit';
      put "@echo. ";
      put '@echo Exit code: %ERRORLEVEL%';
      put "@echo. ";
      put 'if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.';
      put 'if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!';
      put "@echo.";
      put "pause";
      put ":normalexit";
   run;
%mend _createBatchFile;
