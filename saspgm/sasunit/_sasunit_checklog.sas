/**
    \file
    \ingroup  SASUNIT_UTIL

    \brief    check log for errors or warnings

    \param    i_logfile  complete path and name of logfile
    \param    i_error    symbol for error (normally error, but might be language dependant). The value will be converted to uppercase.
    \param    i_warning  symbol for warning (normally warning, but might be language dependant). The value will be converted to uppercase.
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

   ATTRIB
      _errorPatternId      LENGTH = 8
      _ignoreErrPatternId  LENGTH = 8
      _warningPatternId    LENGTH = 8
      _errcount            LENGTH = 8
      _warncount           LENGTH = 8
   ;
   RETAIN
      _errorPatternId      0
      _ignoreErrPatternId  0
      _warningPatternId    0
      _errcount            0
      _warncount           0
   ;

   IF _n_=1 THEN DO;
      _errorPatternId = prxparse("/^%UPCASE(&i_error.)[: ]/");
      _warningPatternId = prxparse("/^%UPCASE(&i_warning.)[: ]/");
      _ignoreErrPatternId  = prxparse("/^ERROR: Errors printed on page/");
   END;

   IF prxmatch (_errorPatternId, logline) 
      AND (NOT prxmatch (_ignoreErrPatternId, logline)) THEN DO;
      _errcount = _errcount+1;
   END;
   ELSE IF prxmatch (_warningPatternId, logline) THEN DO;
      _warncount = _warncount+1;
   END;

   IF eof THEN DO;
      CALL symputx ("&r_errors"  , put(_errcount,8.));
      CALL symputx ("&r_warnings", put(_warncount,8.));
   END;

RUN;

%MEND _sasunit_checkLog;
/** \endcond */
