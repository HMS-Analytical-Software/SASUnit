/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      Creates an XML log config template file that is used to generate an XML log config file for each scenario.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_projectBinFolder      Path and folder where the binaries for the project are located
   \param      i_sasunitLogFolder      Path and folder where the log files for SASUnit suite are located
   \param      i_sasunitScnLogFolder   Path and folder where the log files for SASUnit scenarios are located
   \param      i_sasunitLanguage       Language that is used because it is part of the resulting path
*/ /** \cond */
%macro _createScnLogConfigTemplate (i_projectBinFolder   =
                                   ,i_sasunitLogFolder   =
                                   ,i_sasunitScnLogFolder=
                                   ,i_sasunitLanguage    =
                                   );
                               
   data _null_;
      file "&i_projectBinFolder./sasunit.scnlogconfig.%lowcase(&i_sasunitLanguage.).template.xml";
      put '<?xml version="1.0" encoding="UTF-8" ?>';
      put '<logging:configuration xmlns:logging="http://www.sas.com/xml/logging/1.0/">';
      %_writeSASUnitScenarioAppender (i_logpath=&i_sasunitScnLogFolder.
                                     ,i_scnid  =<SCNID>
                                     )
      put;
      %_writeSASUnitScenarioAggAppender (i_logpath=&i_sasunitScnLogFolder.
                                        ,i_append =true
                                        )
      put;
      %_writeSASUnitAssertAppender (i_logpath=&i_sasunitLogFolder.
                                   ,i_append =true
                                   )
      put;
      put '   <!-- Insert your project specific appenders here! -->';
      put '   <!-- End of project specific appenders! -->';
      put;
      put '   <!-- Redirect all messages to SASUnit scenario log file -->';
      %_writeSASUnitLogger(i_loggerName=App.Program
                          ,i_additivity=TRUE
                          ,i_level=Info
                          ,i_appender=SASUnitScenarioAppender
                          );
      put;
      %_writeSASUnitLogger(i_loggerName=App.Program.SASUnitScenario
                          ,i_additivity=FALSE
                          ,i_level=Info
                          ,i_appender=SASUnitScenarioAggAppender
                          );
      put;
      put '   <!-- New logger for SASUnit messages by assertions; Will be used to track outcome of asserts -->';
      put '   <!-- New logger will be protocolling in special logfile -->';
      put '   <!-- Perhaps in a later release asserts will be running without test data base -->';
      %_writeSASUnitLogger(i_loggerName=App.Program.SASUnitScenario.Asserts
                          ,i_additivity=FALSE
                          ,i_level=Info
                          ,i_appender=SASUnitAssertsAppender
                          );
      put;
      put '   <!-- Insert your project specific loggers here! -->';
      put '   <!-- End of loggers specific appenders! -->';
      put;
      put '   <!-- Root-Logger must always be present, even with an empty definition -->';
      put '   <root />';
      put '</logging:configuration>';
   run;                             
%mend _createScnLogConfigTemplate;
/** \endcond */