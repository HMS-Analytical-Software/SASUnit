/** \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      set global macro variables for OS commands.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%macro _oscmds;

   %global 
      g_removedir 
      g_makedir
      g_copydir
      g_endcommand
      g_sasstart
      g_splash
      ;

   %LET g_removedir   = rm -r -f;
   %LET g_removefile  = rm;
   %LET g_makedir     = mkdir;
   %LET g_copydir     = cp -R;
   %LET g_endcommand  =%str(;);
   %_xcmd(umask 003);
   %let g_sasstart =%sysfunc(pathname(sasroot))/sasexe/sas;
   %let g_splash =;

%mend _oscmds;

/** \endcond */
