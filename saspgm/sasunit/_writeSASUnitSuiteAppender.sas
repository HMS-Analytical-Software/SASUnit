/**
   \file
   \ingroup    SASUNIT_SETUP

   \brief      Utility macro for SASUnit setup that writes down the Suite Appender section of logConfigXML


   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_logpath               Path where the respective log file should be created
   \param      i_scnid                 Scenario ID as three character string padded with leading zeros
   \param      i_append                Parameter value for appen (optional: Default=FALSE)
*/ /** \cond */
%macro _writeSASUnitSuiteAppender (i_logpath=
                                  ,i_append = FALSE
                                  );
      put '   <!-- Appender for an aggregated protocol -->';
      put '   <appender name="SASUnitSuiteAppender" class="FileAppender">';
      put "      <param name=""File""           value=""&i_logpath./log4sasunit_suite.log""/>";
      put "      <param name=""Append""         value=""%upcase(&i_append.)""/>";
      put '      <param name="ImmediateFlush" value="TRUE"/>';
      put '      <layout>';
      put '         <param name="ConversionPattern" value="%d{ISO8601} %r [%t] %-5p %c %u - %m"/>';
      put '      </layout>';
      put '   </appender>';
%mend _writeSASUnitSuiteAppender;
/** \endcond */