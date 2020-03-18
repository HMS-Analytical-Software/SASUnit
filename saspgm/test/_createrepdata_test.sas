/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createRepData.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _createRepData.sas);

%let workpath          =%sysfunc(pathname(WORK));
%let w_sasunit_path    =&workpath./saspgm;
%let w_sasunit_os_path =&w_sasunit_path./os;
%let w_macro_path      =&workpath./macro;
%let w_macro2_path     =&workpath./macro2;
%let w_macro3_path     =&workpath./macro3;

data work.exa;
   set target.exa (obs=1);
   exa_id       = 0;
   exa_id+1;
   exa_auton    = 0;
   exa_pgm      = "SASUnit_Marco.sas";
   exa_filename = "&w_sasunit_path./SASUnit_Macro.sas";
   exa_path     = "saspgm/SASUnit_Marco.sas";
   output;
   exa_id+1;
   exa_auton    = 1;
   exa_pgm      = "SASUnit_OS_Marco.sas";
   exa_filename = "&w_sasunit_os_path./SASUnit_OS_Macro.sas";
   exa_path     = "saspgm/os/SASUnit_OS_Marco.sas";
   output;
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
   exa_id+1;
   exa_auton    = 3;
   exa_pgm      = "Testscenario_inside_autocall.sas";
   exa_filename = "&w_macro2_path./Testscenario_inside_autocall.sas";
   exa_path     = "macro2/Testscenario_inside_autocall.sas";
   output;
   exa_id+1;
   exa_auton    = .;
   exa_pgm      = "macro_outside_autocall.sas";
   exa_filename = "&w_macro3_path./macro_outside_autocall.sas";
   exa_path     = "macro3/macro_outside_autocall.sas";
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
   scn_rc           = 0;
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
   cas_res      = 0;
   output;
   cas_scnid    = 2;
   cas_id       = 2;
   cas_exaid    = 4;
   cas_obj      = "autocall_macro_2.sas";
   cas_desc     = "Test für autocall_macro_2.sas";
   cas_spec     = "";
   cas_start    = 0;
   cas_end      = 1;
   cas_res      = 0;
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
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 1;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 2;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 2;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 3;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 3;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 4;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 4;
   tst_id       = 3;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 1;
   tst_casid    = 4;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 2;
   tst_casid    = 1;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 2;
   tst_casid    = 1;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 2;
   tst_casid    = 2;
   tst_id       = 1;
   tst_type     = "assertLog";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
   tst_scnid    = 2;
   tst_casid    = 2;
   tst_id       = 2;
   tst_type     = "assertLogMsg";
   tst_desc     = "Test für egal was";
   txt_exp      = "0#0";
   tst_act      = "0#1";
   tst_res      = 1;
   tst_errmsg   = "Denk Dir was schönes aus ;)";
   output;
run;

data work.tsu;
   set target.tsu;
run;

%initTestcase(i_object=_createRepData.sas, i_desc=Test with correct call);

%_switch();
%_createRepData(d_reporting=work._myReportingDataset
               ,d_repexa   =work._myExaDataset
               );
%_switch();

%endTestcall;

%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 13
                  ,i_where          = 1
                  ,i_desc           = Total number of observations
                  );

%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 4
                  ,i_where          = scn_id=1 AND tst_id=1
                  ,i_desc           = Four test cases for scenario 1
                  );
%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 2
                  ,i_where          = scn_id=2 AND tst_id=1
                  ,i_desc           = Two test cases for scenario 2
                  );

%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 2
                  ,i_where          = scn_id=1 AND cas_id=1
                  ,i_desc           = Two asserts for scenario 1 test case 1
                  );
%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 2
                  ,i_where          = scn_id=1 AND cas_id=2
                  ,i_desc           = Two asserts for scenario 1 test case 2
                  );
%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 2
                  ,i_where          = scn_id=1 AND cas_id=3
                  ,i_desc           = Two asserts for scenario 1 test case 3
                  );
%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 3
                  ,i_where          = scn_id=1 AND cas_id=4
                  ,i_desc           = Two asserts for scenario 1 test case 4
                  );
%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 2
                  ,i_where          = scn_id=2 AND cas_id=1
                  ,i_desc           = Two asserts for scenario 2 test case 1
                  );
%assertRecordCount(i_libref         = work
                  ,i_memname        = _myReportingDataset
                  ,i_operator       = EQ
                  ,i_recordsExp     = 2
                  ,i_where          = scn_id=2 AND cas_id=2
                  ,i_desc           = Two asserts for scenario 2 test case 2
                  );
%endTestcase;

proc datasets lib=work nolist;
   delete
      tsu
      exa
      scn
      cas
      tst
      _myReportingDataSet
   ;
   
%endScenario();
/** \endcond */