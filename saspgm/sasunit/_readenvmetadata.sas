/**
   \file
   \ingroup  SASUNIT_UTIL

   \brief    reads metadata o fruntime environment

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \todo Add SAS Studio and JupyterNotebooks
 
   \param    g_runMode
   \param    g_runningProgram
   \param    g_runEnvironment
   \param    g_runningProgramFullName
*/
/** \cond */ 
%MACRO _readEnvMetadata;

   %global 
      g_runMode
      g_runningProgram
      g_runEnvironment
      g_runningProgramFullName
   ;

   /* This is nice but not reliable. SAS Studio or JupyterNotebooks behave differently
   *** Check for batch or interactive mode ***;
   %if (%symexist (SYSPROCESSMODE)) %then %do;
      %if (&SYSPROCESSMODE.=SAS Batch Mode) %then %do;
         %let g_runMode=SASUNIT_BATCH;         
      %end;
   %end;
   %else %do;
      %if (%sysfunc(quote(&SYSPROCESSNAME.))="SAS Batch Mode") %then %do;
         %let g_runMode=SASUNIT_BATCH;         
      %end;
      %else %if (%substr(&SYSPROCESSNAME.,1,7) = Program) %then %do;
         %let g_runMode=SASUNIT_BATCH;         
      %end;
   %end;
   
   *** Check for interactive mode ***;
   %if (%symexist (SYSPROCESSMODE)) %then %do;
      %if (&SYSPROCESSMODE.=SAS DMS Session OR &SYSPROCESSMODE.=SAS Workspace Server) %then %do;
         %let g_runMode=SASUNIT_INTERACTIVE;         
      %end;
   %end;
   %else %do;
      %if (%sysfunc(quote(&SYSPROCESSNAME.))="DMS Process" OR %sysfunc(quote(&SYSPROCESSNAME.))="Object Server") %then %do;
         %let g_runMode=SASUNIT_INTERACTIVE;         
      %end;
   %end;
*/
/* This one doesn't work for enterprise guide
   %if (&SYSENV. = FORE) %then %do;
      %let g_runMode=SASUNIT_INTERACTIVE;         
   %end;
   %else %do;
      %let g_runMode=SASUNIT_BATCH;         
   %end;*/

   *** Check for execution mode and running program ***;
   %let g_runningProgram         =_NONE_;
   %let g_runningProgramFullName =_NONE_;

   %let g_runningProgramFullName=%sysfunc(getoption(SYSIN));

   %if (%bquote(&g_runningProgramFullName.) ne %str()) %then %do;
      %let g_runningProgramFullName =%sysfunc(translate (&g_runningProgramFullName., /, \));
      %let g_runningProgram         =%scan(&g_runningProgramFullName., -1, /);
      %let g_runMode                =SASUNIT_BATCH;         
   %end;
   %else %do;
      %let g_runMode=SASUNIT_INTERACTIVE;         
      %let g_runningProgramFullName =_NONE_;
   %end;   

   *** Check for running Environment ***;
   *** Add SAS Studio and JupyterNotebooks ***;
   %if (%symexist (_CLIENTAPPABREV)) %then %do;
      %if (%upcase(&_CLIENTAPPABREV)=EG) %then %do;
         %let g_runEnvironment =SASUNIT_SEG;
      %end;
   %end;
   %else %do;
      %if (%sysfunc(quote(&SYSPROCESSNAME.))="Object Server") %then %do;
         %let g_runEnvironment =SASUNIT_SEG;
      %end;
      %else %if (%sysfunc(quote(&SYSPROCESSNAME.))="DMS Process" OR %substr(&SYSPROCESSNAME.,1,7) = Program) %then %do;
         %let g_runEnvironment =SASUNIT_DMS;
      %end;
   %end;
   
   *** Check for running program ***;
   %if (&g_runMode. ne SASUNIT_BATCH) %then %do;
      %if (&g_runEnvironment.=SASUNIT_SEG) %then %do;
         %if (&_SASPROGRAMFILE. ne '') %then %do;
            %let g_runningProgramFullName=%sysfunc(dequote(&_SASPROGRAMFILE.));
         %end;
      %end;
      %else %if (&g_runEnvironment.=SASUNIT_DMS) %then %do;
         %let g_runningProgramFullName=%sysfunc(getoption(SYSIN));
      %end;
   %end;
   %if (%bquote(&g_runningProgramFullName.) ne _NONE_) %then %do;
      %let g_runningProgramFullName =%sysfunc(translate (&g_runningProgramFullName., /, \));
      %let g_runningProgram         =%scan(&g_runningProgramFullName., -1, /);
   %end;
%exit:
%MEND _readEnvMetadata;
/** \endcond */
