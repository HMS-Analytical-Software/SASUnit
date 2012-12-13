/** 
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for use of config file

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ 
/** \cond */ 

/* test case 1 ------------------------------------*/
%initTestcase(i_object=_dummy_macro.sas, i_desc=special config should be used);

proc options;
run;

%endTestcall()

%assertEquals (i_expected=Test for i_config, i_actual=&HUGO, i_desc=must be equal);
%assertLogMsg (i_logMsg  =config_for_testing.cfg);
%assertLogMsg (i_logMsg  =autoexec_for_config_test.sas);

%assertLog (i_errors=0, i_warnings=0)

%endTestcase()

/** \endcond */ 
