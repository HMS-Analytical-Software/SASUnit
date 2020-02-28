/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _reportJUnitXML.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _reportJUnitXML.sas);

%let workpath=%sysfunc(pathname(WORK));
%let workpath          =%sysfunc(pathname(WORK));
%let w_sasunit_path    =&workpath./saspgm;
%let w_sasunit_os_path =&w_sasunit_path./os;
%let w_macro_path      =&workpath./macro;
%let w_macro2_path     =&workpath./macro2;
%let w_macro3_path     =&workpath./macro3;

data work.exa;
   set target.exa (obs=1);
   exa_id       = 2;
   exa_id+1;
   exa_auton    = 2;
   exa_pgm      = "autocall_macro_1.sas";
   exa_filename = "&w_macro_path./autocall_macro_1.sas";
   exa_path     = "macro/autocall_macro_1.sas";
   output;
   exa_id+1;
   exa_auton    = 3;
   exa_pgm      = "autocall_macro_2.sas";
   exa_filename = "&w_macro2_path./autocall_macro_2.sas";
   exa_path     = "macro2/autocall_macro_2.sas";
   output;
run;

data work.scn;
   set target.scn (obs=1);
   scn_id           = 1;
   scn_path         = "scn/Testscenario_outside_autocall.sas";
   scn_desc         = "Blah Blubb Blubber";
   scn_start        = 0;
   scn_end          = 10;
   scn_changed      = 23;
   scn_rc           = 0;
   scn_errorcount   = scn_id;
   scn_warningcount = scn_id*2;
   output;
   scn_id           = 2;
   scn_path         = "macro2/Testscenario_inside_autocall.sas";
   scn_desc         = "Blah Blubb Blubber";
   scn_start        = 0;
   scn_end          = 10;
   scn_changed      = 23;
   scn_rc           = 2;
   scn_errorcount   = scn_id;
   scn_warningcount = scn_id*2;
   output;
run;

data work.cas;
   set target.cas (obs=1);
   cas_scnid    = 1;
   cas_id       = 1;
   cas_exaid    = 3;
   cas_obj      = "autocall_macro_1.sas";
   cas_desc     = "Test für autocall_macro_1.sas";
   cas_spec     = "";
   cas_start    = 0;
   cas_end      = 1;
   cas_res      = 0;
   output;
   cas_scnid    = 1;
   cas_id       = 2;
   cas_exaid    = 3;
   cas_obj      = "autocall_macro_1.sas";
   cas_desc     = "Test für autocall_macro_1.sas";
   cas_spec     = "";
   cas_start    = 0;
   cas_end      = 1;
   cas_res      = 0;
   output;
   cas_scnid    = 1;
   cas_id       = 3;
   cas_exaid    = 4;
   cas_obj      = "autocall_macro_2.sas";
   cas_desc     = "Test für autocall_macro_2.sas";
   cas_spec     = "";
   cas_start    = 0;
   cas_end      = 1;
   cas_res      = 0;
   output;
   cas_scnid    = 1;
   cas_id       = 4;
   cas_exaid    = 4;
   cas_obj      = "autocall_macro_2.sas";
   cas_desc     = "Test für autocall_macro_2.sas";
   cas_spec     = "";
   cas_start    = 0;
   cas_end      = 1;
   cas_res      = 0;
   output;
   cas_scnid    = 2;
   cas_id       = 1;
   cas_exaid    = 3;
   cas_obj      = "autocall_macro_1.sas";
   cas_desc     = "Test für autocall_macro_1.sas";
   cas_spec     = "";
   cas_start    = 0;
   cas_end      = 1;
   cas_res      = 2;
   output;
   cas_scnid    = 2;
   cas_id       = 2;
   cas_exaid    = 4;
   cas_obj      = "autocall_macro_2.sas";
   cas_desc     = "Test für autocall_macro_2.sas";
   cas_spec     = "";
   cas_start    = 0;
   cas_end      = 1;
   cas_res      = 2;
   output;
run;

