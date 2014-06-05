/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      run an operation system command

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   cmd     OS command with quotes where necessary 
   \return  error symbol &sysrc will be set to a value other than 0, if an error occurs.

 */ /** \cond */ 

%MACRO _xcmd(i_cmd);
   %LOCAL logfile;

   %LET logfile=%sysfunc(pathname(work))/___log.txt;
   %sysexec &i_cmd > "&logfile";
   
   %IF &g_verbose. %THEN %DO;
      %PUT ======== OS Command Start ========;
       /* Evaluate sysexec´s return code*/
      %IF &sysrc. = 0 %then %put &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %ELSE %PUT &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %PUT &g_note.(SASUNIT): SYSEXEC COMMAND IS: &i_cmd > "&logfile";
      
      /* write &logfile to the log */
      /* for the followin commands "cd", "pwd", "setenv" or "umask" SAS executes
         SAS equivalent of these commands -> no files are generated that could be read */
      %IF %sysfunc(index(&i_cmd, "umask"))  EQ 0 OR 
          %sysfunc(index(&i_cmd, "setenv")) EQ 0 OR 
          %sysfunc(index(&i_cmd, "pwd"))    EQ 0 OR 
          %sysfunc(index(&i_cmd, "cd"))     EQ 0 %THEN %DO;
         DATA _NULL_;
            infile "&logfile" truncover;
            input;
            putlog _infile_;
         RUN;
      %END;
      %PUT ======== OS Command End ========;
   %END;
%MEND _xcmd; 

/** \endcond */

