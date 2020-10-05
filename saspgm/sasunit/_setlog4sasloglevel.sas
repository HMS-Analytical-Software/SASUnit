/**
   \file
   \ingroup    SASUNIT_SCN

   \brief      Set the logging level for a specific logger

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      loggername     Name of the logger that should get a new logging level
   \param      level          New logging level for respective logger (optional: Default=INFO)
*/ /** \cond */ 
%macro _setlog4sasloglevel (loggername=
                           ,level=INFO
                           );

   %local l_optionsString;
   
   %let l_optionsString=;
   
   %if (%length(&loggername.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., LoggerName is empty);
      %return;
   %end;
   %if (%length(&level.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., Logging Level is null);
      %return;
   %end;
   %else %do;
      %let l_optionsString=&l_optionsString. LEVEL=%upcase(&level.);
   %end;
   %let _rc = %sysfunc(log4sas_logger(&loggername., &l_optionsString.));
   %_issueDebugMessage (&g_currentLogger., ------>loggername=&loggername.);
   %_issueDebugMessage (&g_currentLogger., ------>%nrbquote(&l_optionsString.));
   %if (&_rc ne 0) %then %do;
      %_issueErrorMessage (&g_currentLogger., _rc is NOT null: &_rc.);
   %end;
   %_issueDebugMessage (&g_currentLogger., ------>rc=&_rc.);
%mend _setlog4sasloglevel;
/** \endcond **/