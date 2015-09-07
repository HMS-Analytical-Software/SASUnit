/** \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      create a directory, if it does not exist
               The containing directory must exist. 

               \%mkdir(dir=directory)

               sets &sysrc to a value other than 0, when errors occured.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
*/ /** \cond */

%macro _mkdir (dir
              );

   %local xwait xsync xmin logfile;
   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));

   options noxwait xsync xmin;

   %let logfile=%sysfunc(pathname(work))\___mkdir.txt;
   %SYSEXEC(md "&dir" > "&logfile" 2>&1);  
   
   %if &g_verbose. %then %do;
      %put ======== OS Command Start ========;

      /* Evaluate sysexec´s return code */
      %if &sysrc. = 0 %then %put &g_note.(SASUNIT): Sysrc : 0 -> SYSEXEC SUCCESSFUL;
      %else %put &g_error.(SASUNIT): Sysrc : &sysrc -> An Error occured;

      /* put sysexec command to log*/
      %put &g_note.(SASUNIT): SYSEXEC COMMAND IS: md "&dir" > "&logfile";
      
      /* write &logfile to the log*/
      data _null_;
         infile "&logfile" truncover lrecl=512;
         input line $512.;
         putlog line;
      run;
      %put ======== OS Command End ========;
   %end;

   options &xwait &xsync &xmin;

%mend _mkdir; 

/** \endcond */

