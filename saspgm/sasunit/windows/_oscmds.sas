/** \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      set global macro variables for OS commands.

   \version    \$Revision: 9 $
   \author     \$Author: amangold $
   \date       \$Date: 2010-08-02 22:33:56 +0200 (Mo, 02 Aug 2010) $
   \sa         \$HeadURL: https://sasunit.svn.sourceforge.net/svnroot/sasunit/trunk/saspgm/sasunit/_copydir.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */  

%macro _oscmds;

   %global 
      g_copydir
      g_endcommand
      g_makedir
      g_removedir
      g_removefile
      g_sasstart
      g_splash
      g_dateformat
      ;

   %local
      l_filename
      ;

      %LET g_copydir     = xcopy /E /I /Y;
      %LET g_endcommand  =%str( );
      %LET g_makedir     = md;
      %LET g_removedir   = rd /S /Q;
      %LET g_removefile  = del /S /Q;
      %LET g_sasstart    ="%sysget(sasroot)/sas.exe";
      %LET g_splash      = -nosplash;

      * retrieve dateformat from WINDOWS registry *;
      * Set default if anything goes wrong *;
      %LET g_dateformat  = _NONE_;

   %let xwait=%sysfunc(getoption(xwait));
   %let xsync=%sysfunc(getoption(xsync));
   %let xmin =%sysfunc(getoption(xmin));

   options noxwait xsync xmin;

   %let l_filename = %sysfunc (pathname (work))\retrive_dateformat.txt;
   %sysexec (reg query "HKCU\Control Panel\International" /v sShortDate > "&l_filename.");

   options &xwait &xsync &xmin;

   data _null_;
      infile "&l_filename.";
      input;
      if index (upcase (_INFILE_), "REG_SZ") then do;
         dateformat = lowcase (scan (_INFILE_,3," "));
         * Get rid of separators *;
         dateformat = compress (dateformat, '.-/');
         * make sure that year is displayed ohnly with to characters *;
         dateformat = tranwrd (dateformat, "yyyy", "yy");
         dateformat = tranwrd (dateformat, "jjjj", "jj");
         * Add suffix for length *;
         dateformat = catt (dateformat, "10.");
         call symputx ("G_DATEFORMAT", trim (dateformat));
      end;
   run;
%mend _oscmds;

/** \endcond */
