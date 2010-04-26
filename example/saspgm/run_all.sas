/**
\file
\ingroup    SASUNIT_EXAMPLES_TEST

\brief      Run all test scenarios for SASUnit example project

            (see also _sasunit_doc.sas)
            Initialize SASUnit (open test repository or create when needed) with initSASUnit.sas
            - set project name
            - set root path for convenience (all other paths can be relative to root path)
            - set paths for SASUnit macro library, test repository, units under test, test data, reference data

            Run all test scenarios in folder example\saspgm (suffix _test.sas) with runSASUnit.sas where
            the test scenario or the unit under test has been changed since previous run.            

            Create or recreate necessary HTML pages in the test report with reportSASUnit.sas.
            
\version    \$Revision: 38 $
\author     \$Author: mangold $
\date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
\sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/example/saspgm/run_all.sas $
*/ /** \cond */ 

OPTIONS 
   MPRINT MAUTOSOURCE 
   SASAUTOS=(SASAUTOS "c:\projekte\sasunit\saspgm\sasunit") /* SASUnit macro library */
;

/* open test repository or create when needed */
%initSASUnit(
   i_root       = c:\projekte\sasunit /* root path, all other paths can then be relative paths */
  ,io_target    = example\doc\sasunit /* Output of SASUnit: test repository, logs, results, reports */
  ,i_overwrite  = 0                   /* set to 1 to force all test scenarios to be run, else only changed 
                                         scenarios or scenarios with changed unit under test will be run*/
  ,i_project    = SASUnit Examples    /* Name of project, for report */
  ,i_sasunit    = saspgm\sasunit      /* SASUnit macro library */
  ,i_sasautos   = example\saspgm      /* Search for units under test here */
  ,i_testdata   = example\dat         /* test data, libref testdata */
  ,i_refdata    = example\dat         /* reference data, libref refdata */
)

/* Run specified test scenarios. There can be more than one call to runSASUnit */
%runSASUnit(i_source = example\saspgm\*_test.sas)

/* Create or recreate HTML pages for report where needed */
%reportSASUnit()

/** \endcond */
