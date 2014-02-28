/** \file
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
      g_removedir 
      g_makedir
      g_copydir
      g_endcommand
      g_sasstart
      g_splash
      ;

     %LET g_removedir   = rd /S /Q;
     %LET g_removefile  = del /S /Q;
     %LET g_makedir     = md;
     %LET g_copydir     = xcopy /E /I /Y;
     %LET g_endcommand  =%str( );
     %LET g_sasstart    ="%sysget(sasroot)/sas.exe";
     %LET g_splash      = -nosplash;


%mend _oscmds;

/** \endcond */
