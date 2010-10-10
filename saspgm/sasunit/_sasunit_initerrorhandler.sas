/** \file
   \ingroup    SASUNIT_UTIL

   \brief      initialize error handling, see _sasunit_handleError.sas.

               Must be called before first call to _sasunit_handleerror.
               Resets global variables for error handling. 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

%MACRO _sasunit_initErrorHandler;
/* global signal for return of error conditions to calling macros programs */
%GLOBAL g_error_code; 
%LET g_error_code=;

/* most recent error message */
%GLOBAL g_error_msg; 
%LET g_error_msg=;

/* macro program which generated the most recent error */
%GLOBAL g_error_macro; 
%LET g_error_macro=;

%MEND _sasunit_initErrorHandler;
/** \endcond */
