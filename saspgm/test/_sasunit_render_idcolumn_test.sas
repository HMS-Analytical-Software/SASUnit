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
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Numeric column with link - no title);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_idColumn (i_sourceColumn=Num, i_linkColumn=MyLinkColumn);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.idcolumn.>.a class=.lightlink. href=.This path points to my link .>12.3456 <.a><.td>);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Numeric column with link and title);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_idColumn (i_sourceColumn=Num, i_format=z10.2, i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.idcolumn.>.a class=.lightlink. title=.This is the title for my link . href=.This path points to my link .>0000012.35<.a><.td>);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Character column with link - no title);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_idColumn (i_sourceColumn=Text, i_linkColumn=MyLinkColumn);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.idcolumn.>.a class=.lightlink. href=.This path points to my link .>Hugo <.a><.td>);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_sasunit_render_idColumn.sas, i_desc=Numeric column with link and title);
data _null_;
   Length text MyLinkColumn MyLinkTitle $80;
   Text="Hugo";
   MyLinkColumn="This path points to my link";
   MyLinkTitle="This is the title for my link";
   Num=12.3456;
   %_sasunit_render_idColumn (i_sourceColumn=Text, i_format=$12., i_linkColumn=MyLinkColumn, i_linkTitle=MyLinkTitle);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.idcolumn.>.a class=.lightlink. title=.This is the title for my link . href=.This path points to my link .>Hugo        <.a><.td>);

%endTestcase();

/** \endcond */
