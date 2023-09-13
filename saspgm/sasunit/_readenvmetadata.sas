/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      reads metadata of runtime environment

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

   \return   g_runMode
   \return   g_runningProgram
   \return   g_runEnvironment
   \return   g_runningProgramFullName
*/
/** \cond */ 
%MACRO _readEnvMetadata;

   %global 
      g_runMode
      g_runningProgram
      g_runEnvironment
      g_runningProgramFullName
      g_xcmd
      g_dirMacro
   ;

   %local l_sysin;

   %*** Check for execution mode and running program ***;
   %let g_runMode                =_NONE_;
   %let g_runningProgram         =_NONE_;
   %let g_runEnvironment         =_NONE_;
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
         /*** No way to determine the currently interactive running program in Display Manager ***/
      %end;
      %else %if (&g_runEnvironment.=SASUNIT_JUPYTER) %then %do;
         /*** No way to determine the currently interactive running program in Jupyter Notebooks ***/
      %end;
   %end;
   %if (%bquote(&g_runningProgramFullName.) ne _NONE_) %then %do;
      %let g_runningProgramFullName =%sysfunc(translate (&g_runningProgramFullName., /, \));
      %let g_runningProgram         =%scan(&g_runningProgramFullName., -1, /);
   %end;

   %*** Check if XCMD is allowed ***;
   %let g_xcmd = %sysfunc(getoption(XCMD));
   %if (&g_xcmd. = NOXCMD) %then %do;
      %let g_dirMacro = _noxcmd_dir;
   %end;
   %else %do;
      %let g_dirMacro = _dir;
   %end;
%MEND _readEnvMetadata;
/** \endcond */