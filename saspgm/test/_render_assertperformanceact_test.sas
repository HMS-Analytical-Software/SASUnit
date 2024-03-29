/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertPerformanceAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \remark Renderer macros are not called within a scenario. Errors will be visible, so currently there is no need to add further test cases
*/ /** \cond */ 
%initScenario (i_desc=Test of _render_assertPerformanceAct.sas)

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
%initTestcase(i_object=_render_assertPerformanceAct.sas, i_desc=Sourcecolumn contains missing value);
data work.actual;
   set work._input;
   %_render_assertPerformanceAct (i_sourceColumn=num,o_html=1,o_targetColumn=_output);
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
%initTestcase(i_object=_render_assertPerformanceAct.sas, i_desc=Sourcecolumn contains non-missing value - No format);
data work.actual;
   set work._input;
   %_render_assertPerformanceAct (i_sourceColumn=num,o_html=1,o_targetColumn=_output);
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
%initTestcase(i_object=_render_assertPerformanceAct.sas, i_desc=Sourcecolumn contains non-missing value - Format three digits);
data work.actual;
   set work._input;
   %_render_assertPerformanceAct (i_sourceColumn=num, i_format=11.3,o_html=1,o_targetColumn=_output);
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
%initTestcase(i_object=_render_assertPerformanceAct.sas, i_desc=Sourcecolumn contains non-missing value - Format no digits);
data work.actual;
   set work._input;
   %_render_assertPerformanceAct (i_sourceColumn=num, i_format=11.,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

%endScenario();
/** \endcond */