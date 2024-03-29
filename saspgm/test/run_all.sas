/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Invocation of the basic test scenarios

   \version    \$Revision: GitBranch: feature/jira-29-separate-SASUnit-files-from-project-source $
   \author     \$Author: landwich $
   \date       \$Date: 2024-03-13 11:25:42 (Mi, 13. M�rz 2024) $
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 

OPTIONS 
   MPRINT MAUTOSOURCE NOMLOGIC NOSYMBOLGEN
   APPEND=(SASAUTOS "%sysget(SASUNIT_ROOT)/saspgm/sasunit") /* SASUnit macro library */
;
/**/
proc options option=logparm;run;

%initSASUnit(
   i_root                     = %sysget(SASUNIT_PROJECT_ROOT)
  ,io_target                  = %sysget(SASUNIT_TEST_DB_FOLDER)
  ,i_overwrite                = %sysget(SASUNIT_OVERWRITE)
  ,i_project                  = SASUnit Self Test
  ,i_sasunit                  = %sysget(SASUNIT_ROOT)saspgm/sasunit
  ,i_sasautos                 = %sysget(SASUNIT_AUTOCALL_ROOT)sasunit
  ,i_sasautos1                = %sysget(SASUNIT_AUTOCALL_ROOT)test
  ,i_sasautos2                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib1
  ,i_sasautos3                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib2
  ,i_testdata                 = dat
  ,i_refdata                  = dat
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
  ,i_resourceFolder           = %sysget(SASUNIT_RESOURCE_FOLDER)
  ,i_OSEncoding               = %sysget(SASUNIT_HOST_ENCODING)
);

%runSASUnit(i_source = %str(%sysget(SASUNIT_TEST_SCENARIO_ROOT)reportsasunit_inexisting_scenario_has_to_fail));
%runSASUnit(i_source = %str(%sysget(SASUNIT_TEST_SCENARIO_ROOT)%str(*)_test.sas));
%runSASUnit(i_source = %str(%sysget(SASUNIT_TEST_SCENARIO_ROOT)%lowcase(%sysget(SASUNIT_HOST_OS))/%str(*)_test.sas));

/* To check different config and autoexec files there will be additional calls   */
/* of initSASUnit and runSASUnit.                                                */
/* First of all there will be created a new config file with a separate option   */
/* for autoexec. Then a separate autoexec file is created.                       */
/* To ensure the use of these files there will be set a macro variable different */
/* In each autoexec file and tested in special testcases.                        */
%let ConfigName   =%sysfunc(pathname(work))/config_for_testing.cfg;
%let AutoexecName1=%sysfunc(pathname(work))/autoexec_for_config_test.sas;
%let AutoexecName2=%sysfunc(pathname(work))/autoexec_for_autoexec_test.sas;

data _null_;
   file "&ConfigName.";
   infile "%sysget(SASUNIT_ROOT)/bin/sasunit.%sysget(SASUNIT_SAS_VERSION).%lowcase(%sysget(SASUNIT_HOST_OS)).%lowcase(%sysget(SASUNIT_LANGUAGE)).cfg" end=eof;
   input;
   put _INFILE_;
   if (eof) then do;
      put '-SASAUTOS (SASAUTOS "\TEMP1\HUGO" "\TEMP1\FRITZ")';
      put "-autoexec ""&AutoexecName1.""";
   end;
run;

data _null_;
   file "&AutoexecName1.";
   put '%LET HUGO=Test for i_config;';
run;

data _null_;
   file "&AutoexecName2.";
   put '%LET HUGO=Test for i_autoexec;';
run;

%initSASUnit(
   i_root                     = %sysget(SASUNIT_PROJECT_ROOT)
  ,io_target                  = %sysget(SASUNIT_TEST_DB_FOLDER)
  ,i_overwrite                = 0
  ,i_project                  = SASUnit Self Test
  ,i_sasunit                  = %sysget(SASUNIT_ROOT)/saspgm/sasunit
  ,i_sasautos                 = %sysget(SASUNIT_AUTOCALL_ROOT)sasunit
  ,i_sasautos1                = %sysget(SASUNIT_AUTOCALL_ROOT)test
  ,i_sasautos2                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib1
  ,i_sasautos3                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib2
  ,i_testdata                 = dat
  ,i_refdata                  = dat
  ,i_doc                      = doc/spec
  ,i_sascfg                   = &ConfigName.
  ,i_testcoverage             = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_crossref                 = %sysget(SASUNIT_CROSSREFERENCE)
  ,i_crossrefsasunit          = %sysget(SASUNIT_CROSSREFERENCE_SASUNIT)
  ,i_language                 = %lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_logFolder                = %sysget(SASUNIT_LOG_FOLDER)
  ,i_scnLogFolder             = %sysget(SASUNIT_SCN_LOG_FOLDER)
  ,i_log4SASSuiteLogLevel     = %sysget(SASUNIT_LOGLEVEL)
  ,i_log4SASScenarioLogLevel  = %sysget(SASUNIT_SCN_LOGLEVEL)
  ,i_reportFolder             = %sysget(SASUNIT_REPORT_FOLDER)
  ,i_resourceFolder           = %sysget(SASUNIT_ROOT)/resources
  ,i_OSEncoding               = %sysget(SASUNIT_HOST_ENCODING)
)

