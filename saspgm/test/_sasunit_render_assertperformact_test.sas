/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_assertPerformAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%LET G_NLS_REPORTDETAIL_045=Message found; 
%LET G_NLS_REPORTDETAIL_046=Message not found; 

*** Testcase 1 ***; 
data work._input;
   length href href_act href_rep text _formatName $80 _output $400;
   num=.;
   _formatName="BEST32.";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = compress (putn (num, _formatName));
run;
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains missing value);
data work.actual;
   set work._input;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work._input;
   length href href_act href_rep text _formatName $80 _output $400;
   num=3.45678901234;
   _formatName="BEST32.";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = compress (putn (num, _formatName));
run;
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains non-missing value - No format);
data work.actual;
   set work._input;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 3 ***; 
data work._input;
   length href href_act href_rep text $80 _output $400;
   num=3.45678901234;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = put (num, 11.3);
run;
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains non-missing value - Format three digits);
data work.actual;
   set work._input;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num, i_format=11.3,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 4 ***; 
data work._input;
   length href href_act href_rep text $80 _output $400;
   num=3.45678901234;
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = put (num, 11.);
run;
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains non-missing value - Format no digits);
data work.actual;
   set work._input;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num, i_format=11.,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

/** \endcond */
