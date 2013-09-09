/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertColumnsExp.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%LET G_NLS_REPORTDETAIL_015=assertColumnsExp; 
%LET G_NLS_REPORTDETAIL_038=assertColumnsExp; 

*** Testcase 1 ***; 
data work._input;
   length href href_exp href_rep text tst_act $80 _output $400;
   Text="";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ('_',put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_cmp_exp.html');
   _output = catt ("^{style [flyover=""assertColumnsExp"" url=""", href_exp, """] assertColumnsExp } ^n ^n ", Text);
run;
%initTestcase(i_object=_render_assertColumnsExp.sas, i_desc=Sourcecolumn contains missing value);
data work.actual;
   set work._input;
   %_render_assertColumnsExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work._input;
   length href href_exp href_rep text $80 _output $400;
   Text="Das ist mein anzuzeigender Text";
   tst_act="^_";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ('_',put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_cmp_exp.html');
   _output = catt ("^{style [flyover=""assertColumnsExp"" url=""", href_exp, """] assertColumnsExp } ^n ^n ", Text);
run;
%initTestcase(i_object=_render_assertColumnsExp.sas, i_desc=Sourcecolumn contains non-missing value);
data work.actual;
   set work._input;
   %_render_assertColumnsExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

*** Testcase 3 ***; 
data work._input;
   length href href_exp href_rep text tst_act $80 _output $400;
   Text="";
   tst_act="DSLABEL";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ('_',put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_cmp_exp.html');
   _output = catt ("^{style [flyover=""assertColumnsExp"" url=""", href_exp, """] assertColumnsExp } ^n ^n ", Text);
run;
%initTestcase(i_object=_render_assertColumnsExp.sas, i_desc=Sourcecolumn contains missing value - with tst_act);
data work.actual;
   set work._input;
   %_render_assertColumnsExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 4 ***; 
data work._input;
   length href href_exp href_rep text tst_act $80 _output $400;
   Text="Das ist mein anzuzeigender Text";
   tst_act="DSLABEL";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ('_',put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_cmp_exp.html');
   _output = catt ("^{style [flyover=""assertColumnsExp"" url=""", href_exp, """] assertColumnsExp } ^n ^n ", Text);
run;
%initTestcase(i_object=_render_assertColumnsExp.sas, i_desc=Sourcecolumn contains missing value - with tst_act);
data work.actual;
   set work._input;
   %_render_assertColumnsExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

/** \endcond */
