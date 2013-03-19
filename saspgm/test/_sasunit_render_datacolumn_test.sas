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
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Sourcecolumn contains missing value);
data _null_;
   Length text $80;
   Text="";
   %_sasunit_render_dataColumn (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>  <.td>);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Sourcecolumn contains html blank);
data _null_;
   Length text $80;
   Text='&nbsp;';
   %_sasunit_render_dataColumn (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>%str(&)nbsp; <.td>);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column without format);
data _null_;
   Length text $80;
   Text="1234";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>12.3456 <.td>);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with numeric format);
data _null_;
   Length text $80;
   Text="1234";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_format=z6.2);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>012.35<.td>);

%endTestcase();

*** Testcase 5 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Character column without format);
data _null_;
   Length text $80;
   Text="1234";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>1234 <.td>);

%endTestcase();

*** Testcase 6 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Character column with character format);
data _null_;
   Length text $80;
   Text="1234";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_format=$8.);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>1234    <.td>);

%endTestcase();

*** Testcase 7 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with character format);
data _null_;
   Length text $80;
   Text="1234";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_format=$8.);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=1);
%assertLogmsg (i_logmsg=WARNING: Variable Num has already been defined as numeric.);

%endTestcase();

*** Testcase 8 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Character column with numeric format);
data _null_;
   Length text $80;
   Text="Hugo";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_format=z8.2);
run;

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR 48-59. The format .Z was not found or could not be loaded.);

%endTestcase();

*** Testcase 9 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Link Column without title);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_linkColumn=MyLinkColumn);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. href=.This path points to my link .>Hugo <.a><.td>);

%endTestcase();

*** Testcase 10 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Link Column with title);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>.a class=.lightlink. title=.This is the title for my link . href=.This path points to my link .>Hugo <.a><.td>);

%endTestcase();

*** Testcase 11 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Link title without link column);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_linkTitle=MyLinkTitle);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>Hugo <.td>);

%endTestcase();

*** Testcase 12 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Setting column type);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Text, i_columnType=MyDataColumnTestType);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.MyDataColumnTestType.>Hugo <.td>);

%endTestcase();

*** Testcase 13 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with link - no title - with different column type);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_columnType=MyDataColumnTestType, i_format=z10.2, i_linkColumn=MyLinkColumn);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.MyDataColumnTestType.>.a class=.lightlink. href=.This path points to my link .>0000012.35<.a><.td>);

%endTestcase();

*** Testcase 14 ***; 
%initTestcase(i_object=_sasunit_render_dataColumn.sas, i_desc=Numeric column with link and title with different column type);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_dataColumn (i_sourceColumn=Num, i_columnType=MyDataColumnTestType, i_format=z10.2, i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.MyDataColumnTestType.>.a class=.lightlink. title=.This is the title for my link . href=.This path points to my link .>0000012.35<.a><.td>);

%endTestcase();

/** \endcond */
