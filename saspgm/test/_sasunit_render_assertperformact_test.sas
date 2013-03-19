/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _sasunit_render_assertPerformAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%LET G_NLS_REPORTDETAIL_045=Message found; 
%LET G_NLS_REPORTDETAIL_046=Message not found; 

*** Testcase 1 ***; 
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains missing value);
data _null_;
   Length text $80;
   num=.;
   tst_type="assertPerformance";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>\. <.td>);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains non-missing value - No format);
data _null_;
   Length text $80;
   num=3.45678901234;
   tst_type="assertPerformance";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>3\.4567890123 <.td>);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains non-missing value - Format three digits);
data _null_;
   Length text $80;
   num=3.45678901234;
   tst_type="assertPerformance";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num, i_format=11.3);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>      3.457<.td>);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_sasunit_render_assertPerformAct.sas, i_desc=Sourcecolumn contains non-missing value - Format no digits);
data _null_;
   Length text $80;
   num=345678901.23456789;
   tst_type="assertPerformance";
   scn_id=1;
   cas_id=1;
   tst_id=1;
   %_sasunit_render_assertPerformAct (i_sourceColumn=num, i_format=11.);
run;

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=.td class=.datacolumn.>  345678901<.td>);

%endTestcase();

/** \endcond */
