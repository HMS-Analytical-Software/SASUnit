/** 
   \file
   \ingroup    SASUNIT_TESTS 

   \brief      Invocation of the basic test scenarios

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

OPTIONS MPRINT MAUTOSOURCE SASAUTOS=(SASAUTOS "/home/mangold/sasunit/saspgm/sasunit");
proc options option=logparm;run;

%initSASUnit(
   i_root       = /home/mangold/sasunit
  ,io_target    = doc/sasunit
  ,i_overwrite  = 0
  ,i_project    = SASUnit
  ,i_sasunit    = saspgm/sasunit
  ,i_sasautos   = saspgm/sasunit
  ,i_sasautos1  = saspgm/test
  ,i_sasautos2  = saspgm/test/pgmlib1
  ,i_sasautos3  = saspgm/test/pgmlib2
  ,i_testdata   = dat
  ,i_refdata    = dat
  ,i_doc        = doc/spec
)

/* Note: Due to an error in SAS 9.2 M0, scenario selection by wildcards is deactivated in this release */
%*runSASUnit(i_source = %str(saspgm/test/%str(*)_test.sas));

%runSASUnit(i_source = saspgm/test/_sasunit_abspath_test.sas);
%runSASUnit(i_source = saspgm/test/_sasunit_checkszenario_test.sas);
%runSASUnit(i_source = saspgm/test/_sasunit_dir_test.sas);
%runSASUnit(i_source = saspgm/test/_sasunit_existdir_test.sas);
%runSASUnit(i_source = saspgm/test/_sasunit_nobs_test.sas);
%runSASUnit(i_source = saspgm/test/assertcolumns_test.sas);
%runSASUnit(i_source = saspgm/test/assertequals_test.sas);
%runSASUnit(i_source = saspgm/test/assertlibrary_test.sas);
%runSASUnit(i_source = saspgm/test/assertreport_test.sas);
%runSASUnit(i_source = saspgm/test/tree1_test.sas);
%runSASUnit(i_source = saspgm/test/tree2_test.sas);

%reportSASUnit();

/** \endcond */

