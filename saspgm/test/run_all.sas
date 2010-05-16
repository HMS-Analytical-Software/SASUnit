/** 
   \file
   \ingroup    SASUNIT_TESTS 

   \brief      Invocation of the basic test scenarios

   \version    \$Revision: 57 $
   \author     \$Author: mangold $
   \date       \$Date: 2010-05-16 14:51:20 +0200 (So, 16 Mai 2010) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/run_all.sas $

*/

/*DE
   \file
   \ingroup    SASUNIT_TESTS 

   \brief      Aufruf der Basis-Testszenarien

*/ /** \cond */ 

OPTIONS MPRINT MAUTOSOURCE SASAUTOS=(SASAUTOS "c:/projekte/sasunit/saspgm/sasunit");
proc options option=logparm;run;

%initSASUnit(
   i_root       = c:/projekte/sasunit
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

