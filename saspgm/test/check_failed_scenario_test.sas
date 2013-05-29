/**
   \file
   \ingroup    SASUNIT_TEST 
   \brief      Testcall for scenario with error only in scenario log - has to fail!
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

data test;
   set work.class;
run;

/*-- first call: Everthing is ok ------------------------------------*/
%initTestcase(i_object=reportsasunit.sas, i_desc=Correct assert)
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc=everything is OK)
%endTestcase()
