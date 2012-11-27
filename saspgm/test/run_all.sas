/** 
   \file
   \ingroup    SASUNIT_TESTS 

   \brief      Invocation of the basic test scenarios

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

/* History
   30.08.2012 KL  Values for rootpath of SASUnit, language and overwrite are taken over from OS-Variables.
                  So there is no need to change run_all for operating systems or languages
   10.10.2010 AM  Neuerstellung 
*/ 

OPTIONS MPRINT MAUTOSOURCE SASAUTOS=(SASAUTOS "%sysget(SASUNIT_ROOT)/saspgm/sasunit");
proc options option=logparm;run;

%initSASUnit(
   i_root       = %sysget(SASUNIT_ROOT)
  ,io_target    = doc/sasunit/%lowcase(%sysget(SASUNIT_LANGUAGE))
  ,i_overwrite  = %sysget(SASUNIT_OVERWRITE)
  ,i_project    = SASUnit
  ,i_sasunit    = saspgm/sasunit
  ,i_sasautos   = saspgm/sasunit
  ,i_sasautos1  = saspgm/test
  ,i_sasautos2  = saspgm/test/pgmlib1
  ,i_sasautos3  = saspgm/test/pgmlib2
  ,i_testdata   = dat
  ,i_refdata    = dat
  ,i_doc        = doc/spec
  ,i_sascfg     = bin/sasunit.%sysget(SASUNIT_SAS_VERSION).%lowcase(%sysget(SASUNIT_HOST_OS)).%lowcase(%sysget(SASUNIT_LANGUAGE)).cfg
)

%runSASUnit(i_source = %str(saspgm/test/reportsasunit_inexisting_scenario_has_to_fail));
%runSASUnit(i_source = %str(saspgm/test/%str(*)_test.sas));

%reportSASUnit(
   i_language=%upcase(%sysget(SASUNIT_LANGUAGE))
);

/** \endcond */

