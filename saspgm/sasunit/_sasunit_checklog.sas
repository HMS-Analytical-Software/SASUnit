/**
    \file
    \ingroup  SASUNIT_UTIL

    \brief    check log for errors or warnings

    \param    i_logfile  complete path and name of logfile
    \param    i_error    symbol for error (normally error, but might be language dependant)
    \param    i_warning  symbol for warning (normally warning, but might be language dependant)
    \param    r_errors   macro variable to return number of errors (999 if logfile does not exist)
    \param    r_warnings macro variable to return number of warnings (999 if logfile does not exist)

    \version    \$Revision$
    \author     \$Author$
    \date       \$Date$
    \sa         \$HeadURL$

*/ /** \cond */ 

%MACRO _sasunit_checkLog(
    i_logfile  =
   ,i_error    = 
   ,i_warning  = 
   ,r_errors   = 
   ,r_warnings = 
);

%LET &r_errors   = 999;
%LET &r_warnings = 999;
DATA _null_;
   INFILE "&i_logfile" TRUNCOVER end=eof;
   INPUT logline $char255.;
   IF index (logline, "&i_error")   = 1 THEN error_count+1;
   IF index (logline, "&i_warning") = 1 THEN warning_count+1;
   IF eof THEN DO;
      CALL symput ("&r_errors"  , compress(put(error_count,8.)));
      CALL symput ("&r_warnings", compress(put(warning_count,8.)));
   END;
RUN;

%MEND _sasunit_checkLog;
/** \endcond */
