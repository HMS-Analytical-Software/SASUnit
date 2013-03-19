/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_assertColumnsAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%LET G_NLS_REPORTDETAIL_016=assertColumnsAct; 
%LET G_NLS_REPORTDETAIL_017=assertColumnsAct; 
%LET G_NLS_REPORTDETAIL_038=assertColumnsAct; 
%LET G_NLS_REPORTDETAIL_039=assertColumnsAct; 

*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_render_assertColumnsAct.sas, i_desc=Sourcecolumn contains missing value);
data _null_;
   Length text $80;
   Text="";
   tst_type="assertColumns";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertColumnsAct (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn...a class=.lightlink. title=.assertColumnsAct. href=.001_001_001_cmp_act.html..assertColumnsAct..a..br ..);
%assertLogmsg (i_logmsg=                       .a class=.lightlink. title=.assertColumnsAct. href=.001_001_001_cmp_rep.html..assertColumnsAct..a..br ..  ..td.);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_assertColumnsAct.sas, i_desc=Sourcecolumn contains non-missing value);
data _null_;
   Length text $80;
   Text="Das ist mein anzuzeigender Text";
   tst_type="assertColumns";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertColumnsAct (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn...a class=.lightlink. title=.assertColumnsAct. href=.001_001_001_cmp_act.html..assertColumnsAct..a..br ..);
%assertLogmsg (i_logmsg=                       .a class=.lightlink. title=.assertColumnsAct. href=.001_001_001_cmp_rep.html..assertColumnsAct..a..br ..Das ist mein anzuzeigender Text ..td.);

%endTestcase();


/** \endcond */
