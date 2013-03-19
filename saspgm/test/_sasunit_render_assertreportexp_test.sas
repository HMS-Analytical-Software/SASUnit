/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_assertReportExp.sas

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
%LET G_NLS_REPORTDETAIL_021=Open expected report; 

*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Both results are missing);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_act="";
   text_exp="";
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportExp (i_sourceColumn=text_exp, i_actualColumn=text_act);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>  <.td>);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Both results are html blank);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_act='&bnsp;';
   text_exp='&nbsp;';
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportExp (i_sourceColumn=text_exp, i_actualColumn=text_act);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>%str(&)nbsp; <.td>);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Actual result is missing);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_act="";
   text_exp=".txt";
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportExp (i_sourceColumn=text_exp, i_actualColumn=text_act);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.Open expected report . href=._001_001_001_man_exp.txt .>.txt <.a><.td>);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Actual result is html blank);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_act='&nbsp;';
   text_exp='.txt';
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportExp (i_sourceColumn=text_exp, i_actualColumn=text_act);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.Open expected report . href=._001_001_001_man_exp.txt .>.txt <.a><.td>);

%endTestcase();

*** Testcase 5 ***; 
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Expected result is missing);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_act=".txt";
   text_exp="";
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportExp (i_sourceColumn=text_exp, i_actualColumn=text_act);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>  <.td>);

%endTestcase();

*** Testcase 6 ***; 
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Expected result is html blank);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_act='.txt';
   text_exp='&nbsp;';
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportExp (i_sourceColumn=text_exp, i_actualColumn=text_act);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>%str(&)nbsp; <.td>);

%endTestcase();

*** Testcase 7 ***; 
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Both reports are present);
data _null_;
   Length text_exp text_act i_linkColumn i_linkTitle $80;
   text_act='.txt';
   text_exp='.txt';
   tst_type="assertReport";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertReportExp (i_sourceColumn=text_exp, i_actualColumn=text_act);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.Open both reports . href=._001_001_001_rep.html .>.txt <.a><.td>);

%endTestcase();

/** \endcond */