%runSASUnit(i_source = saspgm/test/assert_i_config_usage_configtest.sas);

%initSASUnit(
   i_root                     = %sysget(SASUNIT_PROJECT_ROOT)
  ,io_target                  = %sysget(SASUNIT_TEST_DB_FOLDER)
  ,i_overwrite                = 0
  ,i_project                  = SASUnit Self Test
  ,i_sasunit                  = %sysget(SASUNIT_ROOT)/saspgm/sasunit
  ,i_sasautos                 = %sysget(SASUNIT_AUTOCALL_ROOT)sasunit
  ,i_sasautos1                = %sysget(SASUNIT_AUTOCALL_ROOT)test
  ,i_sasautos2                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib1
  ,i_sasautos3                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib2
  ,i_testdata                 = dat
  ,i_refdata                  = dat
  ,i_doc                      = doc/spec
  ,i_sascfg                   = %sysget(SASUNIT_SAS_CFG)
  ,i_autoexec                 = &AutoexecName2.
  ,i_testcoverage             = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_crossref                 = %sysget(SASUNIT_CROSSREFERENCE)
  ,i_crossrefsasunit          = %sysget(SASUNIT_CROSSREFERENCE_SASUNIT)
  ,i_language                 = %lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_logFolder                = %sysget(SASUNIT_LOG_FOLDER)
  ,i_scnLogFolder             = %sysget(SASUNIT_SCN_LOG_FOLDER)
  ,i_log4SASSuiteLogLevel     = %sysget(SASUNIT_LOGLEVEL)
  ,i_log4SASScenarioLogLevel  = %sysget(SASUNIT_SCN_LOGLEVEL)
  ,i_reportFolder             = %sysget(SASUNIT_REPORT_FOLDER)
  ,i_resourceFolder           = %sysget(SASUNIT_ROOT)/resources
  ,i_OSEncoding               = %sysget(SASUNIT_HOST_ENCODING)
)

%runSASUnit(i_source = %sysget(SASUNIT_TEST_SCENARIO_ROOT)saspgm/test/assert_i_autoexec_usage_configtest.sas);

*** Recreate the old config and autoexec to ensure the right settings ***;
*** if you use SASUnit without overwrite afterwards                   ***;
%initSASUnit(
   i_root                     = %sysget(SASUNIT_PROJECT_ROOT)
  ,io_target                  = %sysget(SASUNIT_TEST_DB_FOLDER)
  ,i_overwrite                = 0
  ,i_project                  = SASUnit Self Test
  ,i_sasunit                  = %sysget(SASUNIT_ROOT)/saspgm/sasunit
  ,i_sasautos                 = %sysget(SASUNIT_AUTOCALL_ROOT)sasunit
  ,i_sasautos1                = %sysget(SASUNIT_AUTOCALL_ROOT)test
  ,i_sasautos2                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib1
  ,i_sasautos3                = %sysget(SASUNIT_TEST_SCENARIO_ROOT)pgmlib2
  ,i_testdata                 = dat
  ,i_refdata                  = dat
  ,i_doc                      = doc/spec
  ,i_sascfg                   = %sysget(SASUNIT_SAS_CFG)
  ,i_autoexec                 = %str( )
  ,i_testcoverage             = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_crossref                 = %sysget(SASUNIT_CROSSREFERENCE)
  ,i_crossrefsasunit          = %sysget(SASUNIT_CROSSREFERENCE_SASUNIT)
  ,i_language                 = %lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_logFolder                = %sysget(SASUNIT_LOG_FOLDER)
  ,i_scnLogFolder             = %sysget(SASUNIT_SCN_LOG_FOLDER)
  ,i_log4SASSuiteLogLevel     = %sysget(SASUNIT_LOGLEVEL)
  ,i_log4SASScenarioLogLevel  = %sysget(SASUNIT_SCN_LOGLEVEL)
  ,i_reportFolder             = %sysget(SASUNIT_REPORT_FOLDER)
  ,i_resourceFolder           = %sysget(SASUNIT_ROOT)/resources
  ,i_OSEncoding               = %sysget(SASUNIT_HOST_ENCODING)
);

%reportSASUnit(
    i_language       =%lowcase(%sysget(SASUNIT_LANGUAGE))
   ,o_html           =1
   ,o_junit          =1
   ,o_pgmdoc         =%sysget(SASUNIT_PGMDOC)
   ,o_pgmdoc_sasunit =%sysget(SASUNIT_PGMDOC_SASUNIT)
);
/** \endcond */
 
