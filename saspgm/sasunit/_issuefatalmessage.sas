/** 
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Issues a fatal message to a logger
   
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   
   \param     loggername   Name of the logger to capture the message
   \param     message      Message to be captured by the logger

   \return    message      Message in the associated appender
*//** \cond */
%macro _issueFatalMessage(loggername, message);
   %if (%length(&loggername.)=0) %then %do; 
      %put WARNING: loggername is null;
      %return;
   %end;
   %if (%length(&message.)=0) %then %do; 
      %put WARNING: message is null;
      %return;
   %end;
   %let _rc = %sysfunc(log4sas_logevent(&loggername., Fatal, &message.));
   %if (&_rc ne 0) %then %do;
      %put ERROR: _rc is NOT null: &_rc.;  
   %end;
%mend _issueFatalMessage;
/** \endcond */