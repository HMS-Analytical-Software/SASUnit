/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      initialize a test scenario, see initSASUnit.sas.
               _scenario.sas is used to initialize the SAS session 
               spawned by runSASUnit.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   io_target       path to test database
*/ /** \cond */ 

%MACRO _scenario(io_target  = 
                );

   %LOCAL l_macname; 

   %LET l_macname=&sysmacroname;

   OPTIONS MAUTOSOURCE MPRINT LINESIZE=MAX;

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
      %PUT ========================== Error! Test scenario will be aborted! ================================;
   LIBNAME target;
   %exit:
%MEND _scenario;
/** \endcond */
