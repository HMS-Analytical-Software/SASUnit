/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_dataColumn.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

*** Testcase 1 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="";
   output;
run;
data work.expected;
   set work.input;
   _output=Text;
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Sourcecolumn contains missing value);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="^_";
   output;
run;
data work.expected;
   set work.input;
   _output=Text;
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Sourcecolumn contains html blank);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 3 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="1234";
   Num=12.3456;
   _formatName="BEST32.";
   output;
run;
data work.expected;
   set work.input;
   _output=compress(put(num,best32.));
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column without format);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Num,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 4 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="1234";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=put(num,z6.2);
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with numeric format);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_format=z6.2,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 5 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="1234";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=Text;
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Character column without format);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 6 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="1234";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=Text;
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Character column with character format);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_format=$8.,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 7 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="1234";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=put(num,$8.);
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with character format);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_format=$8.,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=1);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 8 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="Hugo";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output="";
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Character column with numeric format);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_format=z8.2,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=1,i_warnings=2);

%endTestcase();

*** Testcase 9 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=catt ("^{style [ url=""", MyLinkColumn, """]", " " !! Text, "}");
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Link Column without title);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_linkColumn=MyLinkColumn,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 10 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=catt ("^{style [flyover=""", MyLinkTitle, """ url=""", MyLinkColumn, """]", " " !! Text, "}");
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Link Column with title);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 11 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=catt ("^{style [flyover=""", MyLinkTitle, """]", " " !! Text, "}");
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Link title without link column);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_linkTitle=MyLinkTitle,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 12 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=catt ("^{style %lowcase(MyDataColumnTestType)", " " !! Text, "}");
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Setting column type);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_columnType=MyDataColumnTestType,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 13 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=catt ("^{style %lowcase(MyDataColumnTestType) [ url=""", MyLinkColumn, """]", " " !! put (num,z10.2), "}");
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with link - no title - with different column type);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_columnType=MyDataColumnTestType, i_format=z10.2, i_linkColumn=MyLinkColumn,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 14 ***; 
data work.input;
   Length text _formatName $80 _output $1000;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   output;
run;
data work.expected;
   set work.input;
   _output=catt ("^{style %lowcase(MyDataColumnTestType) [flyover=""", MyLinkTitle, """ url=""", MyLinkColumn, """]", " " !! put (num,z10.2), "}");
run;
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with link and title with different column type);
data work.actual;
   set work.input;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_columnType=MyDataColumnTestType, i_format=z10.2, i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle,o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

/** \endcond */
