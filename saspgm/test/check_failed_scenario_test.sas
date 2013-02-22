/**
   \file
   \ingroup    SASUNIT_TEST 
   \brief      Testcall for scenario with error only in scenario log - has to fail!
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/ /** \cond */ 

/* change log
   14.02.2013 KL Created
*/ 

data test;
   set work.class;
run;

/*-- first call: Everthing is ok ------------------------------------*/
%initTestcase(i_object=reportsasunit.sas, i_desc=Correct assert)
%endTestcall()
%assertLog(i_errors=0, i_warnings=0, i_desc=everything is OK)
%endTestcase()
