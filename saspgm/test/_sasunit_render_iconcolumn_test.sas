/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_iconColumn.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 


%LET g_nls_reportDetail_025=Error occured;
%LET g_nls_reportDetail_026=Manual check;
%LET g_nls_reportDetail_027=Undefined result;

*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_render_iconColumn.sas, i_desc=Call with missing value);
data _null_;
   Num=.;
   %_sasunit_render_iconColumn (i_sourceColumn=Num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.iconcolumn.><img src=....... alt=.Undefined result.><.img><.td>);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_iconColumn.sas, i_desc=Call with negative value);
data _null_;
   Num=-1;
   %_sasunit_render_iconColumn (i_sourceColumn=Num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.iconcolumn.><img src=....... alt=.Undefined result.><.img><.td>);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_sasunit_render_iconColumn.sas, i_desc=Call with result OK);
data _null_;
   Num=0;
   %_sasunit_render_iconColumn (i_sourceColumn=Num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.iconcolumn.>.img src=.ok.png. alt=.OK.><.img><.td>);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_sasunit_render_iconColumn.sas, i_desc=Call with result Manual);
data _null_;
   Num=2;
   %_sasunit_render_iconColumn (i_sourceColumn=Num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.iconcolumn.>.img src=.manual.png. alt=.Manual check.><.img><.td>);

%endTestcase();

*** Testcase 5 ***; 
%initTestcase(i_object=_sasunit_render_iconColumn.sas, i_desc=Call with result Error);
data _null_;
   Num=1;
   %_sasunit_render_iconColumn (i_sourceColumn=Num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.iconcolumn.>.img src=.error.png. alt=.Error occured.><.img><.td>);

%endTestcase();

*** Testcase 6 ***; 
%initTestcase(i_object=_sasunit_render_iconColumn.sas, i_desc=Call with high value);
data _null_;
   Num=3;
   %_sasunit_render_iconColumn (i_sourceColumn=Num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.iconcolumn.>.img src=....... alt=.Undefined result.><.img><.td>);

%endTestcase();

/** \endcond */
