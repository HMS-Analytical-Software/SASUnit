/** \file
   \ingroup    SASUNIT_TESTS 

   \brief      Aufruf der Basis-Testszenarien

   \version    \$Revision: 50 $
   \author     \$Author: mangold $
   \date       \$Date: 2009-07-16 10:29:18 +0200 (Do, 16 Jul 2009) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/test/run_all.sas $

*/ /** \cond */ 

OPTIONS MPRINT MAUTOSOURCE SASAUTOS=(SASAUTOS "c:\projekte\sasunit.903\saspgm\sasunit");

%initSASUnit(
   i_root       = c:\projekte\sasunit.903
  ,io_target    = doc\sasunit
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

%runSASUnit(i_source = %str(saspgm/test/%str(*)_test.sas));

%reportSASUnit();

/** \endcond */

