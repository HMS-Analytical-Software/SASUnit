/**
   \file
   \ingroup    SASUNIT_UTIL_OS_UNIX_AIX

   \brief      set global macro variables for OS commands.

   \version    \$Revision: GitBranch: feature/jira-29-separate-SASUnit-files-from-project-source $
   \author     \$Author: landwich $
   \date       \$Date: 2024-03-13 11:25:41 (Mi, 13. M�rz 2024) $

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the Lesser GPL license see included file readme.txt
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/readme/.
*/ /** \cond */  
%macro _oscmds;

   %global 
      g_removedir 
      g_copydir
      g_endcommand
      g_makedir
      g_sasstart
      g_splash
      g_infile_options
      g_osCmdFileSuffix
      g_assertTextIgnoreCase
      g_assertTextCompressBlanks
      ;
      
   %local
      l_macroName 
   ;   
   %LET l_macroName=&sysmacroname;

   %LET g_removedir                 =rm -r -f;
   %LET g_copydir                   =cp -R;
   %LET g_endcommand                =%str( );
   %LET g_makedir                   =mkdir;
   %LET g_sasstart                  ="%sysfunc(pathname(sasroot))/bin/sas_&g_language.";
   %LET g_splash                    =;   
   %LET g_infile_options            =;
   %LET g_osCmdFileSuffix           =sh;
   %LET g_assertTextIgnoreCase      =-i;
   %LET g_assertTextCompressBlanks  =-b;
   
   %*************************************************************;
   %*** Check if XCMD is allowed                              ***;
   %*************************************************************;
   %IF %_handleError(&l_macroName.
                 ,NOXCMD
                 ,(%sysfunc(getoption(XCMD)) = NOXCMD)
                 ,Your SAS Session does not allow XCMD%str(,) therefore functionality is restricted.
                 ,i_msgtype=WARNING
                 ) 
   %THEN %DO;
      * Should only be a warning, so reset error flag *;
      %let G_ERROR_CODE =;
   %END;
   %ELSE %DO;
      %_xcmd(umask 0033);
   %END;
   
   options nobomfile;

%mend _oscmds;
/** \endcond */
