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
data work._input;
   length href href_exp href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_act="";
   tst_exp="";
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = tst_exp;
run;
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Both results are missing);
data work.actual;
   set work._input;
   %_sasunit_render_assertReportExp (i_sourceColumn=tst_exp, i_actualColumn=tst_act,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work._input;
   length href href_exp href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_act='^_';
   tst_exp='^_';
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = tst_exp;
run;
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Both results are html blank);
data work.actual;
   set work._input;
   %_sasunit_render_assertReportExp (i_sourceColumn=tst_exp, i_actualColumn=tst_act,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 3 ***; 
data work._input;
   length href href_exp href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_act="";
   tst_exp=".txt";
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ("_", put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_man_exp');
   href_rep = catt (href,'_man_rep.html');
   IF tst_act NE '^_' AND tst_act NE ' ' THEN DO; 
      %*** Link to reporting html, if both results exist ***;
      i_linkColumn = href_rep;
      i_linkTitle  = "&g_nls_reportDetail_020.";
   END;
   ELSE DO; 
      %*** Link to expected document, if only one results exists ***;
      %*** Document type is contained in tst_exp                 ***;
      i_linkColumn = catt (href_exp, tst_exp);
      i_linkTitle  = "&g_nls_reportDetail_021.";
   END;
   _output  = catt ("^{style [flyover=""", i_linktitle, """ url=""", i_linkColumn, """]", " " !! tst_exp, "}");
run;
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Actual result is missing);
data work.actual;
   set work._input;
   %_sasunit_render_assertReportExp (i_sourceColumn=tst_exp, i_actualColumn=tst_act,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 4 ***; 
data work._input;
   length href href_exp href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_act='^_';
   tst_exp='.txt';
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ("_", put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_man_exp');
   href_rep = catt (href,'_man_rep.html');
   IF tst_act NE '^_' AND tst_act NE ' ' THEN DO; 
      %*** Link to reporting html, if both results exist ***;
      i_linkColumn = href_rep;
      i_linkTitle  = "&g_nls_reportDetail_020.";
   END;
   ELSE DO; 
      %*** Link to expected document, if only one results exists ***;
      %*** Document type is contained in tst_exp                 ***;
      i_linkColumn = catt (href_exp, tst_exp);
      i_linkTitle  = "&g_nls_reportDetail_021.";
   END;
   _output  = catt ("^{style [flyover=""", i_linktitle, """ url=""", i_linkColumn, """]", " " !! tst_exp, "}");
run;
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Actual result is html blank);
data work.actual;
   set work._input;
   %_sasunit_render_assertReportExp (i_sourceColumn=tst_exp, i_actualColumn=tst_act,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 5 ***; 
data work._input;
   length href href_exp href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_act=".txt";
   tst_exp="";
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = tst_exp;
run;
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Expected result is missing);
data work.actual;
   set work._input;
   %_sasunit_render_assertReportExp (i_sourceColumn=tst_exp, i_actualColumn=tst_act,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 6 ***; 
data work._input;
   length href href_exp href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_act=".txt";
   tst_exp="^_";
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = tst_exp;
run;
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Expected result is html blank);
data work.actual;
   set work._input;
   %_sasunit_render_assertReportExp (i_sourceColumn=tst_exp, i_actualColumn=tst_act,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 7 ***; 
data work._input;
   length href href_exp href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_act='.txt';
   tst_exp='.txt';
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ("_", put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_man_exp');
   href_rep = catt (href,'_man_rep.html');
   IF tst_act NE '^_' AND tst_act NE ' ' THEN DO; 
      %*** Link to reporting html, if both results exist ***;
      i_linkColumn = href_rep;
      i_linkTitle  = "&g_nls_reportDetail_020.";
   END;
   ELSE DO; 
      %*** Link to expected document, if only one results exists ***;
      %*** Document type is contained in tst_exp                 ***;
      i_linkColumn = catt (href_exp, tst_exp);
      i_linkTitle  = "&g_nls_reportDetail_021.";
   END;
   _output  = catt ("^{style [flyover=""", i_linktitle, """ url=""", i_linkColumn, """]", " " !! tst_exp, "}");
run;
%initTestcase(i_object=_sasunit_render_assertReportExp.sas, i_desc=Both reports are present);
data work.actual;
   set work._input;
   %_sasunit_render_assertReportExp (i_sourceColumn=tst_exp, i_actualColumn=tst_act,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

/** \endcond */
