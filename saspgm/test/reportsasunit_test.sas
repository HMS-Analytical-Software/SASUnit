/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of reportSASUnit.sas - has to fail! 2 errors (subsequent, dealing with positional parameters)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 


%initScenario(i_desc=%str(Test of reportSASUnit.sas - has to fail! 2 errors %(subsequent, dealing with positional parameters%)));

%let workpath =%sysfunc(pathname(WORK));
%let rc       =%sysfunc (dcreate(rep, &workpath.));

data work.tsu;
   set refdata.empty_test_db_tsu;
run;
data work.exa;
   set refdata.empty_test_db_exa;
run;
data work.scn;
   set refdata.empty_test_db_scn;
run;
data work.cas;
   set refdata.empty_test_db_cas;
run;
data work.tst;
   set refdata.empty_test_db_tst;
run;

%*** MockUp ***;
%MACRO _reportPgmDoc(i_language      =
                    ,i_repdata       =
                    ,o_html          =
                    ,o_pdf           =
                    ,o_path          =
                    ,o_pgmdoc_sasunit=
                    ,i_style         =
                    );

   %PUT NOTE(SASUNIT):---->Doing _repoprtPgmDoc;
%MEND;


%macro testcase(i_object=runsasunit.sas, i_desc=%str(Call without any scenarios in runSASUnit));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)
   %_switch();
   /* call */
   %reportSASUnit(o_output         =&workpath.);
   %_switch();
   %endTestcall()

   /* assert */
   %assertLog(i_errors=0, i_warnings=0);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%endScenario();

/*%Macro reportsasunit_test;*/
/**/
/*/* test case start ------------------------------------ */*/
/*%initTestcase(*/
/*    i_object = reportSASUnit.sas,*/
/*   ,i_desc   = %STR(Syntax error in macro call, test case will not be shown in the report)*/
/*);*/
/**/
/*data _null_;*/
/*   put 'dummy unit under test executing';*/
/*run;*/
/**/
/*%endTestcall;*/
/**/
/*%assertLog (i_errors=0, i_warnings=0);*/
/**/
/*%endTestcase;*/
/**/
/**/
/*/* test case start ------------------------------------ */*/
/*%initTestcase(*/
/*    i_object = reportSASUnit.sas*/
/*   ,i_desc   = %STR(dummy test case, must be shown in the report as OK (scenario contains other test with syntax errors))*/
/*);*/
/**/
/*data _null_;*/
/*   put 'dummy unit under test executing';*/
/*run;*/
/**/
/*%endTestcall;*/
/**/
/*%assertLog (i_errors=0, i_warnings=0);*/
/**/
/*%endTestcase;*/
/**/
/*%Mend reportsasunit_test;*/
/*%reportsasunit_test*/

/** \endcond */
