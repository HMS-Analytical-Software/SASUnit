/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertForeignKeyAct.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \remark Renderer macros are not called within a scenario. Errors will be visible, so currently there is no need to add specific test cases
*/ /** \cond */ 
%initScenario (i_desc=Test of _render_assertForeignKeyAct.sas)

%initTestcase(i_object=_render_assertForeignKeyAct.sas, i_desc=Test with correct call);
   *** Empty scenario *;
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */
