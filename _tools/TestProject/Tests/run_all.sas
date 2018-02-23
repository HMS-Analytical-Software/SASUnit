/**
   \file
   \ingroup    SASUNIT_TP_TEST

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

*/ /** \cond */  

OPTIONS 
   MPRINT MAUTOSOURCE NOMLOGIC NOSYMBOLGEN
   APPEND=(SASAUTOS "%sysget(SASUNIT_ROOT)/saspgm/sasunit") /* SASUnit macro library */
;

%LET SASUNIT_VERBOSE=1;
%LET SASUNIT_CROSSREF=1;
%LET SASUNIT_CROSSREFSASUNIT=1;

proc options option=logparm;run;

%initSASUnit(
   i_root            = %sysget(SASUNIT_ROOT)\_tools\TestProject           /* root path, all other paths can then be relative paths */
  ,io_target         = doc/sasunit/%lowcase(%sysget(SASUNIT_LANGUAGE))  /* Output of SASUnit: test repository, logs, results, reports */
  ,i_overwrite       = %sysget(SASUNIT_OVERWRITE)                       /* set to 1 to force all test scenarios to be run, else only changed 
                                                                           scenarios or scenarios with changed unit under test will be run*/
  ,i_project         = SASUnit Testproject                              /* Name of project, for report */
  ,i_sasunit         = %sysget(SASUNIT_ROOT)/saspgm/sasunit             /* SASUnit macro library */
  ,i_sasautos        = saspgm01                                         /* Search for units under test here */
  ,i_sasautos1       = saspgm02                                         /* Search for units under test here */
  ,i_sasautos2       = saspgm03                                         /* Search for units under test here */
  ,i_sasautos3       = saspgm04                                         /* Search for units under test here */
  ,i_sasautos4       = saspgm05                                         /* Search for units under test here */
  ,i_sasautos5       = saspgm06                                         /* Search for units under test here */
  ,i_sasautos6       = saspgm07                                         /* Search for units under test here */
  ,i_sasautos7       = saspgm08                                         /* Search for units under test here */
  ,i_sasautos8       = saspgm09                                         /* Search for units under test here */
  ,i_sasautos9       = saspgm10                                         /* Search for units under test here */
  ,i_sasautos10      = saspgm11                                         /* Search for units under test here */
  ,i_sasautos11      = saspgm12                                         /* Search for units under test here */
  ,i_sasautos12      = saspgm13                                         /* Search for units under test here */
  ,i_testdata        = dat                                              /* test data, libref testdata */
  ,i_refdata         = dat                                              /* reference data, libref refdata */
  ,i_doc             = doc/spec
  ,i_sascfg          = bin/sasunit.%sysget(SASUNIT_SAS_VERSION).%lowcase(%sysget(SASUNIT_HOST_OS)).%lowcase(%sysget(SASUNIT_LANGUAGE)).cfg
  ,i_testcoverage    = %sysget(SASUNIT_COVERAGEASSESSMENT)              /* set to 1 to assess test coverage assessment */
  ,i_verbose         = &SASUNIT_VERBOSE.
  ,i_crossref        = &SASUNIT_CROSSREF.
  ,i_crossrefsasunit = &SASUNIT_CROSSREFSASUNIT.
  ,i_language        = %lowcase(%sysget(SASUNIT_LANGUAGE))
  )

/* Run specified test scenarios. There can be more than one call to runSASUnit */
%runSASUnit(i_source = Tests/%str(*)_test.sas);

/* Create or recreate HTML pages for report where needed */
%reportSASUnit(
   i_language =%lowcase(%sysget(SASUNIT_LANGUAGE))
  ,o_html     =1
  ,o_junit    =1
  ,o_pgmdoc   =%sysget(SASUNIT_PGMDOC)
);

/** \endcond */

