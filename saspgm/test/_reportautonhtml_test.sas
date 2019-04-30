/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _reportAutonHTML.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 


%initScenario(i_desc=%str(Test of _reportAutonHTML.sas));

%let workpath =%sysfunc(pathname(WORK));
%let rc       =%sysfunc (dcreate(rep, &workpath.));

%let G_REVISION  =N.N.N;
%let G_VERSION   =NNN;

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

%_switch();
%_createRepData(d_reporting=work._testRep);
%_switch();

%_reportCreateFormats;

%macro testcase(i_object=_reportAutonHTML.sas, i_desc=%str(Call without html, pgmdoc, crossref and test coverage));
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
   
   ods listing close;
   %_opendummyhtmlpage(DEFAULT);

   /* call */
   %_reportAutonHTML (i_repdata     =work._testRep
                     ,o_html        =0
                     ,o_path        =&workpath./rep
                     ,o_file        =test_auton_1
                     ,o_pgmdoc      =0
                     ,o_crossref    =0
                     ,o_testcoverage=0
                     ,i_style       =SASUnit
                     );
   %endTestcall()
   
   ods listing;

   /* assert */
   %assertLog (i_errors=0, i_warnings=0);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_reportAutonHTML.sas, i_desc=%str(Call with pgmdoc, without html, crossref and test coverage));
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

   ods listing close;
   %_opendummyhtmlpage(DEFAULT);

   /* call */
   %_reportAutonHTML (i_repdata     =work._testRep
                     ,o_html        =0
                     ,o_path        =&workpath./rep
                     ,o_file        =test_auton_2
                     ,o_pgmdoc      =1
                     ,o_crossref    =0
                     ,o_testcoverage=0
                     ,i_style       =SASUnit
                     );
   %endTestcall()

   ods listing;

   /* assert */
   %assertLog (i_errors=0, i_warnings=0);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_reportAutonHTML.sas, i_desc=%str(Call with pgmdoc, crossref, without html, test coverage));
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

   ods listing close;
   %_opendummyhtmlpage(DEFAULT);

   /* call */
   %_switch();
   %_reportAutonHTML (i_repdata     =work._testRep
                     ,o_html        =0
                     ,o_path        =&workpath./rep
                     ,o_file        =test_auton_3
                     ,o_pgmdoc      =1
                     ,o_crossref    =1
                     ,o_testcoverage=0
                     ,i_style       =SASUnit
                     );
   %_switch();
   %endTestcall()

   ods listing;

   /* assert */
   %assertLog (i_errors=0, i_warnings=0);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_reportAutonHTML.sas, i_desc=%str(Call with pgmdoc, crossref, test coverage, without html));
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

   ods listing close;
   %_opendummyhtmlpage(DEFAULT);

   /* call */
   %_switch();
   %_reportAutonHTML (i_repdata     =work._testRep
                     ,o_html        =0
                     ,o_path        =&workpath./rep
                     ,o_file        =test_auton_4
                     ,o_pgmdoc      =1
                     ,o_crossref    =1
                     ,o_testcoverage=1
                     ,i_style       =SASUnit
                     );
   %_switch();
   %endTestcall()

   ods listing;

   /* assert */
   %assertLog (i_errors  =0, i_warnings=0);
   
   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;


proc datasets lib=work nolist;
   delete _testRep;
run;quit;

%endScenario();
/** \endcond */
