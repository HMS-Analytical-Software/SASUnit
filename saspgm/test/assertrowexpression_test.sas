/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertRowExpression.sas - has to fail! 1 error (one error concernig non-existing variable name1)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \todo %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid) is marked as not executed. Why?               
*/ /** \cond */ 

%initScenario(i_desc =%str(Test of assertRowExpression.sas - has to fail! 1 error %(one error concernig non-existing variable name1%)));

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
%assertRowExpression(i_libref=work, i_memname=class, i_where=%str(name ne ""), i_desc=Invalid dataset)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Invalid dataset)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,exp,)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 3 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Invalid value for o_maxReportObs)
%endTestcall()
%assertRowExpression(i_libref=sashelp
                    ,i_memname=class
                    ,i_where=%str(name ne "")
                    ,i_desc=Invalid value for o_maxReportObs
                    ,o_maxReportObs=123ABC
                    )
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Invalid value for o_maxReportObs)
%assertDBValue(tst,act,19)
%assertDBValue(tst,exp,19)
%assertDBValue(tst,res,0)
%endTestcase()

%*** Testcase 4 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Invalid where expression)
%endTestcall()
%assertRowExpression(i_libref=sashelp, i_memname=class, i_where=%str(name1 ne ""), i_desc=Invalid where expression)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Invalid where expression)
%assertDBValue(tst,act,-1)
%assertDBValue(tst,exp,19)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 5 ***;
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

%*** Testcase 6 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Condition is violated only 3 obs)
%endTestcall()
%assertRowExpression(i_libref=sashelp
                    ,i_memname=class
                    ,i_where=%str(sex = "F")
                    ,i_desc=Condition is violated only 3 obs
                    ,o_maxReportObs=3
                    )
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Condition is violated only 3 obs)
%assertDBValue(tst,act,9)
%assertDBValue(tst,exp,19)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 7 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Column name contains no missings)
%endTestcall()
%assertRowExpression(i_libref=sashelp
                    ,i_memname=class
                    ,i_where=%str(name ne "")
                    ,i_desc=Column name contains no missings)
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Column name contains no missings)
%assertDBValue(tst,act,19)
%assertDBValue(tst,exp,19)
%assertDBValue(tst,res,0)
%endTestcase()

%*** Testcase 8 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Condition is violated only 3 obs and only variable name)
%endTestcall()
%assertRowExpression(i_libref=sashelp
                    ,i_memname=class
                    ,i_where=%str(sex = "F")
                    ,i_desc=Condition is violated only 3 obs and only variable name
                    ,o_maxReportObs=3
                    ,o_listVars=name
                    )
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Condition is violated only 3 obs and only variable name)
%assertDBValue(tst,act,9)
%assertDBValue(tst,exp,19)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase()

%*** Testcase 9 ***;
%initTestcase(i_object=assertRowExpression.sas, i_desc=Empty input dataset)
data work.class1;
   set sashelp.class;
   stop;
run;
%endTestcall()
%assertRowExpression(i_libref=work
                    ,i_memname=class1
                    ,i_where=%str(sex = "F")
                    ,i_desc=Dataset is empty
                    ,o_maxReportObs=3
                    ,o_listVars=name
                    )
%markTest()
%assertDBValue(tst,type,assertRowExpression)
%assertDBValue(tst,desc,Dataset is empty)
%assertDBValue(tst,act,0)
%assertDBValue(tst,exp,0)
%assertDBValue(tst,res,0)
%endTestcase()

proc datasets lib=work nolist;
   delete class1;
run;
quit;

%endScenario();
/** \endcond */