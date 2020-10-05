/**
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Creates a Log4SAS logger

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      loggername     Name of the logger that should be created
   \param      additivity     If TRUE then events will be propagated to parent logger (optional: Default=TRUE)
   \param      appenderList   List of existing loggers to pass message to
   \param      level          Parameter value for level (optional: Default=INFO)
*/ /** \cond */ 
%macro _createLog4SASLogger(loggername=
                           ,additivity=TRUE
                           ,appenderList=
                           ,level=INFO
                           );

   %local l_optionsString;
   
   %let l_optionsString=;
   
   %if (%length(&loggername.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., LoggerName is empty);
      %return;
   %end;
   %if (%length(&additivity.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., Additivity is empty);
      %return;
   %end;
   %else %do;
      %let l_optionsString=&l_optionsString. ADDITIVITY=&additivity.;
   %end;
   %if (%length(&appenderList.)=0) %then %do; 
      %_issueInfoMessage (&g_currentLogger., AppenderList is empty);
   %end;
   %else %do;
      %let l_optionsString=&l_optionsString. APPENDER-REF=(&appenderList.);
   %end;
   %if (%length(&level.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., Logging Level is null);
      %return;
   %end;
   %else %do;
      %let l_optionsString=&l_optionsString. LEVEL=&level.;
   %end;
   %let _rc = %sysfunc(log4sas_logger(&loggername., &l_optionsString.));
   %_issueDebugMessage (&g_currentLogger., ------>&=loggername.);
   %_issueDebugMessage (&g_currentLogger., ------>%nrbquote(&l_optionsString.));
   %if (&_rc ne 0) %then %do;
      %_issueErrorMessage (&g_currentLogger., _rc is NOT null: &_rc.);
   %end;
   %_issueDebugMessage (&g_currentLogger., ------>&=_rc.);
%mend _createLog4SASLogger;
/** \endcond **/