data work.tst;
   set target.tst (obs=1);
   tst_scnid    = 1;
   tst_casid    = 1;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 1;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 2;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 2;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 3;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 3;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 4;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 4;
   tst_id       = 3;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 1;
   tst_casid    = 4;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 2;
   tst_casid    = 1;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 0;
   tst_errmsg   = "assert passed";
   output;
   tst_scnid    = 2;
   tst_casid    = 1;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 2;
   tst_errmsg   = "assert failed. Artificial failure";
   output;
   tst_scnid    = 2;
   tst_casid    = 2;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 2;
   tst_errmsg   = "assert failed. Artificial failure";
   output;
   tst_scnid    = 2;
   tst_casid    = 2;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 2;
   tst_errmsg   = "assert failed. Artificial failure";
   output;
run;

data work.tsu;
   set target.tsu;
run;

%_switch();
%_createRepData(d_reporting=work._junit_repdata
               ,d_repexa   =work._junit_repExa
               ); 
%_switch();

%_reportCreateTagset;

%macro testcase(i_object=_reportJUnitXML.sas, i_desc=%str(Call with empty repoting dataset));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   data work._junit_repdata_empty;
      set work._junit_repdata;
      stop;
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_reportJUnitXML(i_repdata = work._junit_repdata_empty
                   ,o_file    = &workpath./junit_file_empty.xml
                   ); 

   %endTestcall()

   /* assert */
   %assertLog    (i_errors  =0
                 ,i_warnings=0);
   %assertReport (i_expected=&g_testdata./junit_file_empty.xml
                 ,i_actual  =&workpath./junit_file_empty.xml
                 ,i_desc    =Junit file for empty reporting dataset
                 );

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_reportJUnitXML.sas, i_desc=%str(Call with passed tests only));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   data work._junit_repdata_ok;
      set work._junit_repdata (where=(scn_id=1));
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_reportJUnitXML(i_repdata = work._junit_repdata_ok
                   ,o_file    = &workpath./junit_xml_ok.xml
                   ); 

   %endTestcall()

   /* assert */
   %assertLog    (i_errors  =0
                 ,i_warnings=0);
   %assertReport (i_expected=&g_testdata./junit_xml_ok.xml
                 ,i_actual  =&workpath./junit_xml_ok.xml
                 ,i_desc    =Junit file for empty reporting dataset
                 );

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_reportJUnitXML.sas, i_desc=%str(Call with failed tests only));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   data work._junit_repdata_err;
      set work._junit_repdata (where=(scn_id=2 AND cas_id=2));
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_reportJUnitXML(i_repdata = work._junit_repdata_err
                   ,o_file    = &workpath./junit_xml_err1.xml
                   ); 

   %endTestcall()

   /* assert */
   %assertLog    (i_errors  =0
                 ,i_warnings=0);
   %assertReport (i_expected=&g_testdata./junit_xml_err1.xml
                 ,i_actual  =&workpath./junit_xml_err1.xml
                 ,i_desc    =Junit file for empty reporting dataset
                 );

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_reportJUnitXML.sas, i_desc=%str(Call with mixed scenario));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   data work._junit_repdata_err;
      set work._junit_repdata (where=(scn_id=2));
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_reportJUnitXML(i_repdata = work._junit_repdata_err
                   ,o_file    = &workpath./junit_xml_err2.xml
                   ); 

   %endTestcall()

   /* assert */
   %assertLog    (i_errors  =0
                 ,i_warnings=0);
   %assertReport (i_expected=&g_testdata./junit_xml_err2.xml
                 ,i_actual  =&workpath./junit_xml_err2.xml
                 ,i_desc    =Junit file for empty reporting dataset
                 );

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_reportJUnitXML.sas, i_desc=%str(Call with more than one scenario));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* setup environment for test call */
   data work._junit_repdata;
      set work._junit_repdata;
   run;

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.)

   /* call */
   %_reportJUnitXML(i_repdata = work._junit_repdata
                   ,o_file    = &workpath./junit_xml_mixed.xml
                   ); 

   %endTestcall()

   /* assert */
   %assertLog    (i_errors  =0
                 ,i_warnings=0);
   %assertReport (i_expected=&g_testdata./junit_xml_mixed.xml
                 ,i_actual  =&workpath./junit_xml_mixed.xml
                 ,i_desc    =Junit file for empty reporting dataset
                 );

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

proc datasets lib=work nolist;
   delete
      tsu
      exa
      scn
      cas
      tst
      _junit_repdata_empty
      _junit_repdata_ok
      _junit_repdata_err
      _junit_repdata_err
   ;
run;quit;
%endScenario ();
/** \endcond */
