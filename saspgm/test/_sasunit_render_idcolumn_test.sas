/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_idColumn.sas

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
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   _formatName="BEST32.";
   output;
run;
data work.expected;
   set work.input;
   _output=catt ("^{style [ url=""", MyLinkColumn, """]", " " !! compress(put(Num,best32.)), "}");
run;
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Numeric column with link - no title);
data work.actual;
   set work.input;
   %_sasunit_render_idColumn (i_sourceColumn=Num, i_linkColumn=MyLinkColumn, o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 2 ***; 
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
   _output=catt ("^{style [flyover=""", MyLinkTitle, """ url=""", MyLinkColumn, """]", " " !! compress(put(Num,z10.2)), "}");
run;
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Numeric column with link and title);
data work.actual;
   set work.input;
   %_sasunit_render_idColumn (i_sourceColumn=Num, i_format=z10.2, i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle, o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 3 ***; 
data work.expected;
   set work.input;
   _output=catt ("^{style [ url=""", MyLinkColumn, """]", " " !! Text, "}");
run;
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Character column with link - no title);
data work.actual;
   set work.input;
   %_sasunit_render_idColumn (i_sourceColumn=Text, i_linkColumn=MyLinkColumn, o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

*** Testcase 4 ***; 
data work.expected;
   set work.input;
   _output=catt ("^{style [flyover=""", MyLinkTitle, """ url=""", MyLinkColumn, """]", " " !! compress(put (Text, $12.)), "}");
run;
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Numeric column with link and title);
data work.actual;
   set work.input;
   %_sasunit_render_idColumn (i_sourceColumn=Text, i_format=$12., i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle, o_targetColumn=_output);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertColumns (i_expected=work.Expected,i_actual=work.actual);

%endTestcase();

/** \endcond */
