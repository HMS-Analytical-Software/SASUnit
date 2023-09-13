/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _checkLog.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _checkLog.sas);

%Macro _checklog_test;

%LOCAL
   l_fullfilepath
   l_error
   l_warning
   l_errorcountvar
   l_warningcountvar
   l_errorcount
   l_warningcount
;

%t1:
/* === Test case start ================================================ */
%LET l_error            = ERROR;
%LET l_warning          = WARNING;
%LET l_errorcountvar    = l_errorcount;
%LET l_warningcountvar  = l_warningcount;
%LET l_fullfilepath     = &g_testdata./_checklog_t01_input.log;

%initTestcase (   i_object = _checkLog.sas
                , i_desc   = %STR(log contains errors and warnings)
               );

%_checkLog(
                   i_logfile  = &l_fullfilepath.
                  ,i_error    = &l_error.
                  ,i_warning  = &l_warning.
                  ,r_errors   = &l_errorcountvar.
                  ,r_warnings = &l_warningcountvar.
               );

%assertEquals ( i_expected = 3
               ,i_actual   = &&&l_errorcountvar.
               ,i_desc     = %STR(number of detected errors must match)
               );

%assertEquals ( i_expected = 7
               ,i_actual   = &&&l_warningcountvar.
               ,i_desc     = %STR(number of detected warnings must match)
               );

%assertLog ();

%endTestcase();


%t2:
/* === Test case start ================================================ */
%LET l_error            = ERROR;
%LET l_warning          = WARNING;
%LET l_errorcountvar    = l_errorcount;
%LET l_warningcountvar  = l_warningcount;
%LET l_fullfilepath     = &g_testdata./_checklog_t02_input.log;

%initTestcase (   i_object = _checkLog.sas
                , i_desc   = %STR(log contains errors (one without colon) and no warnings)
               );

%_checkLog(
                   i_logfile  = &l_fullfilepath.
                  ,i_error    = &l_error.
                  ,i_warning  = &l_warning.
                  ,r_errors   = &l_errorcountvar.
                  ,r_warnings = &l_warningcountvar.
               );

%assertEquals ( i_expected = 5
               ,i_actual   = &&&l_errorcountvar.
               ,i_desc     = %STR(number of detected errors must match)
               );

%assertEquals ( i_expected = 0
               ,i_actual   = &&&l_warningcountvar.
               ,i_desc     = %STR(number of detected warnings must match)
               );

%assertLog ();

%endTestcase();


%t3:
/* === Test case start ================================================ */
%LET l_error            = ERROR;
%LET l_warning          = WARNING;
%LET l_errorcountvar    = l_errorcount;
%LET l_warningcountvar  = l_warningcount;
%LET l_fullfilepath     = &g_testdata./_checklog_t03_input.log;

%initTestcase (   i_object = _checkLog.sas
                , i_desc   = %STR(log contains no errors and warnings)
               );

%_checkLog(
                   i_logfile  = &l_fullfilepath.
                  ,i_error    = &l_error.
                  ,i_warning  = &l_warning.
                  ,r_errors   = &l_errorcountvar.
                  ,r_warnings = &l_warningcountvar.
               );

%assertEquals ( i_expected = 0
               ,i_actual   = &&&l_errorcountvar.
               ,i_desc     = %STR(number of detected errors must match)
               );

%assertEquals ( i_expected = 0
               ,i_actual   = &&&l_warningcountvar.
               ,i_desc     = %STR(number of detected warnings must match)
               );

%assertLog ();

%endTestcase();


%t4:
/* === Test case start ================================================ */
%LET l_error            = ERROR;
%LET l_warning          = WARNING;
%LET l_errorcountvar    = l_errorcount;
%LET l_warningcountvar  = l_warningcount;
%LET l_fullfilepath     = &g_testdata./_checklog_txx_input.log;

%initTestcase (   i_object = _checkLog.sas
                , i_desc   = %STR(inexistent log file)
               );

%_checkLog(
                   i_logfile  = &l_fullfilepath.
                  ,i_error    = &l_error.
                  ,i_warning  = &l_warning.
                  ,r_errors   = &l_errorcountvar.
                  ,r_warnings = &l_warningcountvar.
               );

%assertEquals ( i_expected = 999
               ,i_actual   = &&&l_errorcountvar.
               ,i_desc     = %STR(number of detected errors must match)
               );

%assertEquals ( i_expected = 999
               ,i_actual   = &&&l_warningcountvar.
               ,i_desc     = %STR(number of detected warnings must match)
               );

%assertLog (
             i_errors   = 1
            ,i_warnings = 0
            ,i_desc     = %STR(log must contain 1 error)
         );

%endTestcase();


%t5:
/* === Test case start ================================================ */
%LET l_error            = error;
%LET l_warning          = warning;
%LET l_errorcountvar    = l_errorcount;
%LET l_warningcountvar  = l_warningcount;
%LET l_fullfilepath     = &g_testdata./_checklog_t01_input.log;

%initTestcase (   i_object = _checkLog.sas
                , i_desc   = %STR(log contains errors and warnings, error/warning symbols passed in lowercase)
               );

%_checkLog(
                   i_logfile  = &l_fullfilepath.
                  ,i_error    = &l_error.
                  ,i_warning  = &l_warning.
                  ,r_errors   = &l_errorcountvar.
                  ,r_warnings = &l_warningcountvar.
               );

%assertEquals ( i_expected = 3
               ,i_actual   = &&&l_errorcountvar.
               ,i_desc     = %STR(number of detected errors must match)
               );

%assertEquals ( i_expected = 7
               ,i_actual   = &&&l_warningcountvar.
               ,i_desc     = %STR(number of detected warnings must match)
               );

%assertLog ();

%endTestcase();


%EXIT:
%Mend _checklog_test;
%_checklog_test;

%endScenario();
/** \endcond */