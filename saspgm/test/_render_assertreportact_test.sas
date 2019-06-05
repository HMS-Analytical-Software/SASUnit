/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertReportAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%initScenario (i_desc=Test of _render_assertReportAct.sas);

%LET G_NLS_REPORTDETAIL_020=Open both reports; 
%LET G_NLS_REPORTDETAIL_022=Actual report is old; 
%LET G_NLS_REPORTDETAIL_023=Open actual report; 
%LET G_NLS_REPORTDETAIL_048=Actual report is missing; 

*** Testcase 1 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp="";
   tst_act="";
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   tst_act  = "&g_nls_reportDetail_048.";
   _output  = "^{style datacolumnerror &g_nls_reportDetail_048.}";
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Both results are missing);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp='^_';
   tst_act='^_';
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   tst_act  = "&g_nls_reportDetail_048.";
   _output  = "^{style datacolumnerror &g_nls_reportDetail_048.}";
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Both results are html blank);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 3 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp=".txt";
   tst_act="";
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   tst_act  = "&g_nls_reportDetail_048.";
   _output  = "^{style datacolumnerror &g_nls_reportDetail_048.}";
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Actual result is missing);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 4 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp='.txt';
   tst_act='^_';
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   tst_act  = "&g_nls_reportDetail_048.";
   _output  = "^{style datacolumnerror &g_nls_reportDetail_048.}";
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Actual result is html blank);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 5 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp="";
   tst_act=".txt";
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ("_", put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_act = catt (href,'_man_act');
   href_rep = catt (href,'_man_rep.html');
   IF tst_exp NE '^_' AND tst_exp NE ' ' THEN DO; 
      %*** Link to reporting html, if both results exist ***;
      i_linkColumn = href_rep;
      i_linkTitle  = "&g_nls_reportDetail_020.";
   END;
   ELSE DO; 
      %*** Link to expected document, if only one results exists ***;
      %*** Document type is contained in tst_exp                 ***;
      i_linkColumn = catt (href_act, tst_act);
      i_linkTitle  = "&g_nls_reportDetail_023.";
   END;
   IF tst_res=2 THEN hlp = trim (tst_act) !! " - &g_nls_reportDetail_022!";
   ELSE hlp = tst_act;
   _output  = catt ("^{style [flyover=""", i_linktitle, """ url=""", i_linkColumn, """]", " " !! hlp, "}");
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Expected result is missing);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 6 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp='^_';
   tst_act='.txt';
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ("_", put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_act = catt (href,'_man_act');
   href_rep = catt (href,'_man_rep.html');
   IF tst_exp NE '^_' AND tst_exp NE ' ' THEN DO; 
      %*** Link to reporting html, if both results exist ***;
      i_linkColumn = href_rep;
      i_linkTitle  = "&g_nls_reportDetail_020.";
   END;
   ELSE DO; 
      %*** Link to expected document, if only one results exists ***;
      %*** Document type is contained in tst_exp                 ***;
      i_linkColumn = catt (href_act, tst_act);
      i_linkTitle  = "&g_nls_reportDetail_023.";
   END;
   IF tst_res=2 THEN hlp = trim (tst_act) !! " - &g_nls_reportDetail_022!";
   ELSE hlp = tst_act;
   _output  = catt ("^{style [flyover=""", i_linktitle, """ url=""", i_linkColumn, """]", " " !! hlp, "}");
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Expected result is html blank);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 7 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp=".txt";
   tst_act=".txt";
   tst_res=2;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ("_", put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_act = catt (href,'_man_act');
   href_rep = catt (href,'_man_rep.html');
   IF tst_exp NE '^_' AND tst_exp NE ' ' THEN DO; 
      %*** Link to reporting html, if both results exist ***;
      i_linkColumn = href_rep;
      i_linkTitle  = "&g_nls_reportDetail_020.";
   END;
   ELSE DO; 
      %*** Link to expected document, if only one results exists ***;
      %*** Document type is contained in tst_exp                 ***;
      i_linkColumn = catt (href_act, tst_act);
      i_linkTitle  = "&g_nls_reportDetail_023.";
   END;
   IF tst_res=2 THEN hlp = trim (tst_act) !! " - &g_nls_reportDetail_022!";
   ELSE hlp = tst_act;
   _output  = catt ("^{style [flyover=""", i_linktitle, """ url=""", i_linkColumn, """]", " " !! hlp, "}");
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Both result are present - test_res eq 2);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 8 ***; 
data work._input;
   length href href_act href_rep tst_act tst_exp i_linkColumn i_linkTitle _formatName $80 hlp _output $400;
   tst_exp='.txt';
   tst_act='.txt';
   tst_res=.;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ("_", put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_act = catt (href,'_man_act');
   href_rep = catt (href,'_man_rep.html');
   IF tst_exp NE '^_' AND tst_exp NE ' ' THEN DO; 
      %*** Link to reporting html, if both results exist ***;
      i_linkColumn = href_rep;
      i_linkTitle  = "&g_nls_reportDetail_020.";
   END;
   ELSE DO; 
      %*** Link to expected document, if only one results exists ***;
      %*** Document type is contained in tst_exp                 ***;
      i_linkColumn = catt (href_act, tst_act);
      i_linkTitle  = "&g_nls_reportDetail_023.";
   END;
   IF tst_res=2 THEN hlp = trim (tst_act) !! " - &g_nls_reportDetail_022!";
   ELSE hlp = tst_act;
   _output  = catt ("^{style [flyover=""", i_linktitle, """ url=""", i_linkColumn, """]", " " !! hlp, "}");
run;
%initTestcase(i_object=_render_assertReportAct.sas, i_desc=Both result are present - test_res ne 2);
data work.actual;
   set work._input;
   %_render_assertReportAct (i_sourceColumn=tst_act, i_expectedColumn=tst_exp,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

/** \endcond */
