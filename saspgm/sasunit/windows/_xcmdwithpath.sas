/**
   \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      run an operation system command

   \version    \$Revision: GitBranch: feature/jira-29-separate-SASUnit-files-from-project-source $
   \author     \$Author: landwich $
   \date       \$Date: 2024-03-13 11:25:42 (Mi, 13. März 2024) $
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the Lesser GPL license see included file readme.txt
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/readme/.
            
   \param   i_cmd_path     OS command parameters containing paths.
   \param   i_cmd          OS command parameters that contain text
   \param   i_expected_shell_rc  Expected return value after completion of the OS-command (Optional: Default=0)
   \return  r_rc           Return Code of %sysexec 
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
   
   %let l_cmd  = %_makeSASUnitPath(&i_cmd_path.);
   %let l_cmd  = %_adaptSASUnitPathToOS(&l_cmd.);
   %LET l_cmd = &l_cmd. &i_cmd.;

   OPTIONS noxwait xsync xmin;
   
   %LET logfile=%sysfunc(pathname(work))\___log.txt;

   %SYSEXEC &l_cmd. > "&logfile";
   %LET &r_rc. = &sysrc.;

   %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: %str(======== OS Command Start ========));
   /* Evaluate sysexec´s return code*/
   %IF &sysrc. = &i_expected_shell_rc. %THEN %DO;
      %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: Sysrc=ExpectedRC: &sysrc.=&i_expected_shell_rc. -> SYSEXEC SUCCESSFUL);
   %END;
   %ELSE %DO;
      %_issueErrorMessage (&g_currentLogger., _xcmdWithPath: Sysrc<>ExpectedRC: &sysrc.<>&i_expected_shell_rc. -> An Error occured);
   %END;

   /* put sysexec command to log*/
   %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: SYSEXEC COMMAND IS: &l_cmd. > "&logfile");
   
   %if (&g_currentLogLevel. = DEBUG or &g_currentLogLevel. = TRACE) %then %do;
      /* write &logfile to the log*/
      DATA _NULL_;
         infile "&logfile" truncover;
         input;
         putlog _infile_;
      RUN;
   %END;
      
   %_issueDebugMessage (&g_currentLogger., _xcmdWithPath: %str(======== OS Command End ========));

   OPTIONS &xwait &xsync &xmin;

%MEND _xcmdWithPath; 

/** \endcond */

