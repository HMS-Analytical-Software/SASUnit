/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _render_assertRowExpressionExp.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \remark Renderer macros are not called within a scenario. Errors will be visible, so currently there is no need to add specific test cases
*/ /** \cond */ 
%initScenario (i_desc=Test of _render_assertRowExpressionExp.sas)

%initTestcase(i_object=_render_assertRowExpressionExp.sas, i_desc=Test with correct call);
   *** Empty scenario *;
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */
