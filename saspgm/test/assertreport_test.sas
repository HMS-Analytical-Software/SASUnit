/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertreport.sas, has to fail!

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/assertReport_test.sas $

*/ /** \cond */ 

/* change log
   07.02.2008 AM  überarbeitet: 
                  Umbenennung AssertManual -> AssertReport
                  2 zusätzliche Testszenarien für Prüfung, ob Bericht auch tatsächlich erzeugt wurde
                  Umbenennung der Ausgabedateien nachvollzogen
*/ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%initTestcase(i_object=assertreport.sas, i_desc=i_actual as well as i_expected specified)

ods listing close;
ods pdf file="&g_work/report1.pdf";
proc print data=sashelp.class;
title 'Report1 - expected';
run;
ods pdf close;
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()

%assertReport(i_expected=&g_work/report1.pdf, i_actual=&g_work/report2.pdf, 
i_desc=%str(expected=.pdf, actual=.pdf, result grey/empty, correct title 'Report2 - actual' in actual report and 'Report1 - expected' in expected report, tooltips on both links to .pdf correct?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(expected=.pdf, actual=.pdf, result grey/empty, correct title 'Report2 - actual' in actual report and 'Report1 - expected' in expected report, tooltips on both links to .pdf correct?))
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected copied to testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual copied to testout)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertreport.sas, i_desc=%str(only i_actual, not i_expected specified))
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=, i_actual=&g_work/report2.pdf, i_desc=
%str(expected=empty, actual=.pdf, result grey/empty, correct title 'Report2 - actual' in actual report?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(expected=empty, actual=.pdf, result grey/empty, correct title 'Report2 - actual' in actual report?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual copied to testout)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertreport.sas, i_desc=%str(only i_expected, not i_actual specified, must be red))
%endTestcall()
%assertReport(i_expected=&g_work/report1.pdf, i_actual=, i_desc=%str(expected=.pdf, actual=missing(red), result is red?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=.pdf, actual=missing(red), result is red?))
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected copied to testout)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual not in testout)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertreport.sas, i_desc=%str(neither i_expected nor i_actual specified, must be red))
%endTestcall()
%assertReport(i_actual=, i_expected=, i_desc=%str(expected=, actual=missing(red), result is red?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=, actual=missing(red), result is red?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual not in testout)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertreport.sas, i_desc=%str(invalid file specified for i_actual, must be red))
%endTestcall()
%assertReport(i_expected=&g_work/report1.pdf, i_actual=&g_work/report3.pdf, i_desc=%str(expected=.pdf, actual=missing(red), result is red?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=.pdf, actual=missing(red), result is red?))
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected copied to testout)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual not in testout)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertreport.sas, i_desc=invalid file specified for i_expected)
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=&g_work/report3.pdf, i_actual=&g_work/report2.pdf, i_desc=%str(expected=, actual=.pdf, result is grey/empty?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=, actual=.pdf, result is grey/empty?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual copied to testout)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertreport.sas, i_desc=%str(i_actual older than current SAS session - must be red))
%endTestcall()
%assertReport(i_expected=, i_actual=&g_sasunit/assertreport.sas, i_desc=
%str(expected=empty, actual=.sas7bdat - not created anew, result red?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(expected=empty, actual=.sas7bdat - not created anew, result red?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.sas7bdat)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.sas7bdat)), i_desc=actual copied to testout)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertreport.sas, i_desc=%str(i_manual=0 - must be green))
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=, i_actual=&g_work/report2.pdf, i_manual=0, i_desc=
%str(expected=empty, actual=.pdf, result green?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(expected=empty, actual=.pdf, result green?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,0)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=actual copied to testout)
%endTestcase(i_assertLog=1)

/** \endcond */ 
