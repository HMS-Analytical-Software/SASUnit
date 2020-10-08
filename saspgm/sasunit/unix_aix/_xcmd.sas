/**
   \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \param   i_cmd     OS command with quotes where necessary 
   \param   i_operator           Operator for evaluation of the shell command return code
   \param   i_expected_shell_rc  Command file to be executed by the OS
   
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.
*/ /** \cond */ 
%MACRO _xcmd(i_cmd
            ,i_operator
            ,i_expected_shell_rc
            );
            
   %LOCAL logfile l_cmd rc filrf l_operator l_expected_shell_rc;;

   %let l_operator=EQ;
   %if (%length (&i_operator) > 0) %then %do;
      %let l_operator=&i_operator.;
   %end;
   
   %let l_expected_shell_rc=0;      
   %if (%length(&i_expected_shell_rc) > 0) %then %do;
      %let l_expected_shell_rc=&i_expected_shell_rc.;      
   %end;

   %LET logfile=%sysfunc(pathname(work))/___log.txt;
   %let rc = %_delfile(&logfile);
   %sysexec &i_cmd > "&logfile";
   
   %_issueDebugMessage (&g_currentLogger., _xcmd: %str(======== OS Command Start ========));
    /* Evaluate sysexec´s return code*/
   %IF (&sysrc. &l_operator. &l_expected_shell_rc) %THEN %DO;
      %_issueDebugMessage (&g_currentLogger., _xcmd: Sysrc : 0 -> SYSEXEC SUCCESSFUL);
   %END;
   %ELSE %DO;
      %_issueErrorMessage (&g_currentLogger., _xcmd: &sysrc -> An Error occured);
   %END;

   /* put sysexec command to log*/
   %_issueDebugMessage (&g_currentLogger., _xcmd: SYSEXEC COMMAND IS: &i_cmd > "&logfile");
   
   /* write &logfile to the log */
   /* for the following commands "cd", "pwd", "setenv" or "umask" SAS executes
      SAS equivalent of these commands -> no files are generated that could be read */
   %LET filrf=_tmpf;
   %LET rc=%sysfunc(filename(filrf,&logfile));
   %LET rc = %sysfunc(fexist(&filrf));

   %IF (&rc.) %THEN %DO;
      %if (&g_currentLogLevel. = DEBUG or &g_currentLogLevel. = TRACE) %then %do;
         DATA _NULL_;
            infile "&logfile" truncover;
            input;
            putlog _infile_;
         RUN;
      %end;
   %END;
   %ELSE %DO;
      %_issueDebugMessage (&g_currentLogger., %str(_xcmd: No File Redirection for Commands cd, pwd, setenv and umask));
   %END;
   %LET rc=%sysfunc(filename(filrf));
      
   %_issueDebugMessage (&g_currentLogger., _xcmd: %str(======== OS Command End ========));
%MEND _xcmd; 
/** \endcond */