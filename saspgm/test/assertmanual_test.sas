/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertManual.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%initScenario(i_desc =Test of assertManual.sas)

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%initTestcase(i_object=assertManual.sas, i_desc=%str(call without description))
%endTestcall()
%assertManual()
%markTest()
options mlogic symbolgen mprint source notes;
%assertDBValue(tst,type,assertManual)
%assertDBValue(tst,desc,Manual assert - serves as placeholder)
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%initTestcase(i_object=assertManual.sas, i_desc=%str(description specified))
%endTestcall()
%assertManual(i_desc=the description 1)
%markTest()
%assertDBValue(tst,type,assertManual)
%assertDBValue(tst,desc,the description 1)
%assertDBValue(tst,exp,)
%assertDBValue(tst,act,)
%assertDBValue(tst,res,1)
%endTestcase(i_assertLog=0)

%endScenario()
/** \endcond */