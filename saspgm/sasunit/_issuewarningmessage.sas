/** 
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Issues a Wrning message to a logger
   
   \version    \$Revision: 000 $
   \author     \$Author: author $
   \date       \$Date:  $
   
   \param     loggername   Name of the logger to capture the message
   \param     message      Message to be captured by the logger

   \return    message      Message in the associated appender
*/
%macro _issueWarningMessage(loggername, message);
   %if (%length(&loggername.)=0) %then %do; 
      %put WARNING: loggername is null;
      %return;
   %end;
   %if (%length(&message.)=0) %then %do; 
      %put WARNING: message is null;
      %return;
   %end;
   %let _rc = %sysfunc(log4sas_logevent(&loggername., Warn, &message.));
   %if (&_rc ne 0) %then %do;
      %put ERROR: _rc is NOT null: &_rc.;  
   %end;
%mend _issueWarningMessage;

