/** 
   \file
   \ingroup    SASUNIT_TESTS 

   \brief      Invocation of the basic test scenarios

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

OPTIONS MPRINT MAUTOSOURCE SASAUTOS=(SASAUTOS "c:/projects/sasunit/saspgm/sasunit");
proc options option=logparm;run;

%initSASUnit(
   i_root       = c:/projects/sasunit
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

%runSASUnit(i_source = %str(saspgm/test/%str(*)_test.sas));

%reportSASUnit();

/** \endcond */

