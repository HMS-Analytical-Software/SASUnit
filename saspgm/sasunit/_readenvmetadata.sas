/**
   \file
   \ingroup  SASUNIT_UTIL

   \brief    reads metadata of runtime environment

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

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

   %local l_sysin;

   %*** Check for execution mode and running program ***;
   %let g_runningProgram         =_NONE_;
   %let g_runningProgramFullName =_NONE_;

   %let l_sysin=%qsysfunc(getoption(SYSIN));

   %*** Detect Jupyter Notebooks ***;
   %if (&l_sysin. eq __STDIN__) %then %do;
      %let g_runMode                =SASUNIT_INTERACTIVE;         
      %let g_runningProgramFullName =_NONE_;
   %end;
   %*** Detect batch mode ***;
   %else %if (&l_sysin. ne %str()) %then %do;
      %let g_runningProgramFullName =%sysfunc(translate (&l_sysin., /, \));
      %let g_runningProgram         =%scan(&g_runningProgramFullName., -1, /);
      %let g_runMode                =SASUNIT_BATCH;         
   %end;
   %else %do;
      %let g_runMode                =SASUNIT_INTERACTIVE;         
      %let g_runningProgramFullName =_NONE_;
   %end;   

   %*** Check for running Environment ***;
   %if (%symexist (_EXECENV)) %then %do;
      %if (%upcase(&_EXECENV.)=SASSTUDIO) %then %do;
         %let g_runEnvironment =SASUNIT_SASSTUDIO;
      %end;
   %end;
   %else %if (%symexist (_CLIENTAPPABREV)) %then %do;
      %if (%upcase(&_CLIENTAPPABREV)=EG) %then %do;
         %let g_runEnvironment =SASUNIT_SEG;
      %end;
   %end;
   %else %if (%symexist (_CLIENTPROJECTNAME)) %then %do;
      %let g_runEnvironment =SASUNIT_SEG;
   %end;
   %else %do;
      %if (%sysfunc(quote(&SYSPROCESSNAME.))="Object Server") %then %do;
         %let g_runEnvironment =SASUNIT_SEG;
      %end;
      %else %if (%sysfunc(quote(&SYSPROCESSNAME.))="DMS Process" OR %sysfunc(quote(%substr(&SYSPROCESSNAME.,1,7))) = "Program") %then %do;
         %if (&l_sysin. eq __STDIN__) %then %do;
            %let g_runEnvironment =SASUNIT_JUPYTER;
         %end;
         %else %do;
            %let g_runEnvironment =SASUNIT_DMS;
         %end;
      %end;
   %end;
   
   %*** Check for running program ***;
   %if (&g_runMode. ne SASUNIT_BATCH) %then %do;
      %if (&g_runEnvironment.=SASUNIT_SEG OR &g_runEnvironment.=SASUNIT_SASSTUDIO) %then %do;
         %if (&_SASPROGRAMFILE. ne '' AND &_SASPROGRAMFILE. ne %str()) %then %do;
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
%MEND _readEnvMetadata;
/** \endcond */
