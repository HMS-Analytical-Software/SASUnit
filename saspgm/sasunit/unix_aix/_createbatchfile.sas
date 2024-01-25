/**
   \file
   \ingroup    SASUNIT_SETUP_UNIX

   \brief      Creates a shell skript to start SASUnit in batch
   
               This macro is called from os-independend macro _createbatchfiles.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the Lesser GPL license see included file readme.txt
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/readme/.
               
   \param      i_sasunitCommandFile       Name of the scriptfile that should be generated (e.g. sasunit.9.3.unix.en.overwrite.fast.sh)
   \param      i_operatingSystem          Name of the operating system under which SAS is running. It is also part of the name of the config file.
   \param      i_sasVersion               SAS Version that is used to run SASUnit. SAS Version is part of the path to SAS provided config file and it is also part ot the name of the config file.
   \param      i_sasExe                   Path and name os SAS.EXE to be used for running SASUnit.
   \param      i_sasConfig                Path and name of the of the SAS provided config file that should be used to run SASUnit
   \param      i_sasunitRootFolder        Path to the SASUnit root folder.
   \param      i_projectRootFolder        Path to the project root folder used to resolve the complete path of i_sasunitRunAllPgm.
   \param      i_sasunitTestDBFolder      Name of the target folder where the test data base of SASUnit resides.
   \param      i_sasunitLogFolder         Name of the folder where the log file of run_all.sas should be stored.
   \param      i_sasunitScnLogFolder      Name of the folder where the log files of all scenarios should be stored.
   \param      i_sasunitPgmDoc            Flag if program documentation for project macros should be generated (0 / 1)
   \param      i_sasunitRunAllPgm         Name of the program that starts all scenarios, containing calls \%initSASUnit, \%runSASUnit and \%reportSASUnit.
   \param      i_sasunitReportFolder      Name of the folder where the SASUnit documentation (test and program) should be stored.
   \param      i_sasunitResourceFolder    Path and name of the folder where the resource files (css, js, html) are located
   \param      i_sasunitOverwrite         Flag if all scenarios should be started or only scenarios where scenario or examinee have chenged since last run (0 / 1)
   \param      i_sasunitLanguage          Language that should be used in the SAS session. It is also part of the name of the config file.
   \param      i_sasunitTestCoverage      Flag if test coverage should be generated (0 / 1)
   \param      i_sasunitPgmDocSASUnit     Flag if program documentation for SASUnit macros should be generated (0 / 1)
   \param      i_sasunitCrossRef          Flag if cross reference reports for project macros should be generated (0 / 1)
   \param      i_sasunitCrossRefSASUnit   Flag if cross reference reports for SASUnit macros should be generated (0 / 1)
   \param      i_sasunitLogLevel          Log4SSAS Logging level that is used for SASUnit suite
   \param      i_sasunitScnLogLevel       Log4SSAS Logging level that is used for all senarios
   \param      i_OSEncoding               Encoding of OS which can be different from encoding of SAS session
   \param      i_reportsOnly              specifying if starting scenarios should be skipped and only the documentation part will be run
*/ /** \cond */
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
                       ,i_sasunitResourceFolder    =
                       ,i_sasunitOverwrite         =
                       ,i_sasunitLanguage          =
                       ,i_sasunitTestCoverage      =
                       ,i_sasunitPgmDocSASUnit     =
                       ,i_sasunitCrossRef          =
                       ,i_sasunitCrossRefSASUnit   =
                       ,i_sasunitLogLevel          =
                       ,i_sasunitScnLogLevel       =
                       ,i_OSEncoding               =
                       ,i_reportsOnly              =
                       );

   %local
      l_sasunitCommandFile
   ;
   
   %let l_sasunitCommandFile =%_makeSASUnitPath (&i_sasunitCommandFile.);
   %let l_sasunitCommandFile =%_adaptSASUnitPathToOS (&l_sasunitCommandFile.);
   
   data _null_;
      file "&l_sasunitCommandFile..sh";
      
      put "#!/bin/bash";
      put "# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.";
      put "# For copyright information and terms of usage under the GPL license see included file readme.txt";
      put "# or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.";
      put;
      put "cd ..";
      put;
      put "# --------------------------------------------------------------------------------";
      put "# --- EnvVars for SAS Configuration ----------------------------------------------";
      put "export SASUNIT_HOST_OS=&i_operatingSystem.";
      put "export SASUNIT_HOST_ENCODING=&i_OSEncoding.";
      put "export SASUNIT_SAS_VERSION=&i_sasVersion.";
      put "export SASUNIT_SAS_EXE=&i_sasExe.";
      put "export SASUNIT_SAS_CFG=&i_sasConfig.";
      put "# --------------------------------------------------------------------------------";
      put "# --- EnvVars for SAS Unit Configuration -----------------------------------------";
      put "export SASUNIT_ROOT=""&i_sasunitRootFolder.""";
      put "export SASUNIT_PROJECT_ROOT=""&i_projectRootFolder.""";
      put "export SASUNIT_TEST_DB_FOLDER=""&i_sasunitTestDBFolder.""";
      put "export SASUNIT_LOG_FOLDER=""&i_sasunitLogFolder.""";
      put "export SASUNIT_SCN_LOG_FOLDER=""&i_sasunitScnLogFolder.""";
      put "export SASUNIT_RUNALL=""&i_sasunitRunAllPgm.""";
      put "export SASUNIT_REPORT_FOLDER=""&i_sasunitReportFolder.""";
      put "export SASUNIT_RESOURCE_FOLDER=""&i_sasunitResourceFolder.""";
      put "export SASUNIT_OVERWRITE=&i_sasunitOverwrite.";
      put "export SASUNIT_LANGUAGE=&i_sasunitLanguage.";
      put "export SASUNIT_COVERAGEASSESSMENT=&i_sasunitTestCoverage.";
      put "export SASUNIT_PGMDOC=&i_sasunitPgmDoc.";
      put "export SASUNIT_PGMDOC_SASUNIT=&i_sasunitPgmDocSASUnit.";
      put "export SASUNIT_CROSSREFERENCE=&i_sasunitCrossRef.";
      put "export SASUNIT_CROSSREFERENCE_SASUNIT=&i_sasunitCrossRefSASUnit.";
      put "export SASUNIT_LOGLEVEL=&i_sasunitLogLevel.";
      put "export SASUNIT_SCN_LOGLEVEL=&i_sasunitScnLogLevel.";
      put "export SASUNIT_REPORTS_ONLY=&i_reportsOnly.";
      put "export SASUNIT_CONFIG=${SASUNIT_PROJECT_ROOT}bin/sasunit.$SASUNIT_SAS_VERSION.$SASUNIT_HOST_OS.$SASUNIT_LANGUAGE.cfg";
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
      put 'echo Host OS Encoding          = $SASUNIT_HOST_ENCODING';
      put 'echo SAS Version               = $SASUNIT_SAS_VERSION';
      put 'echo SAS Executable            = $SASUNIT_SAS_EXE';
      put 'echo SAS Config File           = $SASUNIT_SAS_CFG';
      put "echo --- EnvVars for SAS Unit Configuration -----------------------------------------";
      put 'echo SASUnit config            = $SASUNIT_CONFIG';
      put 'echo SASUnit Root Path         = $SASUNIT_ROOT';
      put 'echo Project Root Path         = $SASUNIT_PROJECT_ROOT';
      put 'echo Folder for TestDB         = $SASUNIT_TEST_DB_FOLDER';
      put 'echo Folder for Log Files      = $SASUNIT_LOG_FOLDER';
      put 'echo Folder for Scn Log Files  = $SASUNIT_SCN_LOG_FOLDER';
      put 'echo Folder for Reports        = $SASUNIT_REPORT_FOLDER';
      put 'echo Folder for Resource Files = $SASUNIT_REPORT_FOLDER';
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
      put 'echo Documentation only        = $SASUNIT_REPORTS_ONLY';
      put "echo";
      put;
      put "echo ""Starting SASUnit ...""";
      put "$SASUNIT_SAS_EXE -nosyntaxcheck -noovp -sysin ""$SASUNIT_RUNALL"" -LOGCONFIGLOC ""./bin/sasunit.logconfig.&i_sasunitLanguage..xml"" /*-log ""$SASUNIT_LOG_FOLDER/run_all.log""*/";
      put;
      put "# Show SAS exit status";
      put "RETVAL=$?";
      put "if [ $RETVAL -eq 1 ]";
      put "	then printf ""\nSAS ended with warnings. Review run_all.log for details.\n""";
      put "elif [ $RETVAL -eq 2 ]";
      put "	then printf ""\nSAS ended with errors! Check run_all.log for details!\n""";
      put "fi";
   run;
   
   %sysexec chmod a+x &l_sasunitCommandFile..sh;
%mend _createBatchFile;
/** \endcond */   