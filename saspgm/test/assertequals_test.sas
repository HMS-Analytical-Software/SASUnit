/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertEquals.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 

%initScenario(i_desc =Test of assertEquals.sas)

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%initTestcase(i_object=assertEquals.sas, i_desc=%str(equal values, no fuzz))
%endTestcall()
%assertEquals(i_actual=20, i_expected=20, i_desc=the description 1)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 1)
%assertDBValue(tst,exp,20)
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(equal values, with fuzz))
%endTestcall()
%assertEquals(i_actual=20, i_expected=20, i_desc=the description 2, i_fuzz=1)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 2)
%assertDBValue(tst,exp,20(+-1))
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, no fuzz))
%endTestcall()
%assertEquals(i_actual=19, i_expected=20, i_desc=the description 3)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 3)
%assertDBValue(tst,exp,20)
%assertDBValue(tst,act,19)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, with fuzz, in range))
%endTestcall()
%assertEquals(i_actual=19, i_expected=20, i_desc=the description 4, i_fuzz=2)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 4)
%assertDBValue(tst,exp,20(+-2))
%assertDBValue(tst,act,19)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, with fuzz, on border of range))
%endTestcall()
%assertEquals(i_actual=18, i_expected=20, i_desc=the description 5, i_fuzz=2)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 5)
%assertDBValue(tst,exp,20(+-2))
%assertDBValue(tst,act,18)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, with fuzz, out of range))
%endTestcall()
%assertEquals(i_actual=17, i_expected=20, i_desc=the description 6, i_fuzz=2)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 6)
%assertDBValue(tst,exp,20(+-2))
%assertDBValue(tst,act,17)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, with fuzz, in range, floating points))
%endTestcall()
%assertEquals(i_actual=17.86532, i_expected=20, i_desc=the description 7, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 7)
%assertDBValue(tst,exp,20(+-10))
%assertDBValue(tst,act,17.86532)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, with fuzz, out of range, floating points))
%endTestcall()
%assertEquals(i_actual=117.86532, i_expected=20, i_desc=the description 8, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 8)
%assertDBValue(tst,exp,20(+-10))
%assertDBValue(tst,act,117.86532)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, with fuzz, in range, floating points, twisted))
%endTestcall()
%assertEquals(i_actual=20, i_expected=17.86532, i_desc=the description 8, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 8)
%assertDBValue(tst,exp,17.86532(+-10))
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, with fuzz, out of range, floating points, twisted))
%endTestcall()
%assertEquals(i_actual=20, i_expected=117.86532, i_desc=the description 8, i_fuzz=10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 8)
%assertDBValue(tst,exp,117.86532(+-10))
%assertDBValue(tst,act,20)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(equal values, alpha numeric))
%endTestcall()
%assertEquals(i_actual=AAA, i_expected=AAA, i_desc=the description 9)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 9)
%assertDBValue(tst,exp,AAA)
%assertDBValue(tst,act,AAA)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(unequal values, alpha numeric))
%endTestcall()
%assertEquals(i_actual=BBB, i_expected=AAA, i_desc=the description 10)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 10)
%assertDBValue(tst,exp,AAA)
%assertDBValue(tst,act,BBB)
%assertDBValue(tst,res,2)
%assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertEquals.sas, i_desc=%str(equal values, alpha numeric, with i_fuzz))
%endTestcall()
%assertEquals(i_actual=AAA, i_expected=AAA, i_desc=the description 11, i_fuzz=1)
%markTest()
%assertDBValue(tst,type,assertEquals)
%assertDBValue(tst,desc,the description 11)
%assertDBValue(tst,exp,AAA)
%assertDBValue(tst,act,AAA)
%assertDBValue(tst,res,0)
%endTestcase(i_assertLog=0)

%endScenario()
/** \endcond */