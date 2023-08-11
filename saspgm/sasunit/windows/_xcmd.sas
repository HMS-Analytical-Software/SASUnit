/**
   \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the Lesser GPL license see included file readme.txt
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/readme/.
			   
   \param   i_cmdFile            Command file to be executed by the OS
   \param   i_operator           Operator for evaluation of the shell command return code
   \param   i_expected_shell_rc  Command file to be executed by the OS
   
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.
*/ /** \cond */ 
%MACRO _xcmd(i_cmd
            ,i_operator
            ,i_expected_shell_rc
            );

   %LOCAL xwait xsync xmin logfile l_operator l_expected_shell_rc;
   %LET xwait=%sysfunc(getoption(xwait));
   %LET xsync=%sysfunc(getoption(xsync));
   %LET xmin =%sysfunc(getoption(xmin));
   
   %let l_operator=EQ;
   %if (%length (&i_operator) > 0) %then %do;
      %let l_operator=&i_operator.;
   %end;
   
   %let l_expected_shell_rc=0;      
   %if (%length(&i_expected_shell_rc) > 0) %then %do;
      %let l_expected_shell_rc=&i_expected_shell_rc.;      
   %end;

   OPTIONS noxwait xsync xmin;
   
   %LET logfile=%sysfunc(pathname(work))\___log.txt;

   %SYSEXEC &i_cmd > "&logfile";

   %_issueDebugMessage (&g_currentLogger., _xcmd: %str(======== OS Command Start ========));
    /* Evaluate sysexec´s return code*/
   %IF (&sysrc. &l_operator. &l_expected_shell_rc) %THEN %DO;
      %_issueDebugMessage (&g_currentLogger., _xcmd: Sysrc : &sysrc. -> SYSEXEC SUCCESSFUL);
   %END;
   %ELSE %DO;
      %_issueErrorMessage (&g_currentLogger., _xcmd: &sysrc -> An Error occured);
   %END;

   /* put sysexec command to log*/
   %_issueDebugMessage (&g_currentLogger., _xcmd: SYSEXEC COMMAND IS: &i_cmd > "&logfile");
   
   %if (&g_currentLogLevel. = DEBUG or &g_currentLogLevel. = TRACE) %then %do;
      /* write &logfile to the log*/
      DATA _NULL_;
         infile "&logfile" truncover;
         input;
         putlog _infile_;
      RUN;
   %end;
   
   %_issueDebugMessage (&g_currentLogger., _xcmd: %str(======== OS Command End ========));
   
   OPTIONS &xwait &xsync &xmin;

%MEND _xcmd; 
/** \endcond */