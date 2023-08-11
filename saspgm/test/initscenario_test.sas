/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of initScenario.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test New test case with scenario id zero and i_object ne _AUTOMATIC_
*/ /** \cond */ 
%initScenario (i_desc=Test of initScenario.sas)

%initTestcase(i_object=initScenario.sas, i_desc=Test with correct call);
   *** Empty scenario *;
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */
