/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Invocation of the basic test scenarios

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

OPTIONS MPRINT MAUTOSOURCE SASAUTOS=(SASAUTOS "%trim(%sysget(SASUNIT_ROOT))/saspgm/sasunit");
%LET SASUNIT_VERBOSE=1;
proc options option=logparm;run;

%initSASUnit(
   i_root         = %sysget(SASUNIT_ROOT)
  ,io_target      = doc/sasunit/%lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_overwrite    = %sysget(SASUNIT_OVERWRITE)
  ,i_project      = SASUnit Self Test
  ,i_sasunit      = saspgm/sasunit
  ,i_sasautos     = saspgm/sasunit
  ,i_sasautos1    = saspgm/test
  ,i_sasautos2    = saspgm/test/pgmlib1
  ,i_sasautos3    = saspgm/test/pgmlib2
  ,i_testdata     = dat
  ,i_refdata      = dat
  ,i_doc          = doc/spec
  ,i_sascfg       = bin/sasunit.%sysget(SASUNIT_SAS_VERSION).%lowcase(%sysget(SASUNIT_HOST_OS)).%lowcase(%sysget(SASUNIT_LANGUAGE)).cfg
  ,i_testcoverage = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_verbose      = &SASUNIT_VERBOSE.
);

%runSASUnit(i_source = %str(saspgm/test/reportsasunit_inexisting_scenario_has_to_fail));
%runSASUnit(i_source = %str(saspgm/test/%str(*)_test.sas));

/* To check different config and autoexec files there will be additional calls   */
/* of initSASUnit and runSASUnit.                                                */
/* First of all there will be created a new config file with a separate option   */
/* for autoexec. Then a separate autoexec file is created.                       */
/* To ensure the use of these files there will be set a macro variable different */
/* In each autoexec file and tested in special testcases.                        */

%let ConfigName   =%sysfunc (pathname(work))/config_for_testing.cfg;
%let AutoexecName1=%sysfunc (pathname(work))/autoexec_for_config_test.sas;
%let AutoexecName2=%sysfunc (pathname(work))/autoexec_for_autoexec_test.sas;

data _null_;
   file "&ConfigName.";
   infile "%sysget(SASUNIT_ROOT)/bin/sasunit.%sysget(SASUNIT_SAS_VERSION).%lowcase(%sysget(SASUNIT_HOST_OS)).%lowcase(%sysget(SASUNIT_LANGUAGE)).cfg" end=eof;
   input;
   put _INFILE_;
   if (eof) then do;
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
   i_root         = %sysget(SASUNIT_ROOT)
  ,io_target      = doc/sasunit/%lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_overwrite    = 0
  ,i_project      = SASUnit Self Test
  ,i_sasunit      = saspgm/sasunit
  ,i_sasautos     = saspgm/sasunit
  ,i_sasautos1    = saspgm/test
  ,i_sasautos2    = saspgm/test/pgmlib1
  ,i_sasautos3    = saspgm/test/pgmlib2
  ,i_testdata     = dat
  ,i_refdata      = dat
  ,i_doc          = doc/spec
  ,i_sascfg       = &ConfigName.
  ,i_testcoverage = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_verbose      = &SASUNIT_VERBOSE.
)

%runSASUnit(i_source = saspgm/test/assert_i_config_usage_configtest.sas);

%initSASUnit(
   i_root         = %sysget(SASUNIT_ROOT)
  ,io_target      = doc/sasunit/%lowcase(%cmpres(%sysget(SASUNIT_LANGUAGE)))
  ,i_overwrite    = 0
  ,i_project      = SASUnit Self Test
  ,i_sasunit      = saspgm/sasunit
  ,i_sasautos     = saspgm/sasunit
  ,i_sasautos1    = saspgm/test
  ,i_sasautos2    = saspgm/test/pgmlib1
  ,i_sasautos3    = saspgm/test/pgmlib2
  ,i_testdata     = dat
  ,i_refdata      = dat
  ,i_doc          = doc/spec
  ,i_sascfg       = bin/sasunit.%sysget(SASUNIT_SAS_VERSION).%lowcase(%sysget(SASUNIT_HOST_OS)).%lowcase(%sysget(SASUNIT_LANGUAGE)).cfg
  ,i_autoexec     = &AutoexecName2.
  ,i_testcoverage = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_verbose      = &SASUNIT_VERBOSE.
)

%runSASUnit(i_source = saspgm/test/assert_i_autoexec_usage_configtest.sas);

*** Recreate the old config and autoexec to ensure the right settings ***;
*** if you use SASUnit without overwrite afterwards                   ***;
%initSASUnit(
   i_root         = %sysget(SASUNIT_ROOT)
  ,io_target      = doc/sasunit/%lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_overwrite    = 0
  ,i_project      = SASUnit Self Test
  ,i_sasunit      = saspgm/sasunit
  ,i_sasautos     = saspgm/sasunit
  ,i_sasautos1    = saspgm/test
  ,i_sasautos2    = saspgm/test/pgmlib1
  ,i_sasautos3    = saspgm/test/pgmlib2
  ,i_testdata     = dat
  ,i_refdata      = dat
  ,i_doc          = doc/spec
  ,i_sascfg       = bin/sasunit.%sysget(SASUNIT_SAS_VERSION).%lowcase(%sysget(SASUNIT_HOST_OS)).%lowcase(%sysget(SASUNIT_LANGUAGE)).cfg
  ,i_autoexec     = %str( )
  ,i_testcoverage = %sysget(SASUNIT_COVERAGEASSESSMENT)
  ,i_verbose      = &SASUNIT_VERBOSE.
);

%reportSASUnit(
    i_language=%upcase(%sysget(SASUNIT_LANGUAGE))
   ,o_html    =1
   ,o_junit   =1
);

/** \endcond */
