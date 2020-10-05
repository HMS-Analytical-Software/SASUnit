/** 
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Issues a warning message within an assert to a logger
   
   \details    Asserts will issue messages into a separate log file when using log4sas.
               When an assert fails we want to issue a real warning message.
               This is fatal when not using log4sas because it will generate additonal warnings in the log file

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \param     message      Message to be captured by the logger

   \return    message      Message in the associated logger and appender
*//** \cond */
%macro _issueassertwarningmessage(message);
   %_issueWarningMessage (&g_log4SASAssertLogger., &message.);
%mend _issueassertwarningmessage;
/** \endcond */