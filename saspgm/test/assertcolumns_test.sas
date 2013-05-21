/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertcolumns.sas - has to fail! 1 error concerning invalid parameter in macro assertColumns

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

/* change log 
   08.01.2013 BB  Error Description added to \brief
   16.05.2010 AM  Changes for SAS 9.2: dataset label has been added to sashelp.class
   06.07.2008 AM  Umfangreiche �berarbeitung vorhandener Tests, Tests f�r i_allow und o_maxReportObs erg�nzt
   10.08.2007 AM  Erste Version 
*/ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

data class0 class;
   SET sashelp.class;
run;


%initTestcase(i_object=assertcolumns.sas, i_desc=identical datasets)
%endTestcall()
%assertColumns(i_actual=class0, i_expected=class, i_desc=the description)
%markTest()
%assertDBValue(tst,type,assertColumns)
%assertDBValue(tst,desc,the description)
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%let tst_path=&g_testout/_&scnid._&casid._&tstid._assertcolumns;
libname _acLib "&tst_path.";
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&tst_path./_columns_rep.sas7bitm)), i_desc=ODS document in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(_acLib._columns_act)), i_desc=i_actual in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(_acLib._columns_exp)), i_desc=i_expected in testout)
%endTestcase(i_assertLog=0)
libname _acLib clear;

data class1;
   SET class;
   age2 = age+1;
run;

%initTestcase(i_object=assertcolumns.sas, i_desc=identical datasets except for additional variable)
%endTestcall()
%assertColumns(i_actual=class1, i_expected=class, i_desc=the description)
%markTest()
%assertDBValue(tst,type,assertColumns)
%assertDBValue(tst,desc,the description)
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,COMPVAR)
%assertDBValue(tst,res,0)
%let tst_path=&g_testout/_&scnid._&casid._&tstid._assertcolumns;
libname _acLib "&tst_path.";
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&tst_path./_columns_rep.sas7bitm)), i_desc=ODS document in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(_acLib._columns_act)), i_desc=i_actual in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(_acLib._columns_exp)), i_desc=i_expected in testout)
%endTestcase(i_assertLog=0)
libname _acLib clear;

data class3;
   SET class;
   IF _n_=12 THEN age=age+0.1;
run;

%initTestcase(i_object=assertcolumns.sas, i_desc=different values for variable age - must be red!)
%endTestcall()
%assertColumns(i_actual=class3, i_expected=class, i_desc=must be red!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,VALUE)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=different value in variable age > fuzz - must be red!)
%endTestcall()
%assertColumns(i_actual=class3, i_expected=class, i_fuzz=0.09, i_desc=must be red!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,VALUE)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=different value in variable age = fuzz)
%endTestcall()
%assertColumns(i_actual=class3, i_expected=class,i_fuzz=0.1)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=different value in variable age < fuzz)
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

%initTestcase(i_object=assertcolumns.sas, i_desc=additional observation and compare with id  - must be red!)
%endTestcall()
%assertColumns(i_actual=class4, i_expected=class,i_id=name, i_desc=must be red!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,COMPOBS)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

data class5;
   set class;
   drop age;
run;

%initTestcase(i_object=assertcolumns.sas, i_desc=missing column - must be red!)
%endTestcall()
%assertColumns(i_actual=class5, i_expected=class, i_desc=must be red!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,BASEVAR)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=missing dataset i_actual - must be red!)
%endTestcall()
%assertColumns(i_actual=classxxx, i_expected=class, i_desc=must be red!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,ERROR: actual table not found.)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=missing dataset i_expected - must be red!)
%endTestcall()
%assertColumns(i_actual=class1, i_expected=classxxx, i_desc=must be red!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,ERROR: expected table not found.)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=both datasets are missing - must be red!)
%endTestcall()
%assertColumns(i_actual=classxxx, i_expected=classxxx, i_desc=must be red!)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,ERROR: actual table not found.)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

data class6 / view=class6;
   set class;
run;

%initTestcase(i_object=assertcolumns.sas, i_desc=compare a view with a dataset)
%endTestcall()
%assertColumns(i_actual=class6, i_expected=class, i_desc=the description)
%markTest()
%assertDBValue(tst,type,assertColumns)
%assertDBValue(tst,desc,the description)
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%let tst_path=&g_testout/_&scnid._&casid._&tstid._assertcolumns;
libname _acLib "&tst_path.";
%assertEquals(i_expected=1, i_actual=%sysfunc(fileexist(&tst_path./_columns_rep.sas7bitm)), i_desc=ODS document in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(_acLib._columns_act)), i_desc=view i_actual in testout)
%assertEquals(i_expected=1, i_actual=%sysfunc(exist(_acLib._columns_exp)), i_desc=i_expected in testout)
%endTestcase(i_assertLog=0)
libname _acLib clear;

data _null_;
   file "&g_work/1.txt";
   put "Dummy";
run;

%initTestcase(i_object=assertcolumns.sas, i_desc=invalid value for i_allow)
%endTestcall()
%assertColumns(i_actual=class1, i_expected=class, i_desc=the description, i_allow=XXX)
%assertReport(i_actual=&g_work/1.txt, i_desc=look for a message in the scenario log regarding invalid value XXX for i_allow)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=additional observation and use id and i_allow)
%endTestcall()
%assertColumns(i_actual=class4, i_expected=class, i_id=name, i_allow=COMPOBS, i_desc=table comparison)
%markTest()
%assertDBValue(tst,exp,COMPOBS)
%assertDBValue(tst,act,COMPOBS)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

data class7;
   set class;
   label age='XXX';
run;

%initTestcase(i_object=assertcolumns.sas, i_desc=different variable labels and not i_allow LABEL - must be red!)
%endTestcall()
%assertColumns(i_actual=class7, i_expected=class, i_desc=must be red!, i_allow=DSLABEL COMPVAR)
%markTest()
%assertDBValue(tst,exp,DSLABEL COMPVAR)
%assertDBValue(tst,act,LABEL)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=different variable labels with i_allow LABEL)
%endTestcall()
%assertColumns(i_actual=class7, i_expected=class, i_desc=the description)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,LABEL)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=limit maximum number of records with o_maxReportObs)
%endTestcall()
%assertColumns(i_actual=class0, i_expected=class, i_desc=only 5 records, i_maxReportObs=5)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertcolumns.sas, i_desc=limit maximum number of records with o_maxReportObs=0)
%endTestcall()
%assertColumns(i_actual=class0, i_expected=class, i_desc=no datasets copied, i_maxReportObs=0)
%markTest()
%assertDBValue(tst,exp,DSLABEL LABEL COMPVAR)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)
/** \endcond */ 
