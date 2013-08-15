/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests for assertRowExpression.sas - has to fail! 4 assertRowExpression errors

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%*** Testcase 1 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Invalid libref)
%endTestcall()
%assertRowExpression(i_libref=hugo, i_memname=class, i_where=%str(name ne ""), i_desc=Invalid libref)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Invalid libref)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,exp,)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 2 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Invalid dataset)
%endTestcall()
%assertRowExpression(i_libref=hugo, i_memname=class, i_where=%str(name ne ""), i_desc=Invalid dataset)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Invalid dataset)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,exp,)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 3 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Invalid where expression)
%endTestcall()
%assertRowExpression(i_libref=hugo, i_memname=class, i_where=%str(name ne ""), i_desc=Invalid where expression)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Invalid where expression)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,exp,)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 4 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Condition is violated)
%endTestcall()
%assertRowExpression(i_libref=sashelp, i_memname=class, i_where=%str(sex = "F"), i_desc=Condition is violated)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Condition is violated)
%assertDBValue(tst,act,9)
%assertDBValue(tst,exp,19)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 5 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Column name contains no missings)
%endTestcall()
%assertRowExpression(i_libref=sashelp, i_memname=class, i_where=%str(name ne ""), i_desc=Column name contains no missings)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Column name contains no missings)
%assertDBValue(tst,act,19)
%assertDBValue(tst,exp,19)
%assertDBValue(tst,res,0)
%endTestcase()

/** \endcond */
