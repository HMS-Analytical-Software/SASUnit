/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertLogMsgExp.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
               
   \todo Rethink design. Test knows the implementation!
   
*/ /** \cond */ 

%initScenario (i_desc=Test of _render_assertLogMsgExp.sas);

%LET G_NLS_REPORTDETAIL_042=found; 
%LET G_NLS_REPORTDETAIL_043=not found; 
%LET G_NLS_REPORTDETAIL_044=Message; 

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
   hlp  = substr(Text,1,1); 
   if hlp='1' then hlp="&g_nls_reportDetail_042"; 
   else            hlp="&g_nls_reportDetail_043"; 
   Text = substr(Text,2);
   hlp = "&g_nls_reportDetail_044 " !! trim(Text) !! " " !! trim(hlp);
   _output  = hlp;
run;
%initTestcase(i_object=_render_assertLogMsgExp.sas, i_desc=Sourcecolumn contains missing value);
data work.actual;
   set work._input;
   %_render_assertLogMsgExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);
%endTestcase();

*** Testcase 2 ***; 
data work._input;
   length href href_act href_rep text _formatName $80 hlp _output $400;
   Text="1Das ist mein anzuzeigender Text";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   hlp  = substr(Text,1,1); 
   if hlp='1' then hlp="&g_nls_reportDetail_042"; 
   else            hlp="&g_nls_reportDetail_043"; 
   Text = substr(Text,2);
   hlp = "&g_nls_reportDetail_044 " !! trim(Text) !! " " !! trim(hlp);
   _output  = hlp;
run;
%initTestcase(i_object=_render_assertLogMsgExp.sas, i_desc=Sourcecolumn contains non-missing value);
data work.actual;
   set work._input;
   %_render_assertLogMsgExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 3 ***; 
data work._input;
   length href href_act href_rep text _formatName $80 hlp _output $400;
   Text="~Das ist mein anzuzeigender Text";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   hlp  = substr(Text,1,1); 
   if hlp='1' then hlp="&g_nls_reportDetail_042"; 
   else            hlp="&g_nls_reportDetail_043"; 
   Text = substr(Text,2);
   hlp = "&g_nls_reportDetail_044 " !! trim(Text) !! " " !! trim(hlp);
   _output  = hlp;
run;
%initTestcase(i_object=_render_assertLogMsgExp.sas, i_desc=Sourcecolumn contains non-missing value);
data work.actual;
   set work._input;
   %_render_assertLogMsgExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

/** \endcond */
