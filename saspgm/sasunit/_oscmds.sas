/** \file
   \ingroup    SASUNIT_UTIL 

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

%MACRO _oscmds;

   %GLOBAL 
      g_removedir 
      g_makedir
      g_copydir
      g_endcommand
      g_sasstart
      g_splash
      g_removefile
      ;
   %IF &sysscp. = WIN %THEN %DO; 
           %LET g_removedir   = rd /S /Q;
           %LET g_removefile  = del /S /Q;
           %LET g_makedir     = md;
           %LET g_copydir     = xcopy /E /I /Y;
           %LET g_endcommand  =%str( );
           %LET g_sasstart    ="%sysget(sasroot)/sas.exe";
           %LET g_splash      = -nosplash;
   %END;
   %ELSE %IF &sysscp.         = LINUX %THEN %DO;
           %LET g_removedir   = rm -r -f;
           %LET g_removefile  = rm;
           %LET g_makedir     = mkdir;
           %LET g_copydir     = cp -R;
           %LET g_endcommand  =%str(;);
           %_xcmd(umask 0033);
           %LET g_sasstart    ="%sysfunc(pathname(sasroot))/bin/sas_%sysget(SASUNIT_LANGUAGE)";
           %LET g_splash      =;
   %END;
%MEND _oscmds;

/** \endcond */
