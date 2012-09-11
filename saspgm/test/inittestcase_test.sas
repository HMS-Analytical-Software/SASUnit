/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for inittestcase.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
*/ /** \cond */ 

%Macro inittestcase_test;

/* test case start ------------------------------------ */
%initTestcase(
    i_object = inittestcase.sas,
   ,i_desc   = %STR(Syntax error in macro call, test case must be reported with error)
);

data _null_;
   put 'dummy unit under test executing';
run;

%endTestcall;

%assertLog (i_errors=0, i_warnings=0);

%endTestcase;


/* test case start ------------------------------------ */
%initTestcase(
    i_object = inittestcase.sas
   ,i_desc   = %STR(Test case must execute as second test)
);

data _null_;
   put 'dummy unit under test executing';
run;

%endTestcall;

%assertLog (i_errors=0, i_warnings=0);

%LOCAL
   l_casid
;
PROC SQL NOPRINT;
   SELECT max(cas_id) INTO :l_casid FROM target.cas
   WHERE cas_scnid = &g_scnid.;
QUIT;

%assertEquals (
    i_expected = 2
   ,i_actual   = &l_casid.
   ,i_desc     = %STR(test case number must be 2)
);

%endTestcase;

%Mend inittestcase_test;
%inittestcase_test;
/** \endcond */
