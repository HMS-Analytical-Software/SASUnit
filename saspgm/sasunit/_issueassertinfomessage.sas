/** 
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Issues an info message within an assert to a logger
   
   \details    Asserts will issue messages into a separate log file when using log4sas.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \param     message      Message to be captured by the logger

   \return    message      Message in the associated appender
*/
%macro _issueassertinfomessage(message);
   %if (&g_useLog4SAS.) %then %do;
      %_issueInfoMessage (&g_assertLogger., &message.);
   %end;
   %else %do;
      %_issueDebugMessage (&g_currentLogger., Log4SAS is turned off. No Log for assert Messages present.);
   %end;
%mend _issueassertinfomessage;