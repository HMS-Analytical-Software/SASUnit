/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_assertReportAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%LET G_NLS_REPORTDETAIL_020=Open both reports; 
%LET G_NLS_REPORTDETAIL_022=Actual report is old; 
%LET G_NLS_REPORTDETAIL_023=Open actual report; 
%LET G_NLS_REPORTDETAIL_048=Actual report is missing; 

*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Both results are missing);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp="";
   text_act="";
   tst_res=.;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumnerror.>Actual report is missing <.td>);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Both results are html blank);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp='&nbsp;';
   text_act='&nbsp;';
   tst_res=.;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumnerror.>Actual report is missing <.td>);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Actual result is missing);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp=".txt";
   text_act="";
   tst_res=.;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumnerror.>Actual report is missing <.td>);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Actual result is html blank);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp='.txt';
   text_act='&nbsp;';
   tst_res=.;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumnerror.>Actual report is missing <.td>);

%endTestcase();

*** Testcase 5 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Expected result is missing);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp="";
   text_act=".txt";
   tst_res=.;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.Open actual report . href=._001_001_001_man_act.txt .>.txt <.a><.td>);

%endTestcase();

*** Testcase 6 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Expected result is html blank);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp='&nbsp;';
   text_act='.txt';
   tst_res=.;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.Open actual report . href=._001_001_001_man_act.txt .>.txt <.a><.td>);

%endTestcase();

*** Testcase 7 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Both result are present - test_res eq 1);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp=".txt";
   text_act=".txt";
   tst_res=1;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.Open both reports . href=._001_001_001_rep.html .>.txt - Actual report is old! <.a><.td>);

%endTestcase();

*** Testcase 8 ***; 
%initTestcase(i_object=_sasunit_render_assertReportAct.sas, i_desc=Both result are present - test_res ne 1);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_exp='.txt';
   text_act='.txt';
   tst_res=.;
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportAct (i_sourceColumn=text_act, i_expectedColumn=text_exp);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.Open both reports . href=._001_001_001_rep.html .>.txt <.a><.td>);

%endTestcase();

/** \endcond */
