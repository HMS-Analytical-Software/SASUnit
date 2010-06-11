/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertColumns.sas, has to fail!

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$

*/

/*DE
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests für assertColumns.sas, muss rot sein!

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$

*/ /** \cond */ 

/* Änderungshistorie
   16.05.2010 AM  Changes for SAS 9.2: dataset label has been added to sashelp.class
   06.07.2008 AM  Umfangreiche Überarbeitung vorhandener Tests, Tests für i_allow und o_maxReportObs ergänzt
   10.08.2007 AM  Erste Version 
*/ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

data class0 class;
   SET sashelp.class;
run;

%initTestcase(i_object=assertColumns.sas, i_desc=zwei gleiche Dateien)
%endTestcall()
%assertColumns(i_actual=class0, i_expected=class, i_desc=die Beschreibung)
%markTest()
%assertDBValue(tst,type,assertColumns)
%assertDBValue(tst,desc,die Beschreibung)
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._columns_rep.sas7bitm)), i_desc=ODS-Dokument in Testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(testout._&scnid._&casid._&tstid._columns_act)), i_desc=i_actual in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(testout._&scnid._&casid._&tstid._columns_exp)), i_desc=i_expected in testout)
%endTestcase(i_assertLog=0)

data class1;
   SET class;
   age2 = age+1;
run;

%initTestcase(i_object=assertColumns.sas, i_desc=zwei gleiche Dateien bis auf zusätzliche Spalte)
%endTestcall()
%assertColumns(i_actual=class1, i_expected=class, i_desc=die Beschreibung)
%markTest()
%assertDBValue(tst,type,assertColumns)
%assertDBValue(tst,desc,die Beschreibung)
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,COMPVAR)
%assertDBValue(tst,res,0)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._columns_rep.sas7bitm)), i_desc=ODS-Dokument in Testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(testout._&scnid._&casid._&tstid._columns_act)), i_desc=i_actual in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(testout._&scnid._&casid._&tstid._columns_exp)), i_desc=i_expected in testout)
%endTestcase(i_assertLog=0)

data class3;
   SET class;
   IF _n_=12 THEN age=age+0.1;
run;

%initTestcase(i_object=assertColumns.sas, i_desc=unterschiedlicher Wert in Spalte age - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=class3, i_expected=class, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,VALUE)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=unterschiedlicher Wert in Spalte age > fuzz - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=class3, i_expected=class,i_fuzz=0.09)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,VALUE)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=unterschiedlicher Wert in Spalte age = fuzz)
%endTestcall()
%assertColumns(i_actual=class3, i_expected=class,i_fuzz=0.1)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=unterschiedlicher Wert in Spalte age < fuzz)
%endTestcall()
%assertColumns(i_actual=class3, i_expected=class,i_fuzz=0.11)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

data class4;
   set class;
   output;
   if _n_=12 then do;
      name='Judy2';
      output;
   end;
run;

%initTestcase(i_object=assertColumns.sas, i_desc=zusätzliche Beobachtung und Vergleich mit id - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=class4, i_expected=class,i_id=name, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,COMPOBS)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

data class5;
   set class;
   drop age;
run;

%initTestcase(i_object=assertColumns.sas, i_desc=fehlende Spalte - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=class5, i_expected=class, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,BASEVAR)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=fehlende Datei i_actual - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=classxxx, i_expected=class, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,ERROR: tatsächlich erzeugte Tabelle nicht gefunden.)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=fehlende Datei i_expected - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=class1, i_expected=classxxx, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,ERROR: erwartete Tabelle nicht gefunden.)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=beide Dateien fehlen - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=classxxx, i_expected=classxxx, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,ERROR: tatsächlich erzeugte Tabelle nicht gefunden.)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

data class6 / view=class6;
   set class;
run;

%initTestcase(i_object=assertColumns.sas, i_desc=Vergleich eines Views mit einer Datei)
%endTestcall()
%assertColumns(i_actual=class6, i_expected=class, i_desc=die Beschreibung)
%markTest()
%assertDBValue(tst,type,assertColumns)
%assertDBValue(tst,desc,die Beschreibung)
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&g_testout/_&scnid._&casid._&tstid._columns_rep.sas7bitm)), i_desc=ODS-Dokument in Testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(testout._&scnid._&casid._&tstid._columns_act)), i_desc=view i_actual in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(testout._&scnid._&casid._&tstid._columns_exp)), i_desc=i_expected in testout)
%endTestcase(i_assertLog=0)

data _null_;
   file "&g_work/1.txt";
   put "Dummy";
run;

%initTestcase(i_object=assertColumns.sas, i_desc=ungülter Wert für i_allow)
%endTestcall()
%assertColumns(i_actual=class1, i_expected=class, i_desc=die Beschreibung, i_allow=XXX)
%assertReport(i_actual=&g_work/1.txt, i_desc=Im Szenario-Log muss eine Fehlermeldung wegen ungültigem Wert XXX für i_allow stehen)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=zusätzliche Beobachtung und Vergleich mit id und mit i_allow)
%endTestcall()
%assertColumns(i_actual=class4, i_expected=class, i_id=name, i_allow=COMPOBS, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,COMPOBS)
%assertDBValue(tst,act,COMPOBS)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

data class7;
   set class;
   label age='XXX';
run;

%initTestcase(i_object=assertColumns.sas, i_desc=unterschiedliche Variablenlabels ohne i_allow LABEL - muss rot sein!)
%endTestcall()
%assertColumns(i_actual=class7, i_expected=class, i_desc=muss rot sein!, i_allow=DSLABEL COMPVAR)
%markTest()
%assertDBValue(tst,exp,DSLABEL COMPVAR)
%assertDBValue(tst,act,LABEL)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=unterschiedliche Variablenlabels mit i_allow LABEL)
%endTestcall()
%assertColumns(i_actual=class7, i_expected=class, i_desc=muss rot sein!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,LABEL)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=Maximale Anzahl Sätze beschränkt mit o_maxReportObs)
%endTestcall()
%assertColumns(i_actual=class0, i_expected=class, i_desc=Nur 5 Datensätze, i_maxReportObs=5)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertColumns.sas, i_desc=Maximale Anzahl Sätze beschränkt mit o_maxReportObs=0)
%endTestcall()
%assertColumns(i_actual=class0, i_expected=class, i_desc=keine Dateien kopiert, i_maxReportObs=0)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)


/** \endcond */ 
