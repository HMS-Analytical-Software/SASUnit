/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      Creates an XML log config file for run_all.sas


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
            
   \param      i_projectBinFolder   Path and folder where the binaries for the project are located
   \param      i_sasunitLogFolder   Path and folder where the log files for SASUnit suite are located
   \param      i_sasunitLanguage    Language that is used because it is part of the resulting path
*/ /** \cond */
%macro _createLogConfigFile(i_projectBinFolder=
                           ,i_sasunitLogFolder=
                           ,i_sasunitLanguage =
                           );

   data _null_;
      file "&i_projectBinFolder./sasunit.logconfig.%lowcase(&i_sasunitLanguage.).xml";
      put '<?xml version="1.0" encoding="UTF-8" ?>';
      put '<logging:configuration xmlns:logging="http://www.sas.com/xml/logging/1.0/">';
      %_writeSASUnitRunAllAppender (i_logpath=&i_sasunitLogFolder.)
      put;
      %_writeSASUnitSuiteAppender (i_logpath=&i_sasunitLogFolder.)
      put;
      put '   <!-- Insert your project specific appenders here! -->';
      put '   <!-- End of project specific appenders! -->';
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
      put '   <!-- Insert your project specific loggers here! -->';
      put '   <!-- End of loggers specific appenders! -->';
      put;
      put '   <!-- Root-Logger must always be present, even with an empty definition -->';
      put '   <root />';
      put '</logging:configuration>';
   run;                             
%mend _createLogConfigFile;
/** \endcond */