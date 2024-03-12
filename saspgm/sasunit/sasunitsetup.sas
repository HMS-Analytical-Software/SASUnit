/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      This macro will generate a bunch of script files that can be used to start SASUnit in different ways


   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$   
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

   \param i_sasunitRootFolder       Path and name of the root folder of SASUnit
   \param i_projectRootFolder       Path and name of the root folder of the project
   \param i_sasunitLogFolder        Path and name of the folder for SASUnit suite log files (run_all.log and new ones)
   \param i_sasunitScnLogFolder     Path and name of the folder for SASUnit scenario log files (001.log, 001_001.log etc.)
   \param i_sasunitTestDBFolder     Path and name of the folder for SASUnit test data base (tsu, exa, scn, cas, tst)
   \param i_projectBinFolder        Path and name of the folder where the binaries of the project should reside
   \param i_sasunitLanguage         Language that should be used inside SASUnit (de or en)
   \param i_sasunitRunAllPgm        Path an name of run_all.sas
   \param i_operatingSystem         Operating system that is used to execute SASUnit
   \param i_sasVersion              SAS Version that is used to run SASUnit
   \param i_sasExe                  Path and name of the sas executable
   \param i_sasConfig               Path and name of the sas config file
   \param i_sasunitReportFolder     Path and name of the folder where the documentation should be generated in
   \param i_sasunitResourceFolder   Path and name of the folder where the resource files (css, js, html) are located
   \param i_sasunitLogLevel         Default logging level for SASUnit suite
   \param i_sasunitScnLogLevel      Default logging level for SASUnit scenarios
   \param i_OSEncoding              Encoding of OS which can be different from encoding of SAS session
   \todo Script file for report only
*/
%macro SASUnitSetup (i_sasunitRootFolder      =
                    ,i_projectRootFolder      =
                    ,i_autocallRootFolder     =
                    ,i_testScenarioRootFolder =
                    ,i_sasunitLogFolder       =
                    ,i_sasunitScnLogFolder    =
                    ,i_sasunitTestDBFolder    =
                    ,i_projectBinFolder       =
                    ,i_sasunitLanguage        =
                    ,i_sasunitRunAllPgm       =
                    ,i_operatingSystem        =
                    ,i_sasVersion             =
                    ,i_sasExe                 =
                    ,i_sasConfig              =
                    ,i_sasunitReportFolder    =
                    ,i_sasunitResourceFolder  =
                    ,i_sasunitLogLevel        =
                    ,i_sasunitScnLogLevel     =
                    ,i_OSEncoding             =
                    );

   %local
      l_sasunitLanguage
      l_operatingSystem
   ;

   /*** Check parameters ***/
   %if (not %sysfunc (fileexist ("&i_sasunitRootFolder./saspgm/sasunit/initsasunit.sas"))) %then %do;
      %PUT ERROR: Can not find SASUnit macros in folder "&i_sasunitRootFolder./saspgm/sasunit"!;
      %return;
   %end;   
   %if (not %sysfunc (fileexist ("&i_projectBinFolder."))
        OR %length(&i_projectBinFolder.)=0
       ) %then %do;
      %PUT ERROR: Specified folder for project bacth files (i_projectBinFolder) does not exist!;
      %PUT ERROR- Given folder is "&i_projectBinFolder.";
      %return;
   %end;
   %let l_sasunitLanguage = %lowcase (&i_sasunitLanguage.);
   %if (&l_sasunitLanguage. ne de
        AND &l_sasunitLanguage. ne en
       ) %then %do;
      %PUT ERROR: Invalid language specified! Given language is &l_sasunitLanguage.;
      %PUT ERROR- Supported languages are de and en.;
      %return;
   %end;
   %if (not %sysfunc (fileexist ("&i_sasunitRunAllPgm."))
        OR %length(&i_sasunitRunAllPgm.)=0
       ) %then %do;
      %PUT ERROR: Can not find SASUnit run all program "&i_sasunitRunAllPgm."!;
      %return;
   %end;
   %let l_operatingSystem = %lowcase (&i_operatingSystem.);
   %if (&l_operatingSystem. ne windows
        AND &l_operatingSystem. ne linux
        AND &l_operatingSystem. ne unix_aix
       ) %then %do;
      %PUT ERROR: Invalid operating system specified! Given operating system is &l_operatingSystem.;
      %PUT ERROR- Supported operating systems are windows, linux and unix_aix.;
      %PUT ERROR- Support for operating system unix_aix is still experimental.;
      %return;
   %end;
   %if (&l_operatingSystem. = unix_aix) %then %do;
      %PUT WARNING: Support for operating system unix_aix is still experimental.;
      %return;
   %end;
   %if (not %sysfunc (fileexist ("&i_sasexe."))
        OR %length(&i_sasexe.)=0
       ) %then %do;
      %PUT ERROR: Can not find SAS executable "&i_sasexe."!;
      %return;
   %end;

   %_createBatchFiles(i_operatingSystem         =&l_operatingSystem.
                     ,i_sasVersion              =&i_sasVersion.
                     ,i_sasexe                  =&i_sasexe.
                     ,i_sasConfig               =&i_sasConfig.
                     ,i_sasunitRootFolder       =&i_sasunitRootFolder.
                     ,i_projectRootFolder       =&i_projectRootFolder.
                     ,i_autocallRootFolder      =&i_autocallRootFolder.
                     ,i_testScenarioRootFolder  =&i_testScenarioRootFolder.
                     ,i_projectBinFolder        =&i_projectBinFolder.
                     ,i_sasunitTestDBFolder     =&i_sasunitTestDBFolder.
                     ,i_sasunitLogFolder        =&i_sasunitLogFolder.
                     ,i_sasunitScnLogFolder     =&i_sasunitScnLogFolder.
                     ,i_sasunitRunAllPgm        =&i_sasunitRunAllPgm.
                     ,i_sasunitLanguage         =&l_sasunitLanguage.
                     ,i_sasunitReportFolder     =&i_sasunitReportFolder.
                     ,i_sasunitResourceFolder   =&i_sasunitResourceFolder.
                     ,i_SASUnitLogLevel         =&i_SASUnitLogLevel.
                     ,i_SASUnitScnLogLevel      =&i_SASUnitScnLogLevel.
                     ,i_OSEncoding              =&i_OSEncoding.
                     );
   %_createConfigFile(i_projectBinFolder =&i_projectBinFolder.
                     ,i_projectRootFolder=&i_projectRootFolder.
                     ,i_sasunitLogFolder =&i_sasunitLogFolder.
                     ,i_sasunitLanguage  =&l_sasunitLanguage.
                     ,i_sasunitRunAllPgm =&i_sasunitRunAllPgm.
                     ,i_operatingSystem  =&l_operatingSystem.
                     ,i_sasVersion       =&i_sasVersion.
                     ,i_sasconfig        =&i_sasconfig.
                     );
   %_createLogConfigFile(i_projectBinFolder=&i_projectBinFolder.
                        ,i_sasunitLogFolder=&i_sasunitLogFolder.
                        ,i_sasunitLanguage =&l_sasunitLanguage.
                        );
   %_createScnLogConfigTemplate(i_projectBinFolder   =&i_projectBinFolder.
                               ,i_sasunitLogFolder   =&i_sasunitLogFolder.
                               ,i_sasunitScnLogFolder=&i_sasunitScnLogFolder.
                               ,i_sasunitLanguage    =&l_sasunitLanguage.
                               );                        
                               
   /*** Creating folders in the filesystem ***/
   %_mkdir (&i_sasunitLogFolder.,      makeCompletePath=1);
   %_mkdir (&i_sasunitScnLogFolder.,   makeCompletePath=1);
   %_mkdir (&i_sasunitTestDBFolder.,   makeCompletePath=1);
%mend;
