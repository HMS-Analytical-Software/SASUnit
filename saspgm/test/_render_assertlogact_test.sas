/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertLogAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \remark Renderer macros are not called within a scenario. Errors will be visible, so currently there is no need to add further test cases
*/ /** \cond */ 

%initScenario (i_desc=Test of _render_assertLogAct.sas);

%LET G_NLS_REPORTDETAIL_036=assertLogAct; 
%LET G_NLS_REPORTDETAIL_037=assertLogAct; 

*** Testcase 1 ***; 
data work._input;
   length href href_act href_rep text _formatName $80 hlp _output $400;
   Text="";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = Text;
   hlp      = _output;
run;
%initTestcase(i_object=_render_assertLogAct.sas, i_desc=Sourcecolumn contains missing value);
data work.actual;
   set work._input;
   %_render_assertLogAct (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work._input;
   length href href_act href_rep text _formatName $80 hlp _output $400;
   Text="14#23";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   _output  = "assertLogAct: " !! trim(scan(Text,1,'#')) !! ", assertLogAct: " !! trim(scan(Text,2,'#'));;
   hlp      = _output;
run;
%initTestcase(i_object=_render_assertLogAct.sas, i_desc=Sourcecolumn contains non-missing value);
data work.actual;
   set work._input;
   %_render_assertLogAct (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

%endScenario();
/** \endcond */