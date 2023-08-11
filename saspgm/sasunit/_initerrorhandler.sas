/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      initialize error handling, see _handleError.sas.

               Must be called before first call to _handleerror.
               Resets global variables for error handling. 

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
			   
*/ /** \cond */ 
%MACRO _initErrorHandler;

   /* global signal for return of error conditions to calling macros programs */
   %GLOBAL g_error_code; 
   %LET g_error_code=;

   /* most recent error message */
   %GLOBAL g_error_msg; 
   %LET g_error_msg=;

   /* macro program which generated the most recent error */
   %GLOBAL g_error_macro; 
   %LET g_error_macro=;

%MEND _initErrorHandler;
/** \endcond */
