/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      Utility macro for SASUnit setup that writes down the aggregated Scenario Appender section of logConfigXML


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
            
   \param      i_logpath               Path where the respective log file should be created
   \param      i_append                Parameter value for appen (optional: Default=FALSE)
*/ /** \cond */
%macro _writeSASUnitScenarioAggAppender (i_logpath=
                                        ,i_append = FALSE
                                        );                                  
      put '   <!-- combining Appender that protocols into an ovarall Scenario Logfile log file -->';
      put '   <appender name="SASUnitScenarioAggAppender" class="FileAppender">';
      put "      <param name=""File""           value=""&i_logpath./all_scenarios.log""/>";
      put "      <param name=""Append""         value=""%upcase(&i_append.)""/>";
      put '      <param name="ImmediateFlush" value="TRUE"/>';
      put '      <layout>';
      put '         <param name="ConversionPattern" value="%d{ISO8601} %r [%t] %-5p %c %u - %m"/>';
      put '      </layout>';
      put '   </appender>';
%mend _writeSASUnitScenarioAggAppender;
/** \endcond */