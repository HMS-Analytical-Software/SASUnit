/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Run all test scenarios for SASUnit example project

               (see also <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>)\n
               Initialize SASUnit (open test repository or create when needed) with initSASUnit.sas
               - set project name
               - set root path for convenience (all other paths can be relative to root path)
               - set paths for SASUnit macro library, test repository, units under test, test data, reference data

               Run all test scenarios in folder example\saspgm (suffix _test.sas) with runSASUnit.sas where
               the test scenario or the unit under test has been changed since previous run.            

               Create or recreate necessary HTML pages in the test report with reportSASUnit.sas.
               
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

*/
/** \cond */  
OPTIONS 
   MPRINT MAUTOSOURCE NOMLOGIC NOSYMBOLGEN
   APPEND=(SASAUTOS "%sysget(SASUNIT_ROOT)/saspgm/sasunit")
;

proc options option=logparm;run;

%initSASUnit(
   i_root                     = %sysget(SASUNIT_PROJECT_ROOT)
  ,io_target                  = %sysget(SASUNIT_TEST_DB_FOLDER)
  ,i_overwrite                = %sysget(SASUNIT_OVERWRITE)
  ,i_project                  = SASUnit Examples                                  /* Name of project, for report */
  ,i_sasunit                  = %sysget(SASUNIT_ROOT)/saspgm/sasunit
  ,i_sasautos                 = saspgm                                            /* Search for units under test here */
  ,i_testdata                 = dat                                               /* test data, libref testdata */
  ,i_refdata                  = dat                                               /* reference data, libref refdata */
  ,i_doc                      = doc/spec
  ,i_sascfg                   = %sysget(SASUNIT_SAS_CFG)
  ,i_testcoverage             = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_crossref                 = %sysget(SASUNIT_CROSSREFERENCE)
  ,i_crossrefsasunit          = %sysget(SASUNIT_CROSSREFERENCE_SASUNIT)
  ,i_language                 = %lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_logFolder                = %sysget(SASUNIT_LOG_FOLDER)
  ,i_scnLogFolder             = %sysget(SASUNIT_SCN_LOG_FOLDER)
  ,i_log4SASSuiteLogLevel     = %sysget(SASUNIT_LOGLEVEL)
  ,i_log4SASScenarioLogLevel  = %sysget(SASUNIT_SCN_LOGLEVEL)
  ,i_reportFolder             = %sysget(SASUNIT_REPORT_FOLDER)
  ,i_OSEncoding               = %sysget(SASUNIT_HOST_ENCODING)
  )

/* Run specified test scenarios. There can be more than one call to runSASUnit */
%runSASUnit(i_source = saspgm/%str(*)_test.sas);

/* Create or recreate HTML pages for report where needed */
%reportSASUnit(
   i_language       =%lowcase(%sysget(SASUNIT_LANGUAGE))
  ,o_html           =1
  ,o_junit          =1
  ,o_pgmdoc         =%sysget(SASUNIT_PGMDOC)
  ,o_pgmdoc_sasunit =%sysget(SASUNIT_PGMDOC_SASUNIT)
);

/** \endcond */

