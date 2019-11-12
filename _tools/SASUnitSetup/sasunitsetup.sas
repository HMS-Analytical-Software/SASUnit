
%macro SASUnitSetup (i_sasunitRootFolder  =
                    ,i_projectRootFolder  =
                    ,i_sasunitLogPath     =
                    ,i_sasunitScnLogPath  =
                    ,i_sasunitTestDBFolder=
                    ,i_projectBinFolder   =
                    ,i_sasunitLanguage    =
                    ,i_sasunitRunAllPgm   =
                    ,i_operatingSystem    =
                    ,i_sasVersion         =
                    ,i_sasexe             =
                    ,i_sasconfig          =
                    );

   %local
      l_sasunitLanguage
      l_operatingSystem
   ;

   %let l_sasunitLanguage = %lowcase (&i_sasunitLanguage.);
   %let l_operatingSystem = %lowcase (&i_operatingSystem.);

   %_createBatchFiles(i_sasunitRootFolder=&i_sasunitRootFolder.
                     ,i_projectBinFolder =&i_projectBinFolder.
                     ,i_sasunitLanguage  =&l_sasunitLanguage.
                     ,i_operatingSystem  =&l_operatingSystem.
                     ,i_sasVersion       =&i_sasVersion.
                     ,i_sasexe           =&i_sasexe.
                     );
   %_createConfigFile(i_projectBinFolder =&i_projectBinFolder.
                     ,i_projectRootFolder=&i_projectRootFolder.
                     ,i_sasunitLogPath   =&i_sasunitLogPath.
                     ,i_sasunitLanguage  =&l_sasunitLanguage.
                     ,i_sasunitRunAllPgm =&i_sasunitRunAllPgm.
                     ,i_operatingSystem  =&l_operatingSystem.
                     ,i_sasVersion       =&i_sasVersion.
                     ,i_sasconfig        =&i_sasconfig.
                     );
   %_createLogConfigFile(i_projectBinFolder=&i_projectBinFolder.
                        ,i_sasunitLogPath  =&i_sasunitLogPath.
                        ,i_sasunitLanguage =&l_sasunitLanguage.
                        );
   %_createScnLogConfigTemplate(i_projectBinFolder =&i_projectBinFolder.
                               ,i_sasunitLogPath   =&i_sasunitLogPath.
                               ,i_sasunitScnLogPath=&i_sasunitScnLogPath.
                               ,i_sasunitLanguage  =&l_sasunitLanguage.
                               );
%mend;
