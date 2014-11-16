/** 
   \file
   \ingroup    SASUNIT_UTIL_OS_WIN

   \brief      set global macro variables for OS commands.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
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
      length g_dateformat $40;
      infile "&l_filename.";
      input;
      if index (upcase (_INFILE_), "REG_SZ") then do;
         dateformat = lowcase (scan (_INFILE_,3," "));
         * Building SAS-format name from WIN-Dateformat *;
         * Get rid of separators *;
         g_dateformat = "nldate.";
         * Chekc if monthname is displayed *;
         if (index (dateformat,"mmm")=0) then do;
            * Check order of day month year *;
            index_d=index (dateformat,"d");
            index_m=index (dateformat,"m");
            index_y=index (dateformat,"y");
            if (index_y < index_m) then do;
               if (index_d < index_m) then do;
                  g_dateformat = "yyddmm10.";
               end;
               else do;
                  g_dateformat = "yymmdd10.";
               end;
            end;
            else do;
               if (index_d > index_m) then do;
                  g_dateformat = "mmddyy10.";
               end;
               else do;
                  g_dateformat = "ddmmyy10.";
               end;
            end;
         end;
         call symputx ("G_DATEFORMAT", trim (g_dateformat));
      end;
   run;
%mend _oscmds;

/** \endcond */
