/**
   \file
   \ingroup    SASUNIT_LOG4SAS

   \brief      Creates a Log4SAS appender

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      appenderName   Name of the appender that should be created
   \param      appenderClass  Class of the appender that should be created
   \param      fileRef        File reference to append to
   \param      pattern        Message pattern to be used (optional)
   \param      immediateFlush Parameter value for immediate flush (optional: Default=TRUE)
   \param      threshold      Parameter value for threshold (optional: Default=TRACE)
*/ /** \cond */ 
%macro _createLog4SASAppender(appenderName=
                             ,appenderClass=
                             ,fileRef=
                             ,pattern=
							        ,immediateFlush=TRUE
                             ,threshold=TRACE
                             );
                             
   %local l_optionsString;                             
                             
   %let l_optionsString =;
   
   %if (%length(&appendername.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., AppenderName is empty);
      %return;
   %end;
   %if (%length(&appenderclass.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., AppenderClass is empty);
      %return;
   %end;
   /*** Check appender class and accordingly test necessary parameters ***/
   %if (%length(&fileref.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., Fileref is empty);
      %return;
   %end;
   %else %do;
      %let l_optionsString = &l_optionsString. FILEREF=&fileref.;
   %end;
   %if (%length(%nrbquote(&pattern.))=0) %then %do; 
      %_issueInfoMessage (&g_currentLogger., No pattern is specified);
   %end;
   %else %do;
      %let l_optionsString = &l_optionsString. PATTERN="%nrbquote(&pattern.)";
   %end;
   %if (%length(&threshold.)=0) %then %do; 
      %_issueWarningMessage (&g_currentLogger., threshold is empty);
      %return;
   %end;
   %else %do;
      %let l_optionsString = %nrbquote(&l_optionsString.) THRESHOLD="&threshold.";
   %end;
   %let _rc = %sysfunc(log4sas_appender(&appendername., &appenderclass., %nrbquote(&l_optionsString.)));
   %_issueDebugMessage (&g_currentLogger., ------>&=appendername.);
   %_issueDebugMessage (&g_currentLogger., ------>&=appenderclass.);
   %_issueDebugMessage (&g_currentLogger., ------>%nrbquote(&l_optionsString.));
   %if (&_rc ne 0) %then %do;
      %_issueErrorMessage (&g_currentLogger., _rc is NOT null: &_rc.);
   %end;
   %_issueDebugMessage (&g_currentLogger., ------>&=_rc.);
%mend _createLog4SASAppender;
/** \endcond **/