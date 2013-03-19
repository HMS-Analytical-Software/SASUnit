/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_assertLogExp.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%LET G_NLS_REPORTDETAIL_036=assertLogExp; 
%LET G_NLS_REPORTDETAIL_037=assertLogExp; 

*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_render_assertLogExp.sas, i_desc=Sourcecolumn contains missing value);
data _null_;
   Length text $80;
   Text="";
   tst_type="assertLog";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertLogExp (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn..assertLogExp:  . assertLogExp: ..td.);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_assertLogExp.sas, i_desc=Sourcecolumn contains non-missing value);
data _null_;
   Length text $80;
   Text="08#AB";
   tst_type="assertLog";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertLogExp (i_sourceColumn=Text);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn..assertLogExp: 08. assertLogExp: AB ..td.);

%endTestcase();


/** \endcond */
