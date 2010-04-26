/** 
   \file
   \ingroup    SASUNIT_TESTS 

   \brief      Invocation of the basic test scenarios

   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/test/run_all.sas $

*/

/*DE
   \file
   \ingroup    SASUNIT_TESTS 

   \brief      Aufruf der Basis-Testszenarien

   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/test/run_all.sas $

*/ /** \cond */ 

OPTIONS MPRINT MAUTOSOURCE SASAUTOS=(SASAUTOS "c:\projekte\sasunit\saspgm\sasunit");

%initSASUnit(
   i_root       = c:\projekte\sasunit
  ,io_target    = doc\sasunit
  ,i_overwrite  = 0
  ,i_project    = SASUnit
  ,i_sasunit    = saspgm\sasunit
  ,i_sasautos   = saspgm\sasunit
  ,i_sasautos1  = saspgm\test
  ,i_sasautos2  = saspgm\test\pgmlib1
  ,i_sasautos3  = saspgm\test\pgmlib2
  ,i_testdata   = dat
  ,i_refdata    = dat
  ,i_doc        = doc\spec
)

%runSASUnit(i_source = saspgm\test\*_test.sas);

%reportSASUnit();

/** \endcond */

