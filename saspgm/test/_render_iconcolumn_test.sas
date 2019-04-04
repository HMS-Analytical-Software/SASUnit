/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_iconColumn.sas

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


%LET g_nls_reportDetail_025=Error occured;
%LET g_nls_reportDetail_026=Manual check;
%LET g_nls_reportDetail_027=Undefined result;
proc format lib=work;
   value PictName     0 = "&g_sasunit./resources/html/ok.png"
                      1 = "&g_sasunit./resources/sasunit/html/manual.png"
                      2 = "&g_sasunit./resources/sasunit/html/error.png"
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
   _output = "^{style [postimage=""" !! trim(put (Num, PictNameHTML.))
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
   _output = "^{style [postimage=""" !! trim(put (Num, PictNameHTML.))
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
   _output = "^{style [postimage=""" !! trim(put (Num, PictNameHTML.))
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
   _output = "^{style [postimage=""" !! trim(put (Num, PictNameHTML.))
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
   _output = "^{style [postimage=""" !! trim(put (Num, PictNameHTML.))
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
   _output = "^{style [postimage=""" !! trim(put (Num, PictNameHTML.))
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

/** \endcond */
