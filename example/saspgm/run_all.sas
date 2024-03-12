/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST

   \brief      Run all test scenarios for SASUnit example project

               (see also <A href="hhttps://github.com/HMS-Analytical-Software/SASUnit/wiki/User's%20Guide" target="_blank">SASUnit User's Guide</A>)\n
               Initialize SASUnit (open test repository or create when needed) with initSASUnit.sas
               - set project name
               - set root path for convenience (all other paths can be relative to root path)
               - set paths for SASUnit macro library, test repository, units under test, test data, reference data

               Run all test scenarios in folder example\saspgm (suffix _test.sas) with runSASUnit.sas where
               the test scenario or the unit under test has been changed since previous run.            

               Create or recreate necessary HTML pages in the test report with reportSASUnit.sas.
               
   \version    \$Revision: GitBranch: feature/18-bug-sasunitcfg-not-used-in-sas-subprocess $
   \author     \$Author: landwich $
   \date       \$Date: 2024-02-22 11:27:38 (Do, 22. Februar 2024) $

   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/
/** \cond */  
OPTIONS 
   MPRINT MAUTOSOURCE NOMLOGIC NOSYMBOLGEN
   APPEND=(SASAUTOS "%sysget(SASUNIT_ROOT)/saspgm/sasunit")
;

%initSASUnit(
   i_root                     = %sysget(SASUNIT_PROJECT_ROOT)
  ,io_target                  = %sysget(SASUNIT_TEST_DB_FOLDER)
  ,i_overwrite                = %sysget(SASUNIT_OVERWRITE)
  ,i_project                  = SASUnit Examples                                  /* Name of project, for report */
  ,i_sasunit                  = %sysget(SASUNIT_ROOT)saspgm/sasunit
  ,i_sasautos                 = %sysget(SASUNIT_AUTOCALL_ROOT)saspgm              /* Search for units under test here */
  ,i_testdata                 = dat                                               /* test data, libref testdata */
  ,i_refdata                  = dat                                               /* reference data, libref refdata */
  ,i_doc                      = doc/spec
  ,i_sascfg                   = %sysget(SASUNIT_CONFIG)
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
%runSASUnit(i_source = %sysget(SASUNIT_TEST_SCENARIO_ROOT)saspgm/%str(*)_test.sas);

/* Create or recreate HTML pages for report where needed */
%reportSASUnit(
   i_language       =%lowcase(%sysget(SASUNIT_LANGUAGE))
  ,o_html           =1
  ,o_junit          =1
  ,o_pgmdoc         =%sysget(SASUNIT_PGMDOC)
  ,o_pgmdoc_sasunit =%sysget(SASUNIT_PGMDOC_SASUNIT)
);

/** \endcond */

 