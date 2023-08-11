/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      Utility macro for SASUnit setup that writes down the logger section of logConfigXML


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
            
   \param      i_loggerName            Name of the logger that should be declared
   \param      i_additivity            Parameter value for additivity
   \param      i_level                 Logging level for the logger
   \param      i_appender              Name of the appender that should be used
*/ /** \cond */
%macro _writeSASUnitLogger(i_loggerName=
                          ,i_additivity=
                          ,i_level     =
                          ,i_appender =
                          );
                          
      put "   <logger name=""&i_loggerName."" additivity=""%upcase(&i_additivity.)"" immutability=""FALSE"">";
      put "      <level value=""%upcase(&i_level.)""/>";
      put "      <appender-ref ref=""&i_appender.""/>";
      put '   </logger>';
%mend _writeSASUnitLogger;
/** \endcond */