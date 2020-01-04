/** 
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Issues a warning message within an assert to a logger
   
   \details    Asserts will issue messages into a separate log file when using log4sas.
               When an assert fails we want to issue a real warning message.
               This is fatal when not using log4sas because it will generate additonal warnings in the log file
               Therefore we will capture g_useLog4SAS and only issue that message in the separate log file

   \version    \$Revision: 000 $
   \author     \$Author: author $
   \date       \$Date:  $
   
   \param     message      Message to be captured by the logger

   \return    message      Message in the associated appender
*/
%macro _issueassertwarningmessage(message);
   %if (&g_useLog4SAS.) %then %do;
      %_issueWarningMessage (&g_assertLogger., &message.);
   %end;
   %else %do;
      %_issueDebugMessage (&g_currentLogger., Log4SAS is turned off. No Log for assert Messages present.);
   %end;
%mend _issueassertwarningmessage;