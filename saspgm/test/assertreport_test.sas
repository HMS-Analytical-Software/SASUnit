/** \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests für assertReport.sas, muss rot sein

   \version    \$Revision: 54 $
   \author     \$Author: mangold $
   \date       \$Date: 2009-07-16 14:46:38 +0200 (Do, 16 Jul 2009) $
   \sa         \HeadURL: file:///P:/hms/00507_sasunit/svn/trunk/saspgm/test/assertReport_test.sas $

*/ /** \cond */ 

/* Änderungshistorie
   07.02.2008 AM  überarbeitet: 
                  Umbenennung AssertManual -> AssertReport
                  2 zusätzliche Testszenarien für Prüfung, ob Bericht auch tatsächlich erzeugt wurde
                  Umbenennung der Ausgabedateien nachvollzogen
*/ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%initTestcase(i_object=assertReport.sas, i_desc=sowohl i_actual als auch i_expected angegeben)

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
i_desc=%str(erwartet=.pdf, tatsächlich=.pdf, Ergebnis grau/leer, richtige Titel 'Report2 - actual' in tatsächlich und 'Report1 - expected' in erwartet, korrekte tooltips auf den beiden .pdf?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(erwartet=.pdf, tatsächlich=.pdf, Ergebnis grau/leer, richtige Titel 'Report2 - actual' in tatsächlich und 'Report1 - expected' in erwartet, korrekte tooltips auf den beiden .pdf?))
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected nach testout kopiert)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual nach testout kopiert)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertReport.sas, i_desc=%str(nur i_actual, nicht i_expected angegeben))
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=, i_actual=&g_work/report2.pdf, i_desc=
%str(erwartet=leer, tatsächlich=.pdf, Ergebnis grau/leer, richtiger Titel 'Report2 - actual' in tatsächlich?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(erwartet=leer, tatsächlich=.pdf, Ergebnis grau/leer, richtiger Titel 'Report2 - actual' in tatsächlich?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected nicht in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual nach testout kopiert)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertReport.sas, i_desc=%str(nur i_expected, nicht i_actual angegeben, muss rot sein))
%endTestcall()
%assertReport(i_expected=&g_work/report1.pdf, i_actual=, i_desc=%str(erwartet=.pdf, tatsächlich=fehlt(rot), Ergebnis ist rot?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(erwartet=.pdf, tatsächlich=fehlt(rot), Ergebnis ist rot?))
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected nach testout kopiert)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual nicht in testout)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertReport.sas, i_desc=%str(weder i_expected noch i_actual angegeben, muss rot sein))
%endTestcall()
%assertReport(i_actual=, i_expected=, i_desc=%str(erwartet=, tatsächlich=fehlt(rot), Ergebnis ist rot?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(erwartet=, tatsächlich=fehlt(rot), Ergebnis ist rot?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected nicht in testout)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual nicht in testout)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertReport.sas, i_desc=%str(ungültige Datei bei i_actual angegeben, muss rot sein))
%endTestcall()
%assertReport(i_expected=&g_work/report1.pdf, i_actual=&g_work/report3.pdf, i_desc=%str(erwartet=.pdf, tatsächlich=fehlt(rot), Ergebnis ist rot?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(erwartet=.pdf, tatsächlich=fehlt(rot), Ergebnis ist rot?))
%assertDBValue(tst,exp,.pdf)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected nach testout kopiert)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual nicht in testout)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertReport.sas, i_desc=ungültige Datei bei i_expected angegeben)
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=&g_work/report3.pdf, i_actual=&g_work/report2.pdf, i_desc=%str(erwartet=, tatsächlich=.pdf, Ergebnis ist grau/leer?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,%str(erwartet=, tatsächlich=.pdf, Ergebnis ist grau/leer?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,2)
%assertEquals(i_expected=0, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_exp.pdf)), i_desc=Report1 - expected nicht in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=Report2 - actual nach testout kopiert)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertReport.sas, i_desc=%str(i_actual älter als aktuelle SAS-Sitzung - muss rot sein))
%endTestcall()
%assertReport(i_expected=, i_actual=%sysget(sasroot)/core/sashelp/class.sas7bdat, i_desc=
%str(erwartet=leer, tatsächlich=.sas7bdat - nicht neu erzeugt, Ergebnis rot?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(erwartet=leer, tatsächlich=.sas7bdat - nicht neu erzeugt, Ergebnis rot?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.sas7bdat)
%assertDBValue(tst,res,1)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.sas7bdat)), i_desc=actual nach testout kopiert)
%endTestcase(i_assertLog=1)

%initTestcase(i_object=assertReport.sas, i_desc=%str(i_manual=0 - muss grün sein))
ods pdf file="&g_work/report2.pdf";
proc print data=sashelp.class;
title 'Report2 - actual';
run;
ods pdf close;
%endTestcall()
%assertReport(i_expected=, i_actual=&g_work/report2.pdf, i_manual=0, i_desc=
%str(erwartet=leer, tatsächlich=.pdf, Ergebnis grün?))
%markTest()
%assertDBValue(tst,type,assertReport)
%assertDBValue(tst,desc,
%str(erwartet=leer, tatsächlich=.pdf, Ergebnis grün?))
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,.pdf)
%assertDBValue(tst,res,0)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._man_act.pdf)), i_desc=actual nach testout kopiert)
%endTestcase(i_assertLog=1)

/** \endcond */ 
