/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_iconColumn.sas

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

%initScenario (i_desc=Test of _render_iconColumn.sas);

%LET g_nls_reportDetail_025=Error occured;
%LET g_nls_reportDetail_026=Manual check;
%LET g_nls_reportDetail_027=Undefined result;
proc format lib=work;
   value PictName     0 = "&g_sasunitroot./resources/html/ok.png"
                      1 = "&g_sasunitroot./resources/sasunit/html/manual.png"
                      2 = "&g_sasunitroot./resources/sasunit/html/error.png"
                      OTHER="?????";
   value PictNameHTML 0 = "ok.png"
                      1 = "manual.png"
                      2 = "error.png"
                      OTHER="?????";
   value PictDesc     0 = "OK"
                      1 = "&g_nls_reportDetail_026"
                      2 = "&g_nls_reportDetail_025"
                      OTHER = "&g_nls_reportDetail_027";
run;

*** Testcase 1 ***; 
data work.input;
   Length _formatName $80 _output $1000;
   Num=.;
   output;
run;
data work.expected;
   set work.input;
   _output = "^{style [postimage=""./" !! trim(put (Num, PictNameHTML.))
                   !! """ flyover=""" !! trim(put (Num, PictDesc.)) !! '" fontsize=0pt]' !! Num !! '}';
run;
%initTestcase(i_object=_render_iconColumn.sas, i_desc=Call with missing value);
data work.actual;
   set work.input;
   %_render_iconColumn (i_sourceColumn=Num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work.input;
   Length _formatName $80 _output $1000;
   Num=-1;
   output;
run;
data work.expected;
   set work.input;
   _output = "^{style [postimage=""./" !! trim(put (Num, PictNameHTML.))
                   !! """ flyover=""" !! trim(put (Num, PictDesc.)) !! '" fontsize=0pt]' !! Num !! '}';
run;
%initTestcase(i_object=_render_iconColumn.sas, i_desc=Call with negative value);
data work.actual;
   set work.input;
   %_render_iconColumn (i_sourceColumn=Num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 3 ***; 
data work.input;
   Length _formatName $80 _output $1000;
   Num=0;
   output;
run;
data work.expected;
   set work.input;
   _output = "^{style [postimage=""./" !! trim(put (Num, PictNameHTML.))
                   !! """ flyover=""" !! trim(put (Num, PictDesc.)) !! '" fontsize=0pt]' !! Num !! '}';
run;
%initTestcase(i_object=_render_iconColumn.sas, i_desc=Call with result OK);
data work.actual;
   set work.input;
   %_render_iconColumn (i_sourceColumn=Num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 4 ***; 
data work.input;
   Length _formatName $80 _output $1000;
   Num=2;
   output;
run;
data work.expected;
   set work.input;
   _output = "^{style [postimage=""./" !! trim(put (Num, PictNameHTML.))
                   !! """ flyover=""" !! trim(put (Num, PictDesc.)) !! '" fontsize=0pt]' !! Num !! '}';
run;
%initTestcase(i_object=_render_iconColumn.sas, i_desc=Call with result Manual);
data work.actual;
   set work.input;
   %_render_iconColumn (i_sourceColumn=Num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 5 ***; 
data work.input;
   Length _formatName $80 _output $1000;
   Num=1;
   output;
run;
data work.expected;
   set work.input;
   _output = "^{style [postimage=""./" !! trim(put (Num, PictNameHTML.))
                   !! """ flyover=""" !! trim(put (Num, PictDesc.)) !! '" fontsize=0pt]' !! Num !! '}';
run;
%initTestcase(i_object=_render_iconColumn.sas, i_desc=Call with result Error);
data work.actual;
   set work.input;
   %_render_iconColumn (i_sourceColumn=Num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 6 ***; 
data work.input;
   Length _formatName $80 _output $1000;
   Num=3;
   output;
run;
data work.expected;
   set work.input;
   _output = "^{style [postimage=""./" !! trim(put (Num, PictNameHTML.))
                   !! """ flyover=""" !! trim(put (Num, PictDesc.)) !! '" fontsize=0pt]' !! Num !! '}';
run;
%initTestcase(i_object=_render_iconColumn.sas, i_desc=Call with high value);
data work.actual;
   set work.input;
   %_render_iconColumn (i_sourceColumn=Num,o_html=1,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 7 ***; 
data work.input;
   Length _formatName $80 _output $1000;
   Num=0;
   output;
run;
data work.expected;
   set work.input;
   _output = "^{style [postimage=""Hugo/" !! trim(put (Num, PictNameHTML.))
                   !! """ flyover=""" !! trim(put (Num, PictDesc.)) !! '" fontsize=0pt]' !! Num !! '}';
run;
%initTestcase(i_object=_render_iconColumn.sas, i_desc=Call with result OK and iconOffset Hugo);
data work.actual;
   set work.input;
   %_render_iconColumn (i_sourceColumn=Num,o_html=1,o_targetColumn=_output,i_iconOffset=Hugo);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

%endScenario ();
/** \endcond */