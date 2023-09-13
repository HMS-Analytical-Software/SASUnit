/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertRecordExists.sas - has to fail! 1 error (concerning non-existing variable)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 

%initScenario(i_desc =%str(Test of assertRecordExists.sas - has to fail! 1 error %(concerning non-existing variable%)));

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

%endScenario()
/** \endcond */