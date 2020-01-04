/**
*/
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
