/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertRecordExists.sas - has to fail! 5 errors (4 assertRecordExists and one error concerning non-existing variable)

   \version    \$Revision: 190 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-05-29 18:04:27 +0200 (Mi, 29 Mai 2013) $
   \sa         \$HeadURL: https://menrath@svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/assertequals_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%initTestcase(i_object=assertRecordExists.sas, i_desc=%str(valid expression has to be found))
%endTestcall()
%assertRecordExists(i_dataset=sashelp.class, i_whereExpr=%str(name="Alice"), i_desc=Alice is in dataset SASHELP.CLASS)
%markTest()
%assertDBValue(tst,type,assertRecordExists)
%assertDBValue(tst,desc,Alice is in dataset SASHELP.CLASS)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)


%initTestcase(i_object=assertRecordExists.sas, i_desc=%str(invalid expression has not to be found))
%endTestcall()
%assertRecordExists(i_dataset=sashelp.class, i_whereExpr=%str(name="Hugo"), i_desc=Hugo is not in dataset SASHELP.CLASS)
%markTest()
%assertDBValue(tst,type,assertRecordExists)
%assertDBValue(tst,desc,Hugo is not in dataset SASHELP.CLASS)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertRecordExists.sas, i_desc=%str(invalid dataset parameter causes error))
%endTestcall()
%assertRecordExists(i_dataset=sashelp._invalid_, i_whereExpr=%str(name="Alice"), i_desc=invalid dataset causes error)
%markTest()
%assertDBValue(tst,type,assertRecordExists)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertRecordExists.sas, i_desc=%str(empty whereExpr parameter causes error))
%endTestcall()
%assertRecordExists(i_dataset=sashelp.class, i_whereExpr=%str(), i_desc=empty whereExpr parameter causes error)
%markTest()
%assertDBValue(tst,type,assertRecordExists)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)


%initTestcase(i_object=assertRecordExists.sas, i_desc=%str(invalid whereExpr parameter causes error))
%endTestcall()
%assertRecordExists(i_dataset=sashelp.class, i_whereExpr=age_123=HUGO, i_desc=invalid whereExpr parameter causes error)
%markTest()
%assertDBValue(tst,type,assertRecordExists)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)


/** \endcond */
