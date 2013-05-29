/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for reportsasunit.sas - has to fail! 5 subsequent errors dealing with missing call of initTestcase.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

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
   ,i_desc   = %STR(dummy test case, must be shown in the report as OK (scenario contains other test with syntax errors))
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
