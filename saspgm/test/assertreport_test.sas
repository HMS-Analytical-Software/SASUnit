/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertreport.sas, has to fail!
   
   \details    The asserts for test case "Is everthing displayed properly?" are all red. This is the case because only pre-generated documents are used.\n
               This test case is used to check if there are problems opening differnt document types. SASUnit issues an error if the document is older than the\n
               the last run fo the test case. All assertReport calls must be red. This is always the case for this particular test case.
   

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/assertReport_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/* change log
   07.01.2013 AM  corrected errors in test case no. 6 (i_actual older than current SAS session - must be red)
   02.01.2013 KL  New test case to check behaviour when comparing different report types.
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
%str(expected=empty, actual=.sas - not generated anew, result red?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(expected=empty, actual=.sas - not generated anew, result red?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.sas)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.sas)), i_desc=actual copied to testout)
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

*** Testcase for display of different filetypes ***;
%initTestcase(i_object=assertreport.sas, i_desc=%str(Is everthing displayed properly? Asserts are red! Refer program documentation of this test scenario))
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=&g_refdata./class.jpg,   i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=JPG  / JPG);
%assertReport(i_expected=&g_refdata./class.png,   i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=PNG  / JPG);
%assertReport(i_expected=&g_refdata./class.xls,   i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=XLS  / JPG);
%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=XLSX / JPG);
%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=DOC  / JPG);
%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=DOCX / JPG);
%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=HTML / JPG);
%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=PDF  / JPG);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.jpg, i_manual=0, i_desc=RTF  / JPG);

%assertReport(i_expected=&g_refdata./class.png,   i_actual=&g_refdata./class.png, i_manual=0, i_desc=PNG  / PNG);
%assertReport(i_expected=&g_refdata./class.xls,   i_actual=&g_refdata./class.png, i_manual=0, i_desc=XLS  / PNG);
%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.png, i_manual=0, i_desc=XLSX / PNG);
%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.png, i_manual=0, i_desc=DOC  / PNG);
%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.png, i_manual=0, i_desc=DOCX / PNG);
%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.png, i_manual=0, i_desc=HTML / PNG);
%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.png, i_manual=0, i_desc=PDF  / PNG);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.png, i_manual=0, i_desc=RTF  / PNG);


%assertReport(i_expected=&g_refdata./class.xls,   i_actual=&g_refdata./class.xls, i_manual=0, i_desc=XLS  / XLS);
%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.xls, i_manual=0, i_desc=XLSX / XLS);
%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.xls, i_manual=0, i_desc=DOC  / XLS);
%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.xls, i_manual=0, i_desc=DOCX / XLS);
%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.xls, i_manual=0, i_desc=HTML / XLS);
%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.xls, i_manual=0, i_desc=PDF  / XLS);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.xls, i_manual=0, i_desc=RTF  / XLS);

%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.xlsx, i_manual=0, i_desc=XLSX / XLSX);
%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.xlsx, i_manual=0, i_desc=DOC  / XLSX);
%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.xlsx, i_manual=0, i_desc=DOCX / XLSX);
%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.xlsx, i_manual=0, i_desc=HTML / XLSX);
%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.xlsx, i_manual=0, i_desc=PDF  / XLSX);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.xlsx, i_manual=0, i_desc=RTF  / XLSX);


%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./Report.doc, i_manual=0, i_desc=DOC  / DOC);
%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./Report.doc, i_manual=0, i_desc=DOCX / DOC);
%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./Report.doc, i_manual=0, i_desc=HTML / DOC);
%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.doc, i_manual=0, i_desc=PDF  / DOC);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.doc, i_manual=0, i_desc=RTF  / DOC);

%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=DOCX / DOCX);
%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=HTML / DOCX);
%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=PDF  / DOCX);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=RTF  / DOCX);

%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./Report.html, i_manual=0, i_desc=HTML / HTML);
%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.html, i_manual=0, i_desc=PDF  / HTML);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.html, i_manual=0, i_desc=RTF  / HTML);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.pdf,  i_manual=0, i_desc=PDF  / PDF);
%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.html, i_manual=0, i_desc=RTF  / PDF);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.rtf, i_manual=0, i_desc=RTF  / RTF);

/** \endcond */ 
