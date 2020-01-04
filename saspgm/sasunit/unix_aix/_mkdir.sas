/**
   \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      create a directory, if it does not exist
               The containing directory must exist. 

               \%mkdir(dir=directory)

               sets &sysrc to a value other than 0, when errors occured.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \todo document parameters
   \todo replace with dcreate in data _null_
   \todo move from sasunit_os to sasunit
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \todo replace g_verbose
*/ /** \cond */

%macro _mkdir (dir
              );
   %LOCAL logfile l_dir;
              
   %let logfile=%sysfunc(pathname(work))/___log.txt;
   %let l_dir = %_adaptSASUnitPathToOS (&dir.);
  
   %SYSEXEC(mkdir "&l_dir." > "&logfile" 2>&1);
   %if &g_verbose. %then %do;
      %_issueInfoMessage (&g_currentLogger., _mkdir: %str(======== OS Command Start ========));

      /* Evaluate sysexec´s return code */
      %IF &sysrc. = 0 %THEN %DO;
         %_issueInfoMessage (&g_currentLogger., _mkdir: Sysrc : 0 -> SYSEXEC SUCCESSFUL);
      %END;
      %ELSE %DO;
         %_issueErrorMessage (&g_currentLogger., _mkdir: &sysrc -> An Error occured);
      %END;

      /* put sysexec command to log*/
      %_issueInfoMessage (&g_currentLogger., _mkdir: SYSEXEC COMMAND IS: mkdir "&l_dir." > "&logfile" 2>&1);
      
      /* write &logfile to the log*/
      data _null_;
         infile "&logfile" truncover lrecl=512;
         input line $512.;
         putlog line;
      run;
      %_issueInfoMessage (&g_currentLogger., _mkdir: %str(======== OS Command End ========));
   %end;

%mend _mkdir; 

/** \endcond */

