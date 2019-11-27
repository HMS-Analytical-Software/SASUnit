%macro _createBatchFile(i_sasunitCommandFile=
                       ,i_sasunitRootFolder=
                       ,i_projectBinFolder=
                       ,i_sasunitOverwrite=
                       ,i_sasunitLanguage=
                       ,i_operatingSystem=
                       ,i_sasunitTestCoverage=
                       ,i_sasunitPgmDoc=
                       ,i_sasunitPgmDocSASUnit=
                       ,i_sasunitCrossRef=
                       ,i_sasunitCrossRefSASUnit=
                       ,i_sasunitVerbose=
                       ,i_sasVersion=
                       ,i_sasexe=
                       ,i_sasunitJenkinsPlugin=
                       ,i_sasunitLogPath=
                       ,i_sasunitScnLogPath=
                       );
					   
   data _null_;
      file "&i_sasunitCommandFile..cmd";
      
      put "@echo off";
      put "REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.";
      put "REM For copyright information and terms of usage under the GPL license see included file readme.txt";
      put "REM or https://sourceforge.net/p/sasunit/wiki/readme/.";
      put;
      put "cd ..";
      put "SET SASUNIT_ROOT=&i_sasunitRootFolder.";
      put "SET SASUNIT_OVERWRITE=&i_sasunitOverwrite.";
      put "SET SASUNIT_LANGUAGE=&i_sasunitLanguage.";
      put "SET SASUNIT_HOST_OS=&i_operatingSystem.";
      put "SET SASUNIT_SAS_VERSION=&i_sasVersion.";
      put "SET SASUNIT_COVERAGEASSESSMENT=&i_sasunitTestCoverage.";
      put "SET SASUNIT_PGMDOC=&i_sasunitPgmDoc.";
      put "SET SASUNIT_PGMDOC_SASUNIT=&i_sasunitPgmDocSASUnit.";
      put "SET SASUNIT_CROSSREFERENCE=&i_sasunitCrossRef.";
      put "SET SASUNIT_CROSSREFERENCE_SASUNIT=&i_sasunitCrossRefSASUnit.";
      put "SET SASUNIT_VERBOSE=&i_sasunitVerbose.";
      put "SET SASUNIT_PROJECT_BIN_FOLDER=&i_projectBinFolder.";
      put;
      put "echo.";
      put 'echo SASUnit root path     = %SASUNIT_ROOT%';
      put 'echo SASUnit config        = bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg';
      put 'echo Overwrite             = %SASUNIT_OVERWRITE%';
      put 'echo Testcoverage          = %SASUNIT_COVERAGEASSESSMENT%';
      put 'echo Program Documentation = %SASUNIT_PGMDOC%';
      put 'echo PgmDoc for SASUnit    = %SASUNIT_PGMDOC_SASUNIT%';
      put 'echo Crossreference        = %SASUNIT_CROSSREFERENCE%';
      put 'echo Crossref for SASUnit  = %SASUNIT_CROSSREFERENCE_SASUNIT%';
      put 'echo Verbose               = %SASUNIT_VERBOSE%';
      put 'echo Project bin folder    = %SASUNIT_PROJECT_BIN_FOLDER%';
      put "echo.";
      put;
      if (&i_sasunitOverwrite. = 0) then do;
         put "echo ""Starting SASUnit ...""";
      end;
      else do;
         put "echo ""Starting SASUnit in overwrite mode...""";
      end;
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
