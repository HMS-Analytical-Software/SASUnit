/**
   \file
   \ingroup    SASUNIT_TEST 
   \brief      Testcall for scenario with error only in scenario log - has to fail! 1 error (file WORK.CLASS.DATA does not exist)
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 
%initScenario (i_desc=%str(Testcall for scenario with error only in scenario log - has to fail! 1 error %(file WORK.CLASS.DATA does not exist%)))

data test;
   set work.class;
run;

/*-- first call: Everthing is ok ------------------------------------*/
%initTestcase(i_object=reportSASUnit.sas, i_desc=Correct assert)
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc=everything is OK)
%endTestcase()

%endScenario();
/** \endcond */