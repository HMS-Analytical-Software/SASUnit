/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Empty scenario without any test cases, must be included into report - has to fail!

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%initScenario(i_desc=Test for scenario without any testcases);

%Macro reportsasunit_emptyscn_test;

/* scenario must not contain any test cases
*/

%Mend reportsasunit_emptyscn_test;
%reportsasunit_emptyscn_test;
/** \endcond */
