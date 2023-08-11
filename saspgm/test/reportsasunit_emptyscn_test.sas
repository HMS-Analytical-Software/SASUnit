/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Empty scenario without any test cases, must be included into report - has to fail!

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 

%initScenario(i_desc=%str(Empty scenario without any test cases, must be included into report - has to fail!));

%Macro reportsasunit_emptyscn_test;

/* scenario must not contain any test cases
*/

%Mend reportsasunit_emptyscn_test;
%reportsasunit_emptyscn_test;

%endScenario();
/** \endcond */
