/** \file
   \ingroup    SASUNIT_UTIL

   \brief      initialize a test scenario, see initSASUnit.sas.
               _scenario.sas is used to initialize the SAS session 
               spawned by runSASUnit.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

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

/* set global macro symbols and librefs / filerefs  */
%_loadEnvironment()
%IF &g_error_code NE %THEN %GOTO errexit;

/* create autocall path */
OPTIONS MAUTOSOURCE SASAUTOS=(SASAUTOS "&g_sasunit" 
%IF "&g_sasautos" NE "" %THEN "&g_sasautos";
%DO i=1 %TO 9;
   %IF "&&g_sasautos&i" NE "" %THEN "&&g_sasautos&i";
%END;     );

/* flag for test cases */
%GLOBAL g_inTestcase;
%LET g_inTestcase=0;
%_oscmds;

%GOTO exit;
%errexit:
   %PUT ========================== Error! Test scenario will be aborted! ================================;
LIBNAME target;
%exit:
%MEND _scenario;
/** \endcond */
