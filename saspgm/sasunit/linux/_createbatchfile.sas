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
      file "&i_sasunitCommandFile..sh";
      
      put "#!/bin/bash";
      put "# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.";
      put "# For copyright information and terms of usage under the GPL license see included file readme.txt";
      put "# or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.";
      put;
      put "cd ..";
      put;
      put "# --------------------------------------------------------------------------------";
      put "# --- EnvVars for SAS Configuration ----------------------------------------------";
      put "export SASUNIT_HOST_OS=&i_operatingSystem.";
      put "export SASUNIT_SAS_VERSION=&i_sasVersion.";
      put "export SASUNIT_SAS_EXE=&i_sasExe.";
      put "export SASUNIT_SAS_CFG=&i_sasConfig.";
      put "# --------------------------------------------------------------------------------";
      put "# --- EnvVars for SAS Unit Configuration -----------------------------------------";
      put "export SASUNIT_ROOT=&i_sasunitRootFolder.";
      put "export SASUNIT_PROJECT_ROOT=&i_projectRootFolder.";
      put "export SASUNIT_TEST_DB_FOLDER=&i_sasunitTestDBFolder.";
      put "export SASUNIT_LOG_FOLDER=&i_sasunitLogFolder.";
      put "export SASUNIT_SCN_LOG_FOLDER=&i_sasunitScnLogFolder.";
      put "export SASUNIT_RUNALL=&i_sasunitRunAllPgm.";
      put "export SASUNIT_REPORT_FOLDER=&i_sasunitReportFolder.";
      put "export SASUNIT_OVERWRITE=&i_sasunitOverwrite.";
      put "export SASUNIT_LANGUAGE=&i_sasunitLanguage.";
      put "export SASUNIT_COVERAGEASSESSMENT=&i_sasunitTestCoverage.";
      put "export SASUNIT_PGMDOC=&i_sasunitPgmDoc.";
      put "export SASUNIT_PGMDOC_SASUNIT=&i_sasunitPgmDocSASUnit.";
      put "export SASUNIT_CROSSREFERENCE=&i_sasunitCrossRef.";
      put "export SASUNIT_CROSSREFERENCE_SASUNIT=&i_sasunitCrossRefSASUnit.";
      put "export SASUNIT_LOGLEVEL=&i_sasunitLogLevel.";
      put "export SASUNIT_SCN_LOGLEVEL=&i_sasunitScnLogLevel.";
      put;
      put "# Check if SASUnit Jenkins Plugin is present and use given SASUnit root path";
      put "if [ -z ""$1"" ] ; then";
      put "   echo ... parameter not found. Using SASUnit root path from skript";
      put "   echo";
      put "else";
      put "   export SASUNIT_ROOT=""$(eval echo $1)""";
      put "   echo ...plugin found. Using plugin provided SASUnit root path";
      put "   echo";
      put "fi";
      put "echo";
      put "echo --- EnvVars for SAS Configuration ----------------------------------------------";
      put 'echo Host Operating System     = $SASUNIT_HOST_OS';
      put 'echo SAS Version               = $SASUNIT_SAS_VERSION';
      put 'echo SAS Exceutable            = $SASUNIT_SAS_EXE';
      put 'echo SAS Config File           = $SASUNIT_SAS_CFG';
      put "echo --- EnvVars for SAS Unit Configuration -----------------------------------------";
      put 'echo SASUnit Root Path         = $SASUNIT_ROOT';
      put 'echo Project Root Path         = $SASUNIT_PROJECT_ROOT';
      put 'echo Folder for TestDB         = $SASUNIT_TEST_DB_FOLDER';
      put 'echo Folder for Log Files      = $SASUNIT_LOG_FOLDER';
      put 'echo Folder for Scn Log Files  = $SASUNIT_SCN_LOG_FOLDER';
      put 'echo Folder for Reports        = $SASUNIT_REPORT_FOLDER';
      put 'echo Name of RUN_ALL Program   = $SASUNIT_RUNALL';
      put 'echo Overwrite                 = $SASUNIT_OVERWRITE';
      put 'echo Language                  = $SASUNIT_LANGUAGE';
      put 'echo Testcoverage              = $SASUNIT_COVERAGEASSESSMENT';
      put 'echo Program Documentation     = $SASUNIT_PGMDOC';
      put 'echo PgmDoc for SASUnit        = $SASUNIT_PGMDOC_SASUNIT';
      put 'echo Crossreference            = $SASUNIT_CROSSREFERENCE';
      put 'echo Crossref for SASUnit      = $SASUNIT_CROSSREFERENCE_SASUNIT';
      put 'echo Log Level for RUN_ALL     = $SASUNIT_LOGLEVEL';
      put 'echo Log Level for Scenarios   = $SASUNIT_SCN_LOGLEVEL';
      put "echo";
      put;
      put "echo ""Starting SASUnit ...""";
      put "$SASUNIT_SAS_EXE -nosyntaxcheck -noovp -sysin $SASUNIT_RUNALL -log $SASUNIT_LOG_FOLDER/run_all.log";
      put;
      put "# Show SAS exit status";
      put "RETVAL=$?";
      put "if [ $RETVAL -eq 1 ]";
      put "	then printf ""\nSAS ended with warnings. Review run_all.log for details.\n""";
      put "elif [ $RETVAL -eq 2 ]";
      put "	then printf ""\nSAS ended with errors! Check run_all.log for details!\n""";
      put "fi";
   run;
   
   %sysexec chmod a+x &i_sasunitCommandFile..sh;
%mend _createBatchFile;