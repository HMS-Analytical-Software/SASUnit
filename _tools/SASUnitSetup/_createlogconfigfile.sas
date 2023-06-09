%macro _createLogConfigFile(i_targetFolder    =
                           ,i_sasunitLogPath  =
                           ,i_sasunitLanguage =
                           );

   data _null_;
      file "&i_targetFolder./sasunit.logconfig.&i_sasunitLanguage..xml";
      put '<?xml version="1.0" encoding="UTF-8" ?>';
      put '<logging:configuration xmlns:logging="http://www.sas.com/xml/logging/1.0/">';
      %_writeSASUnitRunAllAppender (i_logpath=&i_sasunitLogPath.)
      put;
      %_writeSASUnitSuiteAppender (i_logpath=&i_sasunitLogPath.)
      put;
      put '   <!-- Redirect all messages to SASUnit RunAll log file -->';
      %_writeSASUnitLogger(i_loggerName=App.Program
                          ,i_additivity=TRUE
                          ,i_level=Info
                          ,i_appender=SASUnitRunAllAppender
                          );
      put;
      put '   <!-- New logger for SASUnit messages; Messages shall be propagated to App.Program -->';
      %_writeSASUnitLogger(i_loggerName=App.Program.SASUnit
                          ,i_additivity=TRUE
                          ,i_level=Info
                          ,i_appender=SASUnitSuiteAppender
                          );
      put;
      put '   <!-- New logger for SASUnit messages by error handler; Not sure if needed at the end of the day -->';
      put '   <!-- Messages shall be be propagated to App.Program -->';
      %_writeSASUnitLogger(i_loggerName=App.Program.SASUnitErrorHandler
                          ,i_additivity=TRUE
                          ,i_level=Info
                          ,i_appender=SASUnitSuiteAppender
                          );
      put;
      put '   <!-- Root-Logger must always be present, even with an empty definition -->';
      put '   <root />';
      put '</logging:configuration>';
   run;                             
%mend _createLogConfigFile;
