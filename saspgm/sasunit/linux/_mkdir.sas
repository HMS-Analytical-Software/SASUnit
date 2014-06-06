/** \file
   \ingroup    SASUNIT_UTIL_OS_LINUX

   \brief      create a directory, if it does not exist
               The containing directory must exist. 

               \%mkdir(dir=directory)

               sets &sysrc to a value other than 0, when errors occured.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */

%macro _mkdir (dir
              );
   %LOCAL logfile;
              
   %let logfile=%sysfunc(pathname(work))/___log.txt;
   
   %SYSEXEC(mkdir "&dir." > "&logfile" 2>&1);
   %if &g_verbose. %then %do;
      %put ======== OS Command Start ========;

      /* Evaluate sysexec´s return code */
      %if &sysrc. = 0 %then %put &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %else %put &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %put &g_note.(SASUNIT): SYSEXEC COMMAND IS: mkdir "&dir." > "&logfile" 2>&1;
      
      /* write &logfile to the log*/
      data _null_;
         infile "&logfile" truncover lrecl=512;
         input line $512.;
         putlog line;
      run;
      %put ======== OS Command End ========;
   %end;

%mend _mkdir; 

/** \endcond */

