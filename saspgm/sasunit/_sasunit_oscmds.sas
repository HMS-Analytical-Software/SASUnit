/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      set global macro variables for OS commands.

   \version    \$Revision: 9 $
   \author     \$Author: amangold $
   \date       \$Date: 2010-08-02 22:33:56 +0200 (Mo, 02 Aug 2010) $
   \sa         \$HeadURL: https://sasunit.svn.sourceforge.net/svnroot/sasunit/trunk/saspgm/sasunit/_sasunit_copydir.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */  

%macro _sasunit_oscmds;

%global 
   g_removedir 
   g_makedir
   g_copydir
   g_endcommand
   g_sasstart
   g_splash
   ;
%if &sysscp. = WIN %then %do; 
        %let g_removedir = rd /S /Q;
        %let g_makedir = md;
        %let g_copydir = xcopy /E /I /Y;
        %let g_endcommand =;
        %let g_sasstart ="%sysget(sasroot)/sas.exe";
        %let g_splash = -nosplash;
%end;
%else %if &sysscp. = LINUX %then %do;
        %let g_removedir = rm -r -f;
        %let g_makedir = mkdir;
        %let g_copydir = cp -R;
        %let g_endcommand =%str(;);
        %_sasunit_xcmd(umask 0033);
        %let g_sasstart ="%sysfunc(pathname(sasroot))/bin/sas_%sysget(SASUNIT_LANGUAGE)";
        %let g_splash =;
%end;

%mend _sasunit_oscmds;

/** \endcond */
