/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertLibraryExp.sas

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

%initScenario (i_desc=Test of _render_assertLibraryExp.sas);

%LET G_NLS_REPORTDETAIL_018=assertLibraryExp; 
%LET G_NLS_REPORTDETAIL_040=assertLibraryExp; 
*** Testcase 1 ***; 
data work._input;
   length href href_act href_rep text tst_exp $80 _output $400;
   Text="";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ('_',put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_library_exp.html');
   _output  = catt ("^{style [flyover=""assertLibraryExp"" url=""", href_exp, """] assertLibraryExp }^n^n",Text);
run;
%initTestcase(i_object=_render_assertLibraryExp.sas, i_desc=Sourcecolumn contains missing value);
data work.actual;
   set work._input;
   %_render_assertLibraryExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work._input;
   length href href_act href_rep text tst_exp $80 _output $400;
   Text="Das ist mein anzuzeigender Text";
   scn_id=1;
   cas_id=1;
   tst_id=1;
run;
data work.expected;
   set work._input;
   href     = catt ('_',put (scn_id, z3.),'_',put (1, z3.),'_',put (tst_id, z3.));
   href_exp = catt (href,'_library_exp.html');
   _output  = catt ("^{style [flyover=""assertLibraryExp"" url=""", href_exp, """] assertLibraryExp }^n^n",Text);
run;
%initTestcase(i_object=_render_assertLibraryExp.sas, i_desc=Sourcecolumn contains non-missing value);
data work.actual;
   set work._input;
   %_render_assertLibraryExp (i_sourceColumn=Text,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

%endScenario();
/** \endcond */