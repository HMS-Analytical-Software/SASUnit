/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      initialize a test scenario, see initSASUnit.sas.
               _scenario.sas is used to initialize the SAS session 
               spawned by runSASUnit.sas

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
            
   \param   io_target       path to test database

*/ /** \cond */ 
%MACRO _scenario(io_target  = 
                );

   %LOCAL l_macname g_currentLogger g_currentLogLevel; 

   %LET l_macname=&sysmacroname;

   OPTIONS MAUTOSOURCE MPRINT MPRINTNEST LINESIZE=MAX;

   %LET g_currentLogger   = App.Program.SASUnitScenario;
   %LET g_currentLogLevel = DEBUG;
   /*** Setting logging information  ***/
   %_setLog4SASLogLevel (loggername =&g_currentlogger.
                        ,level      =&g_currentLogLevel.
                        );   
   
   /* initialize error handling */
   %_initErrorHandler;

   /* check for target directory*/
   %IF %_handleError(&l_macname
                    ,InvalidTargetDir
                    ,"&io_target" EQ "" OR NOT %_existDir(&io_target)
                    ,target directory &io_target does not exist
                    ) 
      %THEN %GOTO errexit;

   /* create libref for test database*/
   LIBNAME target "&io_target";
   %IF %_handleError(&l_macname
                    ,ErrorNoTargetDirLib
                    ,%quote(&syslibrc.) NE 0
                    ,test database cannot be opened
                    ) 
      %THEN %GOTO errexit;

   /* flags for test cases */
   %GLOBAL g_inScenario g_inTestcase g_inTestcall;
   %LET g_inScenario=0;
   %LET g_inTestcase=0;
   %LET g_inTestcall=0;

   %GOTO exit;
   %errexit:
      %_issueInfoMessage (g_currentLogger., %str (========================== Error! Test scenario will be aborted! ================================));
   LIBNAME target;
   %exit:
%MEND _scenario;
/** \endcond */