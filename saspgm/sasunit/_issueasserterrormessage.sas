/** 
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Issues an error message within an assert to a logger
   
   \details    Asserts will issue messages into a separate log file when using log4sas.
               When an assert fails we want to issue a real error message.
               This is fatal when not using log4sas becuase it will generate additional erros in the log file
               Therefore we will capture g_useLog4SAS and only issue that message in the separate log file

   \version    \$Revision: 000 $
   \author     \$Author: author $
   \date       \$Date:  $
   
   \param     message      Message to be captured by the logger

   \return    message      Message in the associated appender
*/
%macro _issueasserterrormessage(message);
   %if (&g_useLog4SAS.) %then %do;
      %_issueErrorMessage (&g_assertLogger., &message.);
   %end;
   %else %do;
      %_issueDebugMessage (&g_currentLogger., Log4SAS is turned off. No Log for assert Messages present.);
   %end;
%mend _issueasserterrormessage;

