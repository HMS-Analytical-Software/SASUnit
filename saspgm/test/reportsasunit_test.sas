/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for reportsasunit.sas, has to fail! 5 subsequent errors dealing with missing call of initTestcase.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
*/ /** \cond */ 

/* change log 
   08.01.2013 BB  Error Description added to \brief
*/ 
%Macro reportsasunit_test;

/* test case start ------------------------------------ */
%initTestcase(
    i_object = reportsasunit.sas,
   ,i_desc   = %STR(Syntax error in macro call, test case will not be shown in the report)
);

data _null_;
   put 'dummy unit under test executing';
run;

%endTestcall;

%assertLog (i_errors=0, i_warnings=0);

%endTestcase;


/* test case start ------------------------------------ */
%initTestcase(
    i_object = reportsasunit.sas
   ,i_desc   = %STR(Dummy test case, must be shown in the report as OK (scenario contains other test with syntax errors))
);

data _null_;
   put 'dummy unit under test executing';
run;

%endTestcall;

%assertLog (i_errors=0, i_warnings=0);

%endTestcase;

%Mend reportsasunit_test;
%reportsasunit_test;
/** \endcond */
