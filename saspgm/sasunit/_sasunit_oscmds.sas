/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      set global macro variables for OS commands.

   \version    \$Revision: 9 $
   \author     \$Author: amangold $
   \date       \$Date: 2010-08-02 22:33:56 +0200 (Mo, 02 Aug 2010) $
   \sa         \$HeadURL: https://sasunit.svn.sourceforge.net/svnroot/sasunit/trunk/saspgm/sasunit/_sasunit_copydir.sas $

*/ /** \cond */ 

/* change history
   31.08.2012 KL  Contents of g_sasstart is concatenated in a data step for both environments, so both need quotes.
   03.08.2010 AM  First version
*/ 

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
        %let g_removedir = rm -r;
        %let g_makedir = mkdir;
        %let g_copydir = cp -R;
        %let g_endcommand =%str(;);
        %_sasunit_xcmd(umask 0033);
        %let g_sasstart ="%sysfunc(pathname(sasroot))/sasexe/sas";
        %let g_splash =;
%end;

%mend _sasunit_oscmds;

/** \endcond */
