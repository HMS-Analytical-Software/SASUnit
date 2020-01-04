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
			   
   \param   i_cmd     OS command with quotes where necessary 
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.

   \todo replace g_verbose
 */ /** \cond */ 

%MACRO _xcmd(i_cmd);

   %LOCAL xwait xsync xmin logfile;
   %LET xwait=%sysfunc(getoption(xwait));
   %LET xsync=%sysfunc(getoption(xsync));
   %LET xmin =%sysfunc(getoption(xmin));

   OPTIONS noxwait xsync xmin;
   
   %LET logfile=%sysfunc(pathname(work))\___log.txt;

   %SYSEXEC &i_cmd > "&logfile"; 


   %IF &g_verbose. %THEN %DO;
      %_issueInfoMessage (&g_currentLogger., _xcmd: %str(======== OS Command Start ========));
       /* Evaluate sysexec´s return code*/
      %IF &sysrc. = 0 %THEN %DO;
         %_issueInfoMessage (&g_currentLogger., _xcmd: Sysrc : 0 -> SYSEXEC SUCCESSFUL);
      %END;
      %ELSE %DO;
         %_issueErrorMessage (&g_currentLogger., _xcmd: &sysrc -> An Error occured);
      %END;

      /* put sysexec command to log*/
      %_issueInfoMessage (&g_currentLogger., _xcmd: SYSEXEC COMMAND IS: &i_cmd > "&logfile");
      
      /* write &logfile to the log*/
      DATA _NULL_;
         infile "&logfile" truncover;
         input;
         putlog _infile_;
      RUN;
      
      %_issueInfoMessage (&g_currentLogger., _xcmd: %str(======== OS Command End ========));
   %END;

   OPTIONS &xwait &xsync &xmin;

%MEND _xcmd; 

/** \endcond */

