/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertLog.sas

   \version    \$Revision: 642 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-03-26 07:51:01 +0100 (Di, 26 Mrz 2019) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/assertcolumns_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario(i_desc =Test of assertLog.sas);

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%let l_filename_wo_e = %sysfunc(pathname(work))/file_with_string_error.txt;
data _NULL_;
   file "&l_filename_wo_e.";
   put "PUT &G_ERROR.: This error will not be counted";
   put "    &G_ERROR.: This error will not be counted";
run;
%let l_filename_w_e = %sysfunc(pathname(work))/file_with_error.txt;
data _NULL_;
   file "&l_filename_w_e.";
   put "PUT &G_ERROR.: This error will not be counted";
   put "&G_ERROR.: This error will be counted";
run;
%let l_filename_wo_w = %sysfunc(pathname(work))/file_with_string_warning.txt;
data _NULL_;
   file "&l_filename_wo_w.";
   put "PUT &G_WARNING.: This warning will not be issued";
   put " &G_WARNING.: This warning will not be issued";
run;
%let l_filename_w_w = %sysfunc(pathname(work))/file_with_warning.txt;
data _NULL_;
   file "&l_filename_w_w.";
   put "PUT &G_WARNING.: This warning will not be counted";
   put "&G_WARNING.: This warning will be counted";
run;
%let l_filename_w_e_w = %sysfunc(pathname(work))/file_with_2warnings_3erros.txt;
data _NULL_;
   file "&l_filename_w_e_w.";
   put "PUT &G_WARNING.: This warning will not be counted";
   put "&G_WARNING.: This warning will be counted";
   put "&G_WARNING.: This warning will be counted";
   put "PUT &G_ERROR.: This error will not be counted";
   put "&G_ERROR.: This error will be counted";
   put "&G_ERROR.: This error will be counted";
   put "&G_ERROR.: This error will be counted";
run;

%initTestcase(i_object=assertLog.sas, i_desc=reading log file without errors)
%endTestcall()
%assertLog(i_errors  =0
          ,i_warnings=0
          ,i_logfile =&G_TESTDATA./_checklog_t03_input.log
          ,i_desc    =log file is error free
          )
   %markTest();
      %assertDBValue(tst,type,assertLog)
      %assertDBValue(tst,exp,0#0)
      %assertDBValue(tst,act,0#0)
      %assertDBValue(tst,res,0)
%assertLog(i_errors  =0
          ,i_warnings=0
          ,i_logfile =&l_filename_wo_e.
          ,i_desc    =log file is error free
          )
   %markTest();
      %assertDBValue(tst,type,assertLog)
      %assertDBValue(tst,exp,0#0)
      %assertDBValue(tst,act,0#0)
      %assertDBValue(tst,res,0)
%assertLog(i_errors  =1
          ,i_warnings=0
          ,i_logfile =&l_filename_w_e.
          ,i_desc    =log file contains one error
          )
   %markTest();
      %assertDBValue(tst,type,assertLog)
      %assertDBValue(tst,exp,1#0)
      %assertDBValue(tst,act,1#0)
      %assertDBValue(tst,res,0)
%assertLog(i_errors  =0
          ,i_warnings=0
          ,i_logfile =&l_filename_wo_w.
          ,i_desc    =log file is warning free
          )
   %markTest();
      %assertDBValue(tst,type,assertLog)
      %assertDBValue(tst,exp,0#0)
      %assertDBValue(tst,act,0#0)
      %assertDBValue(tst,res,0)
%assertLog(i_errors  =0
          ,i_warnings=1
          ,i_logfile =&l_filename_w_w.
          ,i_desc    =log file contains one warning
          )
   %markTest();
      %assertDBValue(tst,type,assertLog)
      %assertDBValue(tst,exp,0#1)
      %assertDBValue(tst,act,0#1)
      %assertDBValue(tst,res,0)
%assertLog(i_errors  =3
          ,i_warnings=2
          ,i_logfile =&l_filename_w_e_w.
          ,i_desc    =log file contains errors and warnings
          )
   %markTest();
      %assertDBValue(tst,type,assertLog)
      %assertDBValue(tst,exp,3#2)
      %assertDBValue(tst,act,3#2)
      %assertDBValue(tst,res,0)
%endTestcase()

%endScenario()
/** \endcond */ 
