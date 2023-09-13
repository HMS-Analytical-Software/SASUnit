/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertManual.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
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