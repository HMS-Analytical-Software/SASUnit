/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertReport.sas
   
   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test New test case with NOXCMD
*/ /** \cond */ 

%initScenario(i_desc =Test of assertReport.sas);

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=i_actual as well as i_expected specified)
ods listing close;
ods pdf file="&g_work./report1.pdf";
proc print data=sashelp.class;
title 'Report1 - expected';
run;
ods pdf close;
ods pdf file="&g_work./report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()

%assertReport(i_expected=&g_work./report1.pdf, i_actual=&g_work./report2.pdf, 
i_desc=%str(expected=.pdf, actual=.pdf, result grey/empty, correct title 'Report2 - actual' in actual report and 'Report1 - expected' in expected report, tooltips on both links to .pdf correct?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc, %str(expected=.pdf, actual=.pdf, result grey/empty, correct title 'Report2 - actual' in actual report and 'Report1 - expected' in expected report, tooltips on both links to .pdf correct?))
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_exp.pdf)), i_desc=Report1 - expected copied to testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.pdf)), i_desc=Report2 - actual copied to testout)
%endTestcase(i_assertLog=1)

/* test case 2 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=%str(only i_actual, not i_expected specified))
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
%assertDBValue(tst,desc, %str(expected=empty, actual=.pdf, result grey/empty, correct title 'Report2 - actual' in actual report?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.pdf)), i_desc=Report2 - actual copied to testout)
%endTestcase(i_assertLog=1)

/* test case 3 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=%str(only i_expected, not i_actual specified))
%endTestcall()
%assertReport(i_expected=&g_work/report1.pdf, i_actual=, i_desc=%str(expected=.pdf, actual=missing(red)))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=.pdf, actual=missing(red)))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.pdf)), i_desc=Report2 - actual not in testout)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

/* test case 4 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=%str(neither i_expected nor i_actual specified))
%endTestcall()
%assertReport(i_actual=, i_expected=, i_desc=%str(expected=, actual=missing(red)))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=, actual=missing(red)))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.pdf)), i_desc=Report2 - actual not in testout)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

/* test case 5 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=%str(invalid file specified for i_actual))
%endTestcall()
%assertReport(i_expected=&g_work/report1.pdf, i_actual=&g_work/report3.pdf, i_desc=%str(expected=.pdf, actual=missing(red)))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=.pdf, actual=missing(red)))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.pdf)), i_desc=Report2 - actual not in testout)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

/* test case 6 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=invalid file specified for i_expected)
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
%assertDBValue(tst,res,1)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_exp.pdf)), i_desc=Report1 - expected not in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.pdf)), i_desc=Report2 - actual copied to testout)
%endTestcase(i_assertLog=1)

/* test case 7 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=%str(i_actual older than current SAS session))
%endTestcall()
%assertReport(i_expected=, i_actual=&g_testdata/Report.docx, i_desc=%str(expected=empty, actual=.docx - not generated anew))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc, %str(expected=empty, actual=.docx - not generated anew))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.docx)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.docx)), i_desc=actual copied to testout)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=1)

/* test case 8 ------------------------------------*/
%initTestcase(i_object=assertReport.sas, i_desc=%str(i_manual=0))
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=, i_actual=&g_work/report2.pdf, i_manual=0, i_desc=%str(expected=empty, actual=.pdf, result green?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(expected=empty, actual=.pdf, result green?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,0)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_reportFolder./tempDoc/_&scnid._&casid._&tstid._assertreport/_man_act.pdf)), i_desc=actual copied to testout)
%endTestcase(i_assertLog=1)

/* test case 9 ------------------------------------*/
*** Testcase for display of different filetypes ***;
%initTestcase(i_object=assertReport.sas, i_desc=%str(is everthing displayed properly?))
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()

%assertReport(i_expected=&g_refdata./class.jpg,   i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=JPG / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,JPG / JPG)
%assertDBValue(tst,exp,.jpg)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./class.png,   i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=PNG / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PNG / JPG)
%assertDBValue(tst,exp,.png)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./class.xls,   i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=XLS / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,XLS / JPG)
%assertDBValue(tst,exp,.xls)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=XLSX / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,XLSX / JPG)
%assertDBValue(tst,exp,.xlsx)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=DOC / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOC / JPG)
%assertDBValue(tst,exp,.doc)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=DOCX / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOCX / JPG)
%assertDBValue(tst,exp,.docx)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=HTML / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,HTML / JPG)
%assertDBValue(tst,exp,.html)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=PDF / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / JPG)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.jpg,   i_manual=0, i_desc=RTF / JPG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / JPG)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.jpg)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./class.png,   i_actual=&g_refdata./class.png,   i_manual=0, i_desc=PNG / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PNG / PNG)
%assertDBValue(tst,exp,.png)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./class.xls,   i_actual=&g_refdata./class.png,   i_manual=0, i_desc=XLS / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,XLS / PNG)
%assertDBValue(tst,exp,.xls)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.png,   i_manual=0, i_desc=XLSX / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,XLSX / PNG)
%assertDBValue(tst,exp,.xlsx)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.png,   i_manual=0, i_desc=DOC / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOC / PNG)
%assertDBValue(tst,exp,.doc)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.png,   i_manual=0, i_desc=DOCX / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOCX / PNG)
%assertDBValue(tst,exp,.docx)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.png,   i_manual=0, i_desc=HTML / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,HTML / PNG)
%assertDBValue(tst,exp,.html)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.png,   i_manual=0, i_desc=PDF / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / PNG)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.png,   i_manual=0, i_desc=RTF / PNG);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / PNG)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.png)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./class.xls,   i_actual=&g_refdata./class.xls,   i_manual=0, i_desc=XLS / XLS);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,XLS / XLS)
%assertDBValue(tst,exp,.xls)
%assertDBValue(tst,act,.xls)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.xls,   i_manual=0, i_desc=XLSX / XLS);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,XLSX / XLS)
%assertDBValue(tst,exp,.xlsx)
%assertDBValue(tst,act,.xls)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.xls,   i_manual=0, i_desc=DOC / XLS);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOC / XLS)
%assertDBValue(tst,exp,.doc)
%assertDBValue(tst,act,.xls)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.xls,   i_manual=0, i_desc=DOCX / XLS);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOCX / XLS)
%assertDBValue(tst,exp,.docx)
%assertDBValue(tst,act,.xls)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.xls,   i_manual=0, i_desc=HTML / XLS);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,HTML / XLS)
%assertDBValue(tst,exp,.html)
%assertDBValue(tst,act,.xls)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.xls,   i_manual=0, i_desc=PDF / XLS);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / XLS)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.xls)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.xls,   i_manual=0, i_desc=RTF / XLS);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / XLS)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.xls)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./class.xlsx,  i_actual=&g_refdata./class.xlsx,  i_manual=0, i_desc=XLSX / XLSX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,XLSX / XLSX)
%assertDBValue(tst,exp,.xlsx)
%assertDBValue(tst,act,.xlsx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./class.xlsx,  i_manual=0, i_desc=DOC / XLSX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOC / XLSX)
%assertDBValue(tst,exp,.doc)
%assertDBValue(tst,act,.xlsx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./class.xlsx,  i_manual=0, i_desc=DOCX / XLSX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOCX / XLSX)
%assertDBValue(tst,exp,.docx)
%assertDBValue(tst,act,.xlsx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./class.xlsx,  i_manual=0, i_desc=HTML / XLSX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,HTML / XLSX)
%assertDBValue(tst,exp,.html)
%assertDBValue(tst,act,.xlsx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./class.xlsx,  i_manual=0, i_desc=PDF / XLSX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / XLSX)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.xlsx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./class.xlsx,  i_manual=0, i_desc=RTF / XLSX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / XLSX)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.xlsx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./Report.doc,  i_actual=&g_refdata./Report.doc,  i_manual=0, i_desc=DOC / DOC);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOC / DOC)
%assertDBValue(tst,exp,.doc)
%assertDBValue(tst,act,.doc)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./Report.doc,  i_manual=0, i_desc=DOCX / DOC);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOCX / DOC)
%assertDBValue(tst,exp,.docx)
%assertDBValue(tst,act,.doc)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./Report.doc,  i_manual=0, i_desc=HTML / DOC);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,HTML / DOC)
%assertDBValue(tst,exp,.html)
%assertDBValue(tst,act,.doc)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.doc,  i_manual=0, i_desc=PDF / DOC);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / DOC)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.doc)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.doc,  i_manual=0, i_desc=RTF / DOC);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / DOC)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.doc)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./Report.docx, i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=DOCX / DOCX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,DOCX / DOCX)
%assertDBValue(tst,exp,.docx)
%assertDBValue(tst,act,.docx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=HTML / DOCX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,HTML / DOCX)
%assertDBValue(tst,exp,.html)
%assertDBValue(tst,act,.docx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=PDF / DOCX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / DOCX)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.docx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.docx, i_manual=0, i_desc=RTF / DOCX);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / DOCX)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.docx)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./Report.html, i_actual=&g_refdata./Report.html, i_manual=0, i_desc=HTML / HTML);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,HTML / HTML)
%assertDBValue(tst,exp,.html)
%assertDBValue(tst,act,.html)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.html, i_manual=0, i_desc=PDF / HTML);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / HTML)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.html)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.html, i_manual=0, i_desc=RTF / HTML);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / HTML)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.html)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./Report.pdf,  i_actual=&g_refdata./Report.pdf,  i_manual=0, i_desc=PDF / PDF);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,PDF / PDF)
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.pdf, i_manual=0, i_desc=RTF / PDF);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / PDF)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertReport(i_expected=&g_refdata./Report.rtf,  i_actual=&g_refdata./Report.rtf,  i_manual=0, i_desc=RTF / RTF);
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,RTF / RTF)
%assertDBValue(tst,exp,.rtf)
%assertDBValue(tst,act,.rtf)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%endScenario()
/** \endcond */ 