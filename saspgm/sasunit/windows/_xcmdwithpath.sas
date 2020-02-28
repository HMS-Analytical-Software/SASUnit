/**
   \file
   \ingroup    SASUNIT_UTIL_OS_WIN

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
            
   \param   i_cmd_path     OS command parameters containing paths. Paths must be suitable for OS
   \param   i_cmd          OS command parameters that contain text
   \param   i_expected_shell_rc  Expected return value after completion of the OS-command (Optional: Default=0)
   \return  r_rc           Return Code of %sysexec 

   \todo replace g_verbose
*/ /** \cond */ 

%MACRO _xcmdWithPath(i_cmd_path           =
                    ,i_cmd                =
                    ,i_expected_shell_rc  =0
                    ,r_rc                 =l_rc
                    );

   %LOCAL xwait xsync xmin logfile l_cmd;
   
   %LET xwait=%sysfunc(getoption(xwait));
   %LET xsync=%sysfunc(getoption(xsync));
   %LET xmin =%sysfunc(getoption(xmin));
   
   %LET l_cmd = &i_cmd_path. &i_cmd.;

   OPTIONS noxwait xsync xmin;
   
   %LET logfile=%sysfunc(pathname(work))\___log.txt;

   %SYSEXEC &l_cmd. > "&logfile";
   %LET &r_rc. = &sysrc.;

   %IF &g_verbose. %THEN %DO;
      %_issueInfoMessage (&g_currentLogger., _xcmdWithPath: %str(======== OS Command Start ========));
      /* Evaluate sysexec´s return code*/
      %IF &sysrc. = &i_expected_shell_rc. %THEN %DO;
         %_issueInfoMessage (&g_currentLogger., _xcmdWithPath: Sysrc=ExpectedRC: &sysrc.=&i_expected_shell_rc. -> SYSEXEC SUCCESSFUL);
      %END;
      %ELSE %DO;
         %_issueErrorMessage (&g_currentLogger., _xcmdWithPath: Sysrc<>ExpectedRC: &sysrc.<>&i_expected_shell_rc. -> An Error occured);
      %END;

      /* put sysexec command to log*/
      %_issueInfoMessage (&g_currentLogger., _xcmdWithPath: SYSEXEC COMMAND IS: &l_cmd. > "&logfile");
      
      /* write &logfile to the log*/
      DATA _NULL_;
         infile "&logfile" truncover;
         input;
         putlog _infile_;
      RUN;
      
      %_issueInfoMessage (&g_currentLogger., _xcmdWithPath: %str(======== OS Command End ========));
   %END;

   OPTIONS &xwait &xsync &xmin;

%MEND _xcmdWithPath; 

/** \endcond */

