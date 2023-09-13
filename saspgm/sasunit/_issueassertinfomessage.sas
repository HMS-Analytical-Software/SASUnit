/** 
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Issues an info message within an assert to a logger
   
   \details    Asserts will issue messages into a separate log file when using log4sas.
               When an assert fails we want to issue a real warning message.
               This is fatal when not using log4sas because it will generate additonal warnings in the log file

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   
   \param     message      Message to be captured by the logger

   \return    message      Message in the associated logger and appender
*//** \cond */
%macro _issueassertinfomessage(message);
   %_issueInfoMessage (&g_log4SASAssertLogger., &message.);
%mend _issueassertinfomessage;
/** \endcond */