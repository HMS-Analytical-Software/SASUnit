/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_assertLogAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%LET G_NLS_REPORTDETAIL_036=assertLogAct; 
%LET G_NLS_REPORTDETAIL_037=assertLogAct; 

*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_render_assertLogAct.sas, i_desc=Sourcecolumn contains missing value);
data _null_;
   Length text $80;
   Text="";
   tst_type="assertLog";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertLogAct (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn..assertLogAct:  . assertLogAct: ..td.);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_assertLogAct.sas, i_desc=Sourcecolumn contains non-missing value);
data _null_;
   Length text $80;
   Text="14#23";
   tst_type="assertLog";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertLogAct (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn..assertLogAct: 14. assertLogAct: 23 ..td.);

%endTestcase();


/** \endcond */
