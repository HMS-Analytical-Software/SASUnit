/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createlog4sasappender.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \remark Not used within SASUnit, so detailed test cases are currently not necessary

*/ /** \cond */ 
%initScenario (i_desc=Test of _createlog4sasappender.sas)

%initTestcase(i_object=_createlog4sasappender.sas, i_desc=Test with correct call);
   *** Empty scenario *;
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */
