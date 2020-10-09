/**
   \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

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

   \param   i_cmd_path     OS command parameters containing paths. Slashes will be transformed to Backslashes
   \param   i_cmd          OS command parameters that contain text
   \return  r_rc           Return Code of %sysexec 
*/ /** \cond */ 

%MACRO _xcmdWithPath(i_cmd_path =
                    ,i_cmd      =
                    ,r_rc       =l_rc
                    );
                    
   %LOCAL logfile l_cmd rc filrf;

   %LET logfile=%sysfunc(pathname(work))/___log.txt;
   %LET rc = %_delfile(&logfile);
   
   %let l_cmd  = %_makeSASUnitPath(&i_cmd_path.);
   %let l_cmd  = %_adaptSASUnitPathToOS(&l_cmd.);
   %LET l_cmd = &l_cmd. &i_cmd.;
   
   %SYSEXEC &l_cmd > "&logfile";
   %LET &r_rc = &sysrc.;
   
   %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: %str(======== OS Command Start ========));
    /* Evaluate sysexec´s return code*/
   %IF &sysrc. = 0 %THEN %DO;
      %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: Sysrc : 0 -> SYSEXEC SUCCESSFUL);
   %END;
   %ELSE %DO;
      %_issueErrorMessage (&g_currentLogger., _xcmdWithPath: &sysrc -> An Error occured);
   %END;

   /* put sysexec command to log*/
   %PUT &g_note.(SASUNIT): SYSEXEC COMMAND IS: ;
   %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: SYSEXEC COMMAND IS: &l_cmd > "&logfile");
   
   /* write &logfile to the log */
   /* for the following commands "cd", "pwd", "setenv" or "umask" SAS executes
      SAS equivalent of these commands -> no files are generated that could be read */
   %LET filrf=_tmpf;
   %LET rc=%sysfunc(filename(filrf,&logfile));
   %LET rc = %sysfunc(fexist(&filrf));

   %IF (&rc) %THEN %DO;
      %if (&g_currentLogLevel. = DEBUG or &g_currentLogLevel. = TRACE) %then %do;
         DATA _NULL_;
            infile "&logfile" truncover;
            input;
            putlog _infile_;
         RUN;
      %end;
   %END;
   %ELSE %DO;
      %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: No File Redirection for Commands cd, pwd, setenv and umask);
   %END;
   %LET rc=%sysfunc(filename(filrf));
   
   %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: %str(======== OS Command End ========));
%MEND _xcmdWithPath; 

/** \endcond */

