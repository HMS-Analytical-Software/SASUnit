/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      Creates shell skripts to start SASUnit in batch
   
               A series of shell scripts is created as blue prints, how to start SASUnit in different ways

   \version    \$Revision: GitBranch: feature/jira-29-separate-SASUnit-files-from-project-source $
   \author     \$Author: landwich $
   \date       \$Date: 2024-03-13 11:25:41 (Mi, 13. März 2024) $
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
               
   \param i_operatingSystem         Name of the operating system under which SAS is running. It is also part of the name of the config file.
   \param i_sasVersion              SAS Version that is used to run SASUnit. SAS Version is part of the path to SAS provided config file and it is also part ot the name of the config file.
   \param i_sasExe                  Path and name os SAS.EXE to be used for running SASUnit.
   \param i_sasConfig               Path and name of the of the SAS provided config file that should be used to run SASUnit
   \param i_sasunitRootFolder       Path to the SASUnit root folder.
   \param i_projectRootFolder       Path to the project root folder used to resolve the complete path of i_sasunitRunAllPgm.
   \param i_autocallRootFolder      Path and name of the root folder holding all autocall folders
   \param i_testScenarioRootFolder  Path and name of the root folder holding all folders with test scenarios
   \param i_projectBinFolder        Name of the folder contain the binary files an shell scripts to start SASUnit (usually bin).
                                    <BR>Signifies the location of the config file.
   \param i_sasunitTestDBFolder     Name of the target folder where the test data base of SASUnit resides.
   \param i_sasunitLogFolder        Name of the folder where the log file of run_all.sas should be stored.
   \param i_sasunitScnLogFolder     Name of the folder where the log files of all scenarios should be stored.
   \param i_sasunitRunAllPgm        Name of the program that starts all scenarios, containing calls \%initSASUnit, \%runSASUnit and \%reportSASUnit.
   \param i_sasunitLanguage         Language that should be used in the SAS session. It is also part of the name of the config file.
   \param i_sasunitReportFolder     Name of the folder where the SASUnit documentation (test and program) should be stored.
   \param i_sasunitResourceFolder   Path and name of the folder where the resource files (css, js, html) are located
   \param i_sasunitLogLevel         Log4SSAS Logging level that is used for SASUnit suite
   \param i_sasunitScnLogLevel      Log4SSAS Logging level that is used for all senarios
   \param i_OSEncoding              Encoding of OS which can be different from encoding of SAS session
*/ /** \cond */
%macro _createBatchFiles(i_operatingSystem         =
                        ,i_sasVersion              =
                        ,i_sasexe                  =                        
                        ,i_sasConfig               =
                        ,i_sasunitRootFolder       =
                        ,i_projectRootFolder       =
                        ,i_autocallRootFolder      =
                        ,i_testScenarioRootFolder  =
                        ,i_projectBinFolder        =
                        ,i_sasunitTestDBFolder     =
                        ,i_sasunitLogFolder        =
                        ,i_sasunitScnLogFolder     =
                        ,i_sasunitRunAllPgm        =
                        ,i_sasunitLanguage         =
                        ,i_sasunitReportFolder     =
                        ,i_sasunitResourceFolder   =
                        ,i_sasunitLogLevel         =
                        ,i_sasunitScnLogLevel      =
                        ,i_OSEncoding              =
                        );

   %local
	  l_projectBinFolder
   ;

   %let l_projectBinFolder    =%_stdPath(&i_projectRootFolder., &i_projectBinFolder.);

   %_createBatchFile(i_sasunitCommandFile       =&i_projectBinFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..overwrite.fast
                    ,i_operatingSystem          =&i_operatingSystem.
                    ,i_sasVersion               =&i_sasVersion.
                    ,i_sasexe                   =&i_sasexe.
                    ,i_sasConfig                =&i_sasConfig.
                    ,i_sasunitRootFolder        =&i_sasunitRootFolder.
                    ,i_projectRootFolder        =&i_projectRootFolder.
                    ,i_autocallRootFolder       =&i_autocallRootFolder.
                    ,i_testScenarioRootFolder   =&i_testScenarioRootFolder.
                    ,i_sasunitTestDBFolder      =&i_sasunitTestDBFolder.
                    ,i_sasunitLogFolder         =&i_sasunitLogFolder.
                    ,i_sasunitScnLogFolder      =&i_sasunitScnLogFolder.
                    ,i_sasunitPgmDoc            =0
                    ,i_sasunitRunAllPgm         =&i_sasunitRunAllPgm.
                    ,i_sasunitOverwrite         =1
                    ,i_sasunitLanguage          =&i_sasunitLanguage.
                    ,i_sasunitTestCoverage      =0
                    ,i_sasunitPgmDocSASUnit     =0
                    ,i_sasunitCrossRef          =0
                    ,i_sasunitCrossRefSASUnit   =0                    
                    ,i_sasunitLogLevel          =&i_sasunitLogLevel.
                    ,i_sasunitScnLogLevel       =&i_sasunitScnLogLevel.
                    ,i_sasunitReportFolder      =&i_sasunitReportFolder.
                    ,i_sasunitResourceFolder    =&i_sasunitResourceFolder.
                    ,i_OSEncoding               =&i_OSEncoding.
                    ,i_reportsOnly              =0
                    );
   %_createBatchFile(i_sasunitCommandFile=&i_projectBinFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..overwrite.full
                    ,i_operatingSystem          =&i_operatingSystem.
                    ,i_sasVersion               =&i_sasVersion.
                    ,i_sasexe                   =&i_sasexe.
                    ,i_sasConfig                =&i_sasConfig.
                    ,i_sasunitRootFolder        =&i_sasunitRootFolder.
                    ,i_projectRootFolder        =&i_projectRootFolder.
                    ,i_autocallRootFolder       =&i_autocallRootFolder.
                    ,i_testScenarioRootFolder   =&i_testScenarioRootFolder.
                    ,i_sasunitTestDBFolder      =&i_sasunitTestDBFolder.
                    ,i_sasunitLogFolder         =&i_sasunitLogFolder.
                    ,i_sasunitScnLogFolder      =&i_sasunitScnLogFolder.
                    ,i_sasunitPgmDoc            =1
                    ,i_sasunitRunAllPgm         =&i_sasunitRunAllPgm.
                    ,i_sasunitOverwrite         =1
                    ,i_sasunitLanguage          =&i_sasunitLanguage.
                    ,i_sasunitTestCoverage      =1
                    ,i_sasunitPgmDocSASUnit     =1
                    ,i_sasunitCrossRef          =1
                    ,i_sasunitCrossRefSASUnit   =1
                    ,i_sasunitLogLevel          =&i_sasunitLogLevel.
                    ,i_sasunitScnLogLevel       =&i_sasunitScnLogLevel.
                    ,i_sasunitReportFolder      =&i_sasunitReportFolder.
                    ,i_sasunitResourceFolder    =&i_sasunitResourceFolder.
                    ,i_OSEncoding               =&i_OSEncoding.
                    ,i_reportsOnly              =0
                    );
   %_createBatchFile(i_sasunitCommandFile=&i_projectBinFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..fast
                    ,i_operatingSystem          =&i_operatingSystem.
                    ,i_sasVersion               =&i_sasVersion.
                    ,i_sasexe                   =&i_sasexe.
                    ,i_sasConfig                =&i_sasConfig.
                    ,i_sasunitRootFolder        =&i_sasunitRootFolder.
                    ,i_projectRootFolder        =&i_projectRootFolder.
                    ,i_autocallRootFolder       =&i_autocallRootFolder.
                    ,i_testScenarioRootFolder   =&i_testScenarioRootFolder.
                    ,i_sasunitTestDBFolder      =&i_sasunitTestDBFolder.
                    ,i_sasunitLogFolder         =&i_sasunitLogFolder.
                    ,i_sasunitScnLogFolder      =&i_sasunitScnLogFolder.
                    ,i_sasunitPgmDoc            =0
                    ,i_sasunitRunAllPgm         =&i_sasunitRunAllPgm.
                    ,i_sasunitOverwrite         =0
                    ,i_sasunitLanguage          =&i_sasunitLanguage.
                    ,i_sasunitTestCoverage      =0
                    ,i_sasunitPgmDocSASUnit     =0
                    ,i_sasunitCrossRef          =0
                    ,i_sasunitCrossRefSASUnit   =0
                    ,i_sasunitLogLevel          =&i_sasunitLogLevel.
                    ,i_sasunitScnLogLevel       =&i_sasunitScnLogLevel.
                    ,i_sasunitReportFolder      =&i_sasunitReportFolder.
                    ,i_sasunitResourceFolder    =&i_sasunitResourceFolder.
                    ,i_OSEncoding               =&i_OSEncoding.
                    ,i_reportsOnly              =0
                    );
   %_createBatchFile(i_sasunitCommandFile=&i_projectBinFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..full
                    ,i_operatingSystem          =&i_operatingSystem.
                    ,i_sasVersion               =&i_sasVersion.
                    ,i_sasexe                   =&i_sasexe.
                    ,i_sasConfig                =&i_sasConfig.
                    ,i_sasunitRootFolder        =&i_sasunitRootFolder.
                    ,i_projectRootFolder        =&i_projectRootFolder.
                    ,i_autocallRootFolder       =&i_autocallRootFolder.
                    ,i_testScenarioRootFolder   =&i_testScenarioRootFolder.
                    ,i_sasunitTestDBFolder      =&i_sasunitTestDBFolder.
                    ,i_sasunitLogFolder         =&i_sasunitLogFolder.
                    ,i_sasunitScnLogFolder      =&i_sasunitScnLogFolder.
                    ,i_sasunitPgmDoc            =1
                    ,i_sasunitRunAllPgm         =&i_sasunitRunAllPgm.
                    ,i_sasunitOverwrite         =0
                    ,i_sasunitLanguage          =&i_sasunitLanguage.
                    ,i_sasunitTestCoverage      =1
                    ,i_sasunitPgmDocSASUnit     =1
                    ,i_sasunitCrossRef          =1
                    ,i_sasunitCrossRefSASUnit   =1
                    ,i_sasunitLogLevel          =&i_sasunitLogLevel.
                    ,i_sasunitScnLogLevel       =&i_sasunitScnLogLevel.
                    ,i_sasunitReportFolder      =&i_sasunitReportFolder.
                    ,i_sasunitResourceFolder    =&i_sasunitResourceFolder.
                    ,i_OSEncoding               =&i_OSEncoding.
                    ,i_reportsOnly              =0
                    );

   %_createBatchFile(i_sasunitCommandFile=&i_projectBinFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..debug
                    ,i_operatingSystem          =&i_operatingSystem.
                    ,i_sasVersion               =&i_sasVersion.
                    ,i_sasexe                   =&i_sasexe.
                    ,i_sasConfig                =&i_sasConfig.
                    ,i_sasunitRootFolder        =&i_sasunitRootFolder.
                    ,i_projectRootFolder        =&i_projectRootFolder.
                    ,i_autocallRootFolder       =&i_autocallRootFolder.
                    ,i_testScenarioRootFolder   =&i_testScenarioRootFolder.
                    ,i_sasunitTestDBFolder      =&i_sasunitTestDBFolder.
                    ,i_sasunitLogFolder         =&i_sasunitLogFolder.
                    ,i_sasunitScnLogFolder      =&i_sasunitScnLogFolder.
                    ,i_sasunitPgmDoc            =0
                    ,i_sasunitRunAllPgm         =&i_sasunitRunAllPgm.
                    ,i_sasunitOverwrite         =1
                    ,i_sasunitLanguage          =&i_sasunitLanguage.
                    ,i_sasunitTestCoverage      =1
                    ,i_sasunitPgmDocSASUnit     =0
                    ,i_sasunitCrossRef          =1
                    ,i_sasunitCrossRefSASUnit   =1
                    ,i_sasunitLogLevel          =DEBUG
                    ,i_sasunitScnLogLevel       =DEBUG
                    ,i_sasunitReportFolder      =&i_sasunitReportFolder.
                    ,i_sasunitResourceFolder    =&i_sasunitResourceFolder.
                    ,i_OSEncoding               =&i_OSEncoding.
                    ,i_reportsOnly              =0
                    );
   %_createBatchFile(i_sasunitCommandFile=&i_projectBinFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..trace
                    ,i_operatingSystem          =&i_operatingSystem.
                    ,i_sasVersion               =&i_sasVersion.
                    ,i_sasexe                   =&i_sasexe.
                    ,i_sasConfig                =&i_sasConfig.
                    ,i_sasunitRootFolder        =&i_sasunitRootFolder.
                    ,i_projectRootFolder        =&i_projectRootFolder.
                    ,i_autocallRootFolder       =&i_autocallRootFolder.
                    ,i_testScenarioRootFolder   =&i_testScenarioRootFolder.
                    ,i_sasunitTestDBFolder      =&i_sasunitTestDBFolder.
                    ,i_sasunitLogFolder         =&i_sasunitLogFolder.
                    ,i_sasunitScnLogFolder      =&i_sasunitScnLogFolder.
                    ,i_sasunitPgmDoc            =0
                    ,i_sasunitRunAllPgm         =&i_sasunitRunAllPgm.
                    ,i_sasunitOverwrite         =1
                    ,i_sasunitLanguage          =&i_sasunitLanguage.
                    ,i_sasunitTestCoverage      =0
                    ,i_sasunitPgmDocSASUnit     =0
                    ,i_sasunitCrossRef          =0
                    ,i_sasunitCrossRefSASUnit   =0
                    ,i_sasunitLogLevel          =TRACE
                    ,i_sasunitScnLogLevel       =TRACE
                    ,i_sasunitReportFolder      =&i_sasunitReportFolder.
                    ,i_sasunitResourceFolder    =&i_sasunitResourceFolder.
                    ,i_OSEncoding               =&i_OSEncoding.
                    ,i_reportsOnly              =0
                    );
   %_createBatchFile(i_sasunitCommandFile       =&i_projectBinFolder./sasunit.&i_sasVersion..&i_operatingSystem..&i_sasunitLanguage..reports_only
                    ,i_operatingSystem          =&i_operatingSystem.
                    ,i_sasVersion               =&i_sasVersion.
                    ,i_sasexe                   =&i_sasexe.
                    ,i_sasConfig                =&i_sasConfig.
                    ,i_sasunitRootFolder        =&i_sasunitRootFolder.
                    ,i_projectRootFolder        =&i_projectRootFolder.
                    ,i_autocallRootFolder       =&i_autocallRootFolder.
                    ,i_testScenarioRootFolder   =&i_testScenarioRootFolder.
                    ,i_sasunitTestDBFolder      =&i_sasunitTestDBFolder.
                    ,i_sasunitLogFolder         =&i_sasunitLogFolder.
                    ,i_sasunitScnLogFolder      =&i_sasunitScnLogFolder.
                    ,i_sasunitPgmDoc            =1
                    ,i_sasunitRunAllPgm         =&i_sasunitRunAllPgm.
                    ,i_sasunitOverwrite         =0
                    ,i_sasunitLanguage          =&i_sasunitLanguage.
                    ,i_sasunitTestCoverage      =1
                    ,i_sasunitPgmDocSASUnit     =1
                    ,i_sasunitCrossRef          =1
                    ,i_sasunitCrossRefSASUnit   =1                    
                    ,i_sasunitLogLevel          =&i_sasunitLogLevel.
                    ,i_sasunitScnLogLevel       =&i_sasunitScnLogLevel.
                    ,i_sasunitReportFolder      =&i_sasunitReportFolder.
                    ,i_sasunitResourceFolder    =&i_sasunitResourceFolder.
                    ,i_OSEncoding               =&i_OSEncoding.
                    ,i_reportsOnly              =1
                    );
%mend _createBatchFiles;
/** \endcond */
