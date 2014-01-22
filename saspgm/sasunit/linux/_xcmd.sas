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

%macro _xcmd(i_cmd);
   %local logfile;

   %LET logfile=%sysfunc(pathname(work))/___log.txt;
   %sysexec (&i_cmd > "&logfile" 2>&1 );
   
   %if &g_verbose. %then %do;
      %put ======== OS Command Start ========;
       /* Evaluate sysexec´s return code*/
      %if &sysrc. = 0 %then %put &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %else %put &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %put &g_note.(SASUNIT): SYSEXEC COMMAND IS: &i_cmd > "&logfile";
      
      /* write &logfile to the log */
      /* for the followin commands "cd", "pwd", "setenv" or "umask" SAS executes
         SAS equivalent of these commands -> no files are generated that could be read */
      %if %sysfunc(index(&i_cmd, "umask"))  eq 0 or 
          %sysfunc(index(&i_cmd, "setenv")) eq 0 or 
          %sysfunc(index(&i_cmd, "pwd"))    eq 0 or 
          %sysfunc(index(&i_cmd, "cd"))     eq 0 %then %do;
         data _null_;
            infile "&logfile" truncover lrecl=512;
            input line $512.;
            putlog line;
         run;
      %end;
      %put ======== OS Command End ========;
   %end;

%mend _xcmd; 

/** \endcond */

