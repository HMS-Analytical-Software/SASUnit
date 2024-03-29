/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _nobs.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _nobs.sas);
      
data test1;
   do i=1 to 100;
      output;
   end;
run;

%initTestcase(i_object=_nobs.sas, i_desc=standard case with 100 obs)
%LET g_nobs = %_nobs(test1);
%assertEquals(i_expected=100, i_actual=&g_nobs, i_desc=number of observations must be 100)
%assertLog()
%endTestcase()

data test2;
   stop;
run;

%initTestcase(i_object=_nobs.sas, i_desc=dataset with 0 obs)
%LET g_nobs = %_nobs(test2);
%assertEquals(i_expected=0, i_actual=&g_nobs, i_desc=number of observations must be 0)
%assertLog()

%initTestcase(i_object=_nobs.sas, i_desc=dataset not existing)
%LET g_nobs = %_nobs(test3);
%assertEquals(i_expected=0, i_actual=&g_nobs, i_desc=number of observations must be 0)
%assertLog()
%endTestcase;

%endScenario();
/** \endcond